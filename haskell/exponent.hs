raiseTo :: (Integral a) => a -> a -> a
raiseTo _ 0 = 1
raiseTo a 1 = a
raiseTo a b = a * (a `raiseTo` (b - 1))
