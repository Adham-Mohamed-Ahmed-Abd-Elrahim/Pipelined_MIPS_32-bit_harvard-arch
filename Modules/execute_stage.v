module execute_stage
#(parameter data_width=32,op_width=5,forward_sel_width=2,alu_ctrl_width=3)
( input [data_width-1:0] rd1, //reg_file out 1
  input [data_width-1:0] rd2, //reg_file out 2
  input [data_width-1:0] result_w , //data_mem read from write_Back stage
  input [data_width-1:0] alu_out_m , //alu _result @ mem stage 
  input [op_width-1:0] rte,
  input [op_width-1:0] rde,
  input [data_width-1:0] sign_extend_e,
  //control signals 
  input alu_src_e,regdst_e,
  input [forward_sel_width-1:0] forward_ae,
input [forward_sel_width-1:0] forward_be,
input [alu_ctrl_width-1:0] alu_ctrl_e,
  //****outputs***
  output [data_width-1:0] alu_result,
  output [data_width-1:0] write_data_e,
  output [op_width-1:0] write_reg

);
//internal signals 
wire [data_width-1:0] src_a ;//in_1 alu
wire [data_width-1:0] src_b ;//in_2 alu

 mux_4_1  #(.width(32),.sel_width(2)) mux_forward_ae

(.in_0(rd1),
.in_1(result_w),
.in_2(alu_out_m),
.in_3({data_width{1'b0}}) , //in_3 attached to zeros 
.sel(forward_ae),
.out(src_a) 
);
 mux_4_1  #(.width(data_width),.sel_width(2)) mux_forward_be

(.in_0(rd2),
.in_1(result_w),
.in_2(alu_out_m),
.in_3({data_width{1'b0}}) , //in_3 attached to zeros 
.sel(forward_be),
.out(write_data_e)
);
mux #( .width (data_width)) mux_alu_src

(.in_0(write_data_e),
.in_1(sign_extend_e),
.sel(alu_src_e),
.out(src_b) 

);
ALU #(.width(32)) alu

(.op1(src_a) ,
.op2(src_b),
.ALU_control(alu_ctrl_e) ,
.result(alu_result) 
);

mux #( .width (op_width)) mux_reg_dest

(.in_0(rte),
.in_1(rde),
.sel(regdst_e),
.out(write_reg) 

);


endmodule