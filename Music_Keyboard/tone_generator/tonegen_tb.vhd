library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tonegen_tb is
end tonegen_tb;

architecture Behavioral of tonegen_tb is
    constant clk_period : time := 10ns;

component top
      Port (clk, reset : in std_logic;
            note_sw: in std_logic_vector(2 downto 0);  
            audio_out : out std_logic);
end component;

signal clk, reset : std_logic; 
signal note_sw: std_logic_vector(2 downto 0);
signal audio_out : std_logic;
begin
uut: top port map
        (
            clk=>clk, reset=>reset,
            note_sw=>note_sw, audio_out=>audio_out
        );

clk_process: process
begin 
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

stim: process
begin
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period*1000*10000;
        note_sw <= "001";
        wait for clk_period*1000*10000;
        note_sw <= "010";
        wait for clk_period*1000*10000;
--        note_sw <= "011";
--        wait for clk_period*1000*10000;
--        note_sw <= "100";
--        wait for clk_period*1000*10000;
--        note_sw <= "101";
--        wait for clk_period*1000*10000;
end process;
end;
