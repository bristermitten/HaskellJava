import Control.Monad
main = do
    i <- readLn :: IO Int
    replicateM_ i (putStrLn "Hello World")
