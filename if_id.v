module if_id (
    input wire clk,
    input wire rst,
    input wire [31:0] pc_in,
    input wire [31:0] pc_plus4_in,
    input wire [31:0] instruction_in,
    output reg [31:0] pc_out,
    output reg [31:0] pc_plus4_out,
    output reg [31:0] instruction_out
);

always @(posedge clk) begin
    if (rst) begin
        pc_out <= 32'b0;
        pc_plus4_out <= 32'b0;
        instruction_out <= 32'b0;
    end
    else begin
        pc_out <= pc_in;
        pc_plus4_out <= pc_plus4_in;
        instruction_out <= instruction_in;
    end
end

endmodule