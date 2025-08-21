----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2025 08:59:52
-- Design Name: 
-- Module Name: rs232_tx - Behavioral
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

entity rs232_tx is
 Port (
        clk_i   : in  STD_LOGIC;   
        TXD_o     : out STD_LOGIC := '1';
        data_i    : in  STD_LOGIC_VECTOR (7 downto 0);
        tx_start  : in  STD_LOGIC;
        tx_busy   : out STD_LOGIC := '0'
    );
end rs232_tx;

architecture Behavioral of rs232_tx is

    constant TRANSMISSION   : integer := 9600;
    constant CLK            : integer := 100_000_000;
    constant BAUD_COUNT     : integer := CLK / TRANSMISSION;
    constant HALF_BAUD      : integer := BAUD_COUNT / 2;
    
    type tx_state_type is (TX_IDLE, TX_START_BIT, TX_DATA_BITS, TX_STOP_BIT);
    signal tx_state : tx_state_type := TX_IDLE;
    
    -- Safe state attributes
    attribute fsm_safe_state : string;
    attribute fsm_safe_state of tx_state : signal is "TX_IDLE";
    attribute fsm_encoding : string;
    attribute fsm_encoding of tx_state : signal is "gray";
    
    signal tx_data_reg         : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    
    signal tx_baud_counter     : integer range 0 to BAUD_COUNT-1 := 0;
    signal tx_bit_counter      : integer range 0 to 7 := 0;

begin

tx_process: process(clk_i)
	begin
		
		if rising_edge(clk_i) then
            
            case tx_state is
                when TX_IDLE =>
                    TXD_o <= '1';
                    tx_busy <= '0';
                    if tx_start = '1' then
                        tx_data_reg <= data_i;
                        tx_state <= TX_START_BIT;
                        tx_baud_counter <= 0;
                        tx_bit_counter <= 0;
                        tx_busy <= '1';
                    end if;
                
                when TX_START_BIT =>
                    if tx_baud_counter = BAUD_COUNT - 1 then
                        TXD_o <= '0';
                        tx_state <= TX_DATA_BITS;
                        tx_baud_counter <= 0;
                    else
                        tx_baud_counter <= tx_baud_counter + 1;
                    end if;
                
                when TX_DATA_BITS =>
                    if tx_baud_counter = BAUD_COUNT-1 then
                        tx_baud_counter <= 0;
                        TXD_o <= tx_data_reg(tx_bit_counter);                     
                        if tx_bit_counter = 7 then
                            tx_state <= TX_STOP_BIT;
                            tx_bit_counter <= 0;
                        else
                            tx_bit_counter <= tx_bit_counter + 1;
                        end if;
                    else
                        tx_baud_counter <= tx_baud_counter + 1;
                    end if;
                
                when TX_STOP_BIT =>
                    if tx_baud_counter = BAUD_COUNT-1 then
                        TXD_o <= '1';
                        tx_state <= TX_IDLE;
                        tx_baud_counter <= 0;
                    else
                        tx_baud_counter <= tx_baud_counter + 1;
                    end if;
                
                when others =>
                    tx_state <= TX_IDLE;
            end case;
        end if;
	end process;

end Behavioral;
