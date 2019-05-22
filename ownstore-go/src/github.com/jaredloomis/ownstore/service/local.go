package main

import "io/ioutil"

import "../service"

type LocalService struct {
  rootFolder string
}

func (r LocalService) Store(blob Blob) (Identifier, OwnError) {
  return "", nil
}
