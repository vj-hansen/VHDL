library ieee;
use ieee.std_logic_1164.all;
 
entity edice_tb is
end edice_tb;
 
architecture tb of edice_tb is
constant clk_period : time := 10 ns;
component top
        port (  CLK, Cheat, reset, run : in std_logic;
                set_val : in std_logic_vector(2 downto 0);    
                an : out std_logic_vector(3 downto 0);
                seg7, leds : out std_logic_vector(6 downto 0)
            );
end component;
 
signal clk, Run, Cheat : std_logic;
signal set_val : std_logic_vector(2 downto 0);
signal reset : std_logic := '0';
signal an : std_logic_vector(3 downto 0);
signal seg7, leds : std_logic_vector(6 downto 0);   

begin
    uut : top port map
            (
                clk => clk, leds => leds,
                seg7 => seg7, set_val => set_val, an => an,
                cheat => cheat, reset => reset, run => run
            );
 
 -- clock process
clk_process : process
   begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
end process;
-- throw dice
sim_run: process
    begin
        Run <= '0';
            wait for clk_period*2;
        Run <= '1'; 
            wait for clk_period*5;
end process; 
-- cheating
sim_cheat: process
    begin
        cheat <= '0';
            wait for clk_period*50;
        cheat <= '1'; 
            wait for clk_period*50;
end process; 
-------------     
stim: process
       begin
            reset <= '1';
            wait for clk_period;
            reset <= '0';
            set_val <= "001"; -- dice = 1
            wait for clk_period*8;
            set_val <= "010"; -- dice = 2
            wait for clk_period*8;
            set_val <= "011"; -- dice = 3
            wait for clk_period*8;
            set_val <= "100"; -- dice = 4
            wait for clk_period*8;
            set_val <= "101"; -- dice = 5
            wait for clk_period*8;
            set_val <= "110"; -- dice = 6
            wait for clk_period*8;
            set_val <= "111"; -- invalid value = 7
            wait for clk_period*8;
            set_val <= "000"; -- invalid value = 0
            wait for clk_period*8;
    end process;
end;
