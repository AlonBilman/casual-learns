--Alon Bilman 
--211684535


{-1-}

type Matrix t = [[t]]

{-1.a-}

mat_fold_rows :: (a -> t -> a) -> a -> Matrix t -> a 
mat_fold_rows func acc mat = foldl (\acc row -> foldl func acc row) acc mat
                          -- I could do : func = foldl (foldl func) and it would have been the same.

{-1.b-}

mat_fold_cols :: (a -> t -> a) -> a -> Matrix t -> a
mat_fold_cols func acc mat = mat_fold_rows func acc (transpose mat)
    where transpose :: Matrix t -> Matrix t 
          transpose ([]:_) = [] -- if one of the elements are empty then the whole matrix is empty
          transpose xs = map head xs : transpose (map tail xs) 

{-1.c-}  

sum_cols :: Matrix Int -> [Int]
sum_cols [] = []
sum_cols mat =
  let rowCount = length mat
      colCount = length (head mat)
      (finalCount, finalSums) = mat_fold_cols (\(cnt, currentSums) item ->
              let colIndex = cnt `div` rowCount                         --column? 
                  updatedSums = update_at colIndex (+ item) currentSums
              in (cnt + 1, updatedSums)) (0, replicate colCount 0) mat
  in finalSums
        where
              update_at :: Int -> (x -> x) -> [x] -> [x]
              update_at _ _ []     = []
              update_at 0 f (x:xs) = f x : xs
              update_at n f (x:xs) = x : update_at (n - 1) f xs


{-1.d-}

{-  So, I want to stop callin f as soon as I finish.. in that case I wont use foldl...-}

{-my answer : -}

{-Given-}
is_prime :: Int -> Bool 
is_prime n = n > 2 &&  length ( filter (\item -> (( mod n item) == 0) ) ( take (n-2) [2..] )) == 0 


-- Impl
at_least_fast :: [t] -> (t -> Bool) -> Int -> Bool 
at_least_fast l f n = at_least_helper l f 0
  where
    at_least_helper [] _ count = count >= n
    at_least_helper (x:xs) f count
      | count >= n     = True   -- this is where I stop calling f
      | f x {-==True-} = at_least_helper xs f (count + 1) --we found 1
      | otherwise      = at_least_helper xs f count

{-This impl we call is_prime (that is f as arg) untill we find 10 primes, 
  from the web the 10th prime is 29 so it will call 
  f (aka is_prime) 29 times. -}

{- The given at_least would have call is_prime (or f) length of the list - times 
   in our case 10000000 times-}