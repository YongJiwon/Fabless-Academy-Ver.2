// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Wed Apr 22 15:42:51 2026
// Host        : DESKTOP-7CFQ9ND running 64-bit major release  (build 9200)
// Command     : write_verilog -mode funcsim -nolib -force -file
//               D:/Work/OnDeviceAI2/practice_UART_0421/practice_UART_0421.sim/sim_1/impl/func/xsim/tb_uart_func_impl.v
// Design      : uart
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module baud_tick_gen
   (w_b_tick,
    CLK,
    rst_IBUF);
  output w_b_tick;
  input CLK;
  input rst_IBUF;

  wire CLK;
  wire [13:0]counter_reg;
  wire counter_reg0_carry__0_n_0;
  wire counter_reg0_carry__1_n_0;
  wire counter_reg0_carry_n_0;
  wire \counter_reg[13]_i_3_n_0 ;
  wire \counter_reg[13]_i_4_n_0 ;
  wire [13:0]counter_reg_0;
  wire [13:1]data0;
  wire o_b_tick;
  wire rst_IBUF;
  wire w_b_tick;
  wire [2:0]NLW_counter_reg0_carry_CO_UNCONNECTED;
  wire [2:0]NLW_counter_reg0_carry__0_CO_UNCONNECTED;
  wire [2:0]NLW_counter_reg0_carry__1_CO_UNCONNECTED;
  wire [3:0]NLW_counter_reg0_carry__2_CO_UNCONNECTED;
  wire [3:1]NLW_counter_reg0_carry__2_O_UNCONNECTED;

  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  CARRY4 counter_reg0_carry
       (.CI(1'b0),
        .CO({counter_reg0_carry_n_0,NLW_counter_reg0_carry_CO_UNCONNECTED[2:0]}),
        .CYINIT(counter_reg[0]),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[4:1]),
        .S(counter_reg[4:1]));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  CARRY4 counter_reg0_carry__0
       (.CI(counter_reg0_carry_n_0),
        .CO({counter_reg0_carry__0_n_0,NLW_counter_reg0_carry__0_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[8:5]),
        .S(counter_reg[8:5]));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  CARRY4 counter_reg0_carry__1
       (.CI(counter_reg0_carry__0_n_0),
        .CO({counter_reg0_carry__1_n_0,NLW_counter_reg0_carry__1_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[12:9]),
        .S(counter_reg[12:9]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 counter_reg0_carry__2
       (.CI(counter_reg0_carry__1_n_0),
        .CO(NLW_counter_reg0_carry__2_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_counter_reg0_carry__2_O_UNCONNECTED[3:1],data0[13]}),
        .S({1'b0,1'b0,1'b0,counter_reg[13]}));
  LUT1 #(
    .INIT(2'h1)) 
    \counter_reg[0]_i_1 
       (.I0(counter_reg[0]),
        .O(counter_reg_0[0]));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h4)) 
    \counter_reg[10]_i_1 
       (.I0(o_b_tick),
        .I1(data0[10]),
        .O(counter_reg_0[10]));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h4)) 
    \counter_reg[11]_i_1 
       (.I0(o_b_tick),
        .I1(data0[11]),
        .O(counter_reg_0[11]));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h4)) 
    \counter_reg[12]_i_1 
       (.I0(o_b_tick),
        .I1(data0[12]),
        .O(counter_reg_0[12]));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h4)) 
    \counter_reg[13]_i_1 
       (.I0(o_b_tick),
        .I1(data0[13]),
        .O(counter_reg_0[13]));
  (* OPT_MODIFIED = "RETARGET" *) 
  LUT6 #(
    .INIT(64'h0000000000004000)) 
    \counter_reg[13]_i_2 
       (.I0(\counter_reg[13]_i_3_n_0 ),
        .I1(counter_reg[3]),
        .I2(counter_reg[2]),
        .I3(counter_reg[5]),
        .I4(counter_reg[4]),
        .I5(\counter_reg[13]_i_4_n_0 ),
        .O(o_b_tick));
  LUT4 #(
    .INIT(16'hFFFD)) 
    \counter_reg[13]_i_3 
       (.I0(counter_reg[7]),
        .I1(counter_reg[6]),
        .I2(counter_reg[9]),
        .I3(counter_reg[8]),
        .O(\counter_reg[13]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFBFFFFFFFFFFFFFF)) 
    \counter_reg[13]_i_4 
       (.I0(counter_reg[12]),
        .I1(counter_reg[13]),
        .I2(counter_reg[10]),
        .I3(counter_reg[11]),
        .I4(counter_reg[1]),
        .I5(counter_reg[0]),
        .O(\counter_reg[13]_i_4_n_0 ));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h4)) 
    \counter_reg[1]_i_1 
       (.I0(o_b_tick),
        .I1(data0[1]),
        .O(counter_reg_0[1]));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h4)) 
    \counter_reg[2]_i_1 
       (.I0(o_b_tick),
        .I1(data0[2]),
        .O(counter_reg_0[2]));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h4)) 
    \counter_reg[3]_i_1 
       (.I0(o_b_tick),
        .I1(data0[3]),
        .O(counter_reg_0[3]));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h4)) 
    \counter_reg[4]_i_1 
       (.I0(o_b_tick),
        .I1(data0[4]),
        .O(counter_reg_0[4]));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h4)) 
    \counter_reg[5]_i_1 
       (.I0(o_b_tick),
        .I1(data0[5]),
        .O(counter_reg_0[5]));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h4)) 
    \counter_reg[6]_i_1 
       (.I0(o_b_tick),
        .I1(data0[6]),
        .O(counter_reg_0[6]));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h4)) 
    \counter_reg[7]_i_1 
       (.I0(o_b_tick),
        .I1(data0[7]),
        .O(counter_reg_0[7]));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h4)) 
    \counter_reg[8]_i_1 
       (.I0(o_b_tick),
        .I1(data0[8]),
        .O(counter_reg_0[8]));
  (* OPT_MODIFIED = "RETARGET" *) 
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h4)) 
    \counter_reg[9]_i_1 
       (.I0(o_b_tick),
        .I1(data0[9]),
        .O(counter_reg_0[9]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg_reg[0] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(counter_reg_0[0]),
        .Q(counter_reg[0]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg_reg[10] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(counter_reg_0[10]),
        .Q(counter_reg[10]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg_reg[11] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(counter_reg_0[11]),
        .Q(counter_reg[11]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg_reg[12] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(counter_reg_0[12]),
        .Q(counter_reg[12]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg_reg[13] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(counter_reg_0[13]),
        .Q(counter_reg[13]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg_reg[1] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(counter_reg_0[1]),
        .Q(counter_reg[1]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(counter_reg_0[2]),
        .Q(counter_reg[2]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(counter_reg_0[3]),
        .Q(counter_reg[3]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(counter_reg_0[4]),
        .Q(counter_reg[4]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(counter_reg_0[5]),
        .Q(counter_reg[5]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(counter_reg_0[6]),
        .Q(counter_reg[6]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg_reg[7] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(counter_reg_0[7]),
        .Q(counter_reg[7]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg_reg[8] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(counter_reg_0[8]),
        .Q(counter_reg[8]));
  FDCE #(
    .INIT(1'b0)) 
    \counter_reg_reg[9] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(counter_reg_0[9]),
        .Q(counter_reg[9]));
  FDCE #(
    .INIT(1'b0)) 
    o_b_tick_reg
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(o_b_tick),
        .Q(w_b_tick));
endmodule

module debounce
   (w_start,
    btnR_IBUF,
    CLK,
    rst_IBUF);
  output w_start;
  input btnR_IBUF;
  input CLK;
  input rst_IBUF;

  wire CLK;
  wire btnR_IBUF;
  wire [20:0]cnt;
  wire [20:1]cnt0;
  wire cnt0_carry__0_n_0;
  wire cnt0_carry__1_n_0;
  wire cnt0_carry__2_n_0;
  wire cnt0_carry_n_0;
  wire \cnt[20]_i_2_n_0 ;
  wire \cnt[20]_i_3_n_0 ;
  wire \cnt[20]_i_4_n_0 ;
  wire \cnt[20]_i_5_n_0 ;
  wire \cnt[20]_i_6_n_0 ;
  wire dout_i_1_n_0;
  wire [20:0]p_0_in;
  wire rst_IBUF;
  wire sync_ff1;
  wire sync_ff2;
  wire w_start;
  wire [2:0]NLW_cnt0_carry_CO_UNCONNECTED;
  wire [2:0]NLW_cnt0_carry__0_CO_UNCONNECTED;
  wire [2:0]NLW_cnt0_carry__1_CO_UNCONNECTED;
  wire [2:0]NLW_cnt0_carry__2_CO_UNCONNECTED;
  wire [3:0]NLW_cnt0_carry__3_CO_UNCONNECTED;

  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  CARRY4 cnt0_carry
       (.CI(1'b0),
        .CO({cnt0_carry_n_0,NLW_cnt0_carry_CO_UNCONNECTED[2:0]}),
        .CYINIT(cnt[0]),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(cnt0[4:1]),
        .S(cnt[4:1]));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  CARRY4 cnt0_carry__0
       (.CI(cnt0_carry_n_0),
        .CO({cnt0_carry__0_n_0,NLW_cnt0_carry__0_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(cnt0[8:5]),
        .S(cnt[8:5]));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  CARRY4 cnt0_carry__1
       (.CI(cnt0_carry__0_n_0),
        .CO({cnt0_carry__1_n_0,NLW_cnt0_carry__1_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(cnt0[12:9]),
        .S(cnt[12:9]));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  CARRY4 cnt0_carry__2
       (.CI(cnt0_carry__1_n_0),
        .CO({cnt0_carry__2_n_0,NLW_cnt0_carry__2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(cnt0[16:13]),
        .S(cnt[16:13]));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  CARRY4 cnt0_carry__3
       (.CI(cnt0_carry__2_n_0),
        .CO(NLW_cnt0_carry__3_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(cnt0[20:17]),
        .S(cnt[20:17]));
  LUT6 #(
    .INIT(64'h0000105510550000)) 
    \cnt[0]_i_1 
       (.I0(cnt[0]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[0]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[10]_i_1 
       (.I0(cnt0[10]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[10]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[11]_i_1 
       (.I0(cnt0[11]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[11]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[12]_i_1 
       (.I0(cnt0[12]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[12]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[13]_i_1 
       (.I0(cnt0[13]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[13]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[14]_i_1 
       (.I0(cnt0[14]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[14]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[15]_i_1 
       (.I0(cnt0[15]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[15]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[16]_i_1 
       (.I0(cnt0[16]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[16]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[17]_i_1 
       (.I0(cnt0[17]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[17]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[18]_i_1 
       (.I0(cnt0[18]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[18]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[19]_i_1 
       (.I0(cnt0[19]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[19]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[1]_i_1 
       (.I0(cnt0[1]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[1]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[20]_i_1 
       (.I0(cnt0[20]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[20]));
  LUT6 #(
    .INIT(64'h01115555FFFFFFFF)) 
    \cnt[20]_i_2 
       (.I0(\cnt[20]_i_4_n_0 ),
        .I1(\cnt[20]_i_5_n_0 ),
        .I2(\cnt[20]_i_6_n_0 ),
        .I3(cnt[0]),
        .I4(cnt[10]),
        .I5(cnt[15]),
        .O(\cnt[20]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h8000)) 
    \cnt[20]_i_3 
       (.I0(cnt[18]),
        .I1(cnt[17]),
        .I2(cnt[20]),
        .I3(cnt[19]),
        .O(\cnt[20]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \cnt[20]_i_4 
       (.I0(cnt[12]),
        .I1(cnt[11]),
        .I2(cnt[14]),
        .I3(cnt[13]),
        .O(\cnt[20]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'hFE)) 
    \cnt[20]_i_5 
       (.I0(cnt[7]),
        .I1(cnt[9]),
        .I2(cnt[8]),
        .O(\cnt[20]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \cnt[20]_i_6 
       (.I0(cnt[2]),
        .I1(cnt[1]),
        .I2(cnt[5]),
        .I3(cnt[6]),
        .I4(cnt[3]),
        .I5(cnt[4]),
        .O(\cnt[20]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[2]_i_1 
       (.I0(cnt0[2]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[2]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[3]_i_1 
       (.I0(cnt0[3]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[3]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[4]_i_1 
       (.I0(cnt0[4]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[4]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[5]_i_1 
       (.I0(cnt0[5]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[5]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[6]_i_1 
       (.I0(cnt0[6]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[6]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[7]_i_1 
       (.I0(cnt0[7]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[7]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[8]_i_1 
       (.I0(cnt0[8]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[8]));
  LUT6 #(
    .INIT(64'h000020AA20AA0000)) 
    \cnt[9]_i_1 
       (.I0(cnt0[9]),
        .I1(cnt[16]),
        .I2(\cnt[20]_i_2_n_0 ),
        .I3(\cnt[20]_i_3_n_0 ),
        .I4(sync_ff2),
        .I5(w_start),
        .O(p_0_in[9]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[0] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[0]),
        .Q(cnt[0]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[10] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[10]),
        .Q(cnt[10]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[11] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[11]),
        .Q(cnt[11]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[12] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[12]),
        .Q(cnt[12]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[13] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[13]),
        .Q(cnt[13]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[14] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[14]),
        .Q(cnt[14]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[15] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[15]),
        .Q(cnt[15]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[16] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[16]),
        .Q(cnt[16]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[17] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[17]),
        .Q(cnt[17]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[18] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[18]),
        .Q(cnt[18]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[19] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[19]),
        .Q(cnt[19]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[1] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[1]),
        .Q(cnt[1]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[20] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[20]),
        .Q(cnt[20]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[2]),
        .Q(cnt[2]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[3]),
        .Q(cnt[3]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[4]),
        .Q(cnt[4]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[5]),
        .Q(cnt[5]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[6]),
        .Q(cnt[6]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[7] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[7]),
        .Q(cnt[7]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[8] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[8]),
        .Q(cnt[8]));
  FDCE #(
    .INIT(1'b0)) 
    \cnt_reg[9] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(p_0_in[9]),
        .Q(cnt[9]));
  LUT5 #(
    .INIT(32'hACACCCAC)) 
    dout_i_1
       (.I0(sync_ff2),
        .I1(w_start),
        .I2(\cnt[20]_i_3_n_0 ),
        .I3(\cnt[20]_i_2_n_0 ),
        .I4(cnt[16]),
        .O(dout_i_1_n_0));
  FDCE #(
    .INIT(1'b0)) 
    dout_reg
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(dout_i_1_n_0),
        .Q(w_start));
  FDCE #(
    .INIT(1'b0)) 
    sync_ff1_reg
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(btnR_IBUF),
        .Q(sync_ff1));
  FDCE #(
    .INIT(1'b0)) 
    sync_ff2_reg
       (.C(CLK),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(sync_ff1),
        .Q(sync_ff2));
endmodule

(* ECO_CHECKSUM = "b9cc5f69" *) 
(* NotValidForBitStream *)
module uart
   (clk,
    rst,
    btnR,
    tx_data,
    tx);
  input clk;
  input rst;
  input btnR;
  input [7:0]tx_data;
  output tx;

  wire btnR;
  wire btnR_IBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire rst;
  wire rst_IBUF;
  wire tx;
  wire tx_OBUF;
  wire [7:0]tx_data;
  wire [7:0]tx_data_IBUF;
  wire w_b_tick;
  wire w_start;
  wire w_start_d;

  baud_tick_gen U_BAUD_TICK_GEN
       (.CLK(clk_IBUF_BUFG),
        .rst_IBUF(rst_IBUF),
        .w_b_tick(w_b_tick));
  debounce U_BD_TX_START
       (.CLK(clk_IBUF_BUFG),
        .btnR_IBUF(btnR_IBUF),
        .rst_IBUF(rst_IBUF),
        .w_start(w_start));
  uart_tx U_UART_TX
       (.CLK(clk_IBUF_BUFG),
        .D(tx_data_IBUF),
        .rst_IBUF(rst_IBUF),
        .tx_OBUF(tx_OBUF),
        .w_b_tick(w_b_tick),
        .w_start(w_start),
        .w_start_d(w_start_d));
  IBUF btnR_IBUF_inst
       (.I(btnR),
        .O(btnR_IBUF));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  IBUF rst_IBUF_inst
       (.I(rst),
        .O(rst_IBUF));
  OBUF tx_OBUF_inst
       (.I(tx_OBUF),
        .O(tx));
  IBUF \tx_data_IBUF[0]_inst 
       (.I(tx_data[0]),
        .O(tx_data_IBUF[0]));
  IBUF \tx_data_IBUF[1]_inst 
       (.I(tx_data[1]),
        .O(tx_data_IBUF[1]));
  IBUF \tx_data_IBUF[2]_inst 
       (.I(tx_data[2]),
        .O(tx_data_IBUF[2]));
  IBUF \tx_data_IBUF[3]_inst 
       (.I(tx_data[3]),
        .O(tx_data_IBUF[3]));
  IBUF \tx_data_IBUF[4]_inst 
       (.I(tx_data[4]),
        .O(tx_data_IBUF[4]));
  IBUF \tx_data_IBUF[5]_inst 
       (.I(tx_data[5]),
        .O(tx_data_IBUF[5]));
  IBUF \tx_data_IBUF[6]_inst 
       (.I(tx_data[6]),
        .O(tx_data_IBUF[6]));
  IBUF \tx_data_IBUF[7]_inst 
       (.I(tx_data[7]),
        .O(tx_data_IBUF[7]));
  FDCE #(
    .INIT(1'b0)) 
    w_start_d_reg
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(w_start),
        .Q(w_start_d));
endmodule

module uart_tx
   (tx_OBUF,
    CLK,
    rst_IBUF,
    w_start_d,
    w_start,
    w_b_tick,
    D);
  output tx_OBUF;
  input CLK;
  input rst_IBUF;
  input w_start_d;
  input w_start;
  input w_b_tick;
  input [7:0]D;

  wire CLK;
  wire [7:0]D;
  wire \FSM_onehot_c_state[11]_i_1_n_0 ;
  wire \FSM_onehot_c_state[11]_i_2_n_0 ;
  wire \FSM_onehot_c_state[11]_i_3_n_0 ;
  wire \FSM_onehot_c_state[11]_i_4_n_0 ;
  wire \FSM_onehot_c_state_reg_n_0_[0] ;
  wire \FSM_onehot_c_state_reg_n_0_[10] ;
  wire \FSM_onehot_c_state_reg_n_0_[11] ;
  wire \FSM_onehot_c_state_reg_n_0_[1] ;
  wire \FSM_onehot_c_state_reg_n_0_[2] ;
  wire \FSM_onehot_c_state_reg_n_0_[3] ;
  wire \FSM_onehot_c_state_reg_n_0_[4] ;
  wire \FSM_onehot_c_state_reg_n_0_[5] ;
  wire \FSM_onehot_c_state_reg_n_0_[6] ;
  wire \FSM_onehot_c_state_reg_n_0_[7] ;
  wire \FSM_onehot_c_state_reg_n_0_[8] ;
  wire \FSM_onehot_c_state_reg_n_0_[9] ;
  wire data_next;
  wire \data_reg_reg_n_0_[0] ;
  wire p_0_in;
  wire p_1_in;
  wire p_2_in;
  wire p_3_in;
  wire p_4_in;
  wire p_5_in;
  wire p_6_in;
  wire rst_IBUF;
  wire tx_OBUF;
  wire tx_next;
  wire tx_reg;
  wire tx_reg_i_3_n_0;
  wire tx_reg_i_4_n_0;
  wire tx_reg_i_5_n_0;
  wire tx_reg_i_6_n_0;
  wire w_b_tick;
  wire w_start;
  wire w_start_d;

  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFE0)) 
    \FSM_onehot_c_state[11]_i_1 
       (.I0(\FSM_onehot_c_state_reg_n_0_[2] ),
        .I1(\FSM_onehot_c_state_reg_n_0_[3] ),
        .I2(w_b_tick),
        .I3(\FSM_onehot_c_state[11]_i_2_n_0 ),
        .I4(\FSM_onehot_c_state[11]_i_3_n_0 ),
        .I5(\FSM_onehot_c_state[11]_i_4_n_0 ),
        .O(\FSM_onehot_c_state[11]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFF080808)) 
    \FSM_onehot_c_state[11]_i_2 
       (.I0(\FSM_onehot_c_state_reg_n_0_[0] ),
        .I1(w_start),
        .I2(w_start_d),
        .I3(\FSM_onehot_c_state_reg_n_0_[1] ),
        .I4(w_b_tick),
        .O(\FSM_onehot_c_state[11]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hF0F0F0E0)) 
    \FSM_onehot_c_state[11]_i_3 
       (.I0(\FSM_onehot_c_state_reg_n_0_[9] ),
        .I1(\FSM_onehot_c_state_reg_n_0_[8] ),
        .I2(w_b_tick),
        .I3(\FSM_onehot_c_state_reg_n_0_[11] ),
        .I4(\FSM_onehot_c_state_reg_n_0_[10] ),
        .O(\FSM_onehot_c_state[11]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hF0F0F0E0)) 
    \FSM_onehot_c_state[11]_i_4 
       (.I0(\FSM_onehot_c_state_reg_n_0_[5] ),
        .I1(\FSM_onehot_c_state_reg_n_0_[4] ),
        .I2(w_b_tick),
        .I3(\FSM_onehot_c_state_reg_n_0_[7] ),
        .I4(\FSM_onehot_c_state_reg_n_0_[6] ),
        .O(\FSM_onehot_c_state[11]_i_4_n_0 ));
  (* FSM_ENCODED_STATES = "BIT0:000000001000,BIT1:000000010000,START:000000000100,STOP:100000000000,BIT7:010000000000,WAIT:000000000010,IDLE:000000000001,BIT6:001000000000,BIT4:000010000000,BIT5:000100000000,BIT3:000001000000,BIT2:000000100000" *) 
  FDPE #(
    .INIT(1'b1)) 
    \FSM_onehot_c_state_reg[0] 
       (.C(CLK),
        .CE(\FSM_onehot_c_state[11]_i_1_n_0 ),
        .D(\FSM_onehot_c_state_reg_n_0_[11] ),
        .PRE(rst_IBUF),
        .Q(\FSM_onehot_c_state_reg_n_0_[0] ));
  (* FSM_ENCODED_STATES = "BIT0:000000001000,BIT1:000000010000,START:000000000100,STOP:100000000000,BIT7:010000000000,WAIT:000000000010,IDLE:000000000001,BIT6:001000000000,BIT4:000010000000,BIT5:000100000000,BIT3:000001000000,BIT2:000000100000" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_c_state_reg[10] 
       (.C(CLK),
        .CE(\FSM_onehot_c_state[11]_i_1_n_0 ),
        .CLR(rst_IBUF),
        .D(\FSM_onehot_c_state_reg_n_0_[9] ),
        .Q(\FSM_onehot_c_state_reg_n_0_[10] ));
  (* FSM_ENCODED_STATES = "BIT0:000000001000,BIT1:000000010000,START:000000000100,STOP:100000000000,BIT7:010000000000,WAIT:000000000010,IDLE:000000000001,BIT6:001000000000,BIT4:000010000000,BIT5:000100000000,BIT3:000001000000,BIT2:000000100000" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_c_state_reg[11] 
       (.C(CLK),
        .CE(\FSM_onehot_c_state[11]_i_1_n_0 ),
        .CLR(rst_IBUF),
        .D(\FSM_onehot_c_state_reg_n_0_[10] ),
        .Q(\FSM_onehot_c_state_reg_n_0_[11] ));
  (* FSM_ENCODED_STATES = "BIT0:000000001000,BIT1:000000010000,START:000000000100,STOP:100000000000,BIT7:010000000000,WAIT:000000000010,IDLE:000000000001,BIT6:001000000000,BIT4:000010000000,BIT5:000100000000,BIT3:000001000000,BIT2:000000100000" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_c_state_reg[1] 
       (.C(CLK),
        .CE(\FSM_onehot_c_state[11]_i_1_n_0 ),
        .CLR(rst_IBUF),
        .D(\FSM_onehot_c_state_reg_n_0_[0] ),
        .Q(\FSM_onehot_c_state_reg_n_0_[1] ));
  (* FSM_ENCODED_STATES = "BIT0:000000001000,BIT1:000000010000,START:000000000100,STOP:100000000000,BIT7:010000000000,WAIT:000000000010,IDLE:000000000001,BIT6:001000000000,BIT4:000010000000,BIT5:000100000000,BIT3:000001000000,BIT2:000000100000" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_c_state_reg[2] 
       (.C(CLK),
        .CE(\FSM_onehot_c_state[11]_i_1_n_0 ),
        .CLR(rst_IBUF),
        .D(\FSM_onehot_c_state_reg_n_0_[1] ),
        .Q(\FSM_onehot_c_state_reg_n_0_[2] ));
  (* FSM_ENCODED_STATES = "BIT0:000000001000,BIT1:000000010000,START:000000000100,STOP:100000000000,BIT7:010000000000,WAIT:000000000010,IDLE:000000000001,BIT6:001000000000,BIT4:000010000000,BIT5:000100000000,BIT3:000001000000,BIT2:000000100000" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_c_state_reg[3] 
       (.C(CLK),
        .CE(\FSM_onehot_c_state[11]_i_1_n_0 ),
        .CLR(rst_IBUF),
        .D(\FSM_onehot_c_state_reg_n_0_[2] ),
        .Q(\FSM_onehot_c_state_reg_n_0_[3] ));
  (* FSM_ENCODED_STATES = "BIT0:000000001000,BIT1:000000010000,START:000000000100,STOP:100000000000,BIT7:010000000000,WAIT:000000000010,IDLE:000000000001,BIT6:001000000000,BIT4:000010000000,BIT5:000100000000,BIT3:000001000000,BIT2:000000100000" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_c_state_reg[4] 
       (.C(CLK),
        .CE(\FSM_onehot_c_state[11]_i_1_n_0 ),
        .CLR(rst_IBUF),
        .D(\FSM_onehot_c_state_reg_n_0_[3] ),
        .Q(\FSM_onehot_c_state_reg_n_0_[4] ));
  (* FSM_ENCODED_STATES = "BIT0:000000001000,BIT1:000000010000,START:000000000100,STOP:100000000000,BIT7:010000000000,WAIT:000000000010,IDLE:000000000001,BIT6:001000000000,BIT4:000010000000,BIT5:000100000000,BIT3:000001000000,BIT2:000000100000" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_c_state_reg[5] 
       (.C(CLK),
        .CE(\FSM_onehot_c_state[11]_i_1_n_0 ),
        .CLR(rst_IBUF),
        .D(\FSM_onehot_c_state_reg_n_0_[4] ),
        .Q(\FSM_onehot_c_state_reg_n_0_[5] ));
  (* FSM_ENCODED_STATES = "BIT0:000000001000,BIT1:000000010000,START:000000000100,STOP:100000000000,BIT7:010000000000,WAIT:000000000010,IDLE:000000000001,BIT6:001000000000,BIT4:000010000000,BIT5:000100000000,BIT3:000001000000,BIT2:000000100000" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_c_state_reg[6] 
       (.C(CLK),
        .CE(\FSM_onehot_c_state[11]_i_1_n_0 ),
        .CLR(rst_IBUF),
        .D(\FSM_onehot_c_state_reg_n_0_[5] ),
        .Q(\FSM_onehot_c_state_reg_n_0_[6] ));
  (* FSM_ENCODED_STATES = "BIT0:000000001000,BIT1:000000010000,START:000000000100,STOP:100000000000,BIT7:010000000000,WAIT:000000000010,IDLE:000000000001,BIT6:001000000000,BIT4:000010000000,BIT5:000100000000,BIT3:000001000000,BIT2:000000100000" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_c_state_reg[7] 
       (.C(CLK),
        .CE(\FSM_onehot_c_state[11]_i_1_n_0 ),
        .CLR(rst_IBUF),
        .D(\FSM_onehot_c_state_reg_n_0_[6] ),
        .Q(\FSM_onehot_c_state_reg_n_0_[7] ));
  (* FSM_ENCODED_STATES = "BIT0:000000001000,BIT1:000000010000,START:000000000100,STOP:100000000000,BIT7:010000000000,WAIT:000000000010,IDLE:000000000001,BIT6:001000000000,BIT4:000010000000,BIT5:000100000000,BIT3:000001000000,BIT2:000000100000" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_c_state_reg[8] 
       (.C(CLK),
        .CE(\FSM_onehot_c_state[11]_i_1_n_0 ),
        .CLR(rst_IBUF),
        .D(\FSM_onehot_c_state_reg_n_0_[7] ),
        .Q(\FSM_onehot_c_state_reg_n_0_[8] ));
  (* FSM_ENCODED_STATES = "BIT0:000000001000,BIT1:000000010000,START:000000000100,STOP:100000000000,BIT7:010000000000,WAIT:000000000010,IDLE:000000000001,BIT6:001000000000,BIT4:000010000000,BIT5:000100000000,BIT3:000001000000,BIT2:000000100000" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_c_state_reg[9] 
       (.C(CLK),
        .CE(\FSM_onehot_c_state[11]_i_1_n_0 ),
        .CLR(rst_IBUF),
        .D(\FSM_onehot_c_state_reg_n_0_[8] ),
        .Q(\FSM_onehot_c_state_reg_n_0_[9] ));
  LUT3 #(
    .INIT(8'h20)) 
    \data_reg[7]_i_1 
       (.I0(\FSM_onehot_c_state_reg_n_0_[0] ),
        .I1(w_start_d),
        .I2(w_start),
        .O(data_next));
  FDCE #(
    .INIT(1'b0)) 
    \data_reg_reg[0] 
       (.C(CLK),
        .CE(data_next),
        .CLR(rst_IBUF),
        .D(D[0]),
        .Q(\data_reg_reg_n_0_[0] ));
  FDCE #(
    .INIT(1'b0)) 
    \data_reg_reg[1] 
       (.C(CLK),
        .CE(data_next),
        .CLR(rst_IBUF),
        .D(D[1]),
        .Q(p_6_in));
  FDCE #(
    .INIT(1'b0)) 
    \data_reg_reg[2] 
       (.C(CLK),
        .CE(data_next),
        .CLR(rst_IBUF),
        .D(D[2]),
        .Q(p_5_in));
  FDCE #(
    .INIT(1'b0)) 
    \data_reg_reg[3] 
       (.C(CLK),
        .CE(data_next),
        .CLR(rst_IBUF),
        .D(D[3]),
        .Q(p_4_in));
  FDCE #(
    .INIT(1'b0)) 
    \data_reg_reg[4] 
       (.C(CLK),
        .CE(data_next),
        .CLR(rst_IBUF),
        .D(D[4]),
        .Q(p_3_in));
  FDCE #(
    .INIT(1'b0)) 
    \data_reg_reg[5] 
       (.C(CLK),
        .CE(data_next),
        .CLR(rst_IBUF),
        .D(D[5]),
        .Q(p_2_in));
  FDCE #(
    .INIT(1'b0)) 
    \data_reg_reg[6] 
       (.C(CLK),
        .CE(data_next),
        .CLR(rst_IBUF),
        .D(D[6]),
        .Q(p_1_in));
  FDCE #(
    .INIT(1'b0)) 
    \data_reg_reg[7] 
       (.C(CLK),
        .CE(data_next),
        .CLR(rst_IBUF),
        .D(D[7]),
        .Q(p_0_in));
  LUT3 #(
    .INIT(8'hFE)) 
    tx_reg_i_1
       (.I0(\FSM_onehot_c_state_reg_n_0_[1] ),
        .I1(\FSM_onehot_c_state_reg_n_0_[0] ),
        .I2(w_b_tick),
        .O(tx_reg));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    tx_reg_i_2
       (.I0(\FSM_onehot_c_state_reg_n_0_[0] ),
        .I1(\FSM_onehot_c_state_reg_n_0_[1] ),
        .I2(\FSM_onehot_c_state_reg_n_0_[11] ),
        .I3(tx_reg_i_3_n_0),
        .I4(tx_reg_i_4_n_0),
        .O(tx_next));
  LUT5 #(
    .INIT(32'hFFFFF888)) 
    tx_reg_i_3
       (.I0(\FSM_onehot_c_state_reg_n_0_[8] ),
        .I1(p_2_in),
        .I2(\FSM_onehot_c_state_reg_n_0_[4] ),
        .I3(p_6_in),
        .I4(tx_reg_i_5_n_0),
        .O(tx_reg_i_3_n_0));
  LUT5 #(
    .INIT(32'hFFFFF888)) 
    tx_reg_i_4
       (.I0(\FSM_onehot_c_state_reg_n_0_[7] ),
        .I1(p_3_in),
        .I2(\FSM_onehot_c_state_reg_n_0_[10] ),
        .I3(p_0_in),
        .I4(tx_reg_i_6_n_0),
        .O(tx_reg_i_4_n_0));
  LUT4 #(
    .INIT(16'hF888)) 
    tx_reg_i_5
       (.I0(p_1_in),
        .I1(\FSM_onehot_c_state_reg_n_0_[9] ),
        .I2(\data_reg_reg_n_0_[0] ),
        .I3(\FSM_onehot_c_state_reg_n_0_[3] ),
        .O(tx_reg_i_5_n_0));
  LUT4 #(
    .INIT(16'hF888)) 
    tx_reg_i_6
       (.I0(p_4_in),
        .I1(\FSM_onehot_c_state_reg_n_0_[6] ),
        .I2(p_5_in),
        .I3(\FSM_onehot_c_state_reg_n_0_[5] ),
        .O(tx_reg_i_6_n_0));
  FDPE #(
    .INIT(1'b1)) 
    tx_reg_reg
       (.C(CLK),
        .CE(tx_reg),
        .D(tx_next),
        .PRE(rst_IBUF),
        .Q(tx_OBUF));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
