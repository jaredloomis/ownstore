{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
module Http where

import Servant
import Network.Wai.Handler.Warp (run)
import Control.Monad.Trans

import Stor
import Blob
import Service.Local

type BlobAPI =
      "CreateBlob" :> ReqBody '[JSON] Blob   :> Post '[JSON] BlobID
 :<|> "Blob"       :> QueryParam "id" BlobID :> Get  '[JSON] (Maybe Blob)

createBlob :: Blob -> Stor BlobID
createBlob = localCreate

getBlob :: Maybe BlobID -> Stor (Maybe Blob)
getBlob (Just key) = fmap Just $ localGet key
getBlob Nothing    = return Nothing

handlers :: ServerT BlobAPI Stor
handlers = createBlob :<|> getBlob

server :: Server BlobAPI
server = hoistServer blobAPI liftToHandler handlers

blobAPI :: Proxy BlobAPI
blobAPI = Proxy

app :: Application
app = serve blobAPI server

serveIt :: IO ()
serveIt = run 8081 app
