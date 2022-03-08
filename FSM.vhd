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
    
    type t_state is (state00, state01, state10, state11);
    signal STATE : t_state := state00;
    signal firstpart : std_logic_vector(7 downto 0);
    signal secondpart : std_logic_vector(7 downto 0);
    
    procedure convolutional_12 (signal data_in : in std_logic_vector(7 downto 0);
                                signal state : inout t_state;
                                signal byte1 : out std_logic_vector(7 downto 0);
                                signal byte2 : out std_logic_vector(7 downto 0)) is
        
        variable state_var : t_state;
        variable full_output : std_logic_vector(15 downto 0);
        
        variable pk1 : integer;
        variable pk2 : integer;
        
        begin
            state_var := state;
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
            state <= state_var;
            byte1 <= full_output(15 downto 8);
            byte2 <= full_output(7 downto 0);
        end procedure;
    
begin
    o_en <= '1';
    o_address <= x"0001";
    
    process(i_start)
    
    begin
        if rising_edge(i_start) then
            convolutional_12(i_data, STATE, firstpart, secondpart);
        end if;
    end process;
    
    
end architecture;
