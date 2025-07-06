module RegisterFile(
    input              clk,
    input              RegWEn,
    input      [4:0]   rs1_addr, rs2_addr, rd_addr,
    input      [31:0]  rd_data,
    output reg [31:0]  rs1_data, rs2_data
);
    reg [31:0] registers [0:31];

    always @(*) begin
        rs1_data = (rs1_addr == 5'd0) ? 32'b0 : registers[rs1_addr];
        rs2_data = (rs2_addr == 5'd0) ? 32'b0 : registers[rs2_addr];
    end

    always @(posedge clk)
        if (RegWEn && rd_addr != 5'd0)
            registers[rd_addr] <= rd_data;
endmodule
