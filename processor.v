//Authors :
//	1. Harshad Bhausaheb Ugale
//	2. Mahesh Shahaji Patil

// Description :
//	This is main module of system.
//	
//	Organizes all the main modules of the pipeline.

		

module processor (
	input clk,resetn,flush
);

localparam WIDTH = 16;
wire [WIDTH-1:0] OutputToDecode;
wire [15:0] Instruction;
wire [1:0]  R_I_J;
wire [4:0]  alu_op;
wire [11:0] I_12;
wire [WIDTH+2:0] OutputToRR;
wire [41:0] OutputToEX;
wire [31:0] reg_Read_Data;
wire [5:0] reg_Read_addr;	
wire [41:0]  outData; 
wire [15:0] WB_OUT;
wire [2:0] reg_write_addr;
wire [31:0] read_data;	
wire update;
wire [37:0] OutToMA,OutToEX_MA_Reg;
wire [37:0] OutToWB,OutToWB2;
wire [15:0] Mem_Addr;
wire [15:0] write_data;
wire [15:0] read_data1;


	//Call for Instruction Fetch Module
	Instr_Fetch instr_fetch_inst (.clk(clk), .resetn(resetn), .Instruction(Instruction));
	
	//Call for register in between Instruction Fetch and Instruction Decode 
	kbitwidthReg #(16) IF_to_ID_REG (.Din(Instruction), .clk(clk), .resetn(resetn), .ld(1'b1), .Qout(OutputToDecode));
	
	//Call for Instruction Decode Module
	Instr_Decode instr_decode_inst(.flush(flush),.resetn(resetn),.Instr(OutputToDecode),.R_I_J(R_I_J),.alu_op(alu_op),.I_12(I_12));
	
	//Call for register in between Instruction Decode and Register Read 
	kbitwidthReg #(19) ID_to_RR_REG (.Din({I_12,alu_op,R_I_J}),.clk(clk),.resetn(resetn),.ld(1'b1),.Qout(OutputToRR));
	
	//Call for Register Read Module
	//Register_Read register_read_inst (.flush(flush),.resetn(resetn),.InData(OutputToRR), .reg_Read_Data(read_data), .reg_read_addr(reg_Read_addr), .outData(outData));
	//Register_File register_file_inst (.clk(clk),.resetn(resetn),.Din(WB_OUT), .reg_write_addr(reg_write_addr), .reg_read_addr(reg_Read_addr), .read_data(read_data));
	
	//Call for register in between Register Read and Instruction Execute
	//kbitwidthReg #(42) RR_to_EX_REG (.Din(outData),.clk(clk),.resetn(resetn),.ld(1'b1),.Qout(OutputToEX));
	
	//Call for Instruction Execute Module
	Instr_Execute instr_execute_inst (.clk(clk),.resetn(resetn),.flush(flush),.ExInData(OutputToEX),.update(update),.OutToMA(OutToEX_MA_Reg));
	
	//Call for register in between Instruction Execute and Memory Access 
	kbitwidthReg #(38) EX_to_MA_REG (.Din(OutToEX_MA_Reg),.clk(clk),.resetn(resetn),.ld(update),.Qout(OutToMA));
	
	//Call for Memory Access Module   USE:- To load data from memory to register. Memory address formed in load word instruction.
	Memory_Access memory_access_inst (.resetn(resetn), .flush(flush), .MemAccessInData(OutToMA), .Mem_Addr(Mem_Addr), .MemAccessOutput(OutToWB));
	Memory memory_inst (.clk(clk), .resetn(resetn), .mem_write_addr(WB_OUT), .mem_read_addr(Mem_Addr), .write_data(write_data), .read_data(read_data1));

	//Call for register in between Memory Access and Write Back
	kbitwidthReg #(38) MA_to_WB_REG (.Din(OutToWB),.clk(clk),.resetn(resetn),.ld(1'b1),.Qout(OutToWB2));
	
	//Call for Write Back Module
	Write_Back write_back_inst (.resetn(resetn),.WBInData(OutToWB2),.reg_write_addr(reg_write_addr),.WB_OUT(WB_OUT));



endmodule

module tb;

reg clk,resetn;

processor proc_inst (.clk(clk),.resetn(resetn));

initial
	begin
		clk = 0;
		resetn = 1;
		#100 resetn = 0;
		#100 resetn = 1;
	end

always #50 clk = ~clk;

endmodule