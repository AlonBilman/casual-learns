{-Write a function remove_consecutive that removes consecutive identical
elements from a list.
For example:
remove_consecutive “Hello” should return “Helo”
remove_consecutive [4,5,5,5,2,2,0] should return [4,5,2,0]
Important: your solution should be able to operate on very long lists-}

remove_consecutive :: Eq t => [t] -> [t]
remove_consecutive [] = [] 
remove_consecutive x  = foldr (\acc b -> if acc == head b then b else acc:b) [last x] x


{-Write a function filtered_map, which is a higher order function that works like the
standard map but allows filtering out some list items.
filtered_map will take two parameters: a function (that we call f) and a list [t].
The function f is applied on each element in the input list and returns (Maybe t). If
f returns Nothing, the given element will be removed from the list. If f returns Just
t, t will be placed in the list.
Do not use recursion in your solution.
Make sure that your solution traverses the list just once.-}

filtered_map :: (t->Maybe t) -> [t] -> [t]
filtered_map f list = foldl (\acc e -> acc ++ convertMaybe (f e)) [] list
                    where 
                        convertMaybe :: Maybe t -> [t]
                        convertMaybe Nothing = []
                        convertMaybe (Just x) = [x]

{-In this question we define a BinTree data type as follows:
data BinTree t = Empty | Node (BinTree t) t (BinTree t)
2a – 8 Points
Define a function is_sorted, which returns True if the tree sorted (that is, each
node stores a key greater than all the keys in the node's left subtree and less than
those in its right subtree)
-}

data BinTree t = Empty | Node (BinTree t) t (BinTree t) deriving Show

{-2a – 8 Points
Define a function is_sorted, which returns True if the tree sorted (that is, each
node stores a key greater than all the keys in the node's left subtree and less than
those in its right subtree)-}

in_order :: BinTree t -> [t]
in_order Empty = []
in_order (Node left e right) = in_order left ++ [e] ++ in_order right

is_sorted :: Ord t => BinTree t -> Bool
is_sorted Empty = True
is_sorted tree = let y = in_order tree 
                in foldl(\acc i -> acc && ((y !! i) < (y !! (i+1)))) True [0..length y - 2]



{-2b – 6 Points
Declare and define a function add_item, which adds an item to the tree. You can
assume that the tree is sorted (and of course will remain sorted after your
operation).
-}

list_to_tree :: Ord t => [t] -> BinTree t
list_to_tree [] = Empty
list_to_tree (x:xs) = Node (list_to_tree (filter (<x) xs)) x (list_to_tree (filter (>x) xs))

add_item :: Ord t => BinTree t -> t -> BinTree t
add_item Empty x = Node Empty x Empty
add_item tree x = list_to_tree (in_order tree ++ [x])


{-Declare and define a function union_trees, which takes two trees of type BinTree
and returns a BinTree whose values are those found in at least one of the source
trees.
Important: The source trees are assumed to be ordered and the result must also
be ordered.-}

union_trees :: Ord t => BinTree t -> BinTree t -> BinTree t
union_trees Empty Empty = Empty
union_trees Empty tree2 = tree2
union_trees tree1 Empty = tree1
union_trees tree1 tree2 = let list1 = in_order tree1 
                              list2 = in_order tree2
                              in list_to_tree ((filter (`notElem` list1) list2) ++ list1)


{-3a – 10 Points
Declare and define a function same_contents. This function takes two lists as
input parameters and returns True if both lists have the same elements, maybe in
a different order. Note that this implies that the two lists are of the same length.-}

same_contents :: Eq t => [t] -> [t] -> Bool
--same_contents [] [] = True
--same_contents [] _ = False
--same_contents _ [] = False
same_contents list1 list2 = length list1 == length list2 &&
                            foldl (\acc e -> acc && (e `elem` list2)) True list1 &&
                            foldl (\acc e -> acc && (e `elem` list1)) True list2

{-3b – 20 Points
Declare and define a function transpose_to. This function takes two lists and
returns Maybe [(Int,Int)]. It returns Nothing if the lists do not have the same
contents (see 3a). If they have the same contents, the function returns a list of
transpositions that convert the first list to the 2nd
. -}


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
                                        

