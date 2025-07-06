`include "defines.v"

module Branch_Comp(
    input [31:0] A,
    input [31:0] B,
    input        BrUn, 
    input [2:0]  funct3,
    output reg   BranchTaken
);

    wire slt = BrUn ? (A < B) : ($signed(A) < $signed(B));
    wire eq  = (A == B);

    always @(*) begin
        case (funct3)
            `FUNCT3_BEQ:  BranchTaken = eq;
            `FUNCT3_BNE:  BranchTaken = !eq;
            `FUNCT3_BLT:  BranchTaken = slt;
            `FUNCT3_BGE:  BranchTaken = !slt;
            `FUNCT3_BLTU: BranchTaken = slt;
            `FUNCT3_BGEU: BranchTaken = !slt;
            default:      BranchTaken = 1'b0;
        endcase
    end
endmodule
