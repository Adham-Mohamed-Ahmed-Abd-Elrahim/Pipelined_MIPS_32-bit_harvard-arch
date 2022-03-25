module Reg_file 
#(parameter width =32,depth=32,op_width=5)
(input clk,
input reset ,
input WE , //write enable 
input [op_width-1:0] R_op1,//read operand
input [op_width-1:0] R_op2, //read operand
input [op_width-1:0] W_op, //write operand
input  [width-1:0] W_data, //Date to be written
output [width-1:0] RD1, //outread 1 
output [width-1:0] RD2 //outread 2 
);
integer  i;
reg [width-1:0] reg_mem [0:depth-1]; //memory
//Asynchronous Reading 
assign RD1=reg_mem[R_op1];
assign RD2=reg_mem[R_op2];
//Synchronous writing @ negedge 
always @ (negedge clk ,negedge reset ) begin
    if(!reset) begin
        for (i=0;i<depth;i=i+1)begin
            reg_mem[i]<={width{1'b0}};
            end
        end
        else if(WE==1'b1) begin
         reg_mem[W_op]<=W_data;
            end 
    end

endmodule 