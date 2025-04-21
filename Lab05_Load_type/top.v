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
  wire [31:0] mem_rdata, mem_wdata;
  wire rstrb;
  wire [3:0] wstrb;

  //Instantiate sub modules
  cpu cpu0(
        .rst(rst), .clk(clk),
        .mem_rdata(mem_rdata),
        .mem_wdata(mem_wdata),
        .mem_addr(addr),
        .cycle(cycle),
        .mem_rstrb(rstrb),
        .mem_wstrb(wstrb)
      );

  progmem mem0(
            .rst(rst), .clk(clk),
            .addr(addr),
            .data_in(mem_wdata),
            .rd_strobe(rstrb),
            .wr_strobe(wstrb),
            .data_out(mem_rdata)
          );

endmodule
