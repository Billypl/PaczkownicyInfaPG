library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.seg7_utils.all;

entity tb_rs232_display is
end tb_rs232_display;

architecture Behavioral of tb_rs232_display is
    -- Constants
    constant CLK_PERIOD : time := 10 ns;    -- 100 MHz clock
    constant BIT_PERIOD : time := 104167 ns; -- 9600 baud (1/9600 sec)
    
    -- DUT Signals
    signal clk_i      : std_logic := '0';
    signal rst_i      : std_logic := '1';
    signal RXD_i      : std_logic := '1';
    signal led7_an_o  : std_logic_vector(3 downto 0);
    signal led7_seg_o : std_logic_vector(7 downto 0);
    
    signal test_data  : std_logic_vector(7 downto 0) := x"00";
begin
    dut: entity work.top
    port map (
        clk_i      => clk_i,
        rst_i      => rst_i,
        RXD_i      => RXD_i,
        led7_an_o  => led7_an_o,
        led7_seg_o => led7_seg_o
    );
    
    clk_i <= not clk_i after CLK_PERIOD/2;
    
    uart_send_proc: process
    procedure uart_send_byte(
        data : in std_logic_vector(7 downto 0);
        speed_multiplier : in real -- Allows modifying the wait duration
    ) is
    begin
        RXD_i <= '0';
        wait for BIT_PERIOD * speed_multiplier;
        
        for i in 0 to 7 loop
            RXD_i <= data(i);
            wait for BIT_PERIOD * speed_multiplier;
        end loop;
        
        RXD_i <= '1';
        wait for BIT_PERIOD * speed_multiplier;
    end procedure;

    begin
        -- Reset system
        rst_i <= '1';
        wait for 100 ns;
        rst_i <= '0';
        wait for 100 ns;
        
        wait for 10*BIT_PERIOD;
        
--        uart_send_byte(x"53", 1.00);
--        wait for 70*BIT_PERIOD;
        
        uart_send_byte(x"53", 0.96);
        wait for 70*BIT_PERIOD;
        
        uart_send_byte(x"53", 1.04);
        wait for 50*BIT_PERIOD;
        
        wait;
    end process;
    
end Behavioral;