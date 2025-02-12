

{-
Difference between foldl and foldr
-----------------------------------
foldr (+) 0 [1, 2, 3, 4]  
-- 1 + (2 + (3 + (4 + 0)))
-- Result: 10

foldl (+) 0 [1, 2, 3, 4]  
-- (((0 + 1) + 2) + 3) + 4
-- Result: 10
-}


-- Fibonacci 

fibHelper :: Integer -> (Integer,Integer)
fibHelper 0 = (0,0)
fibHelper 1 = (1,0)
fibHelper n = let (a,b) = fibHelper (n-1) in (a+b,a)

fib :: Integer -> Integer
fib n = fst (fibHelper n)

--------------------------------------------------------------------------------
data BinTree = Empty | Leaf Int |  Node BinTree Int BinTree deriving Show 

splitAtMiddle :: [Int] -> ([Int],Int,[Int])
splitAtMiddle [x] = ([],x,[])
splitAtMiddle xs = let (x,y) = splitAt (length xs `div` 2) xs 
                       num = head y 
                   in (x,num,tail y)

makeBalancedTree :: [Int] -> BinTree
makeBalancedTree [] = Empty
makeBalancedTree [x] = Leaf x 
makeBalancedTree xs = let (x,y,z) = splitAtMiddle xs in 
    Node (makeBalancedTree x) y (makeBalancedTree z)

addItemToBalancedTree :: Int -> BinTree -> BinTree
addItemToBalancedTree x Empty = Node Empty x Empty
addItemToBalancedTree x (Leaf y) = if x>y then Node (Leaf y) x Empty else Node (Leaf x) y Empty
addItemToBalancedTree x (Node left y right) = 
    if x>y then Node left y (addItemToBalancedTree x right) 
    else Node (addItemToBalancedTree x left) y right

flattanTree :: BinTree -> [Int]
flattanTree Empty = []
flattanTree (Leaf x) = [x]
flattanTree (Node left value right) = flattanTree left ++ [value] ++ flattanTree right
-----

f :: String -> Either String String 
f item = if odd (length item) then Left item else Right item                   
splitByEither :: [t] -> (t -> Either t t) -> ([t],[t])
splitByEither xs f = let y = map f xs in 
                     let leftList = map (\(Left l) -> l) (filter (\x -> case x of Left _ -> True; _ -> False) y)
                         rightList = map (\(Right r) -> r) (filter (\x -> case x of Right _ -> True; _ -> False) y)
                         in (leftList, rightList)

type BinOp = Float -> Float -> Maybe Float  
data ExprTree =  ExprValue Float | ExprNode ExprTree BinOp ExprTree

eval :: ExprTree -> Maybe Float
eval (ExprValue x) = Just x
eval (ExprNode left op right) = 
    let x = eval left
        y = eval right 
        in case (x,y) of 
            (Just a, Just b) -> op a b
            _ -> Nothing

addOp :: Float -> Float -> Maybe Float 
addOp a b = Just (a+b) 
divOp :: Float -> Float -> Maybe Float 
divOp a b = if b == 0 then Nothing else Just (a/b) 

sample_tree1 :: ExprTree
sample_tree1 = ExprNode ( ExprValue 3  ) divOp  ( ExprNode ( ExprValue 0 ) addOp ( ExprValue 0 ))
sample_tree2 :: ExprTree
sample_tree2 = ExprNode ( ExprValue 3  ) divOp  ( ExprNode ( ExprValue 4 ) addOp ( ExprValue 6 ))



sieve :: Int -> [(Int, Bool)] 
sieve 0 = []
sieve n = 
    let arr = map (,True) [1..n]
    in algo arr  
    where 
        cross :: [(Int,Bool)] -> Int -> [(Int,Bool)]
        cross xs y = map(\(x,b)-> if x `mod` y == 0 then (x,False) else (x,b)) xs
        
        algo :: [(Int,Bool)] -> [(Int,Bool)]
        algo [] = []
        algo ((1,_):xs) = (1,False) : algo xs
        algo ((x,False):xs) = (x,False) : algo xs
        algo ((x,True):xs) = (x,True) : algo (cross xs x)

         

shiftString :: String -> String
shiftString "" = ""
shiftString x = let y = last x : x in init y 

isShifted :: String -> String -> Bool
isShifted "" "" = True
isShifted x y = (length x == length y) &&
        foldl (\acc str -> acc || shiftString str == y) False (take (length x) (iterate shiftString x))
