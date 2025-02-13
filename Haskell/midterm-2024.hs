{-Write a function remove_consecutive that removes consecutive identical
elements from a list.
For example:
remove_consecutive “Hello” should return “Helo”
remove_consecutive [4,5,5,5,2,2,0] should return [4,5,2,0]-}

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

{-2-}

data BinTree t = Empty | Node (BinTree t) t (BinTree t) deriving Show

{-Define a function is_sorted, which returns True if the tree sorted (that is, each
node stores a key greater than all the keys in the node's left subtree and less than
those in its right subtree)-}

in_order :: BinTree t -> [t]
in_order Empty = []
in_order (Node left e right) = in_order left ++ [e] ++ in_order right

is_sorted :: Ord t => BinTree t -> Bool
is_sorted Empty = True
is_sorted tree = let y = in_order tree 
                in foldl(\acc i -> acc && ((y !! i) < (y !! (i+1)))) True [0..length y - 2]



{-Declare and define a function add_item, which adds an item to the tree. You can
assume that the tree is sorted (and of course will remain sorted after your
operation).-}

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

{-3-}

{-Declare and define a function same_contents. This function takes two lists as
input parameters and returns True if both lists have the same elements, maybe in
a different order. Note that this implies that the two lists are of the same length.-}

same_contents :: Eq t => [t] -> [t] -> Bool
same_contents list1 list2 = length list1 == length list2 &&
                            foldl (\acc e -> acc && (e `elem` list2)) True list1 &&
                            foldl (\acc e -> acc && (e `elem` list1)) True list2

{-3b-}
{-Declare and define a function transpose_to. This function takes two lists and
returns Maybe [(Int,Int)]. It returns Nothing if the lists do not have the same
contents (see 3a). If they have the same contents, the function returns a list of
transpositions that convert the first list to the 2nd
.-}

swap :: Int -> Int -> [t] -> [t]
swap i j xs
    | i == j = xs 
    | otherwise =
        let xi = xs !! i
            xj = xs !! j
        in map fst (map(\(e,inx) -> if inx == i then (xj,inx) else if inx == j then (xi,inx) else (e,inx) ) (zip xs [0..]))

findIndex :: Eq t => t -> [t] -> Int -> Int
findIndex x (y:ys) offset
    | x == y    = offset
    | otherwise = findIndex x ys (offset+1)

transposeTo :: Eq a => [a] -> [a] -> Maybe [(Int,Int)]
transposeTo l1 l2 = if not (same_contents l1 l2) then Nothing else Just (safe_transpose_to l1 l2)
  where 
    safe_transpose_to l1 l2 =
        snd (foldl (\(currentList, swaps) i ->
                    if currentList !! i == l2 !! i then (currentList, swaps)
                    else let j = findIndex (l2 !! i) (drop (i+1) currentList) (i+1)
                             swappedList = swap i j currentList
                             in (swappedList, swaps ++ [(i, j)])) 
                             (l1, []) [0..length l1 - 1])

