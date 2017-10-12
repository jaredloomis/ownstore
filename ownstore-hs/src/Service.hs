module Service where

import Blob

-- | A Service is a method of creating, getting, and setting blobs
data Service = Service {
    serviceCreate :: Blob           -> IO BlobID
    serviceGet    :: BlobID         -> IO Blob,
    serviceSet    :: Blob -> BlobID -> IO BlobID
} deriving (Show, Eq)

localService :: Service
localService = Service localCreate undefined undefined

localCreate :: Blob -> IO BlobKey
localCreate blob = undefined
