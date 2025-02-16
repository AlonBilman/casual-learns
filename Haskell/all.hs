
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


type Matrix t = [[t]]
isSquare :: Matrix t -> Bool
isSquare [] = True
isSquare x = foldl(\acc r-> acc && length r == length x) True x



map_matrix2 :: (t -> (Int,Int) -> u )->Matrix t->Matrix u
map_matrix2 f x = map (\(row,e)-> map (\(col,el)-> f el (row,col)) (zip [0..] e) ) (zip [0..] x)


transpose :: Matrix t -> Matrix t
transpose [] = []
transpose x = map_matrix2 (\e (row,col) -> (x !! col) !! row) x


isValidId :: Integer -> Bool
isValidId x = let digit = replicate (9- length(show x)) '0' ++ show x
              in let digitArr = map (\x -> read [x] :: Int) digit
              in let digitArrDoubled = map (\(i,e)-> if i `mod` 2 == 0 then e else e*2) (zip [0..] digitArr)
              in let digitArrDoubledSeperated = foldl(\acc e -> if e > 9 then acc ++ [e `div` 10, e `mod` 10] else acc ++ [e]) [] digitArrDoubled
              in sum digitArrDoubledSeperated `mod` 10 == 0


invert :: [t] -> (Int, Int) -> Either String [t]
invert [] _ = Left "Array is empty"
invert arr (x,y) 
            |x>y || x<0 || y<0 || x>=length arr || y>=length arr = Left "bad params"
            |otherwise =  Right (
                map(\(elem,index)-> if index == x then arr !! y else if index == y then arr !! x else elem ) (zip arr [0..]))

scan :: Ord t => [t] -> [t] 
scan [] = []
scan [x] = [x]
scan (x:y:xs) = if x<y then x:scan (y:xs) else y:scan (x:xs) 

scan2 :: Ord t => [t] -> [t]
scan2 x =foldl(\acc (curr,other) -> if acc!!curr>acc!!other then switch acc (curr,other) else acc) x (take (length x -1) (zip [0..] [1..]))
                where 
                    switch :: [t] -> (Int,Int) -> [t]
                    switch xs (a,b) = map (\(i, e) -> if i == a then xs !! b else if i == b then xs !! a else e) (zip [0..] xs)


filteredMap4 :: (t -> Maybe t) -> [t] -> [t]
filteredMap4 f x = foldl(\acc e-> case f e of 
                Just a -> acc ++ [a]
                Nothing -> acc) [] x

f1 x = if even x then Just x else Nothing

filteredMap :: (t->Maybe t) -> [t] -> [t]
filteredMap _ [] = []
filteredMap f xs = map(\(Just x) -> x)(filter (\x -> case x of Just _ -> True; _ -> False) (map f xs))  

{-map_with_index will be a higher order function taking two parameters: a function (that we call f) and a 
list (much like the standard filter function).  The function f is a function that is applied on each element 
in the input list, and its index (its position in the list), and returns a value.  
For example: 
map_with_index (\item index -> odd index) [2,3,5,6,7] = [False, True, False, True, False] 
map_with_index (\item index -> item+index + 5) [2,3,5,1,7]  = [7, 9, 12, 9, 16]-}

mapWithIndexx :: (a -> Int -> b) -> [a] -> [b]
mapWithIndexx f xs = map(\(item,index)-> f item index) (zip xs [0..])


data BinTree2 t = Empty2 | Node2 (BinTree2 t) t (BinTree2 t) deriving (Eq,Ord,Show)

inOrder :: BinTree2 t -> [t]
inOrder Empty2 = []
inOrder (Node2 x y z) = inOrder x ++ [y] ++ inOrder z 

isSorted :: Ord t => BinTree2 t -> Bool
isSorted Empty2 = True
isSorted tree =  let y = inOrder tree in 
                    foldl(\acc i-> acc && ((y !! i) <= (y !! (i+1)))) True [0..length y - 2]

interSectTreess :: Ord t => BinTree2 t -> BinTree2 t -> BinTree2 t
interSectTreess Empty2 _ = Empty2
interSectTreess _ Empty2 = Empty2
interSectTreess (Node2 t1 e t2)(Node2 t3 el t4) = if e == el then Node2 (interSectTreess t1 t3) e (interSectTreess t2 t4) else Empty2 




{-Write a function is_valid which takes a string and decides whether the 
parentheses in it are valid. By “Valid” we mean that the number of left 
parentheses equals the number of right ones AND that at any point in the string, 
the number of left parentheses is greater than or equal to the number of right 
ones.-}

isValid :: String -> Bool
isValid str = let y = map(\x -> if x == '(' then 1 else if x == ')' then -1 else 0) str
              in sum y == 0 && fst (foldl(\(acc,sum) x -> (acc && sum+x >= 0 ,sum+x)) (True,0) y)

{-Write a function find_matching that takes a string and an index of a left 
parenthesis and returns the index of the matching right parenthesis. 
You can safely assume that the string is valid according to the previous question 
and that the given index is one of a left parenthesis. -}

findMatching :: String -> Int -> Int
findMatching [] _ = -1 --as error
findMatching str i = findIndex 0 (i+1)
    where findIndex :: Int -> Int -> Int
          findIndex sum inx
            | str !! inx == ')' = if sum == 0
                then inx
                else findIndex (sum-1) (inx+1)
            | str !! inx == '(' = findIndex (sum+1) (inx+1)
            | otherwise = findIndex sum (inx+1)
      
                       
-------------------------------------------------------------------     --------------------------------------------
{-Write a function compose, which takes a string and a Dictionary and returns an 
object of type Op (a function). This returned function will be the composition of 
the functions in the input string (the rightmost function is the first to be applied).  
The string is composed of function names separated by ‘.’ and optional spaces.  -}

type Op t = t -> t
type Dictionary t = [(String, Op t)]

compose :: String -> Dictionary t -> Op t
compose str dict = let nStr = words (map(\x -> if x == '.' then ' ' else x) str)
                in foldl(\res x-> res . snd (head (filter (\y -> fst y == x) dict))) id nStr


-- Define the dictionary of operations
dic :: Dictionary Int
dic = [("add", (+2)), ("sub", subtract 2), ("mul", (*3))]

-- Test Cases
main :: IO ()
main = do
    print $ (compose "add . mul . sub" dic) 10  -- Expected: 26
    print $ (compose "mul . add" dic) 4        -- Expected: 18
    print $ (compose "sub . mul" dic) 6        -- Expected: 16
    print $ (compose "add . sub . mul" dic) 5  -- Expected: 15
    print $ (compose "" dic) 7                 -- Expected: 7 (identity function)



------------------------------------------------------------------------------------------------------------------
{-filter_with_index is a higher order function taking two
parameters: a predicate f and a list, and produces a list
of all the elements from the input list that satisfy f. 
f is a predicate (function) that is applied on each element in the input list, 
and its index (its position in the list),
and returns a Boolean value that is the result of some condition on the element and its index.
-}

filterWithIdex :: (a -> Int -> Bool) -> [a] -> [a]
filterWithIdex f xs = map fst (filter (\(x,y) -> f x y) (zip xs [0..]))




removeConsecutive :: Eq t => [t] -> [t]
removeConsecutive x = reverse $ foldl(\acc elem -> if length acc == 0 then elem : acc else if elem == head acc then acc else elem : acc ) [] x


filteredMap2 :: (t -> Maybe t) -> [t] -> [t]
filteredMap2 func list = map (\(Just x) -> x) ( filter (\x -> case x of 
                                                            Nothing -> False 
                                                            otherwise -> True) (map func list))

filteredMap3 :: (t -> Maybe t) -> [t] -> [t] 
filteredMap3 func list = foldl(\acc element -> acc ++ convert(func element)) [] list
                            where 
                                convert x = case x of 
                                            Nothing -> []
                                            (Just x) -> [x]
                                            
sameContents :: Eq t => [t] -> [t] -> Bool
sameContents list1 list2 = let a = foldl(\acc el -> acc && el `elem` list2) True list1
                               b = foldl(\acc el -> acc && el `elem` list1) True list2
                               c = length list1 == length list2 
                               in a && b && c





------------------------------------------------------
{-



-}