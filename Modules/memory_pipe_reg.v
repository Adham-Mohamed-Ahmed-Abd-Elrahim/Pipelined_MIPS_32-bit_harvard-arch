module memory_pipe_reg 
#(parameter data_width=32 ,op_width=5)
(input clk,
input reset ,
input [data_width-1:0] alu_result ,
input [data_width-1:0] write_data_e ,//to be written in data_memory
input [op_width-1:0] write_reg_e, //write address @ reg_file 
//control_signals 
input reg_write_e,
input mem2reg_e,
input mem_write_e,
//---------outputs --------
output reg reg_write_m,
output reg mem2reg_m,
output reg mem_write_m,
output reg [data_width-1:0] alu_result_m,
output reg [data_width-1:0] write_data_m,
output reg [op_width-1:0] write_reg_m
);
always @ (posedge clk ,negedge reset )begin
    if (!reset)begin
reg_write_m<=1'b0;
 mem2reg_m<=1'b0;
 mem_write_m<=1'b0;
alu_result_m<={data_width{1'b0}};
write_data_m<={data_width{1'b0}};
 write_reg_m<={op_width{1'b0}};
    end
    else begin
reg_write_m<=reg_write_e;
 mem2reg_m<=mem2reg_e;
 mem_write_m<=mem_write_e;
alu_result_m<=alu_result;
write_data_m<=write_data_e;
 write_reg_m<=write_reg_e;
    end
end
endmodule 