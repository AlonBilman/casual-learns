--from 2024 a 

{-
Define a function maybe_fold. This function should be declared as follows: 
maybe_foldl ::  (a -> b -> ( Maybe a )) -> a -> [b] -> ( Maybe a )
It should work like the standard foldl with one difference: the “folding” function returns Maybe a, not a.  
Important: you are NOT allowed to use recursion in this function. Your solution must use just standard 
higher-order functions.
-}

maybeFoldl ::  (a -> b ->  Maybe a ) -> a -> [b] ->  Maybe a 
maybeFoldl func acc = foldl(\ maybeAcc elem-> case maybeAcc of
                                           Nothing -> Nothing
                                           Just something -> func something elem) (Just acc)
                                
--examples.
-- maybeFoldl (\acc x -> if x == 0 then Nothing else Just (acc `div` x)) 100 [2,5,0,1,5,6,1,5,7,1,5] -> Nothing
-- maybeFoldl (\acc x -> Just (acc * x)) 1 [2,3,4,5,6,7,8,9] -> Just 362880


{-
As you know, it’s impossible to create a list like the following in Haskell:
[1, 4, 2, [3,4]]
However, we can define a new type to allow us to mimic this structure:
-}

data IntList = Single Int | Multi [IntList] deriving Show

--Write a function, sum' which takes a variable of type IntList and returns the sum of all the numbers in it.

sum' :: IntList -> Int
sum' (Single x) = x
sum' (Multi []) = 0
sum' (Multi (x:xs)) = sum' x + sum' (Multi xs) 

{-
Write a function, flatten which takes a variable of type IntList and returns a list of the
Int values in it

-}

flatten :: IntList -> [Int]
flatten (Single x) = [x]
flatten (Multi []) = []
flatten (Multi (x:xs)) = flatten x ++ flatten (Multi xs)


--from 2024 b 

type Matrix t = [[t]]

--first one is to flatten
matFoldRows :: (a -> t -> a) -> a -> Matrix t -> a 
matFoldRows func acc mat = let y = foldl (\acc x -> acc ++ x) [] mat in 
                           foldl(\acc x -> func acc x) acc y

matFoldRows2 :: (a -> t -> a) -> a -> Matrix t -> a 
matFoldRows2 func acc mat = foldl (\acc row -> foldl func acc row) acc mat
                          -- I could do : func = foldl (foldl func)

matFoldCols :: (a -> t -> a) -> a -> Matrix t -> a
matFoldCols func acc mat = matFoldRows func acc (transpose mat)


transpose :: Matrix t -> Matrix t 
transpose ([]:_) = [] -- if one of the elements are empty then the whole matrix is empty
transpose xs = map head xs : transpose (map tail xs) 


sumCols :: Matrix Int -> [Int]
sumCols mat =
  let rowCount = length mat
      colCount = length (head mat)
      (finalCount, finalSums) = matFoldCols (\(cnt, currentSums) item ->
              let colIndex = cnt `div` rowCount                         -- Which column are we in?
                  updatedSums = updateAt colIndex (+ item) currentSums
              in (cnt + 1, updatedSums)) (0, replicate colCount 0) mat
  in finalSums



-- apply a function at a given index 
updateAt :: Int -> (x -> x) -> [x] -> [x]
updateAt _ _ []     = []
updateAt 0 f (x:xs) = f x : xs
updateAt n f (x:xs) = x : updateAt (n - 1) f xs


{-
Look at the code below. It defines a function called at_least. As an example, it uses a function is_prime 
that tests whether a number (larger than 2) is prime or not.  How many times does your code (for 
at_least) calls the function is_prime? Write a function at_least_fast that has the same parameters as 
at_least but uses just necessary calls.
-}

atLeast :: [t] -> ( t -> Bool ) -> Int -> Bool 
atLeast l f n =   ( foldl ( \acc item -> if ( f item ) then (acc + 1) else acc ) 0 l) >= n 

isPrime :: Int -> Bool 
isPrime n = n > 2 &&  length ( filter (\item -> (( mod n item) == 0) ) ( take (n-2) [2..] )) == 0 

-- Impl
atLeastFast :: [t] -> (t -> Bool) -> Int -> Bool 
atLeastFast l f n = atLeastHelper l f 0
  where
    atLeastHelper [] _ count = count >= n
    atLeastHelper (x:xs) f count
      | count >= n     = True  
      | f x {-==True-} = atLeastHelper xs f (count + 1) --found 1
      | otherwise      = atLeastHelper xs f count