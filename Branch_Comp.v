// Branch_Comp.v
`include "defines.v"

module Branch_Comp(
    input [31:0] A, B,
    input [2:0]  funct3,
    output reg   BranchTaken
);
    wire eq    = (A == B);
    wire neq   = (A != B);
    wire lt_s  = ($signed(A) < $signed(B));
    wire gte_s = ($signed(A) >= $signed(B));
    wire lt_u  = (A < B);
    wire gte_u = (A >= B);

    always @(*) begin
        case (funct3)
            `FUNCT3_BEQ:  BranchTaken = eq;
            `FUNCT3_BNE:  BranchTaken = neq;
            `FUNCT3_BLT:  BranchTaken = lt_s;
            `FUNCT3_BGE:  BranchTaken = gte_s;
            `FUNCT3_BLTU: BranchTaken = lt_u;
            `FUNCT3_BGEU: BranchTaken = gte_u;
            default:      BranchTaken = 1'b0;
        endcase
    end
endmodule