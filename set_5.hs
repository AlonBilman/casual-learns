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

{-Declare and define a function is_sorted, which returns True if the tree sorted (that is, each node stores a 
key greater than all the keys in the node's left subtree and less than those in its right subtree)-}

inOrder :: BinTree t -> [t]
inOrder Empty = []
inOrder (Node l x r) = inOrder l ++ [x] ++ inOrder r

isSorted :: Ord a => BinTree a -> Bool
isSorted tree = let y = inOrder tree 
                in foldl(\acc i -> acc && ((y !! i) <= (y !! (i+1)))) True [0..length y - 2]

{-Declare and define a function intersect_trees, which takes two objects of type BinTree and returns a 
BinTree whose values are those found in both trees.  
Important: You can assume that the source trees are sorted.-}                

listToTree :: Ord a => [a] -> BinTree a
listToTree [] = Empty
listToTree (x:xs) = Node (listToTree (filter(<x) xs)) x (listToTree (filter(>x) xs))

intersectTrees :: Ord a => BinTree a -> BinTree a -> BinTree a
intersectTrees Empty _ = Empty
intersectTrees _ Empty = Empty
intersectTrees tree1 tree2 = let y = inOrder tree1
                                 z = inOrder tree2
                                 in listToTree (filter (`elem` z) y)
                                                                
{-Write a function mergeSortedTrees that takes two sorted binary trees and merges them into a single sorted binary tree.
The resulting tree should contain all the elements from both input trees, maintaining the sorted order.-}

mergeSortedTrees :: Ord a => BinTree a -> BinTree a -> BinTree a 
mergeSortedTrees tree1 tree2 = let list1 = inOrder tree1 
                                   list2 = inOrder tree2
                                   in listToTree (filter (`notElem` list1) list2 ++ list1)


{-Transactions are represented as tuples: (String, Double). 
The String indicates the type ("deposit" or "withdrawal"), and the Double is the amount. 
Apply to withdrawal 5% fee , calculate balance-}

type Transaction = (String,Double)

calculateBalance :: [Transaction] -> Double
calculateBalance [] = 0 
calculateBalance xs = let dep = map snd (filter (\(t,n) -> t=="deposit") xs)
                          wid = map (\(t,n)-> n * (-1.05)) (filter (\(t,n)-> t == "withdrawal") xs)
                          in sum dep + sum wid

------------------------------------------------------------------------------------------------------------

                          