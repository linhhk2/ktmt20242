// defines.v
// File định nghĩa hằng số cho bộ xử lý RISC-V RV32I.
// Tất cả các giá trị được lấy từ tài liệu tham khảo RISC-V.

//================================================================
// 1. OPCODES (Dựa trên trường opcode [6:0] của lệnh) [cite: 1, 4]
//================================================================
`define OPCODE_LUI      7'b0110111  // U-Type: Load Upper Immediate
`define OPCODE_AUIPC    7'b0010111  // U-Type: Add Upper Immediate to PC
`define OPCODE_JAL      7'b1101111  // J-Type: Jump and Link
`define OPCODE_JALR     7'b1100111  // I-Type: Jump and Link Register
`define OPCODE_B        7'b1100011  // B-Type: Branch instructions (beq, bne, etc.)
`define OPCODE_LOAD     7'b0000011  // I-Type: Load instructions (lw, lh, etc.)
`define OPCODE_S        7'b0100011  // S-Type: Store instructions (sw, sh, etc.)
`define OPCODE_I_ARITH  7'b0010011  // I-Type: Arithmetic immediate instructions (addi, slti, etc.)
`define OPCODE_R        7'b0110011  // R-Type: Register-register arithmetic instructions (add, sub, etc.)
`define OPCODE_SYSTEM   7'b1110011  // I-Type: For ecall, ebreak

//================================================================
// 2. FUNCT3 CODES (Dựa trên trường funct3 [14:12] của lệnh)
//================================================================

// --- Funct3 cho lệnh Branch (khi opcode = `OPCODE_B) [cite: 4] ---
`define FUNCT3_BEQ      3'b000
`define FUNCT3_BNE      3'b001
`define FUNCT3_BLT      3'b100
`define FUNCT3_BGE      3'b101
`define FUNCT3_BLTU     3'b110
`define FUNCT3_BGEU     3'b111

// --- Funct3 cho lệnh Load (khi opcode = `OPCODE_LOAD) [cite: 1] ---
`define FUNCT3_LB       3'b000
`define FUNCT3_LH       3'b001
`define FUNCT3_LW       3'b010
`define FUNCT3_LBU      3'b100
`define FUNCT3_LHU      3'b101

// --- Funct3 cho lệnh Store (khi opcode = `OPCODE_S) [cite: 1] ---
`define FUNCT3_SB       3'b000
`define FUNCT3_SH       3'b001
`define FUNCT3_SW       3'b010

// --- Funct3 cho lệnh I-Type Arithmetic (khi opcode = `OPCODE_I_ARITH) [cite: 1] ---
`define FUNCT3_ADDI     3'b000
`define FUNCT3_SLTI     3'b010
`define FUNCT3_SLTIU    3'b011
`define FUNCT3_XORI     3'b100
`define FUNCT3_ORI      3'b110
`define FUNCT3_ANDI     3'b111
`define FUNCT3_SLLI     3'b001
`define FUNCT3_SRLI_SRAI 3'b101 // Funct3 chung cho srli và srai

// --- Funct3 cho lệnh R-Type (khi opcode = `OPCODE_R) [cite: 1] ---
`define FUNCT3_ADD_SUB  3'b000 // Funct3 chung cho add và sub
`define FUNCT3_SLL      3'b001
`define FUNCT3_SLT      3'b010
`define FUNCT3_SLTU     3'b011
`define FUNCT3_XOR      3'b100
`define FUNCT3_SRL_SRA  3'b101 // Funct3 chung cho srl và sra
`define FUNCT3_OR       3'b110
`define FUNCT3_AND      3'b111

//================================================================
// 3. FUNCT7 CODES (Dựa trên trường funct7 [31:25] của lệnh) [cite: 1]
//================================================================
// Chỉ cần thiết khi funct3 không đủ để phân biệt lệnh

`define FUNCT7_ADD      7'b0000000
`define FUNCT7_SUB      7'b0100000

`define FUNCT7_SRL      7'b0000000
`define FUNCT7_SRA      7'b0100000

//================================================================
// 4. ALU INTERNAL OPERATION CODES
//================================================================
// Đây là các mã nội bộ do chúng ta tự định nghĩa để điều khiển ALU.
// Chúng không phải là một phần của chuẩn RISC-V.

`define ALU_ADD     4'b0000
`define ALU_SUB     4'b0001
`define ALU_SLL     4'b0010
`define ALU_SLT     4'b0011
`define ALU_SLTU    4'b0100
`define ALU_XOR     4'b0101
`define ALU_SRL     4'b0110
`define ALU_SRA     4'b0111
`define ALU_OR      4'b1000
`define ALU_AND     4'b1001