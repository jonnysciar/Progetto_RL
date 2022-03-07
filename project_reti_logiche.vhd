library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

--Flip Flop D
entity flip_flopD is
    port (
        i_clk : in std_logic;
        i_data : in std_logic;
        o_data : out std_logic
    );
end flip_flopD;

architecture bitflow of flip_flopD is
begin
     process(i_clk) is
     begin
        if rising_edge(i_clk) then
            o_data <= i_data;
        end if;
     end process;
end architecture;

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
    signal address : std_logic_vector(15 downto 0) := x"0000";
    signal data : std_logic_vector(7 downto 0) := x"00";
    signal clk : std_logic := '1';
    signal i : std_logic := '0';
    signal o : std_logic;
    
    component flip_flopD is
        port (
            i_clk, i_data : in std_logic;
            o_data : out std_logic
        );
    end component;
    
begin
    
    FF1 : flip_flopD
        port map(i_clk, i_data(0), o);
   -- FF2 : flip_flopD
      --  port map(i_clk, data(0), address(0));
    
    o_en <= '1';
    
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            address <= address + '1';
            o_address <= address;
        end if;
    end process;
    
    
    
end architecture;
