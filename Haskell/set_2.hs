
----------------------------------------------------FIRST QUESTION----------------------------------------
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

------------------------------------------------------SECOND QUESTION--------------------------------------------

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
type BinOp = Float -> Float -> Maybe Float  
data ExprTree =  ExprValue Float | ExprNode ExprTree BinOp ExprTree

--Write a function eval, which takes an ExprTree and evaluates its value.

eval :: ExprTree -> Maybe Float
eval (ExprValue x) = Just x 
eval (ExprNode x y z) = 
    let first = eval x 
        second = eval z     
    in 
        if isNothing first || isNothing second 
            then Nothing 
            else y (extract first) (extract second) 
    where 
        isNothing Nothing = True
        isNothing _ = False

        extract (Just a) = a 

--another way to do it, using do in haskell (Better)
eval2 :: ExprTree -> Maybe Float
eval2 (ExprValue x) = Just x
eval2 (ExprNode left op right) = do
    l <- eval left    
    r <- eval right  
    op l r  --apply the binary operation if both are `Just` 


eval3 :: ExprTree -> Maybe Float
eval3 (ExprValue x) = Just x
eval3 (ExprNode left op right) = 
    let x = eval left
        y = eval right 
        in case (x,y) of 
            (Just a, Just b) -> op a b
            _ -> Nothing

--EXAMPL 
addOp :: Float -> Float -> Maybe Float 
addOp a b = Just (a+b) 
divOp :: Float -> Float -> Maybe Float 
divOp a b = if b == 0 then Nothing else Just (a/b) 

sample_tree1 :: ExprTree
sample_tree1 = ExprNode ( ExprValue 3  ) divOp  ( ExprNode ( ExprValue 0 ) addOp ( ExprValue 0 ))
sample_tree2 :: ExprTree
sample_tree2 = ExprNode ( ExprValue 3  ) divOp  ( ExprNode ( ExprValue 4 ) addOp ( ExprValue 6 ))

-----------------------------------------------FOURTH QUESTION------------------------------------------------------

-- sieve of Eratosthenes , an ancient algorithm - link : https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes

sieve :: Int -> [(Int,Bool)]
sieve n = 
    let y = [(i,True)|i<-[1..n]] 
        in algo y  
    where 
        cross :: Int-> [(Int,Bool)] -> [(Int,Bool)]
        cross i [] = []
        cross i ((x, y):xys) = 
            if x `mod` i == 0 
            then (x, False) : cross i xys 
            else (x, y) : cross i xys
            
        algo :: [(Int,Bool)] -> [(Int,Bool)]
        algo [] = []
        algo ((1, _):xys) = (1,False) : algo xys
        algo ((x, False):xys) = (x,False) : algo xys 
        algo ((x,True):xys) = (x,True) : algo(cross x xys) 

        --Insane, this was the hardest one so far

------------------------------------------------END OF SET 2--------------------------------------------------