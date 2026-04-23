`timescale 1ns/1ps

module cpu_tb;
    reg clk;
    reg reset;

    wire [7:0] bus_value;
    wire [2:0] t_state;
    wire halted;
    wire [3:0] opcode;
    wire [3:0] operand;
    wire [3:0] pc_value;
    wire [3:0] mar_value;
    wire [7:0] ir_value;
    wire [7:0] a_value;
    wire [7:0] b_value;
    wire [7:0] mem_value;
    wire [7:0] alu_value;
    wire co;
    wire ce;
    wire mi;
    wire ro;
    wire ri;
    wire ii;
    wire io;
    wire ai;
    wire ao;
    wire bi;
    wire eo;
    wire su;
    wire hlt;

    cpu dut (
        .clk(clk),
        .reset(reset),
        .bus_value(bus_value),
        .t_state(t_state),
        .halted(halted),
        .opcode(opcode),
        .operand(operand),
        .pc_value(pc_value),
        .mar_value(mar_value),
        .ir_value(ir_value),
        .a_value(a_value),
        .b_value(b_value),
        .mem_value(mem_value),
        .alu_value(alu_value),
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
        .hlt(hlt)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        reset = 1'b1;

        dut.u_memory.mem[4'h0] = 8'h03;
        dut.u_memory.mem[4'h1] = 8'h16;
        dut.u_memory.mem[4'h2] = 8'hF0;
        dut.u_memory.mem[4'h3] = 8'h04;
        dut.u_memory.mem[4'h6] = 8'h05;

        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, cpu_tb);

        #12;
        reset = 1'b0;

        wait (halted === 1'b1);
        #10;

        if (a_value !== 8'h09) begin
            $display("FAIL: expected A=09, got A=%02h", a_value);
            $finish_and_return(1);
        end

        $display("PASS: final A register = %02h", a_value);
        $display("PASS: memory[3] = %02h, memory[6] = %02h", dut.u_memory.mem[4'h3], dut.u_memory.mem[4'h6]);
        $finish;
    end

    always @(posedge clk) begin
        if (!reset) begin
            $display(
                "t=%0t T=%0d PC=%0h MAR=%0h IR=%02h BUS=%02h A=%02h B=%02h MEM=%02h ALU=%02h | CO=%b CE=%b MI=%b RO=%b RI=%b II=%b IO=%b AI=%b AO=%b BI=%b EO=%b SU=%b HLT=%b HALTED=%b",
                $time,
                t_state,
                pc_value,
                mar_value,
                ir_value,
                bus_value,
                a_value,
                b_value,
                mem_value,
                alu_value,
                co,
                ce,
                mi,
                ro,
                ri,
                ii,
                io,
                ai,
                ao,
                bi,
                eo,
                su,
                hlt,
                halted
            );
        end
    end
endmodule
