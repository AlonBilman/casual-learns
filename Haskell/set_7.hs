--From final 2023_a

{-1.-}

--In this question, we define a data type Expr as follows: 
data Op = Add | Sub | Mul | Div deriving (Show, Eq)
data Expr = Value Int | BinOp Expr Op Expr deriving Show

{-
It’s supposed to represent an Integer arithmetic expression. 
For example, the expression “3-2” is represented as BinOp (Value 2) Sub (Value 3)

"1-(2-3)" is BinOp (Value 1) Sub (BinOp (Value 2) Sub (Value 3))

"1*2-3" is BinOp (BinOp (Value 1) Mul (Value 2)) Sub (Value 3)

-}

{-1.a-}

{-
Write a function eval that takes an Expr value and returns its integer value. For example, 
eval (BinOp (Value 2) Sub (Value 3)) should return -1.  
Note: The division in this question is an “integer division”. 
      That is it returns just the integer part of the division operation. 
Note 2: You can safely ignore division by zero. 
-}

{-Answer-}

eval :: Expr -> Int
eval (Value x) = x 
eval (BinOp ex1 op ex2) 
                    |op==Add = (+) (eval ex1) (eval ex2)
                    |op==Sub = (-) (eval ex1) (eval ex2)
                    |op==Mul = (*) (eval ex1) (eval ex2)
                    |op==Div = div (eval ex1) (eval ex2)
                    |otherwise = 0

{-
Write a function toString that takes an Expr value and returns a string containing the expression it represents. 
For example, toString (BinOp (Value2) Sub (Value 3)) should return “2-3”. 
-}

{-Answer-}

expToString :: Expr -> String
expToString (Value x) = show x 
expToString (BinOp ex1 op ex2) = expToString ex1 ++ realOp ++ expToString ex2
                            where 
                                realOp
                                    | op == Add = "+"
                                    | op == Sub = "-"
                                    | op == Mul = "*"
                                    | otherwise = "/"

{-
Write a function fromString that takes a string containing a simple expression and 
returns the Expr value. 
For example 
fromString "1+2" should return BinOp (Value 1) Add (Value 2) 
fromString “1 *2 +   3”  should return BinOp (BinOp (Value 1) Mul (Value 2)) Add (Value 3) 

Important, please read carefully: 
The following assumptions can be safely made: 
1. The provided string contains a valid expression 
2. The expression contains just the following characters: ‘0’, ‘1’,…,’9’, ‘+’, ‘-‘, ‘*’, ‘/’ and ‘ ‘ (space) 
3. All the integers in the expression are positive and have only a single digit 

-}

{-Answer-}

fromString :: String -> Expr
fromString str =
    let arr = words (foldl (\acc x -> acc ++ " " ++ [x]) "" str)
    in getExpr arr
  where
    getExpr :: [String] -> Expr
    getExpr [x] = Value (read x :: Int)
    getExpr xs = 
        let op = filter (\(x, i) -> head x `elem` "+-") (zip xs [0..])
            op2 = filter (\(x, i) -> head x `elem` "*/") (zip xs [0..])
        in if op /= [] then 
                BinOp (getExpr (take (snd (head op)) xs)) (realOp (head op)) (getExpr (drop (snd (head op) + 1) xs))
            else BinOp (getExpr (take (snd (head op2)) xs)) (realOp (head op2)) (getExpr (drop (snd (head op2) + 1) xs))
      where
        realOp x
            | fst x == "+" = Add
            | fst x == "-" = Sub
            | fst x == "*" = Mul
            | fst x == "/" = Div



--From final 2023_b -- Already did it. set_3 ... But I did it again

type Matrix t = [[t]]

isSquare :: Matrix t -> Bool
isSquare mat = foldl(\acc x -> acc && (length mat == length x)) True mat

mapMatrix :: (t -> u) -> Matrix t ->   Matrix u 
mapMatrix func = map (map func) -- same as mapMatrix func mat = map (map func) mat

mapMatrix2 :: (t -> (Int,Int) -> u )->Matrix t->Matrix u 
mapMatrix2 func mat = map (\(row,rowInx) -> (map (\(col, colInx) -> func col (rowInx,colInx)) (zip row [0..]))) (zip mat [0..])

transposeMatrix :: Matrix t -> Matrix t -- ofc it has to be squared.. for non - see set_4
transposeMatrix mat = mapMatrix2 (\_ (row,col) -> (mat !! col) !! row ) mat 



--From 2024 - hw2

data BinTree = Empty | Leaf Int | Node BinTree Int BinTree deriving (Show,Eq)

{-
The first data type defines a simple tree containing Int values. Such a tree can be represented as a string. 
For example:   
    Node (Leaf 4) 3 (Node Empty 3 (Node (Leaf 1) 2 (Leaf 2))) can be represented as "3(4,3(,2(1,2)))" 
Important:  
    1. We use only positive integers in this question 
    2. The string representation might contain blanks that do not alter its value. For example “1( , 2)“ 
       is the same as “1(,2)”.
-}

{-
2.a 
    Write a function to_string, which takes a BinTree and returns its string representation 
    as described above. 
-}

treeToString :: BinTree -> String
treeToString Empty = "";
treeToString (Leaf x) = show x 
treeToString (Node tree1 val tree2) = show val ++ "(" ++ treeToString tree1 ++","++ treeToString tree2 ++ ")"  

{-
2.b
Write a function tokenize, which takes a string representing a BinTree and returns a Maybe list of 
its tokens. 
The possible tokens are taken from the following type definition. 
The function should return Nothing if the given string cannot be tokenized. 
Examples :  
tokenize "1(,3(,))" should return Just [Val 1,LPar,Comma,Val 3,LPar,Comma,RPar,RPar] 
tokenize "1(,3(,x))" should return Nothing 
-}

data BinTreeTok = LPar | RPar | Comma  | Val Int deriving (Show,Eq)

tokenize :: String -> Maybe [BinTreeTok]
tokenize str = let y = filter(/= ' ') str in
    if foldl (\acc x -> acc && (x `elem` "0123456789(),")) True y then Just (tokenizeHelper y) else Nothing
    where 
        tokenizeHelper :: String -> [BinTreeTok]
        tokenizeHelper str = reverse(foldl(\acc x -> convert x : acc) [] str)
        convert :: Char -> BinTreeTok
        convert x 
                |x == '(' = LPar
                |x == ')' = RPar
                |x == ',' = Comma
                |otherwise = Val (read [x] :: Int)

{-
2.c 
Write a function compile, which takes a valid representation string and returns the BinTree it 
represents.
-}

compile :: String -> BinTree
compile s = fst (parseTree (fromJust (tokenize s))) 
    where 
        fromJust (Just x) = x

        parseTree :: [BinTreeTok] -> (BinTree, [BinTreeTok])
        parseTree (Val n : LPar : ts) =
            let (left,  Comma : ts2) = parseMaybeTree ts    --rec
                (right, RPar  : ts3) = parseMaybeTree ts2   --rec
            in (Node left n right, ts3) 
        parseTree (Val n : ts) = (Leaf n, ts)               --leaf

        parseMaybeTree :: [BinTreeTok] -> (BinTree, [BinTreeTok])
        parseMaybeTree (Comma : ts) = (Empty, Comma : ts)           --"(_,"
        parseMaybeTree (RPar  : ts) = (Empty, RPar  : ts)           --",_)"  
        parseMaybeTree ts = parseTree ts                            --regular 