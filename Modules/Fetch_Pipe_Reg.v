//*modified 
module Fetch_Pipe_Reg //program counter with pipe reg 
#(parameter width =32)
(input clk ,
input reset ,
input en,
input [width-1:0] pc_in,
output reg  [width-1:0] pc_out
);

always @ (posedge clk,negedge reset )begin
if(!reset)
pc_out<={width{1'b0}};
else if (!en)
pc_out<=pc_in;
end
endmodule 