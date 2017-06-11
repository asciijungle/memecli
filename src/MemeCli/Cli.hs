module MemeCli.Cli(getConfig) where

import Options.Applicative
import Data.Semigroup ((<>))
import MemeCli.Types

getConfig :: IO MemeConfig
getConfig = execParser opts
  where
    opts = info (memeConfig <**> helper)
      ( fullDesc
      <> progDesc "Render a meme with the given text onto a given image"
      <> header "memecli - the cli meme generator")

memeConfig :: Parser MemeConfig
memeConfig = MemeConfig
         <$> strOption
             ( long "input"
             <> short 'i'
             <> metavar "IMAGEFILE"
             <> help "specifies the input image filename to use for the meme generation")
         <*> (getOutput <|> pure StdOutput)
         <*> strOption
              ( long "text"
              <> short 't'
              <> metavar "MEMETEXT"
              <> help "this text will be printed onto the meme" )

getOutput :: Parser Output
getOutput = FileOutput <$> strOption
  ( long "output"
  <> short 'o'
  <> metavar "OUTPUTFILE"
  <> help "specifies the image output filename")
