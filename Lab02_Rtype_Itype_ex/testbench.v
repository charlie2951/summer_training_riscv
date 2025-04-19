`include "top.v"
module top_test;
  reg rst, clk;
  wire [31:0] cycle;
  integer i;
  //instantiate DUT
  top dut (rst, clk, cycle);
  initial
  begin
    $dumpfile("test.vcd");
    $dumpvars;
    rst=1;
    clk=0;
    #50;
    rst=0;
    #80000;
      $finish;
  end

  initial
  begin
   $monitor("Time=%0d, X[0]=%0d, X[1]=%0d, X[2]=%0d, X[3]=%0d, X[4]=%0d,  X[5]=%0d, Cycle=%0d",$time, dut.cpu0.regfile[0],dut.cpu0.regfile[1],dut.cpu0.regfile[2],dut.cpu0.regfile[3],dut.cpu0.regfile[4],dut.cpu0.regfile[5], cycle);
  end

  always #5 clk=~clk;
endmodule
