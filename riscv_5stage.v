module riscv_5stage (
    input wire clk,
    input wire rst
);

reg [31:0] pc;

wire [31:0] instruction;
wire [31:0] pc_plus4;

wire [31:0] if_id_pc;
wire [31:0] if_id_pc_plus4;
wire [31:0] if_id_instruction;

wire [4:0] id_rs1;
wire [4:0] id_rs2;
wire [4:0] id_rd;

wire [31:0] read_data1;
wire [31:0] read_data2;
wire [31:0] immediate;

wire reg_write;
wire alu_src;
wire mem_read;
wire mem_write;
wire mem_to_reg;
wire branch;
wire [3:0] alu_control;

wire [31:0] id_ex_pc;
wire [31:0] id_ex_read_data1;
wire [31:0] id_ex_read_data2;
wire [31:0] id_ex_immediate;
wire [4:0] id_ex_rs1;
wire [4:0] id_ex_rs2;
wire [4:0] id_ex_rd;
wire id_ex_reg_write;
wire id_ex_alu_src;
wire id_ex_mem_read;
wire id_ex_mem_write;
wire id_ex_mem_to_reg;
wire id_ex_branch;
wire [3:0] id_ex_alu_control;

wire [1:0] forward_a;
wire [1:0] forward_b;

reg [31:0] alu_input_a;
reg [31:0] alu_input_b_reg;
wire [31:0] alu_input_b;
wire [31:0] alu_result;
wire alu_zero;

wire [31:0] ex_mem_alu_result;
wire [31:0] ex_mem_write_data;
wire [31:0] ex_mem_branch_target;
wire ex_mem_zero;
wire [4:0] ex_mem_rd;
wire ex_mem_reg_write;
wire ex_mem_mem_read;
wire ex_mem_mem_write;
wire ex_mem_mem_to_reg;
wire ex_mem_branch;

wire [31:0] data_read;

wire [31:0] mem_wb_read_data;
wire [31:0] mem_wb_alu_result;
wire [4:0] mem_wb_rd;
wire mem_wb_reg_write;
wire mem_wb_mem_to_reg;

wire [31:0] write_back_data;

wire pc_write;
wire if_id_write;
wire control_stall;

assign pc_plus4 = pc + 32'd4;

assign id_rs1 = if_id_instruction[19:15];
assign id_rs2 = if_id_instruction[24:20];
assign id_rd = if_id_instruction[11:7];

assign alu_input_b = id_ex_alu_src ? id_ex_immediate : alu_input_b_reg;

assign write_back_data = mem_wb_mem_to_reg ? mem_wb_read_data : mem_wb_alu_result;

always @(*) begin
    case (forward_a)
        2'b10: alu_input_a = ex_mem_alu_result;
        2'b01: alu_input_a = write_back_data;
        default: alu_input_a = id_ex_read_data1;
    endcase
end

always @(*) begin
    case (forward_b)
        2'b10: alu_input_b_reg = ex_mem_alu_result;
        2'b01: alu_input_b_reg = write_back_data;
        default: alu_input_b_reg = id_ex_read_data2;
    endcase
end

always @(posedge clk) begin
    if (rst)
        pc <= 32'b0;
    else if (pc_write) begin
        if (ex_mem_branch && ex_mem_zero)
            pc <= ex_mem_branch_target;
        else
            pc <= pc_plus4;
    end
end

instruction_memory u_instruction_memory (
    .pc(pc),
    .instruction(instruction)
);

if_id u_if_id (
    .clk(clk),
    .rst(rst),
    .pc_in(pc),
    .pc_plus4_in(pc_plus4),
    .instruction_in(instruction),
    .pc_out(if_id_pc),
    .pc_plus4_out(if_id_pc_plus4),
    .instruction_out(if_id_instruction)
);

register_file u_register_file (
    .clk(clk),
    .rst(rst),
    .reg_write(mem_wb_reg_write),
    .rs1(id_rs1),
    .rs2(id_rs2),
    .rd(mem_wb_rd),
    .write_data(write_back_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

immediate_generator u_immediate_generator (
    .instruction(if_id_instruction),
    .immediate(immediate)
);

control_unit u_control_unit (
    .opcode(if_id_instruction[6:0]),
    .funct3(if_id_instruction[14:12]),
    .funct7(if_id_instruction[31:25]),
    .reg_write(reg_write),
    .alu_src(alu_src),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .branch(branch),
    .alu_control(alu_control)
);

hazard_detection u_hazard_detection (
    .id_ex_rd(id_ex_rd),
    .id_ex_mem_read(id_ex_mem_read),
    .if_id_rs1(id_rs1),
    .if_id_rs2(id_rs2),
    .pc_write(pc_write),
    .if_id_write(if_id_write),
    .control_stall(control_stall)
);

id_ex u_id_ex (
    .clk(clk),
    .rst(rst),
    .pc_in(if_id_pc),
    .read_data1_in(read_data1),
    .read_data2_in(read_data2),
    .immediate_in(immediate),
    .rs1_in(id_rs1),
    .rs2_in(id_rs2),
    .rd_in(id_rd),
    .reg_write_in(control_stall ? 1'b0 : reg_write),
    .alu_src_in(control_stall ? 1'b0 : alu_src),
    .mem_read_in(control_stall ? 1'b0 : mem_read),
    .mem_write_in(control_stall ? 1'b0 : mem_write),
    .mem_to_reg_in(control_stall ? 1'b0 : mem_to_reg),
    .branch_in(control_stall ? 1'b0 : branch),
    .alu_control_in(control_stall ? 4'b0000 : alu_control),
    .pc_out(id_ex_pc),
    .read_data1_out(id_ex_read_data1),
    .read_data2_out(id_ex_read_data2),
    .immediate_out(id_ex_immediate),
    .rs1_out(id_ex_rs1),
    .rs2_out(id_ex_rs2),
    .rd_out(id_ex_rd),
    .reg_write_out(id_ex_reg_write),
    .alu_src_out(id_ex_alu_src),
    .mem_read_out(id_ex_mem_read),
    .mem_write_out(id_ex_mem_write),
    .mem_to_reg_out(id_ex_mem_to_reg),
    .branch_out(id_ex_branch),
    .alu_control_out(id_ex_alu_control)
);

forwarding_unit u_forwarding_unit (
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .ex_mem_rd(ex_mem_rd),
    .mem_wb_rd(mem_wb_rd),
    .ex_mem_reg_write(ex_mem_reg_write),
    .mem_wb_reg_write(mem_wb_reg_write),
    .forward_a(forward_a),
    .forward_b(forward_b)
);

alu u_alu (
    .a(alu_input_a),
    .b(alu_input_b),
    .alu_control(id_ex_alu_control),
    .result(alu_result),
    .zero(alu_zero)
);

ex_mem u_ex_mem (
    .clk(clk),
    .rst(rst),
    .alu_result_in(alu_result),
    .write_data_in(alu_input_b_reg),
    .branch_target_in(id_ex_pc + id_ex_immediate),
    .zero_in(alu_zero),
    .rd_in(id_ex_rd),
    .reg_write_in(id_ex_reg_write),
    .mem_read_in(id_ex_mem_read),
    .mem_write_in(id_ex_mem_write),
    .mem_to_reg_in(id_ex_mem_to_reg),
    .branch_in(id_ex_branch),
    .alu_result_out(ex_mem_alu_result),
    .write_data_out(ex_mem_write_data),
    .branch_target_out(ex_mem_branch_target),
    .zero_out(ex_mem_zero),
    .rd_out(ex_mem_rd),
    .reg_write_out(ex_mem_reg_write),
    .mem_read_out(ex_mem_mem_read),
    .mem_write_out(ex_mem_mem_write),
    .mem_to_reg_out(ex_mem_mem_to_reg),
    .branch_out(ex_mem_branch)
);

data_memory u_data_memory (
    .clk(clk),
    .mem_read(ex_mem_mem_read),
    .mem_write(ex_mem_mem_write),
    .address(ex_mem_alu_result),
    .write_data(ex_mem_write_data),
    .read_data(data_read)
);

mem_wb u_mem_wb (
    .clk(clk),
    .rst(rst),
    .read_data_in(data_read),
    .alu_result_in(ex_mem_alu_result),
    .rd_in(ex_mem_rd),
    .reg_write_in(ex_mem_reg_write),
    .mem_to_reg_in(ex_mem_mem_to_reg),
    .read_data_out(mem_wb_read_data),
    .alu_result_out(mem_wb_alu_result),
    .rd_out(mem_wb_rd),
    .reg_write_out(mem_wb_reg_write),
    .mem_to_reg_out(mem_wb_mem_to_reg)
);

endmodule