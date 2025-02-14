import Data.List.NonEmpty (xor)
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

toString :: Expr -> String
toString (Value x) = show x 
toString (BinOp ex1 op ex2) = toString ex1 ++ realOp ++ toString ex2
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
