module Blob where

-- TODO: don't use String, obvi

-- | A Blob is the basic unit of storage in OwnStore.
--   A header with some data
data Blob = Blob {
    blobHeader :: BlobHeader,
    blobData   :: BlobData
} deriving (Show, Eq)

type BlobData = String

-- | The BlobHeader contains all metadata about the blob
data BlobHeader = BlobHeader {
    blobCipher :: Cipher
} deriving (Show, Eq)

-- | Representation of cryptographic ciphers
data Cipher =
    AES | TwoFish | TripleDES |
    MultiCipher [Encryption] | NoCipher
  deriving (Show, Eq)

-- | A BlobID identifies blobs
type BlobID = String

-- | A BlobKey is a key used to decode an encrypted blob
type BlobKey = String
