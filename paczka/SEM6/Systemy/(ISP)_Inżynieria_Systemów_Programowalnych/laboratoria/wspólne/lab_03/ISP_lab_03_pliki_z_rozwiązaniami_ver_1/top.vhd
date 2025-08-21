----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2025 11:37:23
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( clk_i      : in  STD_LOGIC;
           btn_i      : in  STD_LOGIC_VECTOR (3 downto 0);
           sw_i       : in  STD_LOGIC_VECTOR (7 downto 0);
           led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
           led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0));
end top;

architecture Behavioral of top is
    component display is
        Generic ( DIVIDER_COUNT : integer );
        Port ( clk_i      : in  STD_LOGIC;
               rst_i      : in  STD_LOGIC;
               digit_i    : in  STD_LOGIC_VECTOR (31 downto 0);
               led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
               led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    component encoder is
        Port ( clk_i    : in  STD_LOGIC;
               btn_i    : in  STD_LOGIC_VECTOR (3 downto 0);
               sw_i     : in  STD_LOGIC_VECTOR (7 downto 0);
               digit_o  : out STD_LOGIC_VECTOR (31 downto 0));
    end component;

    signal rst_i    : STD_LOGIC := '0';
    signal digit_i  : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
begin
    encoder_inst: encoder
        port map (
            clk_i   => clk_i,
            btn_i   => btn_i,
            sw_i    => sw_i,
            digit_o => digit_i
        );

    display_inst: display
        generic map ( DIVIDER_COUNT => 100000 )
        port map (
            clk_i      => clk_i,
            rst_i      => rst_i,
            digit_i    => digit_i,
            led7_an_o  => led7_an_o,
            led7_seg_o => led7_seg_o
        );
end Behavioral;
