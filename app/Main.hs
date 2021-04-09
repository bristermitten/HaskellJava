module Main where

import Lib

main :: IO ()
main = do
  let content = "Library.add(3, 4);"
  let code = createCode content
  compileCode code