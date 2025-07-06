`include "defines.v"

module ALU_decoder(
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output reg [3:0] alu_control
);

    wire funct7b5 = funct7[5];

    always @(*) begin
        case(ALUOp)
            // ALUOp '00' dành riêng cho các lệnh R-type
            2'b00:
                case(funct3)
                    `FUNCT3_ADD_SUB: alu_control = (funct7b5) ? `ALU_SUB : `ALU_ADD;
                    `FUNCT3_SLL:     alu_control = `ALU_SLL;
                    `FUNCT3_SLT:     alu_control = `ALU_SLT;
                    `FUNCT3_SLTU:    alu_control = `ALU_SLTU;
                    `FUNCT3_XOR:     alu_control = `ALU_XOR;
                    `FUNCT3_SRL_SRA: alu_control = (funct7b5) ? `ALU_SRA : `ALU_SRL;
                    `FUNCT3_OR:      alu_control = `ALU_OR;
                    `FUNCT3_AND:     alu_control = `ALU_AND;
                    default:         alu_control = 4'hX;
                endcase

            // ALUOp '01' CHỈ CÓ NGHĨA LÀ PHÉP CỘNG
            // Dùng cho LOAD, STORE, LUI, AUIPC, JAL, JALR
            2'b01:
                alu_control = `ALU_ADD;

            // ALUOp '10' dành riêng cho các lệnh I-type số học
            2'b10:
                case(funct3)
                    `FUNCT3_ADDI:    alu_control = `ALU_ADD;
                    `FUNCT3_SLTI:    alu_control = `ALU_SLT;
                    `FUNCT3_SLTIU:   alu_control = `ALU_SLTU;
                    `FUNCT3_XORI:    alu_control = `ALU_XOR;
                    `FUNCT3_ORI:     alu_control = `ALU_OR;
                    `FUNCT3_ANDI:    alu_control = `ALU_AND;
                    `FUNCT3_SLLI:    alu_control = `ALU_SLL;
                    `FUNCT3_SRLI_SRAI: alu_control = (funct7b5) ? `ALU_SRA : `ALU_SRL;
                    default:         alu_control = 4'hX;
                endcase

            // ALUOp '11' CHỈ CÓ NGHĨA LÀ PHÉP TRỪ
            // Dùng riêng cho BRANCH để so sánh
            2'b11:
                alu_control = `ALU_SUB;
                
            default: alu_control = 4'hX;
        endcase
    end
endmodule
