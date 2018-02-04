{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
module Http where

import Servant
import Network.Wai.Handler.Warp (run)

import Blob

type BlobAPI = "blobs" :> Get '[JSON] [Blob]

blobs :: [Blob]
blobs = [
    Blob (BlobHeader AES) "whats up",
    Blob (BlobHeader TripleDES) "hello world"
    ]

server :: Server BlobAPI
server = return blobs

blobAPI :: Proxy BlobAPI
blobAPI = Proxy

app :: Application
app = serve blobAPI server

serveIt :: IO ()
serveIt = run 8081 app
