package main

type Service interface {
  Store(Blob) (Identifier, OwnError)
  Update(Identifier, Blob) OwnError
  Get(Identifier) (Blob, OwnError)
  Delete(Identifier) OwnError
}
