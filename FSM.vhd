library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity project_reti_logiche is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        o_address : out std_logic_vector(15 downto 0);
        o_done : out std_logic;
        o_en : out std_logic;
        o_we : out std_logic;
        o_data : out std_logic_vector (7 downto 0)
    );
end project_reti_logiche;

architecture rtl of project_reti_logiche is
    
    type conv_state is (state00, state01, state10, state11);
    signal STATE : conv_state;
    
    type inout_state is (RST, READ, WAIT_READ, WRITE, WAIT_WRITE1, WAIT_WRITE2, DONE);
    signal sig_state : inout_state;
    
    constant read_address : unsigned (15 downto 0) := x"0000";
    constant write_address : unsigned (15 downto 0) := x"03E8";
    
    signal toBe_read : unsigned (15 downto 0);
    signal toBe_write : unsigned (15 downto 0);
    
    signal nByte : integer := 0;
    
    signal firstByte : std_logic_vector(7 downto 0);
    signal secondByte : std_logic_vector(7 downto 0);
    
    procedure conv_12 (signal data_in : in std_logic_vector(7 downto 0);
                                signal state_param : inout conv_state;
                                signal byte1 : out std_logic_vector(7 downto 0);
                                signal byte2 : out std_logic_vector(7 downto 0)) is
        
        variable state_var : conv_state;
        variable full_output : std_logic_vector(15 downto 0);
        
        variable pk1 : integer;
        variable pk2 : integer;
        
        begin
            state_var := state_param;
            for i in 7 downto 0 loop
                pk1 := (2*i) + 1;
                pk2 := 2*i;
                case state_var is
                    when state00 =>
                        if data_in(i) = '0' then
                            state_var := state00;
                            full_output(pk1) := '0';
                            full_output(pk2) := '0';
                        else
                            state_var := state10;
                            full_output(pk1) := '1';
                            full_output(pk2) := '1';
                        end if;
                    when state10 =>
                        if data_in(i) = '0' then
                            state_var := state01;
                            full_output(pk1) := '0';
                            full_output(pk2) := '1';
                        else
                            state_var := state11;
                            full_output(pk1) := '1';
                            full_output(pk2) := '0'; 
                        end if;
                    when state01 =>
                        if data_in(i) = '0' then
                            state_var := state00;
                            full_output(pk1) := '1';
                            full_output(pk2) := '1';
                        else
                            state_var := state10;
                            full_output(pk1) := '0';
                            full_output(pk2) := '0'; 
                        end if;
                    when state11 =>
                        if data_in(i) = '0' then
                            state_var := state01;
                            full_output(pk1) := '1';
                            full_output(pk2) := '0';
                        else
                            state_var := state11; 
                            full_output(pk1) := '0';
                            full_output(pk2) := '1';
                        end if;
                end case;
            end loop;
            state_param <= state_var;
            byte1 <= full_output(15 downto 8);
            byte2 <= full_output(7 downto 0);
        end procedure;
    
begin
    
    
    
    process (i_clk)
    begin
        
        if rising_edge(i_clk) then
        
            if i_rst = '1' then
                sig_state <= RST;
                STATE <= state00;
                toBe_read <= read_address;
                toBe_write <= write_address;
                o_en <= '1';
                o_we <= '0';
                
            elsif i_start = '1' then
                case sig_state is
                    when RST =>
                        sig_state <= READ;
                        STATE <= state00;
                        toBe_read <= read_address;
                        toBe_write <= write_address;
                        o_en <= '1';
                        o_we <= '0';
                        
                    when READ =>
                        if toBe_read = read_address then
                            nByte <= to_integer(unsigned(i_data));
                        end if;
                        o_we <= '0';
                        sig_state <= WAIT_READ;
                        o_address <= std_logic_vector(toBe_read + 1);
                        toBe_read <= toBe_read + 1; 
                        
                    when WAIT_READ =>
                        if toBe_read > read_address + nByte then
                            sig_state <= DONE;
                        else
                            sig_state <= WRITE;
                        end if;
                        
                    when WRITE =>
                        sig_state <= WAIT_WRITE1;
                        conv_12(i_data, STATE, firstByte, secondByte);
                        o_we <= '1';
                        --o_address <= std_logic_vector(toBe_write);
                        
                    when WAIT_WRITE1 =>
                        sig_state <= WAIT_WRITE2;
                        o_data <= firstByte;
                        o_address <= std_logic_vector(toBe_write);
                        toBe_write <= toBe_write + 1;
                        
                    when WAIT_WRITE2 =>
                        sig_state <= READ;
                        o_data <= secondByte;
                        o_address <= std_logic_vector(toBe_write);
                        toBe_write <= toBe_write + 1;
                        --o_we <= '0';
                    when DONE =>
                        sig_state <= DONE;
                        o_done <= '1';
                        
                end case;
            
            elsif sig_state = DONE and i_start = '0' then
                sig_state <= RST;
                o_done <= '0';     
            end if;
            
        end if;
    end process;
    
    
end architecture;









