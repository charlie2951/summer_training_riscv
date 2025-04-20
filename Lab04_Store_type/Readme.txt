//store operation
addi x1,x0,32
addi x2,x0,20
add x3,x1,x2
sw x3, 40(x0)
ebreak

//Hex code
02000093
01400113
002081b3
02302423
00100073

//comment
test passed
