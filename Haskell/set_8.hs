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