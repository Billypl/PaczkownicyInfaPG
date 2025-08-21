library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package seg7_utils is
    -- Convert 4-bit hex to 7-segment display pattern
    function hex_to_7seg(hex : std_logic_vector(3 downto 0)) 
        return std_logic_vector;
end package;

package body seg7_utils is
    function hex_to_7seg(hex : std_logic_vector(3 downto 0)) 
        return std_logic_vector is
    begin
        case hex is
            when x"0"   => return "00000011";
            when x"1"   => return "10011111";
            when x"2"   => return "00100101";
            when x"3"   => return "00001101";
            when x"4"   => return "10011001";
            when x"5"   => return "01001001";
            when x"6"   => return "01000001";
            when x"7"   => return "00011111";
            when x"8"   => return "00000001";
            when x"9"   => return "00001001";
            when x"A"   => return "00010001";
            when x"B"   => return "11000001";
            when x"C"   => return "01100011";
            when x"D"   => return "10000101";
            when x"E"   => return "01100001";
            when x"F"   => return "01110001";
            when others => return "11111111";
        end case;
    end function;
end package body;