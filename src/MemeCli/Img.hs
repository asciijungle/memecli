module MemeCli.Img
  (createMeme)
where

import qualified Graphics.GD as GD
import MemeCli.Types
import MemeCli.Text

textColorWhite :: GD.Color
textColorWhite = GD.rgb 255 255 255

textColorBlack :: GD.Color
textColorBlack = GD.rgb 0 0 0

textSize :: TextSize
textSize = 32.0

initialTextSize :: TextSize
initialTextSize = 200.0

padding :: Int
padding = 10

quality :: Int
quality = 85

targetBlockRatio :: Double
targetBlockRatio = 4

-- (Width, Height)
type Dimensions = (Int, Int)
type TextSize = Double

createMeme :: FilePath -> Output -> MemeText -> IO ()
createMeme x StdOutput y = createMeme x (FileOutput x) y
createMeme input (FileOutput output) text = do
  img <- GD.loadJpegFile input
  _ <- GD.useFontConfig True
  GD.saveJpegFile quality output =<< renderText img text

renderText :: GD.Image -> MemeText -> IO GD.Image
renderText img text = renderBlock img =<< generateBlock text =<< GD.imageSize img

generateBlock :: MemeText -> Dimensions -> IO (Block, TextSize)
generateBlock text imgDim = go $ createBlock text
  where
    go :: Block -> IO (Block, TextSize)
    go block = do
      (textSize, dimensions) <- getBlockDimensions block imgDim
      let ratio = getRatio dimensions
      let (imgW, imgH) = imgDim
      let targetRatio = getRatio (imgW, imgH `div` 5)
--      putStrLn $ "Current ratio is: " ++ show ratio ++
--        " Current block dimensions: " ++ show dimensions ++
--        " Current block: " ++ show block ++
--        " Current FontSize: " ++ show textSize ++
--        " Target Ratio : " ++ show targetRatio
      if (length (longestLine block) > 1) && ratio > targetRatio then
        go $ adjustLines (length block + 1) block
      else
        return (block, textSize)

getRatio :: Dimensions -> Double
getRatio (width, height) = fromIntegral width /  fromIntegral height

renderBlock :: GD.Image -> (Block, TextSize) -> IO GD.Image
renderBlock img (block, size) = do
  (imgW, imgH) <- GD.imageSize img
  (size, (blockW, blockH)) <- getBlockDimensions block (imgW, imgH)
  putStrLn $ "rendering block with dimensions: " ++ show (blockW, blockH)
  renderLines block (lineHeight blockH) blockH
  where
    renderLines :: Block -> Int -> Int -> IO GD.Image
    renderLines [] _  _ = return img
    renderLines (x:xs) offset blockH = do
      _ <- GD.drawString "sans" size 0.0 (0+3, offset+3) (unwords x) textColorBlack img
      _  <- GD.drawString "sans" size 0.0 (0, offset) (unwords x) textColorWhite img
      renderLines xs (offset + lineHeight blockH) blockH

    lineHeight x = x `div` (length block)

getBlockDimensions :: Block -> Dimensions -> IO (TextSize, Dimensions)
getBlockDimensions block imgDim = do
  (textSize, (width, height)) <- getLineDimensions (longestLine block) imgDim
  return (textSize, (width, height * length block))

getLineDimensions :: Line -> Dimensions -> IO (TextSize, Dimensions)
getLineDimensions line imgDim= do
  fontSize <- getLineFontSize line imgDim
  dimensions <- stringMeasurements fontSize $ unwords line
  return (fontSize, dimensions)

getLineFontSize :: Line -> Dimensions -> IO Double
getLineFontSize = getStringFontSize . unwords  

getStringFontSize :: MemeText -> Dimensions -> IO Double
getStringFontSize text imgSize = go initialTextSize
  where
    go :: TextSize -> IO TextSize
    go size = do
      bool <- fitsImage size imgSize
      if bool then
        return size
      else
        go $ size - 1
      where
        fitsImage :: TextSize -> Dimensions -> IO Bool
        fitsImage size imgSize = do
          textSize <- stringMeasurements size text
--          putStrLn $ "textSize: " ++ show textSize ++ " imageSize:" ++ show imgSize
          return (fst imgSize > fst textSize && snd imgSize > snd textSize)

stringMeasurements :: TextSize -> MemeText -> IO Dimensions
stringMeasurements size text = do
  (_, (lrx, lry), _, (ulx, uly)) <- GD.measureString "sans" size 0.0 (0, 0) text textColorWhite
  return (lrx - ulx, lry - uly)
