// main_decoder.v
`include "defines.v"

module main_decoder(
    input  [6:0] opcode,
    output reg   RegWEn,      // Ghi vào thanh ghi?
    output reg   ALUSrc,      // Toán hạng B của ALU là immediate?
    output reg   MemRW,       // Ghi vào bộ nhớ dữ liệu?
    output reg   MemToReg,    // Dữ liệu ghi về thanh ghi lấy từ mem?
    output reg   Branch,      // Là lệnh rẽ nhánh?
    output reg   Jump,        // Là lệnh nhảy (JAL/JALR)?
    output reg [1:0] ALUOp     // Loại phép toán cho ALU_decoder
);
    always @(*) begin
        // Giá trị mặc định
        RegWEn = 1'b0; ALUSrc = 1'b0; MemRW = 1'b0; MemToReg = 1'b0;
        Branch = 1'b0; Jump = 1'b0; ALUOp = 2'bxx;

        case (opcode)
            `OPCODE_R: begin
                RegWEn = 1'b1; ALUOp = 2'b00; // R-type
            end
            `OPCODE_I_ARITH: begin
                RegWEn = 1'b1; ALUSrc = 1'b1; ALUOp = 2'b10; // I-type
            end
            `OPCODE_LOAD: begin
                RegWEn = 1'b1; ALUSrc = 1'b1; MemToReg = 1'b1; ALUOp = 2'b01; // Load
            end
            `OPCODE_S: begin
                ALUSrc = 1'b1; MemRW = 1'b1; ALUOp = 2'b01; // Store
            end
            `OPCODE_B: begin
                Branch = 1'b1; ALUOp = 2'b11; // Branch
            end
            `OPCODE_LUI: begin
                RegWEn = 1'b1; ALUSrc = 1'b1; ALUOp = 2'b10;
            end
            `OPCODE_AUIPC: begin
                RegWEn = 1'b1; ALUSrc = 1'b1; ALUOp = 2'b01;
            end
            `OPCODE_JAL: begin
                RegWEn = 1'b1; Jump = 1'b1; ALUOp = 2'b01;
            end
            `OPCODE_JALR: begin
                RegWEn = 1'b1; Jump = 1'b1; ALUSrc = 1'b1; ALUOp = 2'b01;
            end
        endcase
    end
endmodule