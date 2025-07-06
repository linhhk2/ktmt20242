// --- File: RegisterFile.v ---
module RegisterFile(
    input         clk,
    input         RegWEn,
    input  [4:0]  rs1_addr,
    input  [4:0]  rs2_addr,
    input  [4:0]  rd_addr,
    input  [31:0] rd_data,
    output [31:0] rs1_data,
    output [31:0] rs2_data
);
    reg [31:0] registers [31:0];

    assign rs1_data = (rs1_addr == 5'b0) ? 32'd0 : registers[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 32'd0 : registers[rs2_addr];

    always @(posedge clk) begin
        if (RegWEn && (rd_addr != 5'b0)) begin
            registers[rd_addr] <= rd_data;
        end
    end
endmodule
