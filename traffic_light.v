// traffic_light.v
// 4-way intersection controller - NS road and EW road
// only one direction gets green at a time obviously
// timings are in clock cycles right now, kept short so sim doesn't take forever
// on the actual board you'd need to divide the 100MHz clock down to ~1Hz first

module traffic_light (
    input clk,
    input reset,
    output reg [1:0] ns_light,   // 00 red, 01 yellow, 10 green
    output reg [1:0] ew_light
);

    parameter RED    = 2'b00;
    parameter YELLOW = 2'b01;
    parameter GREEN  = 2'b10;

    // 4 states, one for each phase
    parameter NS_GO   = 0;
    parameter NS_WAIT = 1;
    parameter EW_GO   = 2;
    parameter EW_WAIT = 3;

    parameter GO_TIME   = 6;  // how long green stays on
    parameter WAIT_TIME = 2;  // yellow duration

    reg [1:0] state;
    reg [3:0] cnt;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= NS_GO;
            cnt   <= 0;
        end
        else begin
            case(state)
                NS_GO: begin
                    if (cnt == GO_TIME-1) begin
                        state <= NS_WAIT;
                        cnt <= 0;
                    end else
                        cnt <= cnt + 1;
                end

                NS_WAIT: begin
                    if (cnt == WAIT_TIME-1) begin
                        state <= EW_GO;
                        cnt <= 0;
                    end else
                        cnt <= cnt + 1;
                end

                EW_GO: begin
                    if (cnt == GO_TIME-1) begin
                        state <= EW_WAIT;
                        cnt <= 0;
                    end else
                        cnt <= cnt + 1;
                end

                EW_WAIT: begin
                    if (cnt == WAIT_TIME-1) begin
                        state <= NS_GO;
                        cnt <= 0;
                    end else
                        cnt <= cnt + 1;
                end
                // shouldn't ever hit this but just in case
                default: state <= NS_GO;
            endcase
        end
    end

    // output depends only on state -> Moore machine
    always @(*) begin
        case(state)
            NS_GO:   begin ns_light = GREEN;  ew_light = RED;    end
            NS_WAIT: begin ns_light = YELLOW; ew_light = RED;    end
            EW_GO:   begin ns_light = RED;    ew_light = GREEN;  end
            EW_WAIT: begin ns_light = RED;    ew_light = YELLOW; end
            default: begin ns_light = RED;    ew_light = RED;    end
        endcase
    end

endmodule
