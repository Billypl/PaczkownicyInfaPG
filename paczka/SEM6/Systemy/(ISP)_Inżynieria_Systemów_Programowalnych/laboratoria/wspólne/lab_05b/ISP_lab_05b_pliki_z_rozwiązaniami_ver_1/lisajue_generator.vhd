----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2024 19:11:13
-- Design Name: 
-- Module Name: lisajue_generator - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lisajue_generator is
    Port ( clk_i : in STD_LOGIC;
           ch1_conf : in STD_LOGIC_VECTOR (31 downto 0);
           ch2_conf : in STD_LOGIC_VECTOR (31 downto 0);
           ch_conf_en : in STD_LOGIC_VECTOR (0 downto 0);
           vmem_addr_o : out STD_LOGIC_VECTOR (17 downto 0);
           vmem_data_o: out STD_LOGIC_VECTOR (0 downto 0);
           vmem_wr_en : out STD_LOGIC_VECTOR (0 downto 0));
end lisajue_generator;

architecture Behavioral of lisajue_generator is
COMPONENT singen
    PORT (
      aclk : IN STD_LOGIC;
      aclken : IN STD_LOGIC; -- stop generator by 0 (signal must be on while changing config)
      aresetn : IN STD_LOGIC; -- reset both generators
      s_axis_config_tvalid : IN STD_LOGIC; -- enable config
      s_axis_config_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- 31 downto 16 is phase, 15-0 is hz
      s_axis_config_tlast : IN STD_LOGIC; -- enable config for second channel
      m_axis_data_tvalid : OUT STD_LOGIC; -- if m_axis_data_tdata is valid
      m_axis_data_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- znacz?cze 10 downto 0
      event_s_config_tlast_missing : OUT STD_LOGIC; -- left open
      event_s_config_tlast_unexpected : OUT STD_LOGIC -- left open
    );
  END COMPONENT;
  signal sgen_en: std_logic := '1';
signal sgen_rst: std_logic := '1';
signal sgen_conf_en: std_logic := '0';
signal sgen_conf_data: std_logic_vector(31 downto 0) := (others => '0');
signal sgen_conf_en2: std_logic := '0';
signal sgen_data_valid: std_logic := '0';
signal sgen_data_data: std_logic_vector(15 downto 0) := (others => '0');

signal sgen_ch_selection: std_logic := '0';
signal vmem_addr: unsigned(17 downto 0) ;
type sgen_state_type is (generating,prog1,prog2,reset);
signal sgen_state: sgen_state_type := generating;
signal sgen_skip_gen: std_logic := '0';

signal sgen_ch1_data: std_logic_vector(15 downto 0);
signal sgen_ch2_data: std_logic_vector(15 downto 0);
begin


sgen : singen
PORT MAP (
    aclk => clk_i,
    aclken => sgen_en,
    aresetn => sgen_rst,
    s_axis_config_tvalid => sgen_conf_en,
    s_axis_config_tdata => sgen_conf_data,
    s_axis_config_tlast => sgen_conf_en2,
    m_axis_data_tvalid => sgen_data_valid,
    m_axis_data_tdata => sgen_data_data,
    event_s_config_tlast_missing => open,
    event_s_config_tlast_unexpected => open
);


sgen_wraper : process( clk_i )
variable x: unsigned(20 downto 0);
variable y: unsigned(20 downto 0);
variable sum: unsigned(20 downto 0);

begin
  if rising_edge(clk_i) then
  sgen_conf_en <= '0';
  sgen_rst <= '1';
  vmem_wr_en <= "0";

  -- TOOD: read in data and write to aproprierate memory adress
  if sgen_data_valid = '1' then
    
    if sgen_ch_selection = '0' then
      sgen_ch1_data <= sgen_data_data;
      sgen_ch_selection <= '1';
      else
      sgen_ch2_data <= sgen_data_data; -- remember there is old value
      if sgen_skip_gen = '0' then
        -- 384 = 256 + 128 
        x:= "00000"&unsigned(std_logic_vector(signed(sgen_ch1_data) + 1024)); -- 2**10 (11 bits for number)
        y:= "00000"&unsigned(std_logic_vector(signed(sgen_data_data) + 1024));
        -- x and y is positive now
        -- range 0 - 2048 ()
        -- tageted 0 - 384 (256 + 128)
        --( 2048 * 256 + 2048 * 128 ) range 0 - 2048 * 384 
        -- 0 - (16 * 128) * (3 * 128)
        x:= (x + x + x); -- *3
        y:= (y + y + y);
        x:= "0000" & x(20 downto 4); -- /16
        y:= "0000" & y(20 downto 4);
        y:= (y(12 downto 0)&"00000000") + (y(13 downto 0) & "0000000");
        sum:= x + y;
        vmem_addr_o <= std_logic_vector(sum(17 downto 0)) ; -- calculate adress 
        vmem_data_o <= "1";
        vmem_wr_en <= "1";
        sgen_ch_selection <= '0';
      else
        sgen_skip_gen <= '0';
      end if;
    end if;
  end if ;
        
  case( sgen_state ) is
    when generating => if ch_conf_en = "1" then
      sgen_state <= prog1;
    end if ;
    when prog1 => 
      sgen_conf_en <= '1';
      sgen_conf_data <= ch1_conf;
      sgen_conf_en2 <= '0';
      sgen_state <= prog2;
    when prog2 =>
      sgen_conf_en <= '1';
      sgen_conf_data <= ch2_conf;
      sgen_conf_en2 <= '1';
      vmem_addr <= (others => '0');
      sgen_state <= reset;
    when reset =>
      sgen_rst <= '0';
      vmem_addr_o <= std_logic_vector(vmem_addr);
      vmem_wr_en <= "1";
      vmem_data_o <= "0";
      vmem_addr <= vmem_addr + 1;
      if vmem_addr = to_unsigned(384 * 384,18) then
        sgen_state <= generating;
        if(sgen_ch_selection = '0') then
          sgen_skip_gen <= '1';  
        end if;
      end if;
  end case ;
  end if;
end process ; -- sgen_wraper



end Behavioral;
