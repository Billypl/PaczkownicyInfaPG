library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx is
    Generic (
        CLK_FREQ  : integer := 100000000; -- 100 MHz
        BAUD_RATE : integer := 9600
    );
    Port (
        clk_i      : in  std_logic;
        rst_i      : in  std_logic;
        rxd_i      : in  std_logic;
        data_o     : out std_logic_vector(7 downto 0);
        data_valid : out std_logic
    );
end uart_rx;

architecture Behavioral of uart_rx is
    constant BIT_PERIOD : integer := CLK_FREQ / BAUD_RATE;
    
    type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state : state_type := IDLE;
    
    signal bit_counter : integer range 0 to 7 := 0;
    signal clock_counter : integer range 0 to BIT_PERIOD-1 := 0;
    signal sample_point : std_logic := '0';
    signal shift_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal data_valid_reg : std_logic := '0';
    signal flag : std_logic := '0';

begin
    data_o <= shift_reg;
    data_valid <= data_valid_reg;
    
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            state <= IDLE;
            bit_counter <= 0;
            clock_counter <= 0;
            shift_reg <= (others => '0');
            data_valid_reg <= '0';
        elsif rising_edge(clk_i) then
            data_valid_reg <= '0';
            
            if state = DATA_BITS and clock_counter = BIT_PERIOD-1 and flag = '0'  then
                flag <= '1';
                clock_counter <= BIT_PERIOD / 2;
                sample_point <= '1';
            elsif clock_counter = BIT_PERIOD-1 then
                clock_counter <= 0;
                sample_point <= '1';
            else
                clock_counter <= clock_counter + 1;
                sample_point <= '0';
            end if;
            
            case state is
                when IDLE =>
                    if rxd_i = '0' then
                        state <= START_BIT;
                        clock_counter <= 0;
                    end if;
                
                when START_BIT =>
                    if sample_point = '1' then
                        state <= DATA_BITS;
                        bit_counter <= 0;
                    end if;
                
                when DATA_BITS =>
                    if sample_point = '1' then
                        shift_reg(bit_counter) <= rxd_i;
                        if bit_counter = 7 then
                            state <= STOP_BIT;
                        else
                            bit_counter <= bit_counter + 1;
                        end if;
                    end if;
                
                when STOP_BIT =>
                    if sample_point = '1' then
                        data_valid_reg <= '1';
                        state <= IDLE;
                        flag <= '0';
                    end if;
            end case;
        end if;
    end process;
end Behavioral;