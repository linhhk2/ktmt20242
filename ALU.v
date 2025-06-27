// ALU.v
// Thực hiện các phép toán số học và logic.

`include "defines.v"

module ALU(
    input  [31:0] A,             // Toán hạng A
    input  [31:0] B,             // Toán hạng B
    input  [3:0]  ALUControl,    // Tín hiệu điều khiển 4-bit để chọn phép toán
    output reg [31:0] Result,    // Kết quả phép toán
    output        Zero           // Cờ Zero, bật lên 1 nếu kết quả bằng 0
);

    // Logic tổ hợp để thực hiện phép toán dựa trên ALUControl
    always @(*) begin
        case (ALUControl)
            `ALU_ADD:  Result = A + B;
            `ALU_SUB:  Result = A - B;
            `ALU_SLL:  Result = A << B[4:0];
            `ALU_SLT:  Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
            `ALU_SLTU: Result = (A < B) ? 32'd1 : 32'd0;
            `ALU_XOR:  Result = A ^ B;
            `ALU_SRL:  Result = A >> B[4:0];
            `ALU_SRA:  Result = $signed(A) >>> B[4:0];
            `ALU_OR:   Result = A | B;
            `ALU_AND:  Result = A & B;
            default:   Result = 32'hdeadbeef; // Giá trị không hợp lệ, giúp gỡ lỗi
        endcase
    end

    // Gán cờ Zero nếu kết quả của phép toán là 0
    assign Zero = (Result == 32'd0);

endmodule