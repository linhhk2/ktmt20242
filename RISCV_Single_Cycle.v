// RISCV_Single_Cycle.v

`include "defines.v"

module RISCV_Single_Cycle(
    input clk, reset
);
    // Wires for datapath connections
    wire [31:0] pc_current, pc_next, pc_plus_4;
    wire [31:0] instruction, immediate;
    wire [31:0] rs1_data, rs2_data, alu_result, mem_read_data, write_back_data;
    wire [6:0]  opcode;
    wire [2:0]  funct3;
    wire [6:0]  funct7;
    wire [4:0]  rs1_addr, rs2_addr, rd_addr;
    wire        branch_taken;

    // Control Signals
    wire RegWEn, ALUSrc, MemRW, MemToReg, Branch, Jump;
    wire [3:0] alu_control;

    // PC Logic
    assign pc_plus_4 = pc_current + 4;
    // MUX for next PC
    assign pc_next = (Branch && branch_taken) ? (pc_current + immediate) : // Branch taken
                     (Jump) ? alu_result : // JAL/JALR
                              pc_plus_4;   // Default

    Program_Counter pc_reg(clk, reset, pc_next, pc_current);

    IMEM i_mem(pc_current, instruction);
    
    // Instruction Decoding
    assign opcode   = instruction[6:0];
    assign funct3   = instruction[14:12];
    assign funct7   = instruction[31:25];
    assign rs1_addr = instruction[19:15];
    assign rs2_addr = instruction[24:20];
    assign rd_addr  = instruction[11:7];

    control_unit ctrl(opcode, funct3, funct7, RegWEn, ALUSrc, MemRW, MemToReg, Branch, Jump, alu_control);
    
    RegisterFile reg_file(clk, RegWEn, rs1_addr, rs2_addr, rd_addr, write_back_data, rs1_data, rs2_data);

    Imm_Gen imm_gen(instruction, immediate);
    
    Branch_Comp branch_comp(rs1_data, rs2_data, funct3, branch_taken);

    // ALU Path
    wire [31:0] alu_in_a, alu_in_b;
    // MUX for ALU input A (for auipc)
    assign alu_in_a = (opcode == `OPCODE_AUIPC || opcode == `OPCODE_JAL) ? pc_current : rs1_data;
    // MUX for ALU input B
    assign alu_in_b = ALUSrc ? immediate : rs2_data;
    ALU alu(alu_in_a, alu_in_b, alu_control, alu_result);

    DMEM d_mem(clk, alu_result, rs2_data, MemRW, mem_read_data);

    // MUX for Write Back data
    assign write_back_data = MemToReg ? mem_read_data : (Jump ? pc_plus_4 : alu_result);

endmodule