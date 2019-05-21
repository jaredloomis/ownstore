module Service where

import Blob

-- | A Service is a set of operations on Blobs
data Service f = Service {
    serviceCreate :: Blob               -> f BlobID,
    serviceGet    :: BlobID             -> f Blob,
    serviceUpdate :: BlobID -> BlobBody -> f (),
    serviceDelete :: BlobID             -> f ()
}
