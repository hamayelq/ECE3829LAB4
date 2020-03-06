//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Command: generate_target bd_fc5c_0_wrapper.bd
//Design : bd_fc5c_0_wrapper
//Purpose: IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module bd_fc5c_0_wrapper
   (Clk,
    GPIO1_tri_i,
    GPIO1_tri_o,
    GPIO2_tri_i,
    GPIO2_tri_o,
    GPIO3_tri_o,
    GPIO4_tri_o,
    Reset,
    UART_rxd,
    UART_txd);
  input Clk;
  input [1:0]GPIO1_tri_i;
  output [18:0]GPIO1_tri_o;
  input [0:0]GPIO2_tri_i;
  output [15:0]GPIO2_tri_o;
  output [3:0]GPIO3_tri_o;
  output [11:0]GPIO4_tri_o;
  input Reset;
  input UART_rxd;
  output UART_txd;

  wire Clk;
  wire [1:0]GPIO1_tri_i;
  wire [18:0]GPIO1_tri_o;
  wire [0:0]GPIO2_tri_i;
  wire [15:0]GPIO2_tri_o;
  wire [3:0]GPIO3_tri_o;
  wire [11:0]GPIO4_tri_o;
  wire Reset;
  wire UART_rxd;
  wire UART_txd;

  bd_fc5c_0 bd_fc5c_0_i
       (.Clk(Clk),
        .GPIO1_tri_i(GPIO1_tri_i),
        .GPIO1_tri_o(GPIO1_tri_o),
        .GPIO2_tri_i(GPIO2_tri_i),
        .GPIO2_tri_o(GPIO2_tri_o),
        .GPIO3_tri_o(GPIO3_tri_o),
        .GPIO4_tri_o(GPIO4_tri_o),
        .Reset(Reset),
        .UART_rxd(UART_rxd),
        .UART_txd(UART_txd));
endmodule
