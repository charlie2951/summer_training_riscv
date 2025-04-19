`include "cpu.v"
`include "progmem.v"
//`include "iomem.v"
//We are going to map 6 on board LED to CPU
//LED memory space starts from 0x10000000

module top(
    input rst, clk,
    output [31:0] cycle
    
  );
  wire [31:0]   addr;
  wire [31:0] mem_rdata;
  wire rstrb;
  
  
  //Instantiate sub modules
  cpu cpu0(
        .rst(rst), .clk(clk),
        .mem_rdata(mem_rdata),
           .mem_addr(addr),
        .cycle(cycle),
        .mem_rstrb(rstrb)
        
      );

  progmem mem0(
            .rst(rst), .clk(clk),
            .addr(addr),
            .data_in(),
            .rd_strobe(rstrb),
            .wr_strobe(),
            .data_out(mem_rdata)
          );
  
endmodule
