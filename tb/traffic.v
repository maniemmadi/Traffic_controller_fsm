module tb_traffic_light_controller;

    reg clk, reset;
    wire [2:0] main_light, side_light;

    // Instantiate the controller
    traffic_light_controller dut (
        .clk(clk),
        .reset(reset),
        .main_light(main_light),
        .side_light(side_light)
    );

    // Generate Clock
    always #5 clk = ~clk;

    initial begin
        $display("Time\tMain\tSide");
        $monitor("%0t\t%b\t%b", $time, main_light, side_light);

        clk = 0;
        reset = 1;
        #10 reset = 0;

        #1000 $finish;
    end

endmodule
