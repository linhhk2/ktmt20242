// --- File: Imm_Gen.v ---
`include "defines.v"

module Imm_Gen(
    input  [31:0] instruction,
    output reg [31:0] immediate
);
    wire [6:0] opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            `OPCODE_I_ARITH, `OPCODE_LOAD, `OPCODE_JALR:
                immediate = {{21{instruction[31]}}, instruction[30:20]};
            `OPCODE_S:
                immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            `OPCODE_B:
                immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            `OPCODE_LUI, `OPCODE_AUIPC:
                immediate = {instruction[31:12], 12'b0};
            `OPCODE_JAL:
                immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            default:
                immediate = 32'b0;
        endcase
    end
endmodule
