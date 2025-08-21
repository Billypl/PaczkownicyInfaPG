----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2025 15:14:10
-- Design Name: 
-- Module Name: tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb is
--  Port ( );
end tb;

architecture Behavioral of tb is

component top is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           led_o : out STD_LOGIC_VECTOR (2 downto 0));
end component top;

signal clk_i : std_logic := '0';
signal rst_i : std_logic := '0';
signal led_o : std_logic_vector (2 downto 0);
constant PERIOD : time := 10 ns;

begin
    uut: top PORT MAP(
        clk_i => clk_i,
        rst_i => rst_i,
        led_o => led_o
    );
    
    tb1 : process
    variable x : integer;
    variable current_number : std_logic_vector(2 downto 0);
    variable current_number_gray : std_logic_vector(2 downto 0);
    begin
        loop
            current_number := "000";
            x := 0;
            while x < 11 loop
                clk_i <= '1';
                current_number := current_number + "1";
                current_number_gray(2) := current_number(2);
                current_number_gray(1) := current_number(2) xor current_number(1);
                current_number_gray(0) := current_number(1) xor current_number(0);
                
                wait for 1 ns;

                clk_i <= '0';
                wait for 1 ns;
                x := x + 1;
                
--                assert current_number_gray = led_o 
--                report "Vectors are not equal!" 
--                severity error;
            end loop;
            
            rst_i <= '1';
            wait for 1 ns;
        end loop;
    end process;
end Behavioral;