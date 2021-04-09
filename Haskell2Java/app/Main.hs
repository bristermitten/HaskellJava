module Main where

import InteropLib

main :: IO ()
main = do
  let content = "Library.add(3, 4); for(int i = 0; i < 10; i++) System.out.println(i);" -- Our Java code to execute
  let code = createCode content -- Create a full java program that we can compile and run
  res <- compileCode code -- Execute the code
  putStrLn $ "Output: " ++ res