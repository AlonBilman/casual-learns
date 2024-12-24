
{-1.a-}

remove_consecutive :: Eq t => [t] -> [t]
remove_consecutive [] = [] 
remove_consecutive x  = foldr (\acc b -> if acc == head b then b else acc:b) [last x] x

{-1.b-}

filtered_map :: (t->Maybe t) -> [t] -> [t]
filtered_map f list = foldl (\acc e -> acc ++ convertMaybe (f e)) [] list
                    where 
                        convertMaybe :: Maybe t -> [t]
                        convertMaybe Nothing = []
                        convertMaybe (Just x) = [x]

{-2-}

data BinTree t = Empty | Node (BinTree t) t (BinTree t) deriving Show

{-2a-}

in_order :: BinTree t -> [t]
in_order Empty = []
in_order (Node left e right) = in_order left ++ [e] ++ in_order right

is_sorted :: Ord t => BinTree t -> Bool
is_sorted Empty = True
is_sorted tree = let y = in_order tree 
                in foldl(\acc i -> acc && ((y !! i) < (y !! (i+1)))) True [0..length y - 2]



{-2b-}

list_to_tree :: Ord t => [t] -> BinTree t
list_to_tree [] = Empty
list_to_tree (x:xs) = Node (list_to_tree (filter (<x) xs)) x (list_to_tree (filter (>x) xs))

add_item :: Ord t => BinTree t -> t -> BinTree t
add_item Empty x = Node Empty x Empty
add_item tree x = list_to_tree (in_order tree ++ [x])


{-2c-}

union_trees :: Ord t => BinTree t -> BinTree t -> BinTree t
union_trees Empty Empty = Empty
union_trees Empty tree2 = tree2
union_trees tree1 Empty = tree1
union_trees tree1 tree2 = let list1 = in_order tree1 
                              list2 = in_order tree2
                              in list_to_tree ((filter (`notElem` list1) list2) ++ list1)


{-3a-}

same_contents :: Eq t => [t] -> [t] -> Bool
same_contents list1 list2 = length list1 == length list2 &&
                            foldl (\acc e -> acc && (e `elem` list2)) True list1 &&
                            foldl (\acc e -> acc && (e `elem` list1)) True list2

{-3b-}


switch :: [t] -> Int -> Int -> [t]
switch xs a b = map (\(i, e) -> if i == a then xs !! b else if i == b then xs !! a else e) (zip [0..] xs)

findIndex :: Eq t => t -> [t] -> Int
findIndex x xs = head (map fst (filter (\(i, e) -> e == x) (zip [0..] xs)))

transpose_to :: Eq t => [t] -> [t] -> Maybe [(Int,Int)]
transpose_to list1 list2 = if same_contents list1 list2 
                           then Just (transpose_to' list1 list2 0) 
                           else Nothing
                            where
                                transpose_to' :: Eq t => [t] -> [t] -> Int -> [(Int,Int)]
                                transpose_to' [] [] _ = []
                                transpose_to' list1 list2 index =
                                    if index == length list1 then [] 
                                    else 
                                        let x = list2 !! index 
                                            y = findIndex x list1 
                                            in 
                                         if ( y == index || x == list2 !! y ) then transpose_to' list1 list2 (index + 1)
                                         else (y, index) : (transpose_to'  list1 (switch list2 index y) (index+1)) 

-- Im actually proud of this one, it was tricky.
                                        

