// --- File: DMEM.v ---
module DMEM(
    input         clk,
    input  [31:0] address,
    input  [31:0] write_data,
    input         MemRW,
    output reg [31:0] read_data
);
    reg [31:0] memory [0:1023];

    // zero‑init bộ nhớ dữ liệu
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1)
            memory[i] = 32'b0;
    end

    // đọc bất đồng bộ
    always @(*) read_data = memory[address[11:2]];

    // ghi đồng bộ
    always @(posedge clk)
        if (MemRW) memory[address[11:2]] <= write_data;
endmodule
