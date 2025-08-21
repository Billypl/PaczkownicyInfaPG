----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2025 13:36:49
-- Design Name: 
-- Module Name: encoder - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity encoder is
    Port (
        clk_i    : in  STD_LOGIC;
        btn_i    : in  STD_LOGIC_VECTOR (3 downto 0);
        sw_i     : in  STD_LOGIC_VECTOR (7 downto 0);
        digit_o  : out STD_LOGIC_VECTOR (31 downto 0)
    );
end encoder;

architecture Behavioral of encoder is
    signal dig3, dig2, dig1, dig0 : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal btn_sync, btn_prev      : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal btn_pressed             : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

    function hex_to_seg(hex : STD_LOGIC_VECTOR(3 downto 0)) return STD_LOGIC_VECTOR is
    begin
        case hex is
            when x"0"   => return "0000001";
            when x"1"   => return "1001111";
            when x"2"   => return "0010010";
            when x"3"   => return "0000110";
            when x"4"   => return "1001100";
            when x"5"   => return "0100100";
            when x"6"   => return "0100000";
            when x"7"   => return "0001111";
            when x"8"   => return "0000000";
            when x"9"   => return "0000100";
            when x"A"   => return "0001000";
            when x"B"   => return "1100000";
            when x"C"   => return "0110001";
            when x"D"   => return "1000010";
            when x"E"   => return "0110000";
            when x"F"   => return "0111000";
            when others => return "1111111";
        end case;
    end function;
    
begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            btn_sync <= btn_i;
            btn_prev <= btn_sync;
        end if;
    end process;

    process(clk_i)
    begin
        if rising_edge(clk_i) then
            btn_pressed <= (others => '0');
            for i in 0 to 3 loop
                if btn_prev(i) = '0' and btn_sync(i) = '1' then
                    btn_pressed(i) <= '1';
                end if;
            end loop;
        end if;
    end process;
    
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            for i in 0 to 3 loop
                if btn_pressed(i) = '1' then
                    case i is
                        when 3 => dig3 <= sw_i(3 downto 0);
                        when 2 => dig2 <= sw_i(3 downto 0);
                        when 1 => dig1 <= sw_i(3 downto 0);
                        when 0 => dig0 <= sw_i(3 downto 0);
                    end case;
                end if;
            end loop;
        end if;
    end process;

    digit_o(31 downto 24) <= hex_to_seg(dig3) & sw_i(7);
    digit_o(23 downto 16) <= hex_to_seg(dig2) & sw_i(6);
    digit_o(15 downto 8)  <= hex_to_seg(dig1) & sw_i(5);
    digit_o(7 downto 0)   <= hex_to_seg(dig0) & sw_i(4);
end Behavioral;
