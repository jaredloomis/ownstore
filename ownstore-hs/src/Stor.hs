{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings #-}
module Stor where

import Servant (Handler(..), ServantErr(..))
import Control.Monad.Reader (ReaderT, runReaderT, MonadReader)
import Control.Monad.IO.Class (MonadIO)
import Control.Monad.Except (ExceptT(..), MonadError, runExceptT)

import qualified Data.Text                  as T
import qualified Data.ByteString.Lazy.Char8 as B8

newtype Stor a = Stor {
    runStor :: ReaderT StorConfig (ExceptT StorError IO) a
} deriving (Monad, Functor, Applicative, MonadIO, MonadReader StorConfig, MonadError StorError)

data StorConfig = StorConfig {
    cfgS3Config :: S3ServiceConfig
} deriving (Show, Eq)

data S3ServiceConfig = S3ServiceConfig {
    bucketName :: T.Text
} deriving (Show, Eq)

data StorState = StorState {
} deriving (Show, Eq)

data StorError = StorError {
    storErrorMsg :: String
} deriving (Show)

liftToHandler :: StorConfig -> Stor a -> Handler a
liftToHandler cfg (Stor stor) =
    Handler . translateErrors . runReaderT stor $ cfg
  where
    translateErrors :: ExceptT StorError IO a -> ExceptT ServantErr IO a
    translateErrors comp = ExceptT $ do
        res <- runExceptT comp
        return $ case res of
            Left err -> Left $ ServantErr 510 "OwnStore Error" (B8.pack . storErrorMsg $ err) []
            Right x  -> Right x
