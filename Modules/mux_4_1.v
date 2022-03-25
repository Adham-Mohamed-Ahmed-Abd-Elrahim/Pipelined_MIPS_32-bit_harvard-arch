module mux_4_1 
#(parameter width =32,sel_width=2)
(input [width-1:0] in_0,in_1,in_2,in_3 , //in_3 attached to zeros 
input [sel_width-1:0] sel,
output reg [width-1:0] out 
);
always @ (*)begin
    case(sel) 
        2'b00: out=in_0; 
        2'b01: out=in_1;
        2'b10: out=in_2;
        2'b11: out=in_3;
        default: out=in_3;
    endcase 
end
endmodule 