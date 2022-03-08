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
    signal state : t_state := state00;
    signal test : std_logic_vector(15 downto 0);
    signal firstpart : std_logic_vector(7 downto 0);
    signal secondpart : std_logic_vector(7 downto 0);
    
begin
    o_en <= '1';
    o_address <= x"0002";
    process(i_rst, i_start)
    begin
        if rising_edge(i_rst) or rising_edge(i_start) then
            --state <= state00;
        end if;
    end process;
    
    process --(i_clk)
        variable data : std_logic_vector(7 downto 0) := "10100010";
        variable output_data : std_logic_vector(15 downto 0);
        variable state_int : t_state;
        variable pk1 : integer;
        variable pk2 : integer;
    begin
        --if rising_edge(i_clk) then
            --data := i_data;
            state_int := state;
            for i in 7 downto 0 loop
                pk1 := (2*i) + 1;
                pk2 := 2*i;
                case state_int is
                    when state00 =>
                        if data(i) = '0' then
                            state_int := state00;
                            output_data(pk1) := '0';
                            output_data(pk2) := '0';
                        else
                            state_int := state10;
                            output_data(pk1) := '1';
                            output_data(pk2) := '1';
                        end if;
                    when state10 =>
                        if data(i) = '0' then
                            state_int := state01;
                            output_data(pk1) := '0';
                            output_data(pk2) := '1';
                        else
                            state_int := state11;
                            output_data(pk1) := '1';
                            output_data(pk2) := '0'; 
                        end if;
                    when state01 =>
                        if data(i) = '0' then
                            state_int := state00;
                            output_data(pk1) := '1';
                            output_data(pk2) := '1';
                        else
                            state_int := state10;
                            output_data(pk1) := '0';
                            output_data(pk2) := '0'; 
                        end if;
                    when state11 =>
                        if data(i) = '0' then
                            state_int := state01;
                            output_data(pk1) := '1';
                            output_data(pk2) := '0';
                        else
                            state_int := state11; 
                            output_data(pk1) := '0';
                            output_data(pk2) := '1';
                        end if;
                end case;
            end loop;
            state <= state_int;
            test <= output_data;
            firstpart <= output_data(15 downto 8);
            secondpart <= output_data(7 downto 0);
       -- end if;
        wait for 2000 ns;
    end process;
    
end architecture;
