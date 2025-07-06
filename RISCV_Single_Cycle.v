`include "defines.v"

module RISCV_Single_Cycle(
    input clk,
    input rst_n,
    // Cổng output cho testbench theo dõi, đã được thêm vào
    output wire [31:0] PC_out_top,
    output wire [31:0] Instruction_out_top
);

    // --- Các dây tín hiệu nội bộ ---
    wire [31:0] pc_current, pc_next, pc_plus_4;
    wire [31:0] instruction, immediate;
    wire [31:0] rs1_data, rs2_data, alu_result, mem_read_data, write_back_data;
    wire [31:0] alu_in_a, alu_in_b;
    
    wire [6:0]  opcode;
    wire [2:0]  funct3;
    wire [6:0]  funct7;
    wire [4:0]  rs1_addr, rs2_addr, rd_addr;
    wire        branch_taken;

    // --- Các tín hiệu điều khiển ---
    wire RegWEn, ALUSrc, MemRW, MemToReg, Branch, Jump, BrUn;
    wire [1:0] alu_op; // Tín hiệu từ main_decoder đến ALU_decoder
    wire [3:0] alu_control;

    // --- Logic Datapath ---
    assign pc_plus_4 = pc_current + 4;
    assign pc_next = (Branch && branch_taken) ? (pc_current + immediate) :
                     (Jump)                 ? {alu_result[31:1], 1'b0} :
                                              pc_plus_4;

    // Program Counter
    Program_Counter pc_reg(
        .clk(clk), .rst_n(rst_n), 
        .pc_in(pc_next), .pc_out(pc_current)
    );
    
    // Cổng output cho testbench
    assign PC_out_top = pc_current;
    
    // Instruction Memory và output cho testbench
    IMEM IMEM_inst(.address(pc_current), .instruction(instruction));
    assign Instruction_out_top = instruction;
    
    // Giải mã các trường lệnh
    assign opcode   = instruction[6:0];
    assign funct3   = instruction[14:12];
    assign funct7   = instruction[31:25];
    assign rs1_addr = instruction[19:15];
    assign rs2_addr = instruction[24:20];
    assign rd_addr  = instruction[11:7];
    
    // Control Unit (kết nối với 2 bộ giải mã con)
    control_unit ctrl(
        .opcode(opcode), .funct3(funct3), .funct7(funct7),
        .RegWEn(RegWEn), .ALUSrc(ALUSrc), .MemRW(MemRW), 
        .MemToReg(MemToReg), .Branch(Branch), .BrUn(BrUn), 
        .Jump(Jump), .ALUOp(alu_op), .alu_control(alu_control)
    );

 
    RegisterFile Reg_inst(
        .clk(clk), .RegWEn(RegWEn), 
        .rs1_addr(rs1_addr), .rs2_addr(rs2_addr), .rd_addr(rd_addr), 
        .rd_data(write_back_data), 
        .rs1_data(rs1_data), .rs2_data(rs2_data)
    );
    
    // Imm_Gen và Branch_Comp (không thay đổi)
    Imm_Gen imm_gen(.instruction(instruction), .immediate(immediate));
    Branch_Comp branch_comp(
        .A(rs1_data), .B(rs2_data), .BrUn(BrUn), 
        .funct3(funct3), .BranchTaken(branch_taken)
    );

    assign alu_in_a = (opcode == `OPCODE_AUIPC || opcode == `OPCODE_JAL) ? pc_current : rs1_data;
    assign alu_in_b = ALUSrc ? immediate : rs2_data;
    
    // ALU
    ALU alu(.A(alu_in_a), .B(alu_in_b), .ALUControl(alu_control), .Result(alu_result));
    
    // Data Memory
    DMEM DMEM_inst(
        .clk(clk), .address(alu_result), .write_data(rs2_data), 
        .MemRW(MemRW), .read_data(mem_read_data)
    );

    assign write_back_data = MemToReg ? mem_read_data : (Jump ? pc_plus_4 : alu_result);
    
endmodule
