module Decode_Pipe_Reg
#(parameter ins_width=32)
(input clk,
input en,
input reset ,
input clr,
input [ins_width-1:0] in_instruction ,
input [ins_width-1:0] pcplus4_in,
output  reg [ins_width-1:0] ins_out,
output  reg [ins_width-1:0] pcplus4_out 
);
always @ (posedge clk, negedge reset ) begin
    if (!reset)begin
    ins_out<={ins_width{1'b0}};
    pcplus4_out<={ins_width{1'b0}};
    end
else if ((clr==1'b1)&&!en)begin
 ins_out<={ins_width{1'b0}};
 pcplus4_out<={ins_width{1'b0}};
end
else if (!en)begin
ins_out<=in_instruction;
pcplus4_out<=pcplus4_in;
end

end
endmodule 