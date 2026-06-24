`timescale 1ns / 1ps

module fsm_led_mealy(
    input clk,
    input rst,
    input [2:0] sw,
    output reg [2:0] led
);

// 상태 인코딩과 LED 출력값을 분리
localparam S0 = 3'd0,
           S1 = 3'd1,
           S2 = 3'd2,
           S3 = 3'd3,
           S4 = 3'd4;

localparam LED_1 = 3'b000,
           LED_2 = 3'b100,
           LED_3 = 3'b010,
           LED_4 = 3'b001,
           LED_5 = 3'b111;

reg [2:0] state, next_state;

//--------------------------
// Next-state logic
//--------------------------
always @(*) begin
    case (state)
        S0: begin
            if (sw == 3'b001)      next_state = S1;
            else if (sw == 3'b010) next_state = S2;
            else                   next_state = S0;
        end

        S1: begin
            if (sw == 3'b010) next_state = S2;
            else              next_state = S1;
        end

        S2: begin
            if (sw == 3'b100) next_state = S3;
            else              next_state = S2;
        end

        S3: begin
            if (sw == 3'b111)      next_state = S4;
            else if (sw == 3'b000) next_state = S0;
            else if (sw == 3'b001) next_state = S1;
            else                   next_state = S3;
        end

        S4: begin
            if (sw == 3'b000) next_state = S0;
            else              next_state = S4;
        end

        default: next_state = S0;
    endcase
end

//--------------------------
// State register
//--------------------------
always @(posedge clk or posedge rst) begin
    if (rst)
        state <= S0;
    else
        state <= next_state;
end

//--------------------------
// Mealy output logic
// 출력이 state + sw에 직접 의존
//--------------------------
always @(*) begin
    case (state)
        S0: begin
            if (sw == 3'b001)      led = LED_2;
            else if (sw == 3'b010) led = LED_3;
            else                   led = LED_1;
        end

        S1: begin
            if (sw == 3'b010) led = LED_3;
            else              led = LED_2;
        end

        S2: begin
            if (sw == 3'b100) led = LED_4;
            else              led = LED_3;
        end

        S3: begin
            if (sw == 3'b111)      led = LED_5;
            else if (sw == 3'b000) led = LED_1;
            else if (sw == 3'b001) led = LED_2;
            else                   led = LED_4;
        end

        S4: begin
            if (sw == 3'b000) led = LED_1;
            else              led = LED_5;
        end

        default: led = LED_1;
    endcase
end

endmodule

/*
`timescale 1ns / 1ps

module fsm_led_mealy(
    input clk,
    input rst,
    input [2:0] sw,
    output reg [2:0] led
);

parameter   LED_1 = 3'b000,
            LED_2 = 3'b100,
            LED_3 = 3'b010,
            LED_4 = 3'b001,
            LED_5 = 3'b111;

reg [2:0] state, next_state;

// Next state logic
always @(*) begin
    case (state)
        LED_1: next_state = (sw == 3'b001) ? LED_2 :
                            (sw == 3'b010) ? LED_3 : LED_1;

        LED_2: next_state = (sw == 3'b010) ? LED_3 : LED_2;

        LED_3: next_state = (sw == 3'b100) ? LED_4 : LED_3;

        LED_4: next_state = (sw == 3'b111) ? LED_5 :
                            (sw == 3'b000) ? LED_1 :
                            (sw == 3'b001) ? LED_2 : LED_4;

        LED_5: next_state = (sw == 3'b000) ? LED_1 : LED_5;

        default: next_state = LED_1;
    endcase
end

// State register
always @(posedge clk or posedge rst) begin
    if (rst)
        state <= LED_1;
    else
        state <= next_state;
end

// Mealy output logic
always @(*) begin
    case (state)
        LED_1: led = (sw == 3'b001) ? LED_2 :
                     (sw == 3'b010) ? LED_3 : LED_1;

        LED_2: led = (sw == 3'b010) ? LED_3 : LED_2;

        LED_3: led = (sw == 3'b100) ? LED_4 : LED_3;

        LED_4: led = (sw == 3'b111) ? LED_5 :
                     (sw == 3'b000) ? LED_1 :
                     (sw == 3'b001) ? LED_2 : LED_4;

        LED_5: led = (sw == 3'b000) ? LED_1 : LED_5;

        default: led = LED_1;
    endcase
end

endmodule

*/
/*`timescale 1ns / 1ps

module fsm_led(
    input clk,
    input rst,
    input [2:0] sw,
    output reg [2:0] led
);

parameter   LED_1 = 3'b000,
            LED_2 = 3'b100,
            LED_3 = 3'b010,
            LED_4 = 3'b001,
            LED_5 = 3'b111;
reg [2:0] state, next_state, led_reg;

//Combinational Logic
always @(*) begin
    case(state) //우선순위  고려 => if else // 동일한 타이밍에 처리하려면 case문
        LED_1: next_state = (sw == 3'b001)?LED_2:  
                            ((sw == 3'b010)?LED_3:LED_1); //A 000  -> B or C

        LED_2: next_state = (sw == 3'b010)?LED_3:LED_2; //B 001 -> C
        
        LED_3: next_state = (sw == 3'b100)?LED_4:LED_3; //C 010

        LED_4: next_state = (sw == 3'b111)?(LED_5):
                            (((sw == 3'b000))?(LED_1):
                            ((sw == 3'b001)?(LED_2):(LED_4)));

        LED_5: next_state = (sw == 3'b000)?LED_1:LED_5; // E 111

        default: next_state = LED_1;
    endcase
end

//Sequential Logic
always @(posedge clk or posedge rst) begin

    if (rst) begin
        state <= LED_1;
    end else begin
        state <=next_state;
    end
end

//Output
always @(*) begin
    case(state)
        LED_1: led_reg = 3'b000;
        LED_2: led_reg = 3'b100;
        LED_3: led_reg = 3'b010;
        LED_4: led_reg = 3'b001;
        LED_5: led_reg = 3'b111;
        default: led_reg = LED_1;
    endcase
end

//Sequential Logic
always @(posedge clk or posedge rst) begin

    if (rst) begin
        led <= 3'b000;
    end else begin
        led <=led_reg;
    end
end

endmodule
*/

/*
`timescale 1ns / 1ps

module fsm_led(
    input clk,
    input rst,
    input [2:0] sw,
    output wire [2:0] led
);

parameter   STATE_A = 3'b000,
            STATE_B = 3'b100,
            STATE_C = 3'b010,
            STATE_D = 3'b001,
            STATE_E = 3'b111;

reg [2:0] state, next_state, led_reg;

//Combinational Logic
always @(*) begin
    case(state)
        STATE_A: next_state = (sw == 3'b001)?STATE_B:
        ((sw == 3'b010)?STATE_C:STATE_A); //A 000  -> B or C
        STATE_B: next_state = (sw == 3'b010)?STATE_C:STATE_B; //B 001 -> C
        STATE_C: next_state = (sw == 3'b100)?STATE_D:STATE_C; //C 010

        
        STATE_D: next_state = (sw == 3'b111)?(STATE_E):(((sw == 3'b000))?(STATE_A):((sw == 3'b001)?(STATE_B):(STATE_D)));


        STATE_E: next_state = (sw == 3'b000)?STATE_A:STATE_E; // E 111
        default: next_state = STATE_A;
    endcase
end

//Sequential Logic
always @(posedge clk or posedge rst) begin

    if (rst) begin
        state <= STATE_A;
    end else begin
        state <=next_state;
    end
end

always @(*) begin
    case(state)
        STATE_A: led_reg = 3'b000;
        STATE_B: led_reg = 3'b100;
        STATE_C: led_reg = 3'b010;
        STATE_D: led_reg = 3'b001;
        STATE_E: led_reg = 3'b111;
        default: led_reg = STATE_A;
    endcase
end

assign led = led_reg;

endmodule


*/