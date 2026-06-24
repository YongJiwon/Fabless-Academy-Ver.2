`timescale 1ns / 1ps


module fnd_controller #(    
    parameter   MSEC_WIDTH = 7,
                SEC_WIDTH = 6,
                MIN_WIDTH = 6,
                HOUR_WIDTH = 5
)(
    input clk,
    input rst,
    input [MSEC_WIDTH - 1:0] msec,
    input [SEC_WIDTH - 1:0] sec,
    input [MIN_WIDTH - 1:0] min,
    input [HOUR_WIDTH - 1:0] hour,
    input [7:0] fnd_in,
    output [3:0] fnd_com,
    output [7:0] fnd_data
);
    wire [3:0] w_out_mux, w_out_mux_msec_sec, w_out_mux_min_hour;
    //w_digit_1, w_digit_10, w_digit_100, w_digit_1000;
    wire [3:0] w_msec_digit_1, w_msec_digit_10;
    wire [3:0] w_sec_digit_1, w_sec_digit_10;
    wire [3:0] w_min_digit_1, w_min_digit_10;
    wire [3:0] w_hour_digit_1, w_hour_digit_10;
    wire [2:0] w_digit_sel;
    wire w_1khz;
    wire w_dot_onoff;

digit_splitter # (
    .BIT_WIDTH(MSEC_WIDTH)
) U_MESC_DS (

    .digit_in(msec),
    .digit_1(w_msec_digit_1),
    .digit_10(w_msec_digit_10) 
);

digit_splitter # (
    .BIT_WIDTH(SEC_WIDTH)
) U_SEC_DS (

    .digit_in(sec),
    .digit_1(w_sec_digit_1),
    .digit_10(w_sec_digit_10) 
);



digit_splitter # (
    .BIT_WIDTH(MIN_WIDTH)
) U_MIN_DS (

    .digit_in(min),
    .digit_1(w_min_digit_1),
    .digit_10(w_min_digit_10) 
);



digit_splitter # (
    .BIT_WIDTH(HOUR_WIDTH)
) U_HOUR_DS (

    .digit_in(hour),
    .digit_1(w_hour_digit_1),
    .digit_10(w_hour_digit_10) 
);



comparator U_COMP_DOTONOFF(
    .comp_in(msec),
    .dot_onoff(w_dot_onoff)
);



    mux_8x1 U_MUX_MSEC_SEC (
        //0~9까지의 입력값이 있으니까 4bit로!
        .in0(w_msec_digit_1),  //0의 자리  
        .in1(w_msec_digit_10),  //10의 자리
        .in2(w_sec_digit_1),  //100의 자리
        .in3(w_sec_digit_10),  //1000의 자리
        .sel(w_digit_sel),  //to select input
        .out_mux(w_out_mux_msec_sec)
    );
    mux_8x1 U_MUX_SEC_MIN (
        //0~9까지의 입력값이 있으니까 4bit로!
        .in0(w_msec_digit_1),  //0의 자리  
        .in1(w_msec_digit_10),  //10의 자리
        .in2(w_sec_digit_1),  //100의 자리
        .in3(w_sec_digit_10),  //1000의 자리
        .sel(w_digit_sel),  //to select input
        .out_mux(w_out_mux_msec_sec)
    );
    mux_8x1 U_MUX_MIN_HOUR (
        //0~9까지의 입력값이 있으니까 4bit로!
        .in0(w_msec_digit_1),  //0의 자리  
        .in1(w_msec_digit_10),  //10의 자리
        .in2(w_sec_digit_1),  //100의 자리
        .in3(w_sec_digit_10),  //1000의 자리
        .sel(w_digit_sel),  //to select input
        .out_mux(w_out_mux_msec_sec)
    );

    mux_8x1 U_MUX_HIYR(
        //0~9까지의 입력값이 있으니까 4bit로!
        .in0(w_msec_digit_1),  //0의 자리  
        .in1(w_msec_digit_10),  //10의 자리
        .in2(w_sec_digit_1),  //100의 자리
        .in3(w_sec_digit_10),  //1000의 자리
        .sel(w_digit_sel),  //to select input
        .out_mux(w_out_mux_msec_sec)
    );


mux_2x1 U_MUX_2x1(

    .sel(w_digit_sel[1:0]),
    .out_mux(out_mux)
);



/*    mux_4x1 U_MUX_4x1 (
        //0~9까지의 입력값이 있으니까 4bit로!
        .in0(w_digit_1),  //0의 자리  
        .in1(w_digit_10),  //10의 자리
        .in2(w_digit_100),  //100의 자리
        .in3(w_digit_1000),  //1000의 자리
        .sel(w_digit_sel),  //to select input
        .out_mux(w_out_mux)
    );
*/
    bcd U_BCD (
        .bin(w_out_mux),
        .bcd_data(fnd_data)
    );
    clk_div_1khz U_CLK_DIV_1KHZ(
        .clk(clk),
        .rst(rst),
        .o_1khz(w_1khz) //이걸 reg로 바꾸면 x상태에서 시작하니까 뭘로 변할지를 모름
    );
    counter_8 U_COUNTER_8 (
        .clk(w_1khz),
        .rst(rst),
        .digit_sel(w_digit_sel)
    );
    decoder_2X4 U_DECODER_2X4 (
        .decoder_in(w_digit_sel),
        .fnd_com(fnd_com)
    );
endmodule






module comparator (
    input [6:0] comp_in,
    output wire dot_onoff
);


//0~49 : false 0, 50~99 : ture 1
assign dot_onoff = (comp_in > 49)?1'b0:1'b1;
    
endmodule






module mux_2x1 (
    input [3:0] in0,
    input [3:0] in1,
    input sel,
    output [3:0] out_mux

);

assign out_mux  = (sel) ? in1:in0;
    
endmodule






module clk_div_1khz(
    input clk,
    input rst,
    output o_1khz //이걸 reg로 바꾸면 x상태에서 시작하니까 뭘로 변할지를 모름
);

    reg [15:0] counter_reg; //16bit짜리 플립플롭 생성됨
    reg o_1khz_reg; 

    assign o_1khz = o_1khz_reg;

    always@(posedge clk, posedge rst) begin
        if(rst) begin
            counter_reg <= 16'd0;
            o_1khz_reg <= 1'b0;
        end else begin
            counter_reg <= counter_reg + 1;
            if(counter_reg == (50_000 - 1)) begin
                counter_reg <= 16'd0;
                o_1khz_reg <= ~o_1khz_reg;
            end
        end

    end
endmodule


module counter_8 (
    input clk,
    input rst,
    output [1:0] digit_sel
);

    reg [1:0] counter_reg;  //0,1,2,3만 존재하니까

    assign digit_sel = counter_reg;


    always @(posedge clk, posedge rst) begin
        if (rst) begin
            counter_reg <= 0;  //
        end else begin
            counter_reg <= counter_reg + 1;
        end
    end
endmodule

module decoder_2X4 (
    input      [1:0] decoder_in,
    output reg [3:0] fnd_com
);

    always @(*) begin
        case (decoder_in)
            3'b000: fnd_com = 4'b1110;
            3'b001: fnd_com = 4'b1101;
            3'b010: fnd_com = 4'b1011;
            3'b011: fnd_com = 4'b0111;
            3'b100: fnd_com = 4'b1110;
            3'b101: fnd_com = 4'b1101;
            3'b110: fnd_com = 4'b1011;
            3'b111: fnd_com = 4'b0111;

            default: fnd_com = 4'b1111;
        endcase
    end

endmodule

module digit_splitter # (
    BIT_WIDTH  = 7
)(

    input  [BIT_WIDTH:0] digit_in,
    output [3:0] digit_1,
    output [3:0] digit_10
  //  output [3:0] digit_100,
    //output [3:0] digit_1000
);





    //assign 사용
    assign digit_1 = digit_in % 10;
    assign digit_10 = (digit_in / 10) % 10;
//    assign digit_100 = (digit_in / 100) % 10;
  //  assign digit_1000 = (digit_in / 1000) % 10;


endmodule
module mux_8x1 (
    input [3:0] in0,  //0의 자리  
    input [3:0] in1,  //10의 자리
    input [3:0] in2,  //100의 자리
    input [3:0] in3,  //1000의 자리
    input [3:0] in4,  //0의 자리  
    input [3:0] in5,  //10의 자리
    input [3:0] in6,  //100의 자리
    input [3:0] in7,  //1000의 자리
    input [2:0] sel,  //to select input
    output [3:0] out_mux
);
    reg [3:0] out_reg;
    assign out_mux = out_reg;

    //mux
    always @(*  /*in0, in1, in2, in3, sel*/) begin
        case (sel)
            3'b000: out_reg = in0;
            3'b001: out_reg = in1;
            3'b010: out_reg = in2;
            3'b011: out_reg = in3;
            3'b100: out_reg = in4;
            3'b101: out_reg = in5;
            3'b110: out_reg = in6;
            3'b111: out_reg = in7;

            default:
            out_reg = 4'b0000; //full case 처리했기 때문에 아무 문제가 없지만 그래도 default 추가해서 래치 발생하지 않도록
        endcase
    end
endmodule

module bcd (
    input [3:0] bin,
    output reg [7:0] bcd_data
);

    always @(bin) begin  //항상 bin을 감시하라는 뜻
        case(bin) //설계할 때는 always 구문 안에서만 case 사용 가능
            4'b0000: bcd_data = 8'hC0;
            4'b0001: bcd_data = 8'hF9;
            4'b0010: bcd_data = 8'hA4;
            4'b0011: bcd_data = 8'hB0;
            4'b0100: bcd_data = 8'h99;
            4'b0101: bcd_data = 8'h92;
            4'b0110: bcd_data = 8'h82;
            4'b0111: bcd_data = 8'hF8;
            4'b1000: bcd_data = 8'h80;
            4'b1001: bcd_data = 8'h90;
            4'b1010: bcd_data = 8'h88;
            4'b1011: bcd_data = 8'h83;
            4'b1100: bcd_data = 8'hC6;
            4'b1101: bcd_data = 8'hA1;
            4'b1110: bcd_data = 8'h7F;
            4'b1111: bcd_data = 8'hFF;

            default: bcd_data = 8'hFF;
        endcase

    end
endmodule

