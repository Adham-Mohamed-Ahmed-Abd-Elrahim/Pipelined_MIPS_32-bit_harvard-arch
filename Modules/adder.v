module adder
#(parameter width =32)
(input [width-1:0] in_0,
input [width-1:0] in_1,
output [width-1:0] out 

);
assign out = in_0+in_1 ;
endmodule