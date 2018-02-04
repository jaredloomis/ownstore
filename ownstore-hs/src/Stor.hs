module Stor where

import Control.Monad.State

type Stor = StateT StorState IO

data StorState = StorState {
--    maps :: Int
} deriving (Show, Eq)
