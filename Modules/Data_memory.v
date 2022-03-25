module data_memory
#(parameter width=32,depth=256,addr=32,test_width=16)
(
    input clk,
    input rst ,
    input WE,
    input [addr-1:0] read_addr,//for alu result 
    input [width-1:0] W_data,//for memory write
    output [width-1:0] RD_out, //read output 
    output [test_width-1:0] test_value 
);
integer i;
localparam mem_addr=32'h0000_0000;
reg [width-1:0] data_mem [0:depth-1] ;
//reading
assign RD_out=data_mem[read_addr];
assign test_value=data_mem[mem_addr];

always @ (posedge clk)
begin
if(!rst)begin
    for(i=0;i<width;i=i+1)begin
data_mem[i]<={width{1'b0}};
    end
end
else if (WE==1'b1)
data_mem[read_addr]<=W_data;

end
endmodule 