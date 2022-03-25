/*modified */
module alu_decoder
#(parameter code_width=6,width_alu_op=2,width_alu_control=3 )
(input [code_width-1:0] func,
 input [width_alu_op-1:0] alu_op,
 output reg [width_alu_control-1:0] alu_control 
);
//parameters of func
localparam [code_width-1:0] add=6'b10_0000;
localparam [code_width-1:0] sub=6'b10_0010;
localparam [code_width-1:0] slt=6'b10_1010;
localparam [code_width-1:0] mul=6'b01_1100;
//modification
localparam [code_width-1:0] And=6'b10_0100 ;
localparam [code_width-1:0] OR=6'b10_0101 ;
always @ (*)begin
    case(alu_op)
     2'b00:   alu_control=3'b010;
     2'b01:   alu_control=3'b100;
     2'b10:   case(func)
               add: alu_control=3'b010;
               sub: alu_control=3'b100;
               slt: alu_control=3'b110;
               mul: alu_control=3'b101;
               //*******
               And: alu_control=3'b000;
               OR:  alu_control=3'b001;
               default:alu_control=3'b111; //not_used in alu ->default case
              endcase
    default :alu_control=3'b111;
    endcase
end
endmodule 