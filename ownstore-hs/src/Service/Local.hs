module Service.Local where

import System.Directory
import Data.Binary
import Control.Monad.Trans

import qualified Data.ByteString.Lazy as B

import Stor
import Service
import Blob

localService :: Service Stor
localService = Service localCreate localGet localUpdate localDelete

localCreate :: Blob -> Stor BlobID
localCreate blob = do
    key <- lift randomBlobID
    let fileName = blobStoragePath key
    lift $ B.writeFile fileName (encode blob)
    return key

localGet :: BlobID -> Stor Blob
localGet key = do
    let fileName = blobStoragePath key
    lift $ decode <$> B.readFile fileName

localUpdate :: BlobID -> BlobBody -> Stor ()
localUpdate key body = do
    let fileName = blobStoragePath key
    Blob header _ <- localGet key
    let newBlob = Blob header body
    lift $ B.writeFile fileName (encode newBlob)

localDelete :: BlobID -> Stor ()
localDelete = lift . removeFile . blobStoragePath

blobStoragePath :: BlobID -> FilePath
blobStoragePath = ("." ++)
