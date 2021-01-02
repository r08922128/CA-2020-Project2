module EXMEM
(
    clk_i,
    start_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUdata_i,
    MemWdata_i,
    RDaddr_i, 
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUdata_o,
	MemWdata_o,
    RDaddr_o
);

input           clk_i,
                start_i,
                RegWrite_i,
                MemtoReg_i,
                MemRead_i,
                MemWrite_i; 
input [31:0]    ALUdata_i,
                MemWdata_i;
input [4:0]     RDaddr_i;
output          RegWrite_o, 
                MemtoReg_o, 
                MemRead_o,
                MemWrite_o; 
output [31:0]   ALUdata_o,
                MemWdata_o; 
output [4:0]    RDaddr_o;
reg             RegWrite_o,
                MemtoReg_o, 
                MemRead_o, 
                MemWrite_o; 
reg [31:0]      ALUdata_o,
                MemWdata_o;
reg [4:0]       RDaddr_o;

always @ ( posedge clk_i or negedge start_i) begin
	if (~start_i) begin 
		RegWrite_o <= 0;
		MemtoReg_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		ALUdata_o <= 0;
		RDaddr_o <= 0;
		MemWdata_o <= 0;
	end
	else begin    
		RegWrite_o <= RegWrite_i;
		MemtoReg_o <= MemtoReg_i;
		MemRead_o <= MemRead_i;
		MemWrite_o <= MemWrite_i;
		ALUdata_o <= ALUdata_i;
		RDaddr_o <= RDaddr_i;
		MemWdata_o <= MemWdata_i;
	end
end

endmodule