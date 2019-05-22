package main

import (
  "fmt"
)


func main() {
  fmt.Printf("%t", OwnError {ERR_NONE, "wasabi"}.Ok())
}
