// DMEM.v
// Mô phỏng bộ nhớ dữ liệu (Data Memory).

module DMEM(
    input         clk,
    input  [31:0] address,     // Địa chỉ truy cập bộ nhớ
    input  [31:0] write_data,  // Dữ liệu cần ghi
    input         MemRW,       // Tín hiệu điều khiển: 1 = Ghi (Write), 0 = Đọc (Read)
    output reg [31:0] read_data // Dữ liệu đọc ra
);

    // Khai báo một mảng các thanh ghi để mô phỏng bộ nhớ 4KB
    // (1024 phần tử, mỗi phần tử 32-bit)
    reg [31:0] memory [0:1023];

    // Logic đọc (tổ hợp/bất đồng bộ)
    // Luôn xuất dữ liệu tại địa chỉ được yêu cầu.
    // Chúng ta dùng address[11:2] vì địa chỉ là word-aligned (chia cho 4).
    always @(*) begin
        read_data = memory[address[11:2]];
    end

    // Logic ghi (tuần tự/đồng bộ)
    // Chỉ ghi dữ liệu vào bộ nhớ tại sườn lên của clock nếu MemRW=1.
    always @(posedge clk) begin
        if (MemRW) begin
            memory[address[11:2]] <= write_data;
        end
    end

endmodule