module cpu (
    input wire clk,
    input wire reset,
    output wire [7:0] bus_value,
    output wire [2:0] t_state,
    output wire halted,
    output wire [3:0] opcode,
    output wire [3:0] operand,
    output wire [3:0] pc_value,
    output wire [3:0] mar_value,
    output wire [7:0] ir_value,
    output wire [7:0] a_value,
    output wire [7:0] b_value,
    output wire [7:0] mem_value,
    output wire [7:0] alu_value,
    output wire co,
    output wire ce,
    output wire mi,
    output wire ro,
    output wire ri,
    output wire ii,
    output wire io,
    output wire ai,
    output wire ao,
    output wire bi,
    output wire eo,
    output wire su,
    output wire mu,
    output wire du,
    output wire hlt
);
    wire [7:0] bus_internal;
    wire [7:0] ir_internal;
    wire [7:0] a_internal;
    wire [7:0] b_internal;
    wire [7:0] mem_internal;
    wire [7:0] alu_internal;
    wire [3:0] pc_internal;
    wire [3:0] mar_internal;

    assign opcode = ir_internal[7:4];
    assign operand = ir_internal[3:0];

    control_unit u_control_unit (
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .co(co),
        .ce(ce),
        .mi(mi),
        .ro(ro),
        .ri(ri),
        .ii(ii),
        .io(io),
        .ai(ai),
        .ao(ao),
        .bi(bi),
        .eo(eo),
        .su(su),
        .mu(mu),
        .du(du),
        .hlt(hlt),
        .t_state(t_state),
        .halted(halted)
    );

    program_counter u_program_counter (
        .clk(clk),
        .reset(reset),
        .increment(ce),
        .pc_value(pc_internal)
    );

    register #(.WIDTH(4)) u_mar (
        .clk(clk),
        .reset(reset),
        .load(mi),
        .data_in(bus_internal[3:0]),
        .data_out(mar_internal)
    );

    register #(.WIDTH(8)) u_ir (
        .clk(clk),
        .reset(reset),
        .load(ii),
        .data_in(bus_internal),
        .data_out(ir_internal)
    );

    register #(.WIDTH(8)) u_a (
        .clk(clk),
        .reset(reset),
        .load(ai),
        .data_in(bus_internal),
        .data_out(a_internal)
    );

    register #(.WIDTH(8)) u_b (
        .clk(clk),
        .reset(reset),
        .load(bi),
        .data_in(bus_internal),
        .data_out(b_internal)
    );

    alu u_alu (
        .a_value(a_internal),
        .b_value(b_internal),
        .subtract(su),
        .multiply(mu),
        .divide(du),
        .result(alu_internal)
    );

    memory u_memory (
        .clk(clk),
        .write_en(ri),
        .address(mar_internal),
        .data_in(bus_internal),
        .data_out(mem_internal)
    );

    bus u_bus (
        .co(co),
        .ro(ro),
        .io(io),
        .ao(ao),
        .eo(eo),
        .pc_value(pc_internal),
        .mem_value(mem_internal),
        .ir_address(operand),
        .a_value(a_internal),
        .alu_value(alu_internal),
        .bus_value(bus_internal)
    );

    assign bus_value = bus_internal;
    assign pc_value = pc_internal;
    assign mar_value = mar_internal;
    assign ir_value = ir_internal;
    assign a_value = a_internal;
    assign b_value = b_internal;
    assign mem_value = mem_internal;
    assign alu_value = alu_internal;
endmodule
