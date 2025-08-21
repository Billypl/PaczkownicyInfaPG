----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2025 08:58:01
-- Design Name: 
-- Module Name: rs232_rx - Behavioral
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

entity rs232_rx is
 Port (
        clk_i   : in  STD_LOGIC;   
        RXD_i   : in  STD_LOGIC;  
        data_o  : out STD_LOGIC_VECTOR (7 downto 0)  := (others=>'0');
        data_valid : out STD_LOGIC := '0'
    );
end rs232_rx;

architecture Behavioral of rs232_rx is

    constant TRANSMISSION   : integer := 9600;
    constant CLK            : integer := 100_000_000;
    constant BAUD_COUNT     : integer := CLK / TRANSMISSION;
    constant HALF_BAUD      : integer := BAUD_COUNT / 2;
    
    type rx_state_type is (RX_IDLE, RX_START_BIT, RX_DATA_BITS, RX_STOP_BIT);
    signal rx_state : rx_state_type := RX_IDLE;
    
    -- Safe state attributes
    attribute fsm_safe_state : string;
    attribute fsm_safe_state of rx_state : signal is "RX_IDLE";
    attribute fsm_encoding : string;
    attribute fsm_encoding of rx_state : signal is "gray";
    
    signal RXD_sync         : STD_LOGIC_VECTOR(1 downto 0) := "11";
    signal rx_baud_counter     : integer range 0 to BAUD_COUNT-1 := 0;
    signal rx_bit_counter      : integer range 0 to 7 := 0;
    signal rx_shift_reg        : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal rx_data_reg         : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    
begin

    process(clk_i)
    begin
        if rising_edge(clk_i) then
            RXD_sync <= RXD_sync(0) & RXD_i;
        end if;
    end process;
    
	rx_process: process(clk_i)
	begin
		
		if rising_edge(clk_i) then
            data_valid <= '0'; -- default
            
            case rx_state is
                when RX_IDLE =>
                    -- Wait for start bit (falling edge)
                    if RXD_sync = "10" then
                        rx_state <= RX_START_BIT;
                        rx_baud_counter <= 0;
                    end if;
                
                when RX_START_BIT =>
                    if rx_baud_counter = BAUD_COUNT - 1 then
                        -- Sample start bit in the middle
                        if RXD_sync(1) = '0' then
                            rx_state <= RX_DATA_BITS;
                            rx_baud_counter <= 0;
                            rx_bit_counter <= 0;
                        else
                            rx_state <= RX_IDLE;
                        end if;
                    else
                        rx_baud_counter <= rx_baud_counter + 1;
                    end if;
                
                when RX_DATA_BITS =>
                    if rx_baud_counter = BAUD_COUNT-1 then
                        rx_baud_counter <= 0;
                        -- Shift in data (LSB first)
                        rx_shift_reg <= RXD_sync(1) & rx_shift_reg(7 downto 1);
                        
                        if rx_bit_counter = 7 then
                            rx_state <= RX_STOP_BIT;
                        else
                            rx_bit_counter <= rx_bit_counter + 1;
                        end if;
                    else
                        rx_baud_counter <= rx_baud_counter + 1;
                    end if;
                
                when RX_STOP_BIT =>
                    if rx_baud_counter = BAUD_COUNT-1 then
                        -- Check stop bit (should be '1')
                        if RXD_sync(1) = '1' then
                            rx_data_reg <= rx_shift_reg;
                            data_valid <= '1';
                        end if;
                        rx_state <= RX_IDLE;
                    else
                        rx_baud_counter <= rx_baud_counter + 1;
                    end if;
                
                when others =>
                    rx_state <= RX_IDLE;
            end case;
        end if;
	end process;

	data_o <= rx_data_reg;
end Behavioral;
