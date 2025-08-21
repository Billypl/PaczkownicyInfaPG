library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.seg7_utils.all;

entity top is
    Port ( 
        clk_i      : in  STD_LOGIC;
        rst_i      : in  STD_LOGIC;
        RXD_i      : in  STD_LOGIC;
        led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
        led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
    );
end top;

architecture Behavioral of top is
    component uart_rx
        Generic (
            CLK_FREQ  : integer := 100000000;
            BAUD_RATE : integer := 9600
        );
        Port (
            clk_i      : in  std_logic;
            rst_i      : in  std_logic;
            rxd_i      : in  std_logic;
            data_o     : out std_logic_vector(7 downto 0);
            data_valid : out std_logic
        );
    end component;
    
    component display
        Generic (
            DIVIDER_COUNT : integer := 100000
        );
        Port (
            clk_i      : in  STD_LOGIC;
            rst_i      : in  STD_LOGIC;
            digit_i    : in  STD_LOGIC_VECTOR (31 downto 0);
            led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
            led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;
    
    signal rxd_sync      : std_logic_vector(1 downto 0) := "11";
    signal uart_data     : std_logic_vector(7 downto 0) := (others => '0');
    signal uart_valid    : std_logic := '0';
    signal display_digits : std_logic_vector(31 downto 0) := (others => '1');

begin
    -- Input synchronization
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            rxd_sync <= rxd_sync(0) & RXD_i;
        end if;
    end process;
    
    -- UART Receiver instance
    uart_rx_inst: uart_rx
        generic map (
            CLK_FREQ  => 100000000,
            BAUD_RATE => 9600
        )
        port map (
            clk_i      => clk_i,
            rst_i      => rst_i,
            rxd_i      => rxd_sync(1),
            data_o     => uart_data,
            data_valid => uart_valid
        );
    
    -- Display data processing
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            display_digits <= (others => '1'); -- All segments off
        elsif rising_edge(clk_i) then
            if uart_valid = '1' then
                -- Format: [blank][blank][high nibble][low nibble]
                display_digits(31 downto 16) <= (others => '1'); -- Blank left two displays
                display_digits(15 downto 8)  <= hex_to_7seg(uart_data(7 downto 4));
                display_digits(7 downto 0)   <= hex_to_7seg(uart_data(3 downto 0));
            end if;
        end if;
    end process;
    
    -- Display controller instance
    display_inst: display
        generic map (
            DIVIDER_COUNT => 100000
        )
        port map (
            clk_i      => clk_i,
            rst_i      => rst_i,
            digit_i    => display_digits,
            led7_an_o  => led7_an_o,
            led7_seg_o => led7_seg_o
        );
end Behavioral;