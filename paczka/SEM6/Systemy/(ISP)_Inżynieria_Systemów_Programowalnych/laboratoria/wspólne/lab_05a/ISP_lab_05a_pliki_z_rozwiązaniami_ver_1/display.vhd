----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2025 17:44:19
-- Design Name: 
-- Module Name: display - Behavioral
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

entity display is
 Port (
        clk_i       : in  STD_LOGIC;
        digit_i     : in  STD_LOGIC_VECTOR (31 downto 0);
        led7_an_o   : out STD_LOGIC_VECTOR (3 downto 0);
        led7_seg_o  : out STD_LOGIC_VECTOR (7 downto 0)
    );
end display;

architecture Behavioral of display is
    signal counter     : INTEGER := 0;
    signal anode_sel   : integer := 0;
    signal segment_out : STD_LOGIC_VECTOR(7 downto 0);

    constant CLK_DIV : INTEGER := 100_000; -- 100 MHz -> 1 kHz

begin
    process(clk_i)
    begin
        if anode_sel = 4 then
            counter <= 0;
            anode_sel <= 0;
        elsif rising_edge(clk_i) then
            if counter = CLK_DIV then
                counter <= 0;
                anode_sel <= anode_sel + 1;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    process(anode_sel, digit_i)
    begin
        case anode_sel is
            when 0 => led7_an_o <= "1110"; segment_out <= digit_i(7 downto 0);
            when 1 => led7_an_o <= "1101"; segment_out <= digit_i(15 downto 8);
            when 2 => led7_an_o <= "1011"; segment_out <= digit_i(23 downto 16);
            when 3 => led7_an_o <= "0111"; segment_out <= digit_i(31 downto 24);
            when others => led7_an_o <="1111";
        end case;
    end process;

    led7_seg_o <= segment_out;
end Behavioral;
