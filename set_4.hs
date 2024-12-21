{-Write a function invert, which takes a list [t], and a pair (a,b) of
integers. The function will return Either String t. If a and b are valid
indices, the function will return Right [t] – where [t] is a list in which
the items in indices a and b will exchange places. If either a or b is not
valid, the function will return Left s, where s is a string describing the
problem. -}

invert :: [t] -> (Int, Int) -> Either String [t]
invert [] _ = Left "Empty list"
invert x (a,b) = if a < 0 || b < 0 || a >= length x || b >= length x then Left "Bad indices" 
                    else Right (helper x (min a b) (max a b))
                    where 
                        helper :: [t] -> Int -> Int -> [t]
                        helper [] _ _ = []
                        helper xs a b = let (beforeA, afterA) = splitAt a xs
                                            (beforeB, afterB) = splitAt (b - a - 1) (tail afterA)
                                            elementA = head afterA
                                            elementB = head afterB
                                        in beforeA ++ [elementB] ++ beforeB ++ [elementA] ++ tail afterB
-- something simple like switching places can be abit costly 
-- so we can use list comprehension to do the same thing                  
invert2 :: [t] -> (Int,Int) -> Either String [t] 
invert2 [] _ = Left "Empty list"
invert2 x (a,b) = if a < 0 || b < 0 || a >= length x || b >= length x then Left "Bad indices"
                    else Right (helper2 x a b)
                    where 
                        helper2 :: [t] -> Int -> Int -> [t]
                        helper2 [] _ _ = []
                        helper2 xs a b = let elementA = xs !! a
                                             elementB = xs !! b
                                        in [if i == a then elementB else if i == b then elementA else xs !! i | i <- [0..length xs - 1]]

--another with map and zip
invert3 :: [t] -> (Int, Int) -> Either String [t]
invert3 [] _ = Left "Empty list"
invert3 x (a, b)
    | a < 0 || b < 0 || a >= length x || b >= length x = Left "Bad indices"
    | otherwise = Right (helper3 x a b)
  where
    helper3 :: [t] -> Int -> Int -> [t]
    helper3 xs a b = 
        map (\(i, e) -> if i == a then xs !! b else if i == b then xs !! a else e) (zip [0..] xs)
