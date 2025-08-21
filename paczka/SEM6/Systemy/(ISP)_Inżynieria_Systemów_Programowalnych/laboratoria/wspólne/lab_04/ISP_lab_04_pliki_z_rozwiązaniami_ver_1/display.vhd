library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.seg7_utils.all;

entity display is
    Generic (
        DIVIDER_COUNT : integer := 100000  -- 100 MHz to 1 kHz
    );
    Port (
        clk_i      : in  STD_LOGIC;
        rst_i      : in  STD_LOGIC;
        digit_i    : in  STD_LOGIC_VECTOR (31 downto 0);
        led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
        led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
    );
end display;

architecture Behavioral of display is
    signal counter       : integer range 0 to DIVIDER_COUNT := 0;
    signal tick          : STD_LOGIC := '0';
    signal current_digit : integer range 0 to 3 := 0;
begin
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            counter <= 0;
            tick <= '0';
        elsif rising_edge(clk_i) then
            if counter = DIVIDER_COUNT then
                counter <= 0;
                tick <= '1';
            else
                counter <= counter + 1;
                tick <= '0';
            end if;
        end if;
    end process;
    
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            current_digit <= 0;
            led7_an_o <= (others => '1'); -- All displays off
            led7_seg_o <= (others => '1');
        elsif rising_edge(clk_i) then
            if tick = '1' then
                current_digit <= (current_digit + 1) mod 4;
            end if;

            case current_digit is
                when 0 => 
                    led7_an_o <= "1110";
                    led7_seg_o <= digit_i(7 downto 0);
                when 1 => 
                    led7_an_o <= "1101";
                    led7_seg_o <= digit_i(15 downto 8);
                when 2 => 
                    led7_an_o <= "1011";
                    led7_seg_o <= digit_i(23 downto 16);
                when 3 => 
                    led7_an_o <= "0111";
                    led7_seg_o <= digit_i(31 downto 24);
            end case;
        end if;
    end process;
end Behavioral;