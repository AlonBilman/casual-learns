----------------------------------------FIRST QUESTION---------------------------------------------
--Shift string by 1 

shiftString :: String -> String
shiftString "" = ""
shiftString x = let y = last x : x in init y     

----------------------------------------SECOND QUESTION---------------------------------------------
{- function that takes two Strings and returns True if 
    one of them is a result of applying shiftString 
    one or more times -}

--isShifted :: String -> String -> Bool 

