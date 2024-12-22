{-map_with_index will be a higher order function taking two parameters: a function (that we call f) and a 
list (much like the standard filter function).  The function f is a function that is applied on each element 
in the input list, and its index (its position in the list), and returns a value.  
For example: 
map_with_index (\item index -> odd index) [2,3,5,6,7] = [False, True, False, True, False] 
map_with_index (\item index -> item+index + 5) [2,3,5,1,7]  = [7, 9, 12, 9, 16]-}

mapWithIndex :: (a -> Int -> b) -> [a] -> [b]
mapWithIndex f xs = map (\(i,e)-> f e i) (zip [0..] xs)


----------------------------------------------------------------------------------------------------------------------------
{-Define a function remove_if_index, which removes from a list of Int all items whose value is the same as 
their index.  
For example, when applied to [1,1,1,3,3,3] the result should be [1,1,3,3]-}

removeIfIndex :: [Int] -> [Int]
removeIfIndex [] = []
removeIfIndex x = map snd (filter (\(i, e) -> e /= i) (zip [0..] x))


----------------------------------------------------------------------------------------------------------------------------

data BinTree t = Empty | Node (BinTree t) t (BinTree t) deriving (Eq,Ord,Show) 

inOrder :: BinTree t -> [t]
inOrder Empty = []
inOrder (Node l x r) = inOrder l ++ [x] ++ inOrder r

isSorted :: Ord a => BinTree a -> Bool
isSorted tree = let y = inOrder tree 
                in foldl(\acc i -> acc && ((y !! i) <= (y !! (i+1)))) True [0..length y - 2]
                

intersectTrees :: Ord a => BinTree a -> BinTree a -> BinTree a
intersectTrees Empty _ = Empty
intersectTrees _ Empty = Empty
intersectTrees tree1 tree2 = let y = inOrder tree1
                                 z = inOrder tree2
                                 in listToTree (filter (`elem` z) y)
                                 where 
                                    listToTree :: Ord a => [a] -> BinTree a
                                    listToTree [] = Empty
                                    listToTree (x:xs) = Node (listToTree (filter(<x) xs)) x (listToTree (filter(>x) xs))
