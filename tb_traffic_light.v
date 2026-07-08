// tb_traffic_light.v
// just runs the clock for a while and prints out light changes
// so I can eyeball the sequence and make sure NS/EW never both go green

`timescale 1ns/1ps

module tb_traffic_light;

    reg clk, reset;
    wire [1:0] ns_light, ew_light;

    traffic_light dut (
        .clk(clk),
        .reset(reset),
        .ns_light(ns_light),
        .ew_light(ew_light)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // little helper just so the printout is readable instead of 00/01/10
    function [47:0] name;
        input [1:0] code;
        begin
            case(code)
                2'b00: name = "RED";
                2'b01: name = "YELLOW";
                2'b10: name = "GREEN";
                default: name = "??";
            endcase
        end
    endfunction

    initial begin
        reset = 1;
        #12 reset = 0;
        #400 $finish;   // long enough to see it loop a couple times
    end

    always @(ns_light or ew_light)
        $display("t=%0t  NS=%s  EW=%s", $time, name(ns_light), name(ew_light));

endmodule
