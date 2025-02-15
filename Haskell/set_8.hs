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


