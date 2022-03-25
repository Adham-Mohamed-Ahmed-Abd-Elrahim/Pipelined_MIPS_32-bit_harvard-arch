module main_decoder
#(parameter code_width=6,width_alu_op=2)
(input [code_width-1:0] op_code ,
output reg [width_alu_op-1:0] alu_control,
output reg mem2reg,
output reg mem_wr,
output reg branch,
output reg alu_src,
output reg reg_dst,
output reg reg_wr,
output reg jmp 
);
//instructions
localparam [code_width-1:0] load=6'b10_0011;
localparam [code_width-1:0] store=6'b10_1011;
localparam [code_width-1:0] r_type=6'b00_0000;
localparam [code_width-1:0] add_imed=6'b00_1000;
localparam [code_width-1:0] branch_eq=6'b00_0100;
localparam [code_width-1:0] jmp_ins=6'b00_0010;
always @ (*)begin
    case(op_code)
    load:begin
        jmp=1'b0; 
        alu_control=2'b00;
        mem_wr=1'b0;
        reg_wr=1'b1;
        reg_dst=1'b0;
        alu_src=1'b1;
        mem2reg=1'b1;
        branch=1'b0;  
    end
    store:begin
        jmp=1'b0; 
        alu_control=2'b00;
        mem_wr=1'b1;
        reg_wr=1'b0;
        reg_dst=1'b0;
        alu_src=1'b1;
        mem2reg=1'b1;
        branch=1'b0; 
    end
    r_type:begin
        jmp=1'b0; 
        alu_control=2'b10;
        mem_wr=1'b0;
        reg_wr=1'b1;
        reg_dst=1'b1;
        alu_src=1'b0;
        mem2reg=1'b0;
        branch=1'b0; 
    end
    add_imed:begin
        jmp=1'b0; 
        alu_control=2'b00;
        mem_wr=1'b0;
        reg_wr=1'b1;
        reg_dst=1'b0;
        alu_src=1'b1;
        mem2reg=1'b0;
        branch=1'b0; 
    end
    branch_eq:begin
        jmp=1'b0; 
        alu_control=2'b01;
        mem_wr=1'b0;
        reg_wr=1'b0;
        reg_dst=1'b0;
        alu_src=1'b0;
        mem2reg=1'b0;
        branch=1'b1; 
    end
    jmp_ins:begin
        jmp=1'b1; 
        alu_control=2'b00;
        mem_wr=1'b0;
        reg_wr=1'b0;
        reg_dst=1'b0;
        alu_src=1'b0;
        mem2reg=1'b0;
        branch=1'b0; 
    end
    default :begin
        jmp=1'b0; 
        alu_control=2'b00;
        mem_wr=1'b0;
        reg_wr=1'b0;
        reg_dst=1'b0;
        alu_src=1'b0;
        mem2reg=1'b0;
        branch=1'b0; 
    end
    endcase 
end
endmodule 