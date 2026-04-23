module program_counter (
    input wire clk,
    input wire reset,
    input wire increment,
    output reg [3:0] pc_value
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_value <= 4'b0000;
        end else if (increment) begin
            pc_value <= pc_value + 4'b0001;
        end
    end
endmodule
