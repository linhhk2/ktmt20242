// control_unit.v
module control_unit(
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [6:0] funct7,
    // Outputs from main_decoder
    output       RegWEn,
    output       ALUSrc,
    output       MemRW,
    output       MemToReg,
    output       Branch,
    output       Jump,
    // Output from ALU_decoder
    output [3:0] alu_control
);
    wire [1:0] alu_op;

    main_decoder md(
        .opcode(opcode),
        .RegWEn(RegWEn),
        .ALUSrc(ALUSrc),
        .MemRW(MemRW),
        .MemToReg(MemToReg),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(alu_op)
    );

    ALU_decoder ad(
        .funct7(funct7),
        .funct3(funct3),
        .ALUOp(alu_op),
        .alu_control(alu_control)
    );
endmodule