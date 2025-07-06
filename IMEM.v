// --- File: IMEM.v ---
module IMEM(
    input  [31:0] address,
    output reg [31:0] instruction
);
    reg [31:0] memory [0:1023];

    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1)
            memory[i] = 32'b0;

        string path;
        if (!$value$plusargs("memfile=%s", path))
            path = "program.hex";      // tên mặc định
        $display("[IMEM] loading %s", path);
        $readmemh(path, memory);
    end

    always @(*) instruction = memory[address[11:2]];
endmodule
