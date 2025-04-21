/example of load and store
addi x1,x0,32
addi x2,x0,20
addi x5,x0,40
add x3,x1,x2
sw x3, 0(x5)
lw x4, 0(x5)
ebreak

//hex code
02000093
01400113
02800293
002081b3
0032a023
0002a203
00100073

//result
X[0]=0, X[1]=32, X[2]=20, X[3]=52, X[4]=52,  X[5]=40, Cycle=38

//comment
test passed