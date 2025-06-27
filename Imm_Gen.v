// Imm_Gen.v
// Tạo ra giá trị tức thời (immediate) 32-bit từ lệnh.

`include "defines.v"

module Imm_Gen(
    input  [31:0] instruction, // Lệnh 32-bit
    output reg [31:0] immediate   // Giá trị tức thời 32-bit sau khi mở rộng dấu
);
    // Dùng opcode để xác định định dạng của lệnh
    wire [6:0] opcode = instruction[6:0];

    // Logic tổ hợp để tạo immediate dựa trên opcode
    always @(*) begin
        case (opcode)
            // I-Type: cho các lệnh số học với immediate, lệnh load, và jalr
            `OPCODE_I_ARITH, `OPCODE_LOAD, `OPCODE_JALR:
                immediate = {{20{instruction[31]}}, instruction[31:20]}; // [cite: 54, 56]
            
            // S-Type: cho các lệnh store
            `OPCODE_S:
                immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // [cite: 54, 56]
            
            // B-Type: cho các lệnh rẽ nhánh
            `OPCODE_B:
                immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // [cite: 54, 56]
            
            // U-Type: cho các lệnh lui và auipc
            `OPCODE_LUI, `OPCODE_AUIPC:
                immediate = {instruction[31:12], 12'b0}; // 
            
            // J-Type: cho lệnh jal
            `OPCODE_JAL:
                immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // [cite: 54, 56]
            
            default:
                immediate = 32'hdeadbeef; // Giá trị không hợp lệ, giúp gỡ lỗi
        endcase
    end
endmodule