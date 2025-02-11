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