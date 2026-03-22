module traffic_light_controller (
    input clk,
    input reset,
    output reg [2:0] main_light,  // R=100, Y=010, G=001
    output reg [2:0] side_light
);

    // State Encoding
    parameter S0 = 3'd0, S1 = 3'd1, S2 = 3'd2,
              S3 = 3'd3, S4 = 3'd4, S5 = 3'd5;

    reg [2:0] state, next_state;
    reg [3:0] count;

    // Clocked process for state transitions and counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
            count <= 0;
        end else begin
            if (count >= state_duration(state)) begin
                state <= next_state;
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

    // Next State Logic
    always @(*) begin
        case (state)
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S4;
            S4: next_state = S5;
            S5: next_state = S0;
            default: next_state = S0;
        endcase
    end

    // Output Logic
    always @(*) begin
        case (state)
            S0: begin main_light = 3'b001; side_light = 3'b100; end // MR Green, SR Red
            S1: begin main_light = 3'b010; side_light = 3'b100; end // MR Yellow, SR Red
            S2: begin main_light = 3'b100; side_light = 3'b001; end // MR Red, SR Green
            S3: begin main_light = 3'b100; side_light = 3'b010; end // MR Red, SR Yellow
            S4: begin main_light = 3'b100; side_light = 3'b100; end // Both Red
            S5: begin main_light = 3'b001; side_light = 3'b100; end // MR Green again
            default: begin main_light = 3'b000; side_light = 3'b000; end
        endcase
    end

    // Duration for each state (combinational)
    function [3:0] state_duration;
        input [2:0] s;
        case (s)
            S0: state_duration = 5;
            S1: state_duration = 2;
            S2: state_duration = 3;
            S3: state_duration = 2;
            S4: state_duration = 1;
            S5: state_duration = 1;
            default: state_duration = 1;
        endcase
    endfunction

endmodule
