// Program_Counter.v
module Program_Counter(
    input clk, reset,
    input  [31:0] pc_in,
    output reg [31:0] pc_out
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_out <= 32'h00000000;
        else
            pc_out <= pc_in;
    end
endmodule