-- Author: Matt Bass
--- Day 2: Cube Conundrum ---
-- You're launched high into the atmosphere! The apex of your trajectory just barely reaches the surface 
-- of a large island floating in the sky. You gently land in a fluffy pile of leaves. 
-- It's quite cold, but you don't see much snow. An Elf runs over to greet you.
-- The Elf explains that you've arrived at Snow Island and apologizes for the lack of snow. 
-- He'll be happy to explain the situation, but it's a bit of a walk, so you have some time. 
-- They don't get many visitors up here; would you like to play a game in the meantime?
-- As you walk, the Elf shows you a small bag and some cubes which are either red, green, or blue. 
-- Each time you play this game, he will hide a secret number of cubes of each color in the bag, 
-- and your goal is to figure out information about the number of cubes.
-- To get information, once a bag has been loaded with cubes, the Elf will reach into the bag, 
-- grab a handful of random cubes, show them to you, and then put them back in the bag. He'll do this a few times per game.
-- You play several games and record the information from each game (your puzzle input). 
-- Each game is listed with its ID number (like the 11 in Game 11: ...) 
-- followed by a semicolon-separated list of subsets of cubes that were revealed from the bag (like 3 red, 5 green, 4 blue).
-- For example, the record of a few games might look like this:
-- Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
-- Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
-- Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
-- Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
-- Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
-- In game 1, three sets of cubes are revealed from the bag (and then put back again). The first set is 3 blue cubes 
-- and 4 red cubes; the second set is 1 red cube, 2 green cubes, and 6 blue cubes; the third set is only 2 green cubes.
-- The Elf would first like to know which games would have been possible 
-- if the bag contained only 12 red cubes, 13 green cubes, and 14 blue cubes?
-- In the example above, games 1, 2, and 5 would have been possible if the bag had been loaded with that configuration. 
-- However, game 3 would have been impossible because at one point the Elf showed you 20 red cubes at once; 
-- similarly, game 4 would also have been impossible because the Elf showed you 15 blue cubes at once. 
-- If you add up the IDs of the games that would have been possible, you get 8.
-- Determine which games would have been possible if the bag had been loaded with only 12 red cubes,
-- 13 green cubes, and 14 blue cubes. What is the sum of the IDs of those games?
import System.Environment
import System.Directory
import Data.Char (isDigit, isSpace)
import Data.List (isInfixOf, dropWhile)


type CubeCount = (Int, Int, Int)  -- Representing (Red, Green, Blue)
type Game = [CubeCount]

splitOn :: String -> String -> [String]
splitOn delimiter = foldr f [""] 
  where
    delimLength = length delimiter
    f char acc@(x:xs)
        | take delimLength (char:x) == delimiter = "" : acc
        | otherwise = (char:x) : xs
    f _ [] = error "foldr invariant violated"



-- Split the input into games
splitGames :: String -> [String]
splitGames input = splitOn "Game " input

-- Split a game string into CubeCounts
parseGame :: String -> Game
parseGame gameStr = map parseSet $ splitOn ";" (dropGamePrefix gameStr)

-- Drop the prefix up to and including the colon
dropGamePrefix :: String -> String
dropGamePrefix = drop 1 . dropWhile (/= ':')

-- Split a set of cubes into individual color-count pairs and parse each
parseSet :: String -> CubeCount
parseSet setStr = foldl parseCube (0, 0, 0) $ wordsWhen (==',') setStr

-- Custom function to split a string by a given delimiter
wordsWhen :: (Char -> Bool) -> String -> [String]
wordsWhen p s = case dropWhile p s of
                      "" -> []
                      s' -> w : wordsWhen p s''
                            where (w, s'') = break p s'

-- Parse a single color-count pair
parseCube :: CubeCount -> String -> CubeCount
parseCube (r, g, b) cubeStr = 
    let count = read (filter isDigit cubeStr) :: Int
    in case () of
       _ | "red" `isInfixOf` cubeStr    -> (r + count, g, b)
         | "green" `isInfixOf` cubeStr  -> (r, g + count, b)
         | "blue" `isInfixOf` cubeStr   -> (r, g, b + count)
         | otherwise                    -> (r, g, b)



-- Function to read the file and parse it into a list of games
processGamesFile :: FilePath -> IO [Game]
processGamesFile filePath = do
    fileContent <- readFile filePath
    let gamesStrings = splitGames fileContent
    let games = map parseGame $ filter (not . null) gamesStrings
    return games

-- Function to check if a file is readable
isFileReadable :: FilePath -> IO Bool
isFileReadable filePath = do
  exists <- doesFileExist filePath
  readable <- if exists then readable <$> getPermissions filePath else return False
  return (exists && readable)

-- Function to find possible games based on the known maximum cube counts
findPossibleGames :: [Game] -> CubeCount -> [Int]
findPossibleGames games (maxRed, maxGreen, maxBlue) =
    map fst $ filter (isPossibleGame . snd) $ zip [1..] games
  where
    isPossibleGame :: Game -> Bool
    isPossibleGame game = all (\(r, g, b) -> r <= maxRed && g <= maxGreen && b <= maxBlue) game




-- Main function
main :: IO ()
main = do
    -- Get command-line arguments
    args <- getArgs

    -- Check if an argument is provided
    case args of
        [filePath, redStr, blueStr, greenStr] -> do
            let redCubes = read redStr :: Int
            let blueCubes = read blueStr :: Int
            let greenCubes = read greenStr :: Int
            canRead <- isFileReadable filePath
            if canRead then do
                games <- processGamesFile filePath
                let possibleGames = findPossibleGames games (redCubes, greenCubes, blueCubes)
                putStrLn $ "The sum of the IDs of the Possible games is: " ++ show (sum possibleGames)
            else
                putStrLn ("Cannot read the file: " ++ filePath)
        _ -> putStrLn "Usage: <program> <file_path> <red_cubes> <blue_cubes> <green_cubes>"
