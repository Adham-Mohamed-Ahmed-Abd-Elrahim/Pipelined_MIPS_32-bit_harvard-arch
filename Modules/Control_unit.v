module control_unit 
#(parameter width_code=6,width_alu_control=3)
(input [width_code-1:0] op_code,
input [width_code-1:0] func,
output [width_alu_control-1:0] alu_control,
output mem2reg,
output mem_wr,
output branch,
output alu_src,
output reg_dst,
output reg_wr,
output jmp 
);

localparam [1:0] width_alu_op=2;
//internal signals 
wire [width_alu_op-1:0] alu_op;

//main decoder
main_decoder main_dec
(.op_code(op_code) ,
.alu_control(alu_op),
.mem2reg(mem2reg),
.mem_wr(mem_wr),
.branch(branch),
.alu_src(alu_src),
.reg_dst(reg_dst),
.reg_wr(reg_wr),
.jmp(jmp) 
);
//alu_decoder 
alu_decoder alu_dec
(.func(func),
.alu_op(alu_op),
.alu_control(alu_control)
);
endmodule 