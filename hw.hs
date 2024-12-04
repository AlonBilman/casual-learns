
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

padTo8Bits :: String -> String
padTo8Bits x = if 8- length x > 0 then padTo8Bits ("0" ++ x) else x 

intToBinaryString :: Int -> String
intToBinaryString x = padTo8Bits(reverse(intToBinaryStringHelper x))

padToDivSix :: String -> String 
padToDivSix x = if length x `mod` 6 /= 0  then padToDivSix (x ++ "0") else x

binaryDataToBinaryString :: [Int] -> String 
binaryDataToBinaryString [x] = intToBinaryString x
binaryDataToBinaryString (x:xs) = intToBinaryString x ++ binaryDataToBinaryString xs

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