{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE TypeOperators     #-}
{-# LANGUAGE OverloadedStrings #-}
module Http where

import Servant
import Network.Wai.Handler.Warp (run)

import Stor
import Blob
import Service.Local
import Service.S3

type BlobAPI =
      "CreateBlob" :> ReqBody '[JSON] Blob   :> Post '[JSON] BlobID
 :<|> "Blob"       :> QueryParam "id" BlobID :> Get  '[JSON] Blob

createBlob :: Blob -> Stor BlobID
createBlob = s3Create

getBlob :: Maybe BlobID -> Stor Blob
getBlob (Just key) = s3Read key
getBlob Nothing    = throwError $ StorError "Missing param 'id'"

handlers :: ServerT BlobAPI Stor
handlers = createBlob :<|> getBlob

storConfig :: StorConfig
storConfig = StorConfig (S3ServiceConfig "ownstore-test")

server :: Server BlobAPI
server = hoistServer blobAPI (liftToHandler storConfig) handlers

blobAPI :: Proxy BlobAPI
blobAPI = Proxy

app :: Application
app = serve blobAPI server

serveIt :: IO ()
serveIt = run 8081 app
