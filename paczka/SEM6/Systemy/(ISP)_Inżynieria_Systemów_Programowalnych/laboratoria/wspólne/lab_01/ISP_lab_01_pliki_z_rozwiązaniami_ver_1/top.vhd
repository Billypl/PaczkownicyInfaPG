----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2025 02:34:29 PM
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
    Port ( sw_i : in STD_LOGIC_VECTOR (7 downto 0);
           led7_an_o : out STD_LOGIC_VECTOR (3 downto 0);
           led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0));
end top;


architecture Behavioral of top is

signal parity : std_logic;
signal temp : std_logic_vector(5 downto 0);
begin
    temp(0) <= sw_i(0) xor sw_i(1);
    temp(1) <= temp(0) xor sw_i(2);
    temp(2) <= temp(1) xor sw_i(3);
    temp(3) <= temp(2) xor sw_i(4);
    temp(4) <= temp(3) xor sw_i(5);
    temp(5) <= temp(4) xor sw_i(6);
    parity <= not(temp(5) xor sw_i(7));
    
    led7_an_o <= "0111";
    led7_seg_o <= "01100001" when parity = '1' else "00000011";
    

end Behavioral;
