module MemeCli.Text where

import Data.List
import Data.Maybe
import Test.QuickCheck

type Line  = [String]
type Block = [Line]

createBlock :: String -> Block
createBlock x = [createLine x]  

createLine :: String -> Line
createLine = words

adjustLines :: Int -> Block -> Block
adjustLines numLines block = fromJust $ splitTo numLines $ concat block

longestLine :: Block -> Line
longestLine b = words $ foldr1 (\x y -> if length x > length y then x else y) $ map (concat . intersperse " ") b

prop_splitTo xs int =
  if length xs > int && int > 0 then
    int == length (fromJust (splitTo int xs))
  else
    True

splitTo :: Int -> [a] -> Maybe [[a]]
splitTo num list
  | num < 1 = Nothing
  | num > length list = Nothing
  | otherwise = Just $ go num list
  where
    go :: Int -> [a] -> [[a]]
    go _ [] = []
    go rem list = take lineLength list : go (rem - 1) (drop lineLength list)
      where
        lineLength :: Int
        lineLength =
          if length list `mod` rem > 0 then
            length list `div` rem + 1
          else
            length list `div` rem
