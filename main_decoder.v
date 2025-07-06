`include "defines.v"

module main_decoder(
    input  [6:0] opcode,
    input  [2:0] funct3,
    output reg   RegWEn,
    output reg   ALUSrc,
    output reg   MemRW,
    output reg   MemToReg,
    output reg   Branch,
    output reg   BrUn,
    output reg   Jump,
    output reg [1:0] ALUOp
);

    always @(*) begin
        // Giá trị mặc định
        RegWEn = 1'b0; ALUSrc = 1'b0; MemRW = 1'b0; MemToReg = 1'b0;
        Branch = 1'b0; BrUn = 1'b0; Jump = 1'b0; ALUOp = 2'bxx;

        case (opcode)
            `OPCODE_R: begin
                RegWEn = 1'b1;
                ALUOp = 2'b00; // Dùng '00' cho R-Type
            end
            `OPCODE_I_ARITH: begin
                RegWEn = 1'b1; ALUSrc = 1'b1;
                ALUOp = 2'b10; // Dùng '10' cho I-Type
            end
            `OPCODE_LOAD: begin
                RegWEn = 1'b1; ALUSrc = 1'b1; MemToReg = 1'b1;
                ALUOp = 2'b01; // Dùng '01' cho tính toán địa chỉ
            end
            `OPCODE_S: begin
                ALUSrc = 1'b1; MemRW = 1'b1;
                ALUOp = 2'b01; // Dùng '01' cho tính toán địa chỉ
            end
            `OPCODE_B: begin
                Branch = 1'b1;
                ALUOp = 2'b11; // Dùng '11' riêng cho Branch
                if (funct3 == `FUNCT3_BLTU || funct3 == `FUNCT3_BGEU) begin
                    BrUn = 1'b1;
                end
            end
            `OPCODE_LUI: begin
                RegWEn = 1'b1; ALUSrc = 1'b1;
                ALUOp = 2'b01; // Dùng '01' để ALU luôn thực hiện phép ADD
            end
            `OPCODE_AUIPC: begin
                RegWEn = 1'b1; ALUSrc = 1'b1;
                ALUOp = 2'b01; // Dùng '01' để ALU luôn thực hiện phép ADD
            end
            `OPCODE_JAL: begin
                RegWEn = 1'b1; Jump = 1'b1; ALUSrc = 1'b1;
                ALUOp = 2'b01; // Dùng '01' để ALU luôn thực hiện phép ADD
            end
            `OPCODE_JALR: begin
                RegWEn = 1'b1; Jump = 1'b1; ALUSrc = 1'b1;
                ALUOp = 2'b01; // Dùng '01' để ALU luôn thực hiện phép ADD
            end
        endcase
    end
endmodule
