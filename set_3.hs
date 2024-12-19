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
choose x y = factorial x `div` (factorial y * factorial (x-y))
        where 
            factorial :: Int -> Int 
            factorial 0 = 1
            factorial 1 = 1
            factorial x = x * factorial (x-1)

pascaline :: Int -> [Int]
pascaline n = map (choose n) [0..n]

----------------------------------------FIFTH QUESTION----------------------------------------------

{- Write a function is_square, which takes a Matrix t and 
    determines whether it represents a square matrix.-}

type Matrix t = [[t]]

