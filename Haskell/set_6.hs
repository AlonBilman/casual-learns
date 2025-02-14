{-Write a function even_odd that takes a single string as a parameter and 
returns Either String Bool. If the string represents a valid positive 
integer (of any length), the function returns True if the number contains an 
even number of odd and even digits. It returns False if the number contains 
uneven numbers of odd and even digits. If the given string is not a positive integer 
number, the function returns a string describing the problem. 
-}

evenOdd :: String -> Either String Bool
evenOdd [] = Left "Empty String"
evenOdd ('0':xs) = Left "Not a number"
evenOdd ('-':xs) = Left "Not a positive number or not a number"
evenOdd xs = if isNumber xs 
             then if even (foldl(\acc e -> if even (read [e] :: Int) then acc + 1 else acc) 0 xs) && 
                     even (foldl(\acc e -> if odd (read [e] :: Int) then acc + 1 else acc) 0 xs)
               then Right True else Right False else Left "Not a number"
    where isNumber :: String -> Bool
          isNumber = foldl (\acc i -> acc && (i `elem` ['0'..'9'])) True 

---------------------------------------------------------------------------------------------------------------
{-Write a function is_valid which takes a string and decides whether the 
parentheses in it are valid. By “Valid” we mean that the number of left 
parentheses equals the number of right ones AND that at any point in the string, 
the number of left parentheses is greater than or equal to the number of right 
ones.-}

isValid :: String -> Bool
isValid x  = foldl (\acc e -> if acc + e < 0 then acc - (length x + 1) else acc + e ) 0
                     (map (\k -> if k== ')' then -1 else if k == '(' then 1 else 0) x) == 0

isValid2 :: String -> Bool
isValid2 str = let y = map(\x -> if x == '(' then 1 else if x == ')' then -1 else 0) str
              in sum y == 0 && fst (foldl(\(acc,sum) x -> (acc && sum+x >= 0 ,sum+x)) (True,0) y)
              
{-Write a function find_matching that takes a string and an index of a left 
parenthesis and returns the index of the matching right parenthesis. 
You can safely assume that the string is valid according to the previous question 
and that the given index is one of a left parenthesis. -}

findMatching :: String -> Int -> Int
findMatching [] _ = -1 --as error
findMatching str i = findIndex 0 (i+1)
    where findIndex :: Int -> Int -> Int
          findIndex sum inx
            | str !! inx == ')' = if sum == 0
                then inx
                else findIndex (sum-1) (inx+1)
            | str !! inx == '(' = findIndex (sum+1) (inx+1)
            | otherwise = findIndex sum (inx+1)

---------------------------------------------------------------------------------------------------------------
{-Write a function compose, which takes a string and a Dictionary and returns an 
object of type Op (a function). This returned function will be the composition of 
the functions in the input string (the rightmost function is the first to be applied).  
The string is composed of function names separated by ‘.’ and optional spaces.  -}

type Op t = t -> t
type Dictionary t = [(String, Op t)]

compose :: String -> Dictionary t -> Op t
compose str dict = let nStr = words (map(\x -> if x == '.' then ' ' else x) str)
                in foldl(\res x-> res . snd (head (filter (\y -> fst y == x) dict))) id nStr

--Some tests : 

dic :: Dictionary Int
dic = [("add", (+2)), ("sub", subtract 2), ("mul", (*3))]

main :: IO ()
main = do
    print $ compose "add . mul . sub" dic 10  -- Expected: 26
    print $ compose "mul . add" dic 4        -- Expected: 18
    print $ compose "sub . mul" dic 6        -- Expected: 16
    print $ compose "add . sub . mul" dic 5  -- Expected: 15
    print $ compose "" dic 7                 -- Expected: 7 (identity function)

------------------------------------------------------------------------------------------------------------------
{-filter_with_index is a higher order function taking two
parameters: a predicate f and a list, and produces a list
of all the elements from the input list that satisfy f. 
f is a predicate (function) that is applied on each element in the input list, 
and its index (its position in the list),
and returns a Boolean value that is the result of some condition on the element and its index.
-}

filterWithIdex :: (a -> Int -> Bool) -> [a] -> [a]
filterWithIdex f xs = map fst (filter (\(a,b) -> f a b) (zip xs [0..]))

------------------------------------------------------------------------------------------------------------------