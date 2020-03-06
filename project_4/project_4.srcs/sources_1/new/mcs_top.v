`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2020 08:28:03 AM
// Design Name: 
// Module Name: mcs_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mcs_top(
    input           clk_fpga,
    input           reset,
    input           vgaReset,
    input           rx,
    output          tx,
    input  [1:0]    sw,
    input           pushBut,
    output [3:0]    led,
    
    output [3:0]    vgaRed,
    output [3:0]    vgaGreen,
    output [3:0]    vgaBlue,
    output          hSync,
    output          vSync,
    
    output [6:0]    seg,
    output [3:0]    an
);

parameter ones = 4'b1111;
parameter zeroes = 4'b0000;
    
wire [10:0] hcount;
wire [10:0] vcount;
wire blank;
wire locked;
wire clk_100M;
wire clk_25M;
wire [18:0] outPos;
wire [15:0] outSeg;
wire [11:0] outCol;

wire [8:0] vertPos;
wire [9:0] horzPos;
wire blockConstraint;

clk_wiz_0 clk(
    // Clock out ports
    .clk_100M(clk_100M),     // output clk_100M
    .clk_25M(clk_25M),     // output clk_25M
    // Status and control signals
    .reset(reset), // input reset
    .locked(locked),       // output locked
    // Clock in ports
    .clk_in1(clk_fpga)
);      // input clk_in1
    
microblaze_mcs_0 micro (
  .Clk(clk_100M),                  // input wire Clk
  .Reset(reset),              // input wire Reset
  .UART_rxd(rx),        // input wire UART_rxd
  .UART_txd(tx),        // output wire UART_txd
  .GPIO1_tri_i(sw),  // input wire [1 : 0] GPIO1_tri_i
  .GPIO1_tri_o(outPos),  // output wire [18 : 0] GPIO1_tri_o
  .GPIO2_tri_i(pushBut),  // input wire [0 : 0] GPIO2_tri_i
  .GPIO2_tri_o(outSeg),  // output wire [15 : 0] GPIO2_tri_o
  .GPIO3_tri_o(led),  // output wire [3 : 0] GPIO3_tri_o
  .GPIO4_tri_o(outCol)  // output wire [11 : 0] GPIO4_tri_o
);
    
seven_seg u1 (
    .clk(clk_25M),
    .A(outSeg[3:0]),
    .B(outSeg[7:4]),
    .C(outSeg[11:8]),
    .D(outSeg[15:12]),
    .ANODE(an),
    .SEG_TOP(seg)
);
    
vga_controller_640_60 u2 (
    .rst(vgaReset),
    .pixel_clk(clk_25M),
    .HS(hSync),
    .VS(vSync),
    .hcount(hcount),
    .vcount(vcount),
    .blank(blank)
);


//assign vertPos = outPos[3:0];
//assign horzPos = outPos[8:4];

//assign blockConstraint = 
//    (vcount >= 32 * vertPos && vcount <= 32 * vertPos + 32) &&
//     (hcount >= 32 * horzPos && hcount <= 32 * horzPos + 32);

assign vertPos = outPos[8:0];
assign horzPos = outPos[18:9];

wire [5:0] blockSize;
assign blockSize = (sw[1] == 0) ? 6'd32 : 6'd20;

assign blockConstraint = 
    (vcount >= vertPos && vcount <= vertPos + blockSize) &&
     (hcount >= horzPos && hcount <= horzPos + blockSize);
                             
assign vgaRed = blank ? zeroes : blockConstraint ? outCol[11:8] : zeroes;
assign vgaBlue = blank ? zeroes : blockConstraint ? outCol[7:4] : zeroes;
assign vgaGreen = blank ? zeroes : blockConstraint ? outCol[3:0] : zeroes;                             

endmodule
