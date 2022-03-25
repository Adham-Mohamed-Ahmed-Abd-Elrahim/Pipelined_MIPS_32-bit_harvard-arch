module wr_back_pipe_reg 
#(parameter data_width=32,op_width=5)
(input clk ,
input reset ,
input reg_wr_m,
input mem2reg_m,
input [data_width-1:0] data, //output from data_memory 
input [op_width-1:0] write_reg_m,
input [data_width-1:0] alu_result_m ,
//----outputs ---
output reg reg_wr_w,
output reg mem2reg_w,
output reg [data_width-1:0] data_w,
output reg [op_width-1:0] write_reg_w,
output reg  [data_width-1:0] alu_result_w
);
always @ (posedge clk,negedge reset  )begin
    if (!reset )begin
 reg_wr_w<=1'b0;
mem2reg_w<=1'b0;
 data_w<={data_width{1'b0}};
write_reg_w<={op_width{1'b0}};
alu_result_w<={data_width{1'b0}};
    end
else begin
reg_wr_w<=reg_wr_m;
mem2reg_w<=mem2reg_m;
data_w<=data;
write_reg_w<=write_reg_m;
alu_result_w<=alu_result_m;
end
end
endmodule 