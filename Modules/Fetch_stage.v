module fetch_stage 
#(parameter inst_width=32)
( input [inst_width-1:0] pc ,
output [inst_width-1:0] instruction ,
output [inst_width-1:0] pc_plus4

);

PC_Adder #(.ins_width(32)) pc_adder 

(
.PC_in(pc),
.PC_out(pc_plus4) 

);
/*depth is only for testing ,real=2**addr*/
ins_memory #( .width(32) , .addr(32) ,.depth(128) ) ins_memory

(  .pc_in(pc),
 .instruction(instruction)
);
endmodule 