{-# LANGUAGE OverloadedStrings #-}

module InteropLib (createCode, compileCode) where

import qualified Data.Text as T
import GHC.IO.Handle
import System.Process

baseCode =
  -- The full code of our program.
  "public class Interop {\n \
  \ public static void main(String[] args) {\n \
  \ var res = [code]\n \
  \ System.out.println(res);\n \
  \ }\n \
  \}"

createCode body = T.unpack $ T.replace "[code]" (T.pack body) baseCode -- We do a little string processing

compileCode :: String -> IO String
compileCode code = do
  _ <- writeFile "../work/Interop.java" code -- create the temporary java source file
  (_, _, compileErrorMaybe, _) <- createProcess (proc "javac" ["Library.java", "Interop.java"]) {cwd = Just "../work/"} -- Execute `javac Library.java Interop.java` in work directory
  (_, maybeOut, _, _) <- createProcess (proc "java" ["Interop"]) {cwd = Just "../work/", std_out = CreatePipe} -- Execute our Interop class
  case (compileErrorMaybe, maybeOut) of
    (Just err, _) -> hGetContents err
    (Nothing, Just out) -> hGetContents out
    _ -> return "Program ran without output."
