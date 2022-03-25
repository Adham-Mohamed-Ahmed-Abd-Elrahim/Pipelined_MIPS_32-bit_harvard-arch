module memory_stage 
#(parameter data_width=32,op_width=5,test_width=16)
(input clk,
input reset,
    input [data_width-1:0] in_alu_out_m,
input  [data_width-1:0] write_data_mem,
input mem_write_m,
output [data_width-1:0] data_out, 
output [test_width-1:0] test_value
);

 data_memory #( .width(32),.depth(256),.addr(32),.test_width(16)) data_Memory

(
.clk(clk),
.rst(reset) ,
.WE(mem_write_m),
.read_addr(in_alu_out_m),//for alu result 
.W_data(write_data_mem),//for memory write
.RD_out(data_out), //read output 
.test_value(test_value) 
);
endmodule 