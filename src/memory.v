module memory (
    input wire clk,
    input wire write_en,
    input wire [3:0] address,
    input wire [7:0] data_in,
    output wire [7:0] data_out
);
    integer idx;
    reg [7:0] mem [0:15];

    initial begin
        for (idx = 0; idx < 16; idx = idx + 1) begin
            mem[idx] = 8'h00;
        end
    end

    assign data_out = mem[address];

    always @(posedge clk) begin
        if (write_en) begin
            mem[address] <= data_in;
        end
    end
endmodule
