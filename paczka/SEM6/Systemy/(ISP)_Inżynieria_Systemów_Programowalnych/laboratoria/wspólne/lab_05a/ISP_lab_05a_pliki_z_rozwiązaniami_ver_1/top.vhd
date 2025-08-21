----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.03.2025 10:32:26
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port (
        clk_i       : in  STD_LOGIC;
        RXD_i       : in  STD_LOGIC;
        TXD_o       : out  STD_LOGIC;
        ld0         : out STD_LOGIC;
        led7_an_o   : out STD_LOGIC_VECTOR (3 downto 0);
        led7_seg_o  : out STD_LOGIC_VECTOR (7 downto 0)
    );
end top;

architecture Behavioral of top is
    
    signal rx_data   : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal tx_data   : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal valid_rx  : STD_LOGIC := '0';
    signal digit_data : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal tx_start : STD_LOGIC := '0';
    signal tx_busy : STD_LOGIC := '0';

    function decode_7seg(value : STD_LOGIC_VECTOR(3 downto 0)) return STD_LOGIC_VECTOR is
    begin
        case value is
            when "0000" => return "00000011"; -- 0
            when "0001" => return "10011111"; -- 1
            when "0010" => return "00100101"; -- 2
            when "0011" => return "00001101"; -- 3
            when "0100" => return "10011001"; -- 4
            when "0101" => return "01001001"; -- 5
            when "0110" => return "01000001"; -- 6
            when "0111" => return "00011111"; -- 7
            when "1000" => return "00000001"; -- 8
            when "1001" => return "00001001"; -- 9
            when "1010" => return "00010001"; -- A
            when "1011" => return "11000001"; -- B
            when "1100" => return "01100011"; -- C
            when "1101" => return "10000101"; -- D
            when "1110" => return "01100001"; -- E
            when others => return "01110001"; -- F
        end case;
    end function;

    component rs232_rx
        Port (
            clk_i   : in  STD_LOGIC;
            RXD_i   : in  STD_LOGIC;
            data_o  : out STD_LOGIC_VECTOR (7 downto 0);
            data_valid : out STD_LOGIC
        );
    end component;
    
    component rs232_tx
        Port (
            clk_i   : in  STD_LOGIC;   
            TXD_o     : out STD_LOGIC;
            data_i    : in  STD_LOGIC_VECTOR (7 downto 0);
            tx_start  : in  STD_LOGIC;
            tx_busy   : out STD_LOGIC := '0' 
        );
    end component;

    component display
        Port (
            clk_i       : in  STD_LOGIC;
            digit_i     : in  STD_LOGIC_VECTOR (31 downto 0);
            led7_an_o   : out STD_LOGIC_VECTOR (3 downto 0);
            led7_seg_o  : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;
    
    component fifo_controller
        Port (
            clk        : IN STD_LOGIC;
            rx_data    : IN STD_LOGIC_VECTOR (7 downto 0);
            rx_valid   : IN STD_LOGIC;
            tx_busy    : IN STD_LOGIC;
            tx_data    : OUT STD_LOGIC_VECTOR (7 downto 0);
            tx_valid   : OUT STD_LOGIC;
            full : OUT STD_LOGIC
        );
    end component;

begin

    display_inst: display
        port map (
            clk_i       => clk_i,
            digit_i     => digit_data,
            led7_an_o   => led7_an_o,
            led7_seg_o  => led7_seg_o
        );
        
    rs232_rx_inst: rs232_rx
        port map (
            clk_i   => clk_i,
            RXD_i   => RXD_i,
            data_o  => rx_data,
            data_valid => valid_rx
        );
        
    rs232_tx_inst: rs232_tx
        port map (
            clk_i   => clk_i,
            TXD_o   => TXD_o,
            data_i  => tx_data,
            tx_start => tx_start,
            tx_busy => tx_busy
        );
        
     fifo_controller_inst: fifo_controller
        port map (
            clk => clk_i,
            rx_data => rx_data,
            rx_valid => valid_rx,
            tx_busy => tx_busy,
            tx_data => tx_data,
            tx_valid => tx_start,
            full => ld0
        );
     
     digit_data(7 downto 0) <= decode_7seg(rx_data(3 downto 0));
     digit_data(15 downto 8) <= decode_7seg(rx_data(7 downto 4));
     
end Behavioral;
