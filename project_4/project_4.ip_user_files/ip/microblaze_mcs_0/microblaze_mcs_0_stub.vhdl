-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Tue Mar  3 09:25:47 2020
-- Host        : AK113-06 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/nhtranngoc/Documents/ECE3829LAB4/project_4/project_4.srcs/sources_1/ip/microblaze_mcs_0/microblaze_mcs_0_stub.vhdl
-- Design      : microblaze_mcs_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity microblaze_mcs_0 is
  Port ( 
    Clk : in STD_LOGIC;
    Reset : in STD_LOGIC;
    UART_rxd : in STD_LOGIC;
    UART_txd : out STD_LOGIC;
    GPIO1_tri_i : in STD_LOGIC_VECTOR ( 0 to 0 );
    GPIO1_tri_o : out STD_LOGIC_VECTOR ( 8 downto 0 );
    GPIO2_tri_i : in STD_LOGIC_VECTOR ( 0 to 0 );
    GPIO2_tri_o : out STD_LOGIC_VECTOR ( 15 downto 0 );
    GPIO3_tri_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
    GPIO4_tri_o : out STD_LOGIC_VECTOR ( 11 downto 0 )
  );

end microblaze_mcs_0;

architecture stub of microblaze_mcs_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "Clk,Reset,UART_rxd,UART_txd,GPIO1_tri_i[0:0],GPIO1_tri_o[8:0],GPIO2_tri_i[0:0],GPIO2_tri_o[15:0],GPIO3_tri_o[3:0],GPIO4_tri_o[11:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "bd_fc5c_0,Vivado 2019.1";
begin
end;
