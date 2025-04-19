`include "progmem.v"
//testbench for program memort
//to test read write functionality
//separate data bus 32 bit for data read and write
//single 32 but address bus
//Read enable-read strobe
//write mark is done by write enable signal 4 bit for 4 byte chunk

module test_progmem;
  reg rst, clk;
  reg [31:0] addr;
  //reg [31:0] data_in;
  reg rd_strobe;
  reg [3:0] wr_strobe;
  wire [31:0] data_out;
  //instantiate module
  progmem mem0(
            .rst(rst), .clk(clk),
            .addr(addr),
            .data_in(),
            .rd_strobe(rd_strobe),
            .wr_strobe(wr_strobe),
            .data_out(data_out)
          );
  integer i;
  initial
  begin
    $dumpfile("dump.vcd");
    $dumpvars;
    rst=1;
    clk=1;
    #50;
    rst = 0;
    rd_strobe = 1; #50;
    addr = 0;#10;
    addr=4;#10;
    addr=8;#10;
    addr=12;#10;

    $finish;
  end

  initial
  begin
    $monitor("Address=%d, data_out = %8h", addr, data_out);
  end

  always #5 clk=~clk;
endmodule
