import System.IO

import Data.Vector as V
import Data.List as L

import Control.Monad
import Control.Parallel.Strategies

forall :: (a -> Bool) -> [a] -> Bool
forall p []     = True
forall p (x:xs) = if p x then forall p xs else False

goodChars = "qwertyuiopasdfghjklzxcvbnm"

allGoodChars :: String -> Bool
allGoodChars = forall (\c -> L.elemIndex c goodChars /= Nothing)

charIndex :: Char -> Int
charIndex c =
  case c of
    'a' -> 0
    'b' -> 1
    'c' -> 2
    'd' -> 3
    'e' -> 4
    'f' -> 5
    'g' -> 6
    'h' -> 7
    'i' -> 8
    'j' -> 9
    'k' -> 10
    'l' -> 11
    'm' -> 12
    'n' -> 13
    'o' -> 14
    'p' -> 15
    'q' -> 16
    'r' -> 17
    's' -> 18
    't' -> 19
    'u' -> 20
    'v' -> 21
    'w' -> 22
    'x' -> 23
    'y' -> 24
    'z' -> 25
    _   -> error "bad"

increment :: Int -> Vector Int -> Vector Int
increment i v = (V.take i v) V.++ (cons (1 + v ! i) (V.drop (i + 1) v))

generateStack :: String -> Vector Int
generateStack string =
  let calc result []     = result
      calc result (c:cs) = calc (increment (charIndex c) result) cs
  in calc (V.replicate 26 0) string

parMapWithIndex :: (Int -> a -> b) -> [a] -> [b]
parMapWithIndex f list =
  let helper i l = runEval $
        if L.null l then return []
        else
          let current = f i $ L.head l; rest = helper (i + 1) $ L.tail l
          in rpar current >> rseq rest
            >> (return $ current:rest)
  in helper 0 list

main = do
  handle <- openFile "words.txt" ReadMode
  contents <- hGetContents handle
  let goodWords = L.filter allGoodChars $ words contents
      stacks    = parMap rpar generateStack goodWords
  putStrLn "What string (all lowercase letters) would you like to find anagrams for?"
  input <- getLine
  let stack          = generateStack input
      anagramIndices = L.filter (\x -> x >= 0) $ parMapWithIndex (\i s -> if s == stack then i else (-1)) stacks
      anagrams       = L.map (\i -> goodWords !! i) anagramIndices
  putStrLn $ intercalate "\n" anagrams