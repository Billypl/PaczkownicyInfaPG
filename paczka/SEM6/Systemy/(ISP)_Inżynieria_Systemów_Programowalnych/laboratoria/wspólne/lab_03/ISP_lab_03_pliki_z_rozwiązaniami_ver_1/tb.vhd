----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2025 14:04:39
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
use IEEE.NUMERIC_STD.ALL;
use STD.ENV.ALL;

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
        Port ( 
            clk_i      : in  STD_LOGIC;
            btn_i      : in  STD_LOGIC_VECTOR (3 downto 0);
            sw_i       : in  STD_LOGIC_VECTOR (7 downto 0);
            led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
            led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    signal clk_i      : STD_LOGIC := '0';
    signal btn_i      : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal sw_i       : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal led7_an_o  : STD_LOGIC_VECTOR(3 downto 0);
    signal led7_seg_o : STD_LOGIC_VECTOR(7 downto 0);

    constant CLK_PERIOD   : time := 10 ns;  -- 100 MHz
    constant BUTTON_PRESS : time := 1 ms;
    constant BUTTON_RELEASE : time := 2 ms;
begin

    uut: top
    port map (
        clk_i      => clk_i,
        btn_i      => btn_i,
        sw_i       => sw_i,
        led7_an_o  => led7_an_o,
        led7_seg_o => led7_seg_o
    );

    -- Generator zegara 100 MHz
    clk_process: process
    begin
        clk_i <= '0';
        wait for CLK_PERIOD/2;
        clk_i <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Proces testujący
    stim_proc: process
    begin
        -- Inicjalizacja
        wait for 100 ns;
        
        -- Ustawienie początkowych przełączników
        sw_i(7 downto 4) <= "1010";  -- Dwie kropki (AN3 i AN1)
        sw_i(3 downto 0) <= "0001";  -- Wartość początkowa
        wait for 1 ms;

        -- Sekwencja testowa dla przycisków
        for i in 3 downto 0 loop
            -- Naciśnięcie przycisku
            btn_i(i) <= '1';
            wait for BUTTON_PRESS;
            
            -- Zwolnienie przycisku
            btn_i(i) <= '0';
            wait for BUTTON_RELEASE/2;
            
            -- Zmiana wartości SW w środku okresu zwolnienia
            sw_i(3 downto 0) <= std_logic_vector(unsigned(sw_i(3 downto 0)) + 1);
            wait for BUTTON_RELEASE/2;
        end loop;

        -- Zmiana stanu kropek
        sw_i(7 downto 4) <= "0101";  -- Nowe kropki (AN2 i AN0)
        wait for 2 ms;
        sw_i(7 downto 4) <= "1111";  -- Wszystkie kropki
        wait for 2 ms;

        -- Koniec symulacji
        report "SIMULATION COMPLETED";
        stop;
    end process;
end Behavioral;
