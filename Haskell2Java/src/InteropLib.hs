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
  \ System.out.println(\"Result is : \" +res);\n \
  \ }\n \
  \}"

createCode body = T.unpack $ T.replace "[code]" (T.pack body) baseCode -- We do a little string processing

compileCode code = do
  _ <- writeFile "./java/Interop.java" code -- create the temporary java source file
  _ <- createProcess (proc "javac" ["Library.java", "Interop.java"]) {cwd = Just "../work/"} -- Execute `javac Library.java Interop.java` in work directory
  _ <- createProcess (proc "java" ["Interop"]) {cwd = Just "../work/"} -- Execute our Interop class
  return () -- Can't produce any meaningful result type :(
