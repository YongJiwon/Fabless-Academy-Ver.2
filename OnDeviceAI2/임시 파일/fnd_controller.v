

//////////

`timescale 1ns / 1ps


module fnd_controller (
    input clk,
    input rst,
    input [7:0] fnd_in,
    output [3:0] fnd_com,
    output [7:0] fnd_data
);
    wire [3:0] w_out_mux, w_digit_1, w_digit_10, w_digit_100, w_digit_1000;
    wire [1:0] w_digit_sel;
    wire w_1khz;

    digit_splitter U_DIGIT_SPLIT (
        .digit_in  (fnd_in),
        .digit_1   (w_digit_1),
        .digit_10  (w_digit_10),
        .digit_100 (w_digit_100),
        .digit_1000(w_digit_1000)
    );

    mux_4x1 U_MUX_4x1 (
        //0~9까지의 입력값이 있으니까 4bit로!
        .in0(w_digit_1),  //0의 자리  
        .in1(w_digit_10),  //10의 자리
        .in2(w_digit_100),  //100의 자리
        .in3(w_digit_1000),  //1000의 자리
        .sel(w_digit_sel),  //to select input
        .out_mux(w_out_mux)
    );

    bcd U_BCD (
        .bin(w_out_mux),
        .bcd_data(fnd_data)
    );
    clk_div_1khz U_CLK_DIV_1KHZ(
        .clk(clk),
        .rst(rst),
        .o_1khz(w_1khz) //이걸 reg로 바꾸면 x상태에서 시작하니까 뭘로 변할지를 모름
    );
    counter_4 U_COUNTER_4 (
        .clk(w_1khz),
        .rst(rst),
        .digit_sel(w_digit_sel)
    );
    decoder_2X4 U_DECODER_2X4 (
        .decoder_in(w_digit_sel),
        .fnd_com(fnd_com)
    );
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


module counter_4 (
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
            2'b00: fnd_com = 4'b1110;
            2'b01: fnd_com = 4'b1101;
            2'b10: fnd_com = 4'b1011;
            2'b11: fnd_com = 4'b0111;

            default: fnd_com = 4'b1111;
        endcase
    end

endmodule

module digit_splitter (
    input  [7:0] digit_in,
    output [3:0] digit_1,
    output [3:0] digit_10,
    output [3:0] digit_100,
    output [3:0] digit_1000
);

    //assign 사용
    assign digit_1 = digit_in % 10;
    assign digit_10 = (digit_in / 10) % 10;
    assign digit_100 = (digit_in / 100) % 10;
    assign digit_1000 = (digit_in / 1000) % 10;


endmodule
module mux_4x1 (
    //0~9까지의 입력값이 있으니까 4bit로!
    input [3:0] in0,  //0의 자리  
    input [3:0] in1,  //10의 자리
    input [3:0] in2,  //100의 자리
    input [3:0] in3,  //1000의 자리
    input [1:0] sel,  //to select input
    output [3:0] out_mux
);
    reg [3:0] out_reg;
    assign out_mux = out_reg;

    //mux
    always @(*  /*in0, in1, in2, in3, sel*/) begin
        case (sel)
            2'b00: out_reg = in0;
            2'b01: out_reg = in1;
            2'b10: out_reg = in2;
            2'b11: out_reg = in3;

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
            4'b1110: bcd_data = 8'h86;
            4'b1111: bcd_data = 8'h8E;

            default: bcd_data = 8'hxx;
        endcase

    end
endmodule




/*`timescale 1ns / 1ps


module fnd_controller (
    input clk,
    input rst_n,
    input  [7:0] fnd_in,
    output [3:0] fnd_com,
    output [7:0] fnd_data
);
    wire [1:0] w_digit_sel; 
    wire [3:0] w_out_mux ,w_digit_1,w_digit_10,w_digit_100,w_digit_1000;
    wire o_1khz;

    digit_splitter digit_sp(
    .digit_in(fnd_in),
    .digit_1(w_digit_1),
    .digit_10(w_digit_10),
    .digit_100(w_digit_100),
    .digit_1000(w_digit_1000)
    );

    mux_4x1 U_MUX_4x1(
      .in0(w_digit_1),  
      .in1(w_digit_10),
      .in2(w_digit_100),
      .in3(w_digit_1000),
      .sel(w_digit_sel),
      .out_mux(w_out_mux)
    );


    bcd U_BCD (
        .b_in(w_out_mux),
        .bcd_data(fnd_data)
    );

    

clk_div_1khz U_CLK_DIV_1KHZ(
    .clk(clk),
    .rst_n(rst_n),
    .o_1khz(o_1khz)
);


    counter_4 U_COUNTER_4(
        .clk(o_1khz),
        .rst_n(rst_n),
        .digit_sel(w_digit_sel)
);



    decoder_2x4 U_DECODER_2x4(
        .decoder_in(w_digit_sel),
        .fnd_com(fnd_com)
    );
endmodule



    //직접 들어온 wire라 신호 반전이 불명확하기 때문에 reg를 선언해서 값을 안정적으로 바꿔주도록 함
    //output을 reg로 선언하지 않은 이유는 초기화가 됐는지 모르기 때문에 초기화를 걸어준 것
module clk_div_1khz (
    input clk,
    input rst_n,
    output o_1khz
);
    
    reg [15:0] counter_reg;
    reg o_1khz_reg;
    
    assign o_1khz = o_1khz_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter_reg <= 16'd0;
            o_1khz_reg <= 1'b0;
        end else begin
            if (counter_reg == 16'd49999) begin
                counter_reg <= 16'd0;
                o_1khz_reg <= ~o_1khz_reg;
            end else begin
                counter_reg <= counter_reg + 1'b1;
            end
        end
    end
endmodule

module counter_4 (
    input clk,
    input rst_n,
    output [1:0] digit_sel
);
    reg [1:0] counter_reg;

    assign digit_sel = counter_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter_reg <= 2'b00;
        end else begin
            counter_reg <= counter_reg + 1'b1;
        end
    end
endmodule
/*module counter_4 (
    input clk,
    input rst_n,
    output [1:0] digit_sel
);
    

    reg [1:0] counter_reg;

always @(posedge clk , posedge rst_n) begin
        if (rst_n) begin
            counter_reg <= 0;
        end else begin
            counter_reg <= counter_reg + 1;
        end
end

    assign digit_sel = counter_reg;

    
endmodule
*/

/*
module decoder_2x4(
    input      [1:0] decoder_in,
    output reg [3:0] fnd_com

);

    always @(*) begin
        case(decoder_in)
            2'b00: fnd_com = 4'b1110;
            2'b01: fnd_com = 4'b1101;
            2'b10: fnd_com = 4'b1011;
            2'b11: fnd_com = 4'b0111;
            default: fnd_com = 4'b1111;
        endcase
    end

endmodule



module mux_4x1(
    input [3:0] in0, //digit 1
    input [3:0] in1, //digit 10
    input [3:0] in2, //digit 100
    input [3:0] in3, //digit 1000
    input [1:0] sel, //input select
    output reg  [3:0] out_mux   
); 


    always @(*) begin
        case (sel)
            2'b00: out_mux = in0 ;
            2'b01: out_mux = in1 ;
            2'b10: out_mux = in2 ;
            2'b11: out_mux = in3 ;
            default: out_mux = 4'b0000 ;
        endcase
    end

endmodule 


module digit_splitter(
    input [7:0] digit_in,
    output [3:0] digit_1,
    output [3:0] digit_10,
    output [3:0] digit_100,
    output [3:0] digit_1000
);

    assign digit_1 = digit_in % 10;
    assign digit_10 = (digit_in/10) % 10;
    assign digit_100 = (digit_in/100) % 10;
    assign digit_1000 = (digit_in/1000) % 10;

endmodule


module bcd (
    input [3:0] b_in,
    output reg [7:0] bcd_data
);

    always @(b_in) begin
        case(b_in)
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
            4'b1110: bcd_data = 8'h86;
            4'b1111: bcd_data = 8'h8E;
            default: bcd_data = 8'hxx;
        endcase

    end
endmodule



module adder_fnd(
    input [7:0]a_in,
    input [7:0]b_in,
    input [1:0] digit_sel,
    output [7:0] fnd_com, 
    output [7:0] fnd_data,
    output led
);
    wire [7:0] w_sum;

    fnd_controller U_FND_CRTL(
        .clk(clk),
        .rst_n(rst_n),
        .fnd_in(w_sum),
        .fnd_com(fnd_com),
        .fnd_data(fnd_data)
    );


    FA_8bit U_ADDER_8BIT( //그림 왼쪽 half_adder 먼저 설계
        .a_in(a_in), //from full_adder input a      
        .b_in(b_in), //from full_adder input b
        .sum_out(w_sum),
        .c_out(led)
        );

endmodule

*/