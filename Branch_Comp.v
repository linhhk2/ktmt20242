// --- File: Branch_Comp.v ---
`include "defines.v"

module Branch_Comp(
    input [31:0] A,
    input [31:0] B,
    input        BrUn,
    input [2:0]  funct3,
    output reg   BranchTaken
);
    always @(*) begin
        case (funct3)
            `FUNCT3_BEQ:  BranchTaken = (A == B);
            `FUNCT3_BNE:  BranchTaken = (A != B);
            `FUNCT3_BLT:  BranchTaken = ($signed(A) < $signed(B));
            `FUNCT3_BGE:  BranchTaken = ($signed(A) >= $signed(B));
            `FUNCT3_BLTU: BranchTaken = (A < B);
            `FUNCT3_BGEU: BranchTaken = (A >= B);
            default:      BranchTaken = 1'b0;
        endcase
    end
endmodule
