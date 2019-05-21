module Service.Http where

import Control.Monad.Trans (lift)
import qualified Network.Wreq as Wreq (get)

httpService :: Service Stor
httpService = Service httpCreate undefined undefined undefined

httpCreate :: Blob -> Stor BlobID
httpCreate blob = do
  lift $ get "http://"
