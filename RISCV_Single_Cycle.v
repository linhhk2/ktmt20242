// --- File: RISCV_Single_Cycle.v ---
`include "defines.v"

module RISCV_Single_Cycle(
    input clk,
    input rst_n,
    output wire [31:0] Instruction_out_top,
    output wire [31:0] PC_out_top
);
    wire [31:0] pc_current, pc_next, pc_plus_4;
    wire [31:0] instruction, immediate;
    wire [31:0] rs1_data, rs2_data, alu_result, mem_read_data, write_back_data;
    wire [6:0]  opcode;
    wire [2:0]  funct3;
    wire [6:0]  funct7;
    wire [4:0]  rs1_addr, rs2_addr, rd_addr;
    wire        branch_taken;
    wire RegWEn, ALUSrc, MemRW, MemToReg, Branch, Jump, BrUn;
    wire [3:0] alu_control;
    
    assign pc_plus_4 = pc_current + 4;
    assign pc_next = (Branch && branch_taken) ? (pc_current + immediate) :
                     (Jump) ? alu_result :
                              pc_plus_4;
    
    Program_Counter pc_reg(clk, rst_n, pc_next, pc_current);

    assign PC_out_top = pc_current;
    
    IMEM IMEM_inst(pc_current, instruction);
    
    assign Instruction_out_top = instruction;
    
    assign opcode   = instruction[6:0];
    assign funct3   = instruction[14:12];
    assign funct7   = instruction[31:25];
    assign rs1_addr = instruction[19:15];
    assign rs2_addr = instruction[24:20];
    assign rd_addr  = instruction[11:7];
    
    control_unit ctrl(opcode, funct3, funct7, RegWEn, ALUSrc, MemRW, MemToReg, Branch, BrUn, Jump, alu_control);
    
    RegisterFile Reg_inst(clk, RegWEn, rs1_addr, rs2_addr, rd_addr, write_back_data, rs1_data, rs2_data);
    
    Imm_Gen imm_gen(instruction, immediate);
    
    Branch_Comp branch_comp(rs1_data, rs2_data, BrUn, funct3, branch_taken);
    
    wire [31:0] alu_in_a, alu_in_b;
    assign alu_in_a = (opcode == `OPCODE_AUIPC || opcode == `OPCODE_JAL) ? pc_current : rs1_data;
    assign alu_in_b = ALUSrc ? immediate : rs2_data;
    
    ALU alu(alu_in_a, alu_in_b, alu_control, alu_result);
    
    DMEM DMEM_inst(clk, alu_result, rs2_data, MemRW, mem_read_data);
    
    assign write_back_data = MemToReg ? mem_read_data : (Jump ? pc_plus_4 : alu_result);
    
endmodule
