module PC_Adder 
#(parameter ins_width =32)
(
input [ins_width-1:0]PC_in,
output[ins_width-1:0]PC_out 

);
assign PC_out=PC_in+32'd4;
endmodule 