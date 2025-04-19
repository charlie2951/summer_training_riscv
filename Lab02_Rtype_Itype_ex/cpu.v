/* CPU Version 4.0
Simple Addition
*/
module cpu(
    input rst, clk,
    input [31:0] mem_rdata,//32 bit data chunk from memory
    output [31:0] mem_addr,
    output reg [31:0] cycle, //for debugging only to see how many cycle used
    output mem_rstrb

  );

  reg [31:0] regfile[0:31];//Register file with X0 to X31;
  reg [31:0] addr, data_rs1, data_rs2; //address bus
  reg [31:0] data; //data bus

  reg [3:0] state; //state register
  parameter RESET=0, FETCH=1, DECODE=2, EXECUTE=3, HLT=4,BYTE1=5, BYTE2=6, BYTE3=7, BYTE4=8, WAIT=9, WAIT_LOADING=10; //Different states
  //********* Decoding of Instructions*******//
  wire [4:0] opcode = data[6:2];
  wire [4:0] rd = data[11:7];
  wire [2:0] funct3 = data[14:12];
  wire [6:0] funct7 = data[31:25];
  wire [31:0] I_data = {{21{data[31]}},data[30:20]}; //sign extended data

  // check whether opcode is for R type or I type  or B-type
  wire isRtype = (opcode == 5'b01100);
  wire isItype = (opcode == 5'b00100);
  wire isSystype = (opcode == 5'b11100);


  // flag to calculate mem location for load/store type

  // reg [7:0] tmp_stored_data;
  //  Design ALU using conditional operator
  wire [31:0] ADD = alu_in1 + alu_in2 ;
  wire [31:0] XOR = alu_in1 ^ alu_in2;
 wire [31:0] OR = alu_in1 | alu_in2;
  // wire [31:0] AND = alu_in1 & alu_in2;
  wire [32:0] SUB = {1'b0,alu_in1} + {1'b1, ~alu_in2} + 1'b1; //2's comp additon=subtraction


  // Note : for ADD and SUB, funct3 is same but funct7[5] is different

  wire [31:0] alu_result = (funct3==3'b000) & isRtype & ~funct7[5]? ADD: //ADD
       (funct3==3'b000) & isItype  ? ADD: //ADD
       (funct3==3'b000) & funct7[5]? SUB[31:0]: //SUB
       (funct3==3'b100)? XOR: //XOR
       (funct3==3'b110)? OR:0;
  //note: include AND operation

  //source1 and source 2 data for ALU operation
  wire [31:0] alu_in1 = data_rs1; //source is always rs1 for both type
  wire [31:0] alu_in2 = (isRtype)? data_rs2 :  I_data;//ALU req for comparison in Btype
  wire [31:0] pcplus4 = addr + 4;
  //Generate memory write strobe control signal
  //Generate memory address for load or store operation
  assign mem_addr =  addr;//calculate address for instruction/data to be stored or fetched
  //Generate memory read strobe signal
  assign mem_rstrb = (state==WAIT) ;//need to be modified for load instr
  initial
  begin
    state=0;
    addr = 0;
    cycle = 0;
    regfile[0] = 0;//X0 reg is always 0
  end

  //clock dependent operation

  always @(posedge clk)
  begin
    if(rst)
    begin
      addr <= 0;
      state <= RESET;
      data <= 32'h0;
    end
    else
    case(state)
      RESET: //If reset is pressed
      begin
        if(rst)
          state <= RESET;
        else
          state <= WAIT;
      end
      WAIT:
      begin//this state provides 1 cycle delay to fetch data from progmem
        state <= FETCH;

      end

      FETCH: //Fetch data from progmem RAM
      begin
        data <= mem_rdata; //latch mem read data into reg
        state <= DECODE;
      end

      DECODE: //Decoding of different instruction and generate signal
      begin
        data_rs1 <= regfile[data[19:15]];
        data_rs2 <= regfile[data[24:20]];
        state <= ~isSystype? EXECUTE:  HLT;
      end

      EXECUTE:
      begin
        addr <=  pcplus4;
        state <=  WAIT;

      end

    endcase
  end
  //*** clock cycle counter **//
  always @(posedge clk)
  begin
    if(rst)
      cycle <= 0;
    else
    begin
      if(state != HLT)
        cycle <= cycle + 1;
    end
  end
  // ** Register file write back data **//
  wire write_reg_en = ((isItype|isRtype) &(state==EXECUTE));
  wire [31:0] write_reg_data = (isItype |isRtype) ? alu_result:0;
  always @(posedge clk)
  begin
    if (write_reg_en)
      if (rd != 0)
        regfile[rd] <= write_reg_data;
  end

endmodule
