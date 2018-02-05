module Service.Local where

import System.Directory
import Data.Binary
import Control.Monad.Trans
import System.FilePath ((</>))

import qualified Data.Text            as T
import qualified Data.ByteString.Lazy as B

import Stor
import Service
import Blob

localService :: Service Stor
localService = Service localCreate localGet localUpdate localDelete

localCreate :: Blob -> Stor BlobID
localCreate blob = do
    key <- lift randomBlobID
    let fileName = blobDirectory </> T.unpack key
    lift $ do
        createDirectoryIfMissing True blobDirectory
        B.writeFile fileName (encode blob)
    return key

localGet :: BlobID -> Stor Blob
localGet key = do
    let fileName = blobDirectory </> T.unpack key
    lift $ decode <$> B.readFile fileName

localUpdate :: BlobID -> BlobBody -> Stor ()
localUpdate key body = do
    let fileName = blobDirectory </> T.unpack key
    Blob header _ <- localGet key
    let newBlob = Blob header body
    lift $ B.writeFile fileName (encode newBlob)

localDelete :: BlobID -> Stor ()
localDelete = lift . removeFile . (blobDirectory </>) . T.unpack

blobDirectory :: FilePath
blobDirectory = "." </> "data" </> "blobs"
