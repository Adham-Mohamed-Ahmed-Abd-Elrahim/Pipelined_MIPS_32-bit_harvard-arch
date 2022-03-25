module data_path
#(parameter data_width=32 ,instr_width=32,width_alu_control=3,pc_source_width=2,op_width=5,code_width=6,forward_sel_width=2,test_width=16)
(
input clk ,
input reset ,
//hazard_unit_signals 
input stall_f,stall_d,flush_e,forward_ad,forward_bd,
input [forward_sel_width-1:0] forward_ae,forward_be,
//control_unit signals 
input [width_alu_control-1:0] alu_control,
input  mem2reg,mem_wr, branch, alu_src, reg_dst, reg_wr, jmp ,
output [test_width-1:0] test_value,
//outputs for hazard_unit
output [op_width-1:0] h_rsd,h_rtd,h_rse,h_rte,
output [op_width-1:0] h_write_reg_m,h_write_reg_e,h_write_reg_w,
output reg_wr_e,reg_write_m,reg_wr_w,mem2reg_e,mem2reg_m,
//outputs for control unit 
output [code_width-1:0] op_code,func
);
//**************************************************************************************
//-----All internal signals------ 
//----------for fetch stage------
wire [instr_width-1:0] pc;
wire [instr_width-1:0] pc_f;
wire [instr_width-1:0] pc_plus4;
wire [instr_width-1:0] instruction;
//---------for decode stage------
wire [instr_width-1:0] instr_d; //instruction @ decode stages
wire [instr_width-1:0] pc_plus4_d;
wire [instr_width-1:0] pc_branch_d;
wire [pc_source_width-1:0] pc_src_d;
wire [data_width-1:0] rd1_d;
wire [data_width-1:0] rd2_d;
wire [data_width-1:0] sign_extended_d;
wire [op_width-1:0] rsd,rtd,rde;
wire clr_d ;  //clearing decode_reg
//----------for execute stage-----
//internal_signals 
wire [data_width-1:0] rd1_e;
wire [data_width-1:0] rd2_e;
wire [data_width-1:0] sign_extended_e;
wire [op_width-1:0] rse,rte,rde_e;
wire [width_alu_control-1:0] alu_control_e;
wire [data_width-1:0] alu_result_e;
wire [data_width-1:0] write_data_e;
wire [op_width-1:0]  write_reg_e;
//control signals 
wire mem_wr_e,alu_src_e, reg_dst_e; 
//----------for memory stage-----
//internal signals
wire mem_write_m;
wire [data_width-1:0] alu_result_m;
wire [data_width-1:0] write_data_m;
wire [op_width-1:0] write_reg_m;
wire [data_width-1:0] mem_data_m; 
//----------for write_back stage-----
//internal signals 
wire mem2reg_w;
wire [data_width-1:0] mem_data_w;
wire [op_width-1:0] write_reg_w;
wire  [data_width-1:0] alu_result_w;
//for mux 
wire [data_width-1:0] result_w;
//********************************************************************************
//Main_assignements
assign op_code=instr_d[31:26];
assign func=instr_d[5:0];
 assign h_rsd=rsd;
 assign h_rtd=rtd;
 assign h_rse=rse;
 assign h_rte=rte;
assign  h_write_reg_m=write_reg_m;
assign h_write_reg_e=write_reg_e;
assign h_write_reg_w=write_reg_w;
//********************************************************************************
//----------fetch stage --------
 mux_4_1 #( .width(32),.sel_width(2)) mux_pc_src_d
(
.in_0(pc_plus4),
.in_1(pc_branch_d),
.in_2({pc_plus4_d[31:28],instr_d[25:0],2'b00}),
.in_3({32{1'b0}}) , //in_3 attached to zeros 
.sel(pc_src_d),
.out(pc)
);
 Fetch_Pipe_Reg #(.width(32))  fetch_pipe_register
(.clk(clk) ,
 .reset(reset) ,
 .en(stall_f),
 .pc_in(pc),
 .pc_out(pc_f)
);
fetch_stage  #(.inst_width(32)) fetch_stage_
( 
 .pc(pc_f) ,
 .instruction(instruction) ,
 .pc_plus4(pc_plus4)
);
//***********************************************************************************
//-----------decode stage----
//assignments
assign clr_d=pc_src_d[0] || pc_src_d[1];

 Decode_Pipe_Reg #(.ins_width(32)) decode_pipe_register
(.clk(clk),
 .en(stall_d),
 .reset(reset) ,
 .clr(clr_d),
 .in_instruction(instruction) ,
 .pcplus4_in(pc_plus4),
 .ins_out(instr_d),
 .pcplus4_out(pc_plus4_d) 
);
 decode_stage #(.instr_width(32) , .data_width(32),.pc_source_width(2) ,.op_width(5)) Decode_stage
( .clk(clk) ,
  .reset(reset),
  .Forward_A_D(forward_ad),
  .Forward_B_D(forward_bd),
  .jmp(jmp),
  .branch(branch),
  .alu_out_m(alu_result_m),
  .instruction(instr_d) ,
  .pcplus4(pc_plus4_d),
  .result_w(result_w) ,//data @ which to be written in reg_file 
  .write_reg_w(write_reg_w),
  .reg_write_w(reg_wr_w), //write_enalbe of reg_file from write_Back stage 
  .rd1(rd1_d), // output1 reg_File
  .rd2(rd2_d),//output2 reg_file
  .pc_branch_d(pc_branch_d) ,
  .pc_src_d(pc_src_d),
  .sign_extended_d(sign_extended_d),//@decode stage
  .rsd(rsd),
  .rtd(rtd),
  .rde(rde)
);
//*****execute stage *********

 execute_pipe_reg #(.data_width(32),.alu_ctrl_width(3),.op_width(5)) execute_register

(.clk(clk),
.reset(reset) ,
.clr(flush_e),
//control_unit_in
.reg_write_d(reg_wr),
.mem2reg_d(mem2reg),
.mem_wr_d(mem_wr),
.alu_control_d(alu_control),
.alu_src_d(alu_src),
.reg_dst_d(reg_dst),


//----------
//operand_inputs
.rd1_d(rd1_d),
.rd2_d(rd2_d),
.rsd_d(rsd),
.rtd_d(rtd),
.rde_d(rde),
.sign_extend_d(sign_extended_d),
//----------
//outputs
.reg_write(reg_wr_e),
.mem2reg(mem2reg_e),
.mem_wr(mem_wr_e),
.alu_control(alu_control_e),
.alu_src(alu_src_e),
.reg_dst(reg_dst_e),

//operand_output
.rd1_e(rd1_e),
.rd2_e(rd2_e),
.rse(rse),
.rte(rte),
.rdE(rde_e),
.sign_extend(sign_extended_e)
//----------
);

execute_stage #( .data_width(32),.op_width(5),.forward_sel_width(2),.alu_ctrl_width(3)) Execute_Stage

( .rd1(rd1_e), //reg_file out 1
  .rd2(rd2_e), //reg_file out 2
  .result_w(result_w) , //data_mem read from write_Back stage
  .alu_out_m(alu_result_m) , //alu _result @ mem stage 
  .rte(rte),
  .rde(rde_e),
  .sign_extend_e(sign_extended_e),
  //control signals 
  .alu_src_e(alu_src_e),
  .regdst_e(reg_dst_e),
  .forward_ae(forward_ae),
  .forward_be(forward_be),
  .alu_ctrl_e(alu_control_e),
  //****outputs***
  .alu_result(alu_result_e),
  .write_data_e(write_data_e),
  .write_reg(write_reg_e)

);
//memory stage 

memory_pipe_reg #(.data_width(32) ,.op_width(5)) memory_register

(.clk(clk),
 .reset(reset) ,
 .alu_result(alu_result_e) ,
 .write_data_e(write_data_e) ,//to be written in data_memory
 .write_reg_e(write_reg_e), //write address @ reg_file 
//control_signals 
 .reg_write_e(reg_wr_e),
 .mem2reg_e(mem2reg_e),
 .mem_write_e(mem_wr_e),
//---------outputs --------
 .reg_write_m(reg_write_m),
 .mem2reg_m(mem2reg_m),
 .mem_write_m(mem_write_m),
 .alu_result_m(alu_result_m),
 .write_data_m(write_data_m),
 .write_reg_m(write_reg_m)
);

 memory_stage #(.data_width(32),.op_width(5),.test_width(16)) mem_stage
(.clk(clk),
 .reset(reset),
 .in_alu_out_m(alu_result_m),
 .write_data_mem(write_data_m),
 .mem_write_m(mem_write_m),
 .data_out(mem_data_m), 
 .test_value(test_value)
);
//*******wr back stage***** 

wr_back_pipe_reg #(.data_width(32),.op_width(5)) write_back_register

(.clk(clk) ,
 .reset(reset) ,
 .reg_wr_m(reg_write_m),
 .mem2reg_m(mem2reg_m),
 .data(mem_data_m), //output from data_memory 
 .write_reg_m(write_reg_m),
 .alu_result_m(alu_result_m) ,
//----outputs ---
 .reg_wr_w(reg_wr_w),
 .mem2reg_w(mem2reg_w),
 .data_w(mem_data_w),
 .write_reg_w(write_reg_w),
.alu_result_w(alu_result_w)
);
mux #( .width (32)) mux_mem2reg_w
(.in_0(alu_result_w),
 .in_1(mem_data_w),
 .sel(mem2reg_w),
 .out(result_w) 

);
endmodule 