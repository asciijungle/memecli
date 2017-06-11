module MemeCli.Types where

type FileName = String
type MemeText = String

data Output
  = FileOutput FilePath
  | StdOutput
  deriving (Eq, Show)

data MemeConfig = MemeConfig
  { input :: FileName
  , output :: Output
  , text :: MemeText }
  deriving (Eq, Show)

getInputFile :: MemeConfig -> FileName
getInputFile (MemeConfig x _ _) = x

getOutputFile :: MemeConfig -> Output
getOutputFile (MemeConfig _ x _) = x

getMemeText :: MemeConfig -> MemeText
getMemeText (MemeConfig _ _ x) = x
