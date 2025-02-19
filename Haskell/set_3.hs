----------------------------------------FIRST QUESTION---------------------------------------------
--Shift string by 1 

shiftString :: String -> String
shiftString "" = ""
shiftString x = let y = last x : x in init y     

----------------------------------------SECOND QUESTION---------------------------------------------
{- function that takes two Strings and returns True if 
    one of them is a result of applying shiftString 
    one or more times -}

isShifted :: String -> String -> Bool 
isShifted "" "" = True
isShifted x y = (length x == length y)  && 
                    foldl(\acc index -> acc || shiftStringFor index x == y) False (take (length x) [1..])
                    where 
                        shiftStringFor :: Int -> String -> String 
                        shiftStringFor _ "" = ""
                        shiftStringFor 0 x = x
                        shiftStringFor i x = foldl(\acc _-> shiftString acc) x (take i [1..])

--another way to do it
isShifted2 :: String -> String -> Bool
isShifted2 "" "" = True
isShifted2 x y = (length x == length y) &&
        foldl (\acc str -> acc || str == y) False (take (length x) (iterate shiftString x))
                    
                        
----------------------------------------THIRD QUESTION-----------------------------------------------

--stupidListOp [1, 3, 2] = [1, 3, 3, 3, 2, 2] 
{-
The returned list is composed 
of the values in the original one, where is a value is n, it’s 
replaced with a list of n elements having the same value. -}

stupidListOp :: [Int]->[Int]
stupidListOp [] = []
stupidListOp [x] = if x<0 then [] else replicate x x 
stupidListOp (x:xs) = stupidListOp [x] ++ stupidListOp xs

----------------------------------------FOURTH QUESTION----------------------------------------------

{- Write a function pascalLine, which takes a *positive* Int n and 
returns the n_th line of the Pascal Triangle. -} --https://en.wikipedia.org/wiki/Pascal%27s_triangle

-- n choose k = n! / (k! * (n-k)!)

choose :: Int -> Int -> Int 
choose 0 _ = 1
choose _ 0  = 1
choose x y = if y > x then 0 else factorial x `div` (factorial y * factorial (x-y))
        where 
            factorial :: Int -> Int 
            factorial 0 = 1
            factorial 1 = 1
            factorial x = x * factorial (x-1)

pascaline :: Int -> [Int]
pascaline n = map (choose n) [0..n]

----------------------------------------FIFTH QUESTION----------------------------------------------

{- Write a function isSquare, which takes a Matrix t and 
    determines whether it represents a square matrix.-}

type Matrix t = [[t]]

isSquare :: Matrix t -> Bool
isSquare [] = True
--for every row in the matrix, the length of the row must match the number of rows in the matrix.
isSquare x = foldl(\acc y -> acc && (length x == length y)) True x 

{- Write a function map_matrix, which takes a Matrix t, and a 
function and returns a new Matrix t. The elements of the new 
matrix are created by applying the function to each of the items 
in the argument. 
map_matrix (^2) [[1,2],[3,2]] should return [[1,4],[9,4]]-}

mapMatrix :: (t -> t) -> Matrix t -> Matrix t
mapMatrix _ [] = []
mapMatrix f x = map (map f) x

{-Wrute map_matrix2
The difference from map_matrix is that the 
function that we apply to each element takes not only the item 
but also a tuple that contains its indices. Here is the 
declaration for map_matrix2 -}

map_matrix2 :: (t -> (Int,Int) -> u )->Matrix t->Matrix u
map_matrix2 _ [] = []
map_matrix2 f m = map (\(row, e) -> map (\(col, e2) -> f e2 (row, col)) (zip [0..] e)) (zip [0..] m)


{-Write a function transpose, which takes a square matrix 
and transposes it (rotates values around the main axis). This 
function must use map_matrix2-}

transpose :: Matrix t -> Matrix t
transpose [] = [] 
transpose x = map_matrix2 (\_ (row,col) -> (x !! col) !! row) x


----------------------------------------SIXTH QUESTION-----------------------------------------------
{-Implement an ID card validation function using a checksum.

Algorithm:
- Ensure the number has exactly 9 digits, pad with 0's if shorter.
- Double every second digit from the left.
    Example: [1,3,5,1,6,7…] -> [1, 6, 5, 2, 6, 14…]
- Sum the digits of the doubled values and the undoubled digits.
    Example: [1, 6, 5, 2, 6, 14] -> 1 + 6 + 5 + 2 + 6 + 1 + 4
- If the sum modulo 10 is 0, the number is valid.

-After that Write the function -  validate
validate 58908021 should give -> True 
validate 12345678 should give -> False -}

toDigits :: Integer -> [Integer]
toDigits x | x<=0 = [] 
toDigits x = let digits = helper x 
                in replicate (9 - length digits) 0 ++ digits
    --I could use [read [d] | d <- show x] instad of the helper. it turns a number into a list of its digits as integers.
    where
    helper x | x<=0 = [] 
    helper x = helper (x `div` 10) ++ [x `mod` 10]

doubleEveryOther :: [Integer] -> [Integer]
doubleEveryOther [] = [] 
doubleEveryOther x = let indexedList = zip x [0,1..] 
                        in map (\(val, idx) -> if odd idx then 2 * val else val) indexedList

sumDigits :: [Integer] -> Integer
sumDigits [] = 0
sumDigits [x] = x
sumDigits x = sum (map (\y -> if y>9 then sum (toDigits y) else y) x)

validate :: Integer -> Bool
validate x = sumDigits(doubleEveryOther(toDigits x)) `mod` 10 == 0

--And now that I have sort of experience in Haskell, here is a bettwer solution : 

validate2 :: Integer -> Bool
validate2 x = let digit = replicate (9- length(show x)) '0' ++ show x
              in let digitArr = map (\x -> read [x] :: Int) digit
              in let digitArrDoubled = map (\(i,e)-> if i `mod` 2 == 0 then e else e*2) (zip [0..] digitArr)
              in let digitArrDoubledSeperated = foldl(\acc e -> if e > 9 then acc ++ [e `div` 10, e `mod` 10] else acc ++ [e]) [] digitArrDoubled
              in sum digitArrDoubledSeperated `mod` 10 == 0


----------------------------------------END OF SET 3-----------------------------------------------