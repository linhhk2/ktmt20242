`include "defines.v"

module ALU_decoder(
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input  [6:0] funct7, 
    output reg [3:0] alu_control
);

    // Dây nội bộ để trích xuất bit quan trọng
    wire funct7b5 = funct7[5];

    always @(*) begin
        case(ALUOp)
            2'b00: // R-Type
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
            2'b01: 
                alu_control = `ALU_ADD;
            2'b10: // I-Type
                case(funct3)
                    `FUNCT3_ADDI:    alu_control = `ALU_ADD;
                    `FUNCT3_SLTI:    alu_control = `ALU_SLT;
                    `FUNCT3_SLTIU:   alu_control = `ALU_SLTU;
                    `FUNCT3_XORI:    alu_control = `ALU_XOR;
                    `FUNCT3_ORI:     alu_control = `ALU_OR;
                    `FUNCT3_ANDI:    alu_control = `ALU_AND;
                    `FUNCT3_SLLI:    alu_control = `ALU_SLL;
                    `FUNCT3_SRLI_SRAI: alu_control = (funct7[5]) ? `ALU_SRA : `ALU_SRL; 
                    default:         alu_control = 4'hX;
                endcase
            2'b11: // Cho branches
                alu_control = `ALU_SUB;
            default: alu_control = 4'hX;
        endcase
    end
endmodule
