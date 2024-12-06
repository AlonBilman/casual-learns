
-- Alon Bilman
-- 211684535

-- First question : 

--now I can do : base64Alphabet !! 3 => C  . and '=' as padding.
base64Alphabet :: [Char]
base64Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=" 
base64Padding :: Char 
base64Padding = '='

bitToInt :: Char -> Int 
bitToInt '1' = 1
bitToInt '0' = 0

intToBinaryStringHelper :: Int -> String
intToBinaryStringHelper 0 = "0";
intToBinaryStringHelper 1 = "1";
intToBinaryStringHelper x = show(mod x 2) ++ intToBinaryStringHelper (div x 2)

padBits :: String -> Int -> String
padBits x y = if y- length x > 0 then padBits ("0" ++ x) y else x 

intToBinaryString :: Int -> Int -> String --Ask Ilan
intToBinaryString x = padBits (reverse (intToBinaryStringHelper x)) 

padToDivSix :: String -> String  
padToDivSix x = if length x `mod` 6 /= 0  then padToDivSix (x ++ "0") else x

binaryDataToBinaryString :: [Int] -> String 
binaryDataToBinaryString [x] = intToBinaryString x 8
binaryDataToBinaryString (x:xs) = intToBinaryString x 8 ++ binaryDataToBinaryString xs

binaryDataToBinaryStringAndPadding :: [Int] -> String
binaryDataToBinaryStringAndPadding x = padToDivSix(binaryDataToBinaryString x)

binaryToInt :: String -> Int 
binaryToInt "0" = 0
binaryToInt "1" = 1
binaryToInt (x:xs) = bitToInt x * 2^length xs + binaryToInt xs 

encode :: String -> String
encode "" = []
encode x = 
    let (left, right) = splitAt 6 x  
        in base64Alphabet !! binaryToInt left : encode right  

base64_encode :: [Int] -> String
base64_encode [] = ""
base64_encode x = 
    let res = encode (binaryDataToBinaryStringAndPadding x)
      in    if length res `mod` 4 == 0 
            then res 
            else res ++ replicate (4 - length res `mod` 4) '='

-- Im actually proud of this , I check the head, drop it everytime ,If I get to the end -1 would be an error int else Ill get the char's Int value 
charToInt :: Char -> String -> Int 
charToInt _ [] = -1 
charToInt x base64String = 
    let y = head base64String 
        size = length base64String 
        maxSize = length base64Alphabet
        in if x == y then maxSize - size else charToInt x (tail base64String)

stringToBin :: String -> String
stringToBin "" = ""
stringToBin (x:xs) = let y = charToInt x base64Alphabet in 
    if y == -1 --error. its ok to do so because there is no ~ in base64
        then "~" else intToBinaryString y 6 ++ stringToBin xs
    
decode :: String -> [Int]
decode "" = [];
decode x = 
    let (left, right) = splitAt 8 x  
        in if length left /= 8 then [] else binaryToInt left : decode right  

base64_decode :: String -> [Int] 
base64_decode "" = []
base64_decode x = if length x `mod` 4 == 0 then decode( stringToBin x) else []  