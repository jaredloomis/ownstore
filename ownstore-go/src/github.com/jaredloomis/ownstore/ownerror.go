package main

type OwnError struct {
  code int
  message string
}

func (err OwnError) Ok() bool {
	return err.code == ERR_NONE
}

const (
  ERR_NONE = iota
)
