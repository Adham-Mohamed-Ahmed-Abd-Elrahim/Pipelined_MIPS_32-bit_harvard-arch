module decode_stage 
#(parameter instr_width=32 , data_width=32,pc_source_width=2 ,op_width=5)
(
    input clk ,
    input reset,
    input Forward_A_D,
    input Forward_B_D,
    input jmp,branch,
    input [data_width-1:0] alu_out_m,
    input [instr_width-1:0] instruction ,
    input [instr_width-1:0] pcplus4,
    input [data_width-1:0] result_w ,//data @ which to be written in reg_file 
    input [op_width-1:0] write_reg_w,
    input reg_write_w, //write_enalbe of reg_file from write_Back stage 
    output [data_width-1:0] rd1, // output1 reg_File
    output [data_width-1:0] rd2,//output2 reg_file
    output [instr_width-1:0] pc_branch_d ,
    output [pc_source_width-1:0] pc_src_d,
    output [instr_width-1:0] sign_extended_d,//@decode stage
    output [op_width-1:0] rsd,
    output [op_width-1:0] rtd,
    output [op_width-1:0] rde
);

//internal signals 
wire [instr_width-1:0] sign_extended; //@ decode stage 
wire [instr_width-1:0] sign_extended_shifted; //@ decode stage 
wire [data_width-1:0] rd1_out;
wire [data_width-1:0] rd2_out;
wire branch_and_equal;
wire equal;
//assignment 
assign sign_extended_d=sign_extended;
assign rsd=instruction[25:21];
assign rtd=instruction[20:16];
assign rde=instruction[15:11];
assign pc_src_d={jmp,branch_and_equal};
//equality
assign equal = (rd1_out==rd2_out) ? 1'b1:1'b0 ;
assign branch_and_equal=equal&&branch;

//************Register_file*************
 Reg_file #(.width (32),.depth(32),.op_width(5)) reg_file
(.clk(clk),
 .reset(reset) ,
 .WE(reg_write_w) , //write enable 
.R_op1(instruction[25:21]),//read operand
 .R_op2(instruction[20:16]), //read operand
 .W_op(write_reg_w), //write operand
 .W_data(result_w), //Date to be written
.RD1(rd1), //outread 1 
.RD2(rd2) //outread 2 
);
//muxes 
mux  #(.width(32)) rd1_forward
(.in_0(rd1),
.in_1(alu_out_m),
 .sel(Forward_A_D),
 .out(rd1_out) 

);
mux  #(.width(32)) rd2_forward
(.in_0(rd2),
 .in_1(alu_out_m),
 .sel(Forward_B_D),
 .out(rd2_out) 
);

//*************************************
sign_extention #(.in_width(16),.out_width(32)) sign_exten

( .in(instruction[15:0]),
  .out(sign_extended) 
);

adder #(.width(32)) pc_bracnh_adder
( .in_0(sign_extended_shifted),
.in_1(pcplus4),
 .out(pc_branch_d) 

);
shift_left #(.width(32)) shft_lft

( .in(sign_extended),
  .out(sign_extended_shifted)
);

endmodule