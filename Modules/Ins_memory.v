module ins_memory 
#(parameter width=32 , addr=32 ,depth= 256 ) //depth is only for testing ,real=2**addr
( input [width-1:0] pc_in,
 output  [width-1:0] instruction 
);

reg [width-1:0] ins_mem [0:depth-1] ;
initial begin
   $readmemh("Program 1_Machine Code.txt", ins_mem);
end
assign instruction=ins_mem[pc_in>>2]; //divide by 2 

endmodule 