module Main where

import Lib

main :: IO ()
main = do
  let content = "Library.add(3, 4);" -- Our Java code to execute
  let code = createCode content -- Create a full java program that we can compile and run
  compileCode code -- Execute the code