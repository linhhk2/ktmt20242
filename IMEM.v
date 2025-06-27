// IMEM.v
// Mô phỏng bộ nhớ lệnh (Instruction Memory).

module IMEM(
    input  [31:0] address,       // Địa chỉ của lệnh cần nạp (từ PC)
    output reg [31:0] instruction  // Lệnh được đọc ra
);
    // Khai báo bộ nhớ lệnh, cũng có kích thước 4KB
    reg [31:0] memory [0:1023];

    // Khối initial được thực thi một lần khi bắt đầu mô phỏng
    // để nạp mã máy từ file program.hex vào bộ nhớ.
    initial begin
        $readmemh("program.hex", memory);
    end

    // Logic đọc lệnh (tổ hợp/bất đồng bộ)
    // Luôn xuất ra lệnh tại địa chỉ mà PC trỏ tới.
    always @(*) begin
        instruction = memory[address[11:2]];
    end

endmodule