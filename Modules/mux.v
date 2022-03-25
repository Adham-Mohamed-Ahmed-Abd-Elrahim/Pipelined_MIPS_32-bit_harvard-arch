module mux 
#(parameter width =32)
(input [width-1:0] in_0,
input [width-1:0] in_1,
input sel,
output [width-1:0] out 

);
assign out = (sel==1'b1) ? in_1 : in_0 ;
endmodule