/*modified for testing*/
module ALU 
#(parameter width=32)
(input [width-1:0] op1 ,
input [width-1:0] op2,
input [2:0] ALU_control ,
output reg [width-1:0] result 
);
/*Encoding likewise session*/
localparam [2:0] And=3'b000;
localparam [2:0] Or=3'b001;
localparam [2:0] add=3'b010;
localparam [2:0] sub=3'b100;
localparam [2:0] mul=3'b101;
localparam [2:0] slt=3'b110;
always @ (*)begin
    case(ALU_control)
    And:result=op1&op2;
    Or:result=op1|op2;
    add:result=op1+op2;
    sub:result=op1-op2;
    mul:result=op1*op2;
    slt:result= (op1<op2) ? {{(width-1){1'b0}}, 1'b1}:{(width){1'b0}};  
    default:result={width{1'b0}};
    endcase
end
endmodule 
