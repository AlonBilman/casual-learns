
----------------------------------------------------------------FIRST QUESTION-------------------------------------------------
-- balanced binary tree (getting ordered list of ints)

data BinTree = Empty | Leaf Int |  Node BinTree Int BinTree deriving Show 

splitAtMiddle :: [Int] -> ([Int],Int,[Int])
splitAtMiddle [x] = ([],x,[])
splitAtMiddle xs = 
    let (x,y) = splitAt (length xs `div` 2) xs 
        num = head y 
    in (x,num,tail y)
 
makeBalancedTree :: [Int] -> BinTree 
makeBalancedTree [] = Empty
makeBalancedTree [x] = Leaf x 
makeBalancedTree xs = let (x,y,z) = splitAtMiddle xs in 
    Node (makeBalancedTree x) y (makeBalancedTree z) 

-- adding an item to the Balanced tree : 

flattanTree :: BinTree -> [Int]
flattanTree Empty = []
flattanTree (Leaf x) = [x]
flattanTree (Node left value right) = flattanTree left ++ [value] ++ flattanTree right 

addItemToBalancedTree:: Int -> BinTree -> BinTree 
addItemToBalancedTree x Empty = Node Empty x Empty
addItemToBalancedTree y (Leaf x) = Node (Leaf x) y Empty --Come on.. a tree cant really be a leaf. 
addItemToBalancedTree y x = let flat = flattanTree x ++ [y] in makeBalancedTree flat
--example : ghci> addItemToBalancedTree 11 (Node (Node (Node (Leaf 1) 3 Empty) 5 (Leaf 6)) 7 (Node (Leaf 8) 9 (Leaf 10)))

----------------------------------------------------------------SECOND QUESTION-------------------------------------------------

splitByEither :: [t] -> (t -> Either t t) -> ([t], [t])
splitByEither xs func = 
    let y = map func xs
        leftsList = map (\(Left l) -> l) (filter isLeft y)  
        rightsList = map (\(Right r) -> r) (filter isRight y)
    in (leftsList, rightsList)
  where
    isLeft (Left _) = True
    isLeft _        = False

    isRight (Right _) = True
    isRight _         = False
-- another implementation (Better)

--splitByEither :: [t] -> (t -> Either t t) -> ([t], [t])
--splitByEither xs func = 
    --let y = map func xs  
       -- leftsList = [l | Left l <- y]  
       -- rightsList = [r | Right r <- y] 
   -- in (leftsList, rightsList)

--for example : 
f :: String -> Either String String 
f item = if odd (length item) then Left item else Right item

--run splitByEither [ "It" , "was", "a" , "many", "and", "many" , "years", "ago" ] f 

-----------------------------------------------------THIRD QUESTION-------------------------------------------------------------