`timescale 1 ps / 1 ps

module GPIO_Test_wrapper
   (GPIOA,
    reset,
    sys_clock,
    usb_uart_rxd,
    usb_uart_txd);
  inout [7:0]GPIOA;
  input reset;
  input sys_clock;
  input usb_uart_rxd;
  output usb_uart_txd;

  wire [7:0]GPIOA;
  wire reset;
  wire sys_clock;
  wire usb_uart_rxd;
  wire usb_uart_txd;

  GPIO_Test GPIO_Test_i
       (.GPIOA(GPIOA),
        .reset(reset),
        .sys_clock(sys_clock),
        .usb_uart_rxd(usb_uart_rxd),
        .usb_uart_txd(usb_uart_txd));
endmodule
