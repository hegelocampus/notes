quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (head:tail) =
  let smallerSorted = quicksort [a | a <- tail, a <= head]
      biggerSorted = quicksort [a | a <- tail, a > head]
  in smallerSorted ++ [head] ++ biggerSorted
