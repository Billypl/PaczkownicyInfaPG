----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2025 13:46:48
-- Design Name: 
-- Module Name: fifo_controller - Behavioral
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

entity fifo_controller is
    Port (
        clk        : IN STD_LOGIC;
        rx_data    : IN STD_LOGIC_VECTOR (7 downto 0);
        rx_valid   : IN STD_LOGIC;
        tx_busy    : IN STD_LOGIC;
        tx_data    : OUT STD_LOGIC_VECTOR (7 downto 0);
        tx_valid   : OUT STD_LOGIC;
        full       : OUT STD_LOGIC
    );
end fifo_controller;

architecture Behavioral of fifo_controller is

    type display_state is (IDLE, WAITING_FOR_ADDRESSES, READ_ADDRESSES,
                    DISPLAY, WAITING, CR, CR_WAITING,
                    LF, LF_WAITING, END_CR, END_CR_WAITING,
                    END_LF, END_LF_WAITING, END_WAITING, END_DISPLAY
    );
    signal disp_state : display_state := IDLE;
    
    type caching_state is (C_IDLE, CACHING);
    signal cach_state : caching_state := C_IDLE;
    
    signal i: integer range 0 to 128 := 0;
    
    signal display_in_progress : STD_LOGIC := '0';
    signal displayed_number : INTEGER RANGE 0 TO 18 := 0;   
    signal fifo_full : STD_LOGIC;
    signal empty : STD_LOGIC;
    signal wr_en : STD_LOGIC := '0';
    signal rd_en : STD_LOGIC := '0';
    
    signal fifo_out : STD_LOGIC_VECTOR(7 downto 0);
    signal tx_data_reg : STD_LOGIC_VECTOR(7 downto 0);
    signal rx_data_reg : STD_LOGIC_VECTOR(7 downto 0);
    
    type byte_array is array (0 to 17) of std_logic_vector(7 downto 0);
    signal ascii_codes : byte_array;
    signal valid_chars : INTEGER RANGE 0 TO 17 := 0;
    signal address : std_logic_vector(11 downto 0);
    signal displayed_char : std_logic_vector(7 downto 0);
    
    component fifo_memory
        Port (
            clk : IN STD_LOGIC;
            din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            wr_en : IN STD_LOGIC;
            rd_en : IN STD_LOGIC;
            dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            full : OUT STD_LOGIC;
            empty : OUT STD_LOGIC 
        );
    end component;
    
    component char_memory
      Port (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) 
      );
    end component;
    
begin

    fifo_memory_inst : fifo_memory
        port map (
            clk => clk,
            din => rx_data_reg,
            wr_en => wr_en,
            rd_en => rd_en,
            dout => fifo_out,
            full => fifo_full,
            empty => empty
        );
        
    char_memory_inst : char_memory
        port map (
            clka => clk,
            addra => address,
            douta => displayed_char
        );
     
     
    process(clk)
        variable j: integer range 0 to 15 := 0;
        variable char_counter: integer range 0 to 17 := 0;
        variable column_counter : integer range 0 to 7 := 7;
        variable row_counter: integer range 0 to 15 := 0;
    begin
        if rising_edge(clk) then
            wr_en <= '0';
            tx_valid <= '0';

            case cach_state is
                when C_IDLE =>
                    if i >= 18 then
                        if rx_valid = '1' and rx_data /= "00001101" and fifo_full = '0' then
                            rx_data_reg <= rx_data;
                            wr_en <= '1';
                            i <= i + 1;
                        end if;
                        display_in_progress <= '1';
                        displayed_number <= 18;
                        cach_state <= CACHING;
                    elsif rx_valid = '1' and fifo_full = '0' then 
                        if rx_data /= "00001101" and i = 17 then
                            display_in_progress <= '1';
                            rx_data_reg <= rx_data;
                            wr_en <= '1';
                            displayed_number <= 18;
                            i <= i + 1;
                            cach_state <= CACHING;
                        elsif rx_data = "00001101" then -- Enter
                            display_in_progress <= '1';
                            displayed_number <= i;
                            cach_state <= CACHING;
                        else
                            rx_data_reg <= rx_data;
                            wr_en <= '1';
                            i <= i + 1;
                        end if; 
                    end if;  
                when CACHING =>
                    if display_in_progress = '0' then
                        cach_state <= C_IDLE;
                        i <= i - displayed_number;
                        displayed_number <= 0;
                    elsif rx_valid = '1' then
                        if rx_data /= "00001101" and fifo_full = '0' then
                            rx_data_reg <= rx_data;
                            wr_en <= '1';
                            i <= i + 1;
                        end if;
                    end if;   
--               when C_WAITING =>
--                    cach_state <= C_IDLE;           
            end case; 


            case disp_state is
                when IDLE =>
                    if display_in_progress = '1' then
                        if displayed_number > 0 then
                            rd_en <= '1';
                            disp_state <= WAITING_FOR_ADDRESSES;
                        else
                            disp_state <= DISPLAY;
                        end if;
                    end if;
                when WAITING_FOR_ADDRESSES =>
                    disp_state <= READ_ADDRESSES;
                when READ_ADDRESSES =>
                    ascii_codes(valid_chars) <= fifo_out;
                    valid_chars <= valid_chars + 1;
                    if valid_chars = displayed_number - 2 or empty = '1' then
                        rd_en <= '0';
                    end if;
                    if valid_chars = displayed_number - 1 then
                        rd_en <= '0';
                        address <= ascii_codes(char_counter) & std_logic_vector(to_unsigned(row_counter, 4));
                        disp_state <= DISPLAY;
                    end if;
                when DISPLAY =>
                    if tx_busy = '0' then
                        if displayed_number > 0 then
                            case displayed_char(column_counter) is
                                when '0' => tx_data_reg <= "00100000";
                                when '1' => 
                                    if to_integer(unsigned(ascii_codes(char_counter))) > 127 or to_integer(unsigned(ascii_codes(char_counter))) < 32 then
                                        tx_data_reg <= ascii_codes(char_counter);
                                    else
                                        tx_data_reg <= "00101010";
                                    end if;
                                 when others => tx_data_reg <= "00101010";
                             end case;
                             if column_counter = 0 and char_counter >= valid_chars - 1 and row_counter = 15 then
                                column_counter := 7;
                                char_counter := 0;
                                row_counter := 0;
                                disp_state <= END_CR_WAITING;
                             elsif column_counter = 0 and char_counter >= valid_chars - 1 then
                                column_counter := 7;
                                char_counter := 0;
                                row_counter := row_counter + 1;
                                disp_state <= CR_WAITING;
                             elsif column_counter = 0 then
                                column_counter := 7;
                                char_counter := char_counter + 1;
                                disp_state <= WAITING;
                             else
                                column_counter := column_counter - 1;
                                disp_state <= WAITING;
                             end if;
                             address <= ascii_codes(char_counter) & std_logic_vector(to_unsigned(row_counter, 4));
                             tx_valid <= '1';
                        else
                            if j = 15 then
                                j := 0;
                                disp_state <= END_CR;
                            else
                                j := j + 1;
                                disp_state <= CR; 
                            end if;
                        end if;
                    end if; 
                when WAITING =>
                    if tx_busy = '1' then
                        disp_state <= DISPLAY;
                    end if;
                when CR_WAITING =>
                    if tx_busy = '1' then
                        disp_state <= CR;
                    end if; 
                when CR => 
                    if tx_busy = '0' then
                        tx_data_reg <= "00001101";
                        tx_valid <= '1';
                        disp_state <= LF_WAITING;
                    end if;
                when LF_WAITING =>
                    if tx_busy = '1' then
                        disp_state <= LF;
                    end if;  
                when LF =>
                    if tx_busy = '0' then
                        tx_data_reg <= "00001010";
                        tx_valid <= '1';
                        disp_state <= WAITING;
                    end if;
                when END_CR_WAITING =>
                    if tx_busy = '1' then
                        disp_state <= END_CR;
                    end if; 
                when END_CR => 
                    if tx_busy = '0' then
                        tx_data_reg <= "00001101";
                        tx_valid <= '1';
                        disp_state <= END_LF_WAITING;
                    end if;
                when END_LF_WAITING =>
                    if tx_busy = '1' then
                        disp_state <= END_LF;
                    end if;  
                when END_LF =>
                    if tx_busy = '0' then
                        tx_data_reg <= "00001010";
                        tx_valid <= '1';
                        disp_state <= END_WAITING;
                    end if;
                when END_WAITING =>
                    if tx_busy = '1' then
                        disp_state <= END_DISPLAY;
                    end if;
                when END_DISPLAY =>
                    if tx_busy = '0' then
                        valid_chars <= 0;
                        ascii_codes <= (others => (others => '0'));
                        disp_state <= IDLE;
                        display_in_progress <= '0';
                    end if;
                when others =>
                    disp_state <= IDLE;
                    display_in_progress <= '0';
                    valid_chars <= 0;
            end case;  
        end if;
    end process;
    
    tx_data <= tx_data_reg;
    full <= fifo_full;

end Behavioral;
