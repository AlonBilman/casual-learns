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
---------------------------------------------------------------------------------------------------------------------------
-- Matrix transpose 

type Matrix t = [[t]]

transpose :: Matrix t -> Matrix t 
transpose ([]:_) = [] -- if one of the elements are empty then the whole matrix is empty
transpose xs = map head xs : transpose (map tail xs)

----------------------------------------------------------------------------------------------------------------------------

{-The function scan takes a list, scans it from beginning to end, and
compares each of the adjacent elements: if they are in ascending
order, then it keeps the elements in the same order, otherwise, it
swaps the positions of the two elements. -}

scan :: [Int] -> [Int]
scan [] = []
scan [x] = [x]
scan (x:y:xs) = if x<y then x : scan (y:xs) else y : scan (x:xs) 

--another way to do it
scan2 :: [Int] -> [Int]
scan2 [] = []
scan2 [x] = [x] 
scan2 x = foldl (\acc i -> if acc !! i > acc !! (i+1) then switch acc i (i+1) else acc) x [0..length x - 2]
                where 
                    switch :: [Int] -> Int -> Int -> [Int]
                    switch xs a b = map (\(i, e) -> if i == a then xs !! b else if i == b then xs !! a else e) (zip [0..] xs)

----------------------------------------------------------------------------------------------------------------------------

{-  •Define the function filtered_map, which is a combination of the filter
        and map functions.
    • filtered_map takes two parameters: a unary function f and a list of
        items of type t. The function f is applied on each element of the input
        list and returns (Maybe t). If f returns Nothing, the given element is
        removed from the result list. If f returns Just t, t is placed in the result
        list.
-}

filteredMap :: (t->Maybe t) -> [t] -> [t]
filteredMap _ [] = []
filteredMap f xs = map(\(Just x) -> x)(filter isJust (map f xs))
                where 
                    isJust :: Maybe t -> Bool 
                    isJust (Just _) = True
                    isJust _ = False

--another way to do it
filteredMap2 :: (t -> Maybe t) -> [t] -> [t]
filteredMap2 _ [] = []
filteredMap2 f xs = [x | Just x <- map f xs]

--and another one
filteredMap3 :: (t -> Maybe t) -> [t] -> [t]
filteredMap3 f list = foldl(\acc item -> acc ++ convertMaybe (f item)) [] list
                    where 
                        convertMaybe :: Maybe t -> [t]
                        convertMaybe Nothing = []
                        convertMaybe (Just x) = [x]