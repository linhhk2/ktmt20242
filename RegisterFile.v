module RegisterFile (
    input clk,
    input rst_n, // Tín hiệu reset
    input RegWEn,
    input [4:0] rs1_addr,
    input [4:0] rs2_addr,
    input [4:0] rd_addr,
    input [31:0] rd_data,
    output [31:0] rs1_data,
    output [31:0] rs2_data
);

    reg [31:0] registers[0:31];
    integer i;

    assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : registers[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : registers[rs2_addr];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (RegWEn && (rd_addr != 5'b0)) begin
            registers[rd_addr] <= rd_data;
        end
    end
endmodule
