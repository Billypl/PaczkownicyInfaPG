----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2024 20:59:31
-- Design Name: 
-- Module Name: top_5b - Behavioral
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
use IEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_5b is
    Port ( clk_i : in STD_LOGIC;
           red_o : out STD_LOGIC_VECTOR (3 downto 0); -- all ones is white
           green_o : out STD_LOGIC_VECTOR (3 downto 0);
           blue_o : out STD_LOGIC_VECTOR (3 downto 0);
           hsync_o : out STD_LOGIC; -- short negative impuls set carret to next line
           vsync_o : out STD_LOGIC; -- long negative impuls set carret to start of screen
           sw_i : in STD_LOGIC_VECTOR (7 downto 0);
           btn_i : in STD_LOGIC_VECTOR (3 downto 0));
end top_5b;

architecture Behavioral of top_5b is
COMPONENT video_mem
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(0 DOWNTO 0) 
  );
END COMPONENT;
COMPONENT lisajue_generator is
  port (
    clk_i: in STD_LOGIC;
    ch1_conf: in STD_LOGIC_VECTOR (31 downto 0);
    ch2_conf: in STD_LOGIC_VECTOR (31 downto 0);
    ch_conf_en: in STD_LOGIC_VECTOR (0 downto 0);
    vmem_addr_o: out STD_LOGIC_VECTOR (17 downto 0);
    vmem_data_o: out STD_LOGIC_VECTOR (0 downto 0);
    vmem_wr_en: out STD_LOGIC_VECTOR (0 downto 0));
end COMPONENT;

-- First channel phase must be 0

-- video mem
signal vmem_i_addr: STD_LOGIC_VECTOR(17 DOWNTO 0) := (others => '0');
signal vmem_o_addr: STD_LOGIC_VECTOR(17 DOWNTO 0) := (others => '0');
signal vmem_i_en: std_logic_vector(0 downto 0) := "0";
signal vmem_i_data: std_logic_vector(0 downto 0):= "0";
signal vmem_o_data: std_logic_vector(0 downto 0):= "0";
-- sgen

signal sgen_ch1_conf: std_logic_vector(31 downto 0) := (others => '0'); -- phase,hz
signal sgen_ch2_conf: std_logic_vector(31 downto 0) := (others => '0'); -- phase,hz
alias sgen_ch1_conf_hz: std_logic_vector is sgen_ch1_conf(15 downto 0);
alias sgen_ch2_conf_hz: std_logic_vector is sgen_ch2_conf(15 downto 0);
alias sgen_ch2_conf_phase: std_logic_vector is sgen_ch2_conf(31 downto 16);
signal sgen_conf_en: std_logic_vector(0 downto 0) := "0";
-- bounce
signal btn_dbounced: std_logic_vector(3 downto 0):= (others => '0');
begin
vmem : video_mem
 PORT MAP (
   clka => clk_i,
   wea => vmem_i_en,
   addra => vmem_i_addr,
   dina => vmem_i_data,
   clkb => clk_i,
   addrb => vmem_o_addr,
   doutb => vmem_o_data
 );

lisajue_generator_inst: entity work.lisajue_generator
port map (
  clk_i       => clk_i,
  ch1_conf    => sgen_ch1_conf,
  ch2_conf    => sgen_ch2_conf,
  ch_conf_en  => sgen_conf_en,
  vmem_addr_o => vmem_i_addr,
  vmem_wr_en  => vmem_i_en,
  vmem_data_o => vmem_i_data
);

vga_renderer_inst: entity work.vga_renderer
port map (
  clk_i       => clk_i,
  red_o       => red_o,
  green_o     => green_o,
  blue_o      => blue_o,
  hsync_o     => hsync_o,
  vsync_o     => vsync_o,
  vmem_addr_o => vmem_o_addr,
  vmem_data_i => vmem_o_data
);


btn_proc: process (clk_i)
begin
  if rising_edge(clk_i) then
    btn_dbounced <= btn_i;
  end if;
end process btn_proc;

sw_proc: process(clk_i)
begin
  sgen_conf_en <= "0";
  if rising_edge(clk_i) then
    if btn_dbounced(3) = '1' then
      sgen_ch1_conf_hz <= "00000000" & sw_i;
    end if;
    if btn_dbounced(2) = '1' then
      sgen_ch2_conf_hz <= "00000000" & sw_i;
    end if;
    if btn_dbounced(1) = '1' then
      sgen_ch2_conf_phase <= "00000000" & sw_i;
    end if;
    if btn_dbounced(0) = '1' then -- program
      sgen_conf_en <= "1";
    end if;
  end if;
end process sw_proc;

-- video_o_iutput is 384x384
-- displayed on 640x480
-- genera_ite starting from center and it have to be square
-- Generate in White-Black (all color = 1 is white)

--Cz?stotliwo?? obu kana?�w (X i Y) i faz? jednego (Y) ustawiamy za pomoc? prze??cznik�w SW0-SW7 (zakres 0-255) i przycisk�w BTNL (wpis cz?stotliwo?ci X ustawionej na prze??cznikach), BTNC (wpis cz?stotliwo?ci Y ustawionej na prze??cznikach), BTNR (wpis offsetu fazy Y ustawionej na prze??cznikach).
--Przycisk BTND powinien s?u?y? do wyczyszczenia ekranu i zresetowania generatora DDS (aby rozpocz?? rysowanie figur od ustawionej fazy dla kana?u Y i fazy 0 dla kana?u X).
--Kana? X to Channel 1 (patrz opis komponentu DDS poni?ej). Wsp�?rz?dne ujemne s? po lewej stronie ekranu dodatnie po prawej. Amplituda kana?u powinna by? tak dobrana aby krzywa w pe?ni wykorzysta?a dost?pny ekran.
--Kana? Y to Channel 2 (patrz opis komponentu DDS poni?ej). Wsp�?rz?dne ujemne s? na dole ekranu dodatnie na g�rze. Amplituda kana?u powinna by? tak dobrana aby krzywa w pe?ni wykorzysta?a dost?pny ekran.
--Wsp�?rz?dne (0,0) s? w ?rodku ekranu.
-- W tym ?wiczeniu nie korzystamy z sygna?u �reset". Prosz? zamiast tego stosowa? warto?ci pocz?tkowe sygna?�w i zmiennych.



end Behavioral;
