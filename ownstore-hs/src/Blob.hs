{-# LANGUAGE DeriveGeneric #-}
module Blob where

import GHC.Generics (Generic)
import Data.Word (Word8)
import System.Random (randomIO)
import Data.Binary (Binary(..))
import Data.Binary.Get (Get)
import Data.Aeson (ToJSON, FromJSON)

-- TODO: don't use String, obvi

-- | A Blob is the basic unit of storage in OwnStore.
--   A header with some data
data Blob = Blob {
    blobHeader :: BlobHeader,
    blobBody   :: BlobBody
} deriving (Show, Eq, Generic)

instance ToJSON   Blob
instance FromJSON Blob

instance Binary Blob where
    put (Blob header body) = do
        put header
        put body

    get = do
        header <- get :: Get BlobHeader
        body   <- get :: Get BlobBody
        return $ Blob header body

type BlobBody = String

-- | The BlobHeader contains all metadata about the blob
data BlobHeader = BlobHeader {
    blobCipher :: Cipher
} deriving (Show, Eq, Generic)

instance ToJSON   BlobHeader
instance FromJSON BlobHeader

instance Binary BlobHeader where
    put (BlobHeader cipher) = do
        put cipher

    get = BlobHeader <$> get

-- | Representation of cryptographic ciphers
data Cipher =
    AES | TwoFish | TripleDES |
    MultiCipher [Cipher]
  deriving (Show, Eq, Generic)

instance ToJSON   Cipher
instance FromJSON Cipher

instance Binary Cipher where
    put (MultiCipher xs) = do
        put (0 :: Word8)
        put (length xs)
        mapM_ put xs
    put AES              = put (1 :: Word8)
    put TwoFish          = put (2 :: Word8)
    put TripleDES        = put (3 :: Word8)

    get = do
        flag <- get :: Get Word8
        case flag of
            0 -> do
                len <- get :: Get Int
                MultiCipher <$> mapM (const get) [0..len]
            1 -> return AES
            2 -> return TwoFish
            3 -> return TripleDES
                

-- | A BlobID identifies blobs
type BlobID = String

-- | A BlobKey is a key used to decode an encrypted blob
type BlobSecret = String

-- | Create a random BlobID
randomBlobID :: IO BlobID
randomBlobID = show <$> (randomIO :: IO Int)
