// --- File: ALU.v ---
`include "defines.v"

module ALU(
    input  [31:0] A,
    input  [31:0] B,
    input  [3:0]  ALUControl,
    output reg [31:0] Result
);
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
            default:   Result = 32'hdeadbeef;
        endcase
    end
endmodule
