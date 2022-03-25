module sign_extention
#(parameter in_width=16,out_width=32)
(input [in_width-1:0] in,
output reg  [out_width-1:0] out 
);


always @ (*)begin
   out ={{in_width{in[in_width-1]}},in};
end
endmodule 