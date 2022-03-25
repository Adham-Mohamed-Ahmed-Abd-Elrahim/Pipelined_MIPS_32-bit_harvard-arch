module hazard_unit 
#(parameter op_width=5,mux_sel=2)
(
    input branch_d, //branch @ decode stage
    input jmp_d,
 input [op_width-1:0] RsE, //Operand 1 @Execution stage (source)
 input [op_width-1:0] RtE,//Operand 2  @Execution stage(source)

 input [op_width-1:0] RsD, //Operand 1 @Decode stage (source)
 input [op_width-1:0] RtD,//Operand 2  @Decode stage(source)

 input [op_width-1:0] write_reg_m ,// destenation @ memory stage 
 input [op_width-1:0] write_reg_w ,// destenation @ write stage 
  input [op_width-1:0] write_reg_e ,// destenation @ decode stage 
 input reg_write_mem, //Reg_File WE @ mem stage 
 input reg_write_wr,//Reg_File WE @ write_back stage 
 input reg_write_e, ////Reg_File WE @ execution  stage 
 input mem2reg_e, //control signal directs signal from d_mem to reg_file[gets high @ lw instruction] @ execution stage 
 input mem2reg_m, //
//
//*******outputs****
// For forwarding
output reg [mux_sel-1:0] Forward_A_E, // Forwarding to In_1 to alu @ execute stage 
output reg [mux_sel-1:0] Forward_B_E, // Forwarding to In_2to alu  @ execute stage
output  Forward_A_D, // Forwarding to out1 reg_file  @ decode stage 
output  Forward_B_D, // Forwarding to In_2to alu     @ decode stage 
//for stalling 
output stall_F , //stalling fetching stage
output stall_D,//stalling decode stage
output flush_E//to flush execute stage 

);
//internal signals 
wire lw_stall;
wire branch;
//assignments for stalling
assign lw_stall=((RsD==RtE) || (RtD==RtE)) && mem2reg_e ;
assign branch=((branch_d & reg_write_e & ((write_reg_e == rRsDsD) | (write_reg_e == RtD))) | (branch_d & mem2reg_m & ((write_reg_m == RsD) | (write_reg_m == RtD))));;

assign stall_F=lw_stall||branch;
assign stall_D=lw_stall||branch;
assign flush_E=lw_stall||branch||jmp_d;
//forwarding @ decode stage
assign Forward_A_D = ((RsD!=0)&&(RsD==write_reg_m)&&reg_write_mem);
assign Forward_B_D = ((RtD!=0)&&(RtD==write_reg_m)&&reg_write_mem);
//parameters 
localparam [mux_sel-1:0] reg_file=2'b00;//regular path from reg_file
localparam [mux_sel-1:0] forward_wr=2'b01; 
localparam [mux_sel-1:0] forward_mem=2'b10;//forwarding from mem_stage

//**************Forwarding**************** 
//forwarding @  in_1 to alu
always @ (*)begin
    if((RsE!=0)&&((RsE==write_reg_m)&&reg_write_mem ))
    Forward_A_E=forward_mem;
    else if  ((RsE!=0)&&((RsE==write_reg_w)&&write_reg_w ))
     Forward_A_E=forward_wr;
     else 
     Forward_A_E=reg_file;
end
//forwarding @  in_2 to alu
always @ (*)begin
    if((RtE!=0)&&(RtE==write_reg_m)&&reg_write_mem )
    Forward_B_E=forward_mem;
    else if  ((RtE!=0)&&(RtE==write_reg_w)&&write_reg_w )
     Forward_B_E=forward_wr;
     else 
     Forward_B_E=reg_file;
end


endmodule  