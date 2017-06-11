module Main where

import MemeCli.Types
import qualified MemeCli.Cli as Cli
import qualified MemeCli.Img as Img

main :: IO ()
main = generateMeme =<< Cli.getConfig

generateMeme :: MemeConfig -> IO ()
generateMeme config = do
  print config
  putStrLn $ "Creating meme using " ++ getInputFile config
  Img.createMeme (getInputFile config) (getOutputFile config) (getMemeText config) 


