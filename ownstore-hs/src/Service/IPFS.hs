module Service.IPFS where

ipfsCreate blob = do
  key <- lift randomBlobID
  out <- readCreateProcess (proc "ipfs" ["add", ""]) ""
