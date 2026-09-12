module instruction_memory (
    input wire [31:0] pc,
    output wire [31:0] instruction
);

reg [31:0] memory [0:255];

initial begin
    memory[0] = 32'h00500093;
    memory[1] = 32'h00A00113;
    memory[2] = 32'h002081B3;
    memory[3] = 32'h00310233;
    memory[4] = 32'h004182B3;
    memory[5] = 32'h00520333;
    memory[6] = 32'h006283B3;
    memory[7] = 32'h00730433;
end

assign instruction = memory[pc[9:2]];

endmodule