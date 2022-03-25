module P_MIPS 
#(parameter data_width=32 ,instr_width=32,width_alu_control=3,pc_source_width=2,op_width=5,code_width=6,forward_sel_width=2,test_width=16)
(
input clk,
input reset ,
output [test_width-1:0] test_value
);

//**************************************************************************************************
//----------------internal_signals-----------------
//For control_unit
wire [code_width-1:0] op_code,func ;
wire [width_alu_control-1:0] alu_control;
wire  mem2reg,mem_wr, branch, alu_src,reg_dst,reg_wr, jmp  ;
//For hazard_unit
wire  [forward_sel_width-1:0] Forward_A_E; // Forwarding to In_1 to alu @ execute stage 
wire  [forward_sel_width-1:0] Forward_B_E; // Forwarding to In_2to alu  @ execute stage
wire  Forward_A_D; // Forwarding to out1 reg_file  @ decode stage 
wire  Forward_B_D; // Forwarding to In_2to alu     @ decode stage 
wire [op_width-1:0] h_rsd,h_rtd,h_rse,h_rte;
wire [op_width-1:0] h_write_reg_m,h_write_reg_e,h_write_reg_w;
wire reg_wr_e,reg_write_m,reg_wr_w,mem2reg_e,mem2reg_m;
//for stalling 
wire stall_F ; //stalling fetching stage
wire stall_D;//stalling decode stage
wire flush_E;//to flush execute stage 

//**************************************************************************************************
//----------------control unit-----------------
control_unit #(.width_code(6),.width_alu_control(3)) ctrl_unit
(.op_code(op_code),
 .func(func),
 .alu_control(alu_control),
 .mem2reg(mem2reg),
 .mem_wr(mem_wr),
 .branch(branch),
 .alu_src(alu_src),
 .reg_dst(reg_dst),
 .reg_wr(reg_wr),
 .jmp(jmp) 
);
//**************************************************************************************************
//------------------hazard_unit-------------
 hazard_unit #(.op_width(5),.mux_sel(2)) hazard_unt

(
 .branch_d(branch), //branch @ decode stage
 .jmp_d(jmp),
 .RsE(h_rse), //Operand 1 @Execution stage (source)
 .RtE(h_rte),//Operand 2  @Execution stage(source)

 .RsD(h_rsd), //Operand 1 @Decode stage (source)
 .RtD(h_rtd),//Operand 2  @Decode stage(source)

 .write_reg_m(h_write_reg_m) ,// destenation @ memory stage 
 .write_reg_w(h_write_reg_w) ,// destenation @ write stage 
 .write_reg_e(h_write_reg_e) ,// destenation @ decode stage 
 .reg_write_mem(reg_write_m), //Reg_File WE @ mem stage 
 .reg_write_wr(reg_wr_w),//Reg_File WE @ write_back stage 
 .reg_write_e(reg_wr_e), ////Reg_File WE @ execution  stage 
 .mem2reg_e(mem2reg_e), //control signal directs signal from d_mem to reg_file[gets high @ lw instruction] @ execution stage 
 .mem2reg_m(mem2reg_m), //
//
//*******outputs****
// For forwarding
.Forward_A_E(Forward_A_E), // Forwarding to In_1 to alu @ execute stage 
.Forward_B_E(Forward_B_E), // Forwarding to In_2to alu  @ execute stage
.Forward_A_D(Forward_A_D), // Forwarding to out1 reg_file  @ decode stage 
.Forward_B_D(Forward_B_D), // Forwarding to In_2to alu     @ decode stage 
//for stalling 
.stall_F(stall_F) , //stalling fetching stage
.stall_D(stall_D),//stalling decode stage
.flush_E(flush_E)//to flush execute stage 

);
//**************************************************************************************************
//---------------------data_path----------- 
 data_path #(.data_width(32) ,.instr_width(32),.width_alu_control(3),.pc_source_width(2),.op_width(5),.code_width(6),.forward_sel_width(2),.test_width(16)) data_path_

(
.clk(clk) ,
.reset(reset) ,
//hazard_unit_signals 
 .stall_f(stall_F),
 .stall_d(stall_D),
 .flush_e(flush_E),
 .forward_ad(Forward_A_D),
 .forward_bd(Forward_B_D),
 .forward_ae(Forward_A_E),
 .forward_be(Forward_B_E),
//control_unit signals 
.alu_control(alu_control),
.mem2reg(mem2reg),
.mem_wr(mem_wr),
.branch(branch), 
.alu_src(alu_src), 
.reg_dst(reg_dst), 
.reg_wr(reg_wr), 
.jmp(jmp) ,
.test_value(test_value),
//outputs for hazard_unit
.h_rsd(h_rsd),
.h_rtd(h_rtd),
.h_rse(h_rse),
.h_rte(h_rte),
.h_write_reg_m(h_write_reg_m),
.h_write_reg_e(h_write_reg_e),
.h_write_reg_w(h_write_reg_w),
.reg_wr_e(reg_wr_e),
.reg_write_m(reg_write_m),
.reg_wr_w(reg_wr_w),
.mem2reg_e(mem2reg_e),
.mem2reg_m(mem2reg_m),
//outputs for control unit 
.op_code(op_code),
.func(func)
);
//**************************************************************************************************
endmodule 