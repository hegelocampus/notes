raiseTo :: (Integral a, Integral a) => a -> a -> a
_ `raiseTo` 0 = 1
a `raiseTo` 1 = a
a `raiseTo` b = a * (a `raiseTo` (b - 1))
