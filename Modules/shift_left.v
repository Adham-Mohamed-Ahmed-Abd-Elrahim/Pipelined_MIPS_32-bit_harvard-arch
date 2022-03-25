module shift_left
#(parameter width=32)
(input [width-1:0] in,
output reg [width-1:0] out

);
always @(*)begin
out=(in<<2); //shift left twice
end
endmodule