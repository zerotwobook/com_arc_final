module bus (
    input wire co,
    input wire ro,
    input wire io,
    input wire ao,
    input wire eo,
    input wire [3:0] pc_value,
    input wire [7:0] mem_value,
    input wire [3:0] ir_address,
    input wire [7:0] a_value,
    input wire [7:0] alu_value,
    output reg [7:0] bus_value
);
    always @(*) begin
        bus_value = 8'h00;
        if (co) begin
            bus_value = {4'b0000, pc_value};
        end else if (ro) begin
            bus_value = mem_value;
        end else if (io) begin
            bus_value = {4'b0000, ir_address};
        end else if (ao) begin
            bus_value = a_value;
        end else if (eo) begin
            bus_value = alu_value;
        end
    end
endmodule
