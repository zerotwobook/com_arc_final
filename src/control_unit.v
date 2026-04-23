module control_unit (
    input wire clk,
    input wire reset,
    input wire [3:0] opcode,
    output reg co,
    output reg ce,
    output reg mi,
    output reg ro,
    output reg ri,
    output reg ii,
    output reg io,
    output reg ai,
    output reg ao,
    output reg bi,
    output reg eo,
    output reg su,
    output reg hlt,
    output reg [2:0] t_state,
    output reg halted
);
    localparam OPCODE_LDA = 4'h0;
    localparam OPCODE_ADD = 4'h1;
    localparam OPCODE_SUB = 4'h2;
    localparam OPCODE_STA = 4'h3;
    localparam OPCODE_NOP = 4'hE;
    localparam OPCODE_HLT = 4'hF;

    reg step_reset;
    reg halt_now;

    always @(*) begin
        co = 1'b0;
        ce = 1'b0;
        mi = 1'b0;
        ro = 1'b0;
        ri = 1'b0;
        ii = 1'b0;
        io = 1'b0;
        ai = 1'b0;
        ao = 1'b0;
        bi = 1'b0;
        eo = 1'b0;
        su = 1'b0;
        hlt = 1'b0;
        step_reset = 1'b0;
        halt_now = 1'b0;

        if (!halted) begin
            case (t_state)
                3'd0: begin
                    co = 1'b1;
                    mi = 1'b1;
                end
                3'd1: begin
                    ro = 1'b1;
                    ii = 1'b1;
                    ce = 1'b1;
                end
                3'd2: begin
                    case (opcode)
                        OPCODE_LDA,
                        OPCODE_ADD,
                        OPCODE_SUB,
                        OPCODE_STA: begin
                            io = 1'b1;
                            mi = 1'b1;
                        end
                        OPCODE_NOP: begin
                            step_reset = 1'b1;
                        end
                        OPCODE_HLT: begin
                            hlt = 1'b1;
                            halt_now = 1'b1;
                            step_reset = 1'b1;
                        end
                        default: begin
                            step_reset = 1'b1;
                        end
                    endcase
                end
                3'd3: begin
                    case (opcode)
                        OPCODE_LDA: begin
                            ro = 1'b1;
                            ai = 1'b1;
                            step_reset = 1'b1;
                        end
                        OPCODE_ADD,
                        OPCODE_SUB: begin
                            ro = 1'b1;
                            bi = 1'b1;
                        end
                        OPCODE_STA: begin
                            ao = 1'b1;
                            ri = 1'b1;
                            step_reset = 1'b1;
                        end
                        default: begin
                            step_reset = 1'b1;
                        end
                    endcase
                end
                3'd4: begin
                    case (opcode)
                        OPCODE_ADD: begin
                            eo = 1'b1;
                            ai = 1'b1;
                            step_reset = 1'b1;
                        end
                        OPCODE_SUB: begin
                            su = 1'b1;
                            eo = 1'b1;
                            ai = 1'b1;
                            step_reset = 1'b1;
                        end
                        default: begin
                            step_reset = 1'b1;
                        end
                    endcase
                end
                default: begin
                    step_reset = 1'b1;
                end
            endcase
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            t_state <= 3'd0;
            halted <= 1'b0;
        end else if (halted) begin
            t_state <= t_state;
            halted <= halted;
        end else begin
            if (halt_now) begin
                t_state <= 3'd0;
                halted <= 1'b1;
            end else if (step_reset) begin
                t_state <= 3'd0;
                halted <= 1'b0;
            end else begin
                t_state <= t_state + 3'd1;
                halted <= 1'b0;
            end
        end
    end
endmodule
