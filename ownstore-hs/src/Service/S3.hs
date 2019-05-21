{-# LANGUAGE OverloadedStrings #-}
module Service.S3 where

import Debug.Trace
import Control.Exception (try)
import Control.Monad.Trans (liftIO)
import Control.Monad.Trans.Resource (runResourceT)
import Control.Monad.Except (throwError)
import Control.Monad.Reader (ask)
import Network.HTTP.Client (HttpException(..))
import Data.Binary (decode)
import Data.Conduit (($$+-))
import Data.Conduit.Binary (sinkFile)
import Network.HTTP.Conduit (tlsManagerSettings, responseBody)
import Network.HTTP.Client (RequestBody(..), newManager)

import qualified Aws
import qualified Aws.S3               as S3
import qualified Data.Text.Encoding   as TE
import qualified Data.ByteString.Lazy as B

import Stor
import Service
import Blob

s3Service :: Service Stor
s3Service = Service s3Create s3Read undefined undefined

s3Create :: Blob -> Stor BlobID
s3Create (Blob header body) = do
  bucket <- bucketName . cfgS3Config <$> ask
  liftIO $ do
    key <- randomBlobID
    cfg <- Aws.baseConfiguration
    let s3cfg = Aws.defServiceConfig :: S3.S3Configuration Aws.NormalQuery

    mgr <- newManager tlsManagerSettings
    _ <- runResourceT . Aws.pureAws cfg s3cfg mgr .
      S3.putObject bucket key .
      RequestBodyBS . TE.encodeUtf8 $ body
    return key

s3Read :: BlobID -> Stor Blob
s3Read key = do
  bucket <- bucketName . cfgS3Config <$> ask
  mBlob <- liftIO . try $ do
    cfg <- Aws.baseConfiguration
    let s3cfg = Aws.defServiceConfig :: S3.S3Configuration Aws.NormalQuery

    mgr <- newManager tlsManagerSettings
    S3.GetObjectResponse {S3.gorResponse = resp} <-
      runResourceT . Aws.pureAws cfg s3cfg mgr .
        S3.getObject bucket $ key

    runResourceT $ responseBody resp $$+- sinkFile "s3-read.tmp"
    decode <$> B.readFile "s3-read.tmp"

  case mBlob of
    Left HttpExceptionRequest{} ->
      throwError (StorError "Error reading blob from S3")
    Right blob                  ->
      return blob
