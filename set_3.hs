----------------------------------------FIRST QUESTION---------------------------------------------
--Shift string by 1 

shiftString :: String -> String
shiftString "" = ""
shiftString x = let y = last x : x in init y     

----------------------------------------SECOND QUESTION---------------------------------------------
{- function that takes two Strings and returns True if 
    one of them is a result of applying shiftString 
    one or more times -}

isShifted :: String -> String -> Bool 
isShifted "" "" = True
isShifted x y = (length x == length y)  && 
                    foldl(\acc index -> acc || shiftStringFor index x == y) False (take (length x) [1..])
                    where 
                        shiftStringFor :: Int -> String -> String 
                        shiftStringFor _ "" = ""
                        shiftStringFor 0 x = x
                        shiftStringFor i x = foldl(\acc _-> shiftString acc) x (take i [1..])

                        
----------------------------------------THIRD QUESTION-----------------------------------------------