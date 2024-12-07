
base64Alphabet :: [Char]
base64Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" 
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

intToBinaryString :: Int -> Int -> String 
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

data Answer = Error [Char] | Result [Int] deriving Show

removeEqual :: String -> String
removeEqual "" = ""
removeEqual x = if last x=='=' then removeEqual (init x) else x

base64_decode :: String -> Answer 
base64_decode x = 
    if length x `mod` 4 == 0 then 
            let y = removeEqual x in 
            if '~' `elem` stringToBin y then Error "Not A valid base64 String" else Result(decode (stringToBin y))
        else Error "Not A valid base64 String"



--------------------------------------TESTING FOR QUESTION 1 (run with typing "main" in ghci)----------------------------------------


runTest :: String -> String -> String -> String
runTest testName actual expected =
    if actual == expected
        then testName ++ ": PASS"
        else testName ++ ": FAIL\n  Expected: " ++ expected ++ "\n  Got: " ++ actual

runDecodeTest :: String -> Answer -> Answer -> String
runDecodeTest testName actual expected =
    if show actual == show expected
        then testName ++ ": PASS"
        else testName ++ ": FAIL\n  Expected: " ++ show expected ++ "\n  Got: " ++ show actual

runTests :: [String]
runTests = 
    [ runTest "base64_encode empty" (base64_encode []) ""
    , runTest "base64_encode single byte" (base64_encode [65]) "QQ=="
    , runTest "base64_encode two bytes with padding" (base64_encode [65, 66]) "QUI="
    , runTest "base64_encode three bytes without padding" (base64_encode [65, 66, 67]) "QUJD"
    , runTest "base64_encode four bytes (with padding)" (base64_encode [65, 66, 67, 68]) "QUJDRA=="
    , runTest "base64_encode large input" 
        (base64_encode [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100]) 
        "SGVsbG8gV29ybGQ="

    , runDecodeTest "base64_decode empty" (base64_decode "") (Result [])
    , runDecodeTest "base64_decode valid no padding" (base64_decode "QUJD") (Result [65, 66, 67])
    , runDecodeTest "base64_decode valid with padding" (base64_decode "QUI=") (Result [65, 66])
    , runDecodeTest "base64_decode invalid characters" (base64_decode "QU~D") (Error "Not A valid base64 String")
    , runDecodeTest "base64_decode invalid length" (base64_decode "QUJDRA") (Error "Not A valid base64 String")
    , runDecodeTest "base64_decode valid multi-character" 
        (base64_decode "SGVsbG8gV29ybGQ=") 
        (Result [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100])
    ]

--Need to ask Ilan about this 
main :: IO ()
main = printResults runTests
  where
    printResults [] = return () 
    printResults (x:xs) = do
        putStrLn x           
        printResults xs      