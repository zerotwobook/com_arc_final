module alu (
    input wire [7:0] a_value,
    input wire [7:0] b_value,
    input wire subtract,
    output wire [7:0] result
);
    assign result = subtract ? (a_value - b_value) : (a_value + b_value);
endmodule
