module execute_pipe_reg
#(parameter data_width=32,alu_ctrl_width=3,op_width=5)
(input clk,
input reset ,
input clr,
//control_unit_in
input reg_write_d,
input mem2reg_d,
input mem_wr_d,
input [alu_ctrl_width-1:0] alu_control_d,
input alu_src_d,
input reg_dst_d,


//----------
//operand_inputs
input [data_width-1:0] rd1_d,
input [data_width-1:0] rd2_d,
input [op_width-1:0] rsd_d,
input [op_width-1:0] rtd_d,
input [op_width-1:0] rde_d,
input [data_width-1:0] sign_extend_d,
//----------
//outputs
output reg reg_write,
output reg mem2reg,
output reg mem_wr,
output reg  [alu_ctrl_width-1:0] alu_control,
output reg  alu_src,
output reg  reg_dst,

//operand_output
output reg [data_width-1:0] rd1_e,
output reg [data_width-1:0] rd2_e,
output reg[op_width-1:0] rse,
output reg [op_width-1:0] rte,
output reg [op_width-1:0] rdE,
output reg [data_width-1:0] sign_extend
//----------
);
always @ (posedge clk,negedge reset)begin
    if(!reset)begin
 reg_write<=1'b0;
mem2reg<=1'b0;
mem_wr<=1'b0;
alu_control<={alu_ctrl_width{1'b0}};
alu_src<=1'b0;
reg_dst<=1'b0;

//operand_output
rd1_e<={data_width{1'b0}};
rd2_e<={data_width{1'b0}};
rse<={op_width{1'b0}};
rte<= {op_width{1'b0}};
rdE<={op_width{1'b0}};
sign_extend<={data_width{1'b0}};
    
    end
    else if(clr==1'b1) begin
reg_write<=1'b0;
mem2reg<=1'b0;
mem_wr<=1'b0;
alu_control<={alu_ctrl_width{1'b0}};
alu_src<=1'b0;
reg_dst<=1'b0;

//operand_output
rd1_e<={data_width{1'b0}};
rd2_e<={data_width{1'b0}};
rse<={op_width{1'b0}};
rte<= {op_width{1'b0}};
rdE<={op_width{1'b0}};
sign_extend<={data_width{1'b0}};
    end
    else begin
reg_write<=reg_write_d;   
mem2reg<=mem2reg_d;
mem_wr<=mem_wr_d;
alu_control<=alu_control_d;
alu_src<=alu_src_d;
reg_dst<=reg_dst_d;

//operand_output
rd1_e<=rd1_d;
rd2_e<=rd2_d;
rse<=rsd_d;
rte<=  rtd_d;
rdE<=rde_d;
sign_extend<=sign_extend_d;
    end

end

endmodule 
