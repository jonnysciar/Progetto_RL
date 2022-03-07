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

architecture Behavioral of project_reti_logiche is
    signal address : std_logic_vector(15 downto 0) := x"0000";
    signal data: std_logic_vector(7 downto 0) := x"00";
    --signal clk : std_logic := '0';
    signal i_ff1 : std_logic := '0';
    signal i_ff2 : std_logic := '0';
    signal o_ff1 : std_logic := '0';
    signal o_ff2 : std_logic := '0';


begin


    process is 
    begin
        wait until i_start = '1';
        o_en <= '1';
        o_address <= address;
        o_done <= '0';
    end process;
    
    
    process (i_data) is
    begin
        data <= i_data;
    end process;
    
    
    --Flip-Flop update
    process (i_clk) is
    begin
        if i_clk = '1' then
            o_ff1 <= i_ff1;
            o_ff2 <= i_ff2;
            address <= address + 01;
            o_address <= address;
        else 
        
        end if;
    end process;
    
end architecture;
