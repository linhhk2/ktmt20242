// ALU_decoder.v
// Tạo tín hiệu 4-bit cụ thể cho ALU.

`include "defines.v"

module ALU_decoder(
    input [6:0] funct7,
    input [2:0] funct3,
    input [1:0] ALUOp,
    output reg [3:0] alu_control
);
    always @(*) begin
        case (ALUOp)
            // Dành cho các lệnh R-Type
            2'b00:
                case (funct3)
                    `FUNCT3_ADD_SUB: alu_control = (funct7 == `FUNCT7_SUB) ? `ALU_SUB : `ALU_ADD;
                    `FUNCT3_SLL:     alu_control = `ALU_SLL;
                    `FUNCT3_SLT:     alu_control = `ALU_SLT;
                    `FUNCT3_SLTU:    alu_control = `ALU_SLTU;
                    `FUNCT3_XOR:     alu_control = `ALU_XOR;
                    `FUNCT3_SRL_SRA: alu_control = (funct7 == `FUNCT7_SRA) ? `ALU_SRA : `ALU_SRL;
                    `FUNCT3_OR:      alu_control = `ALU_OR;
                    `FUNCT3_AND:     alu_control = `ALU_AND;
                    default:         alu_control = 4'bxxxx;
                endcase

            // Dành cho lw, sw, auipc, jal, jalr
            2'b01:
                alu_control = `ALU_ADD;

            // Dành cho các lệnh I-Type (số học)
            2'b10:
                case (funct3)
                    `FUNCT3_ADDI:       alu_control = `ALU_ADD;
                    `FUNCT3_SLTI:      alu_control = `ALU_SLT;
                    `FUNCT3_SLTIU:     alu_control = `ALU_SLTU;
                    `FUNCT3_XORI:      alu_control = `ALU_XOR;
                    `FUNCT3_ORI:       alu_control = `ALU_OR;
                    `FUNCT3_ANDI:      alu_control = `ALU_AND;
                    `FUNCT3_SLLI:      alu_control = `ALU_SLL;
                    // Dòng 35 của bạn bây giờ sẽ khớp với defines.v
                    `FUNCT3_SRLI_SRAI: alu_control = (funct7 == `FUNCT7_SRA) ? `ALU_SRA : `ALU_SRL; // SRAI cần kiểm tra funct7
                    default:           alu_control = 4'bxxxx;
                endcase

            // Dành cho các lệnh Branch
            2'b11:
                alu_control = 4'bxxxx; // Không dùng

            default: alu_control = 4'bxxxx;
        endcase
    end
endmodule