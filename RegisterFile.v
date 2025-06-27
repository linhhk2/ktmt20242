// RegisterFile.v
// Mô phỏng tệp thanh ghi (32 thanh ghi, mỗi thanh ghi 32-bit).

module RegisterFile(
    input         clk,
    input         RegWEn,      // Tín hiệu cho phép ghi vào thanh ghi
    input  [4:0]  rs1_addr,    // Địa chỉ thanh ghi nguồn 1
    input  [4:0]  rs2_addr,    // Địa chỉ thanh ghi nguồn 2
    input  [4:0]  rd_addr,     // Địa chỉ thanh ghi đích
    input  [31:0] rd_data,     // Dữ liệu để ghi vào thanh ghi đích
    output [31:0] rs1_data,    // Dữ liệu đọc từ rs1
    output [31:0] rs2_data     // Dữ liệu đọc từ rs2
);

    // Mảng 32 thanh ghi, mỗi thanh ghi 32-bit
    reg [31:0] registers [31:0];

    // Logic đọc (tổ hợp/bất đồng bộ)
    // Nếu địa chỉ là x0 (5'b0), trả về 0. Ngược lại, trả về giá trị của thanh ghi.
    assign rs1_data = (rs1_addr == 5'b0) ? 32'd0 : registers[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 32'd0 : registers[rs2_addr];

    // Logic ghi (tuần tự/đồng bộ)
    // Ghi dữ liệu vào thanh ghi đích tại sườn lên của clock.
    always @(posedge clk) begin
        // Chỉ ghi khi RegWEn=1 và địa chỉ đích không phải là x0.
        if (RegWEn && (rd_addr != 5'b0)) begin
            registers[rd_addr] <= rd_data;
        end
    end

endmodule