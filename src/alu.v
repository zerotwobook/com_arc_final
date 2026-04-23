module alu (
    input wire [7:0] a_value,
    input wire [7:0] b_value,
    input wire subtract,
    input wire multiply,
    input wire divide,
    output wire [7:0] result
);
    assign result = divide ? ((b_value == 8'h00) ? 8'h00 : (a_value / b_value)) :
                    multiply ? (a_value * b_value) :
                    subtract ? (a_value - b_value) :
                    (a_value + b_value);
endmodule
