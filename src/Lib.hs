{-# LANGUAGE OverloadedStrings #-}

module Lib (createCode, compileCode) where

import qualified Data.Text as T
import GHC.IO.Handle
import System.Process

baseCode =
  "public class Interop {\n \
  \ public static void main(String[] args) {\n \
  \ var res = [code]\n \
  \ System.out.println(\"Result is : \" +res);\n \
  \ }\n \
  \}"

createCode body = T.unpack $ T.replace "[code]" (T.pack body) baseCode

compileCode code = do
  _ <- writeFile "./java/Interop.java" code
  _ <- createProcess (proc "javac" ["Library.java", "Interop.java"]) {cwd = Just "./java/"}
  _ <- createProcess (proc "java" ["Interop"]) {cwd = Just "./java/"}
  return ()
