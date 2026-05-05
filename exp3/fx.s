# float fx (float x, float a, float b, float c)

# fa0 - x
# fa1 - a
# fa2 - b
# fa3 - c

FX:
fmv.s ft0, fa3 # ft0 = c
fmul.s ft1, fa2, fa0
fadd.s ft0, ft0, ft1 # ft0 = c + xb
fmul.s ft1, fa0, fa0
fmul.s ft1, ft1, fa1
fadd.s fa0, ft0, ft1 # fa0 = c + xb + xxa
ret