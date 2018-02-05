module Stor where

import Servant (Handler(..))
import Control.Monad.State (StateT, runStateT)
import Control.Monad.Trans (lift)
import Control.Monad.Morph (hoist)

type Stor = StateT StorState IO

data StorState = StorState {
} deriving (Show, Eq)

liftToHandler :: Stor a -> Handler a
liftToHandler stor =
    Handler . fmap fst . lift . runStateT stor $ StorState
