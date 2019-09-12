library ieee;
use ieee.std_logic_1164.all;
 
entity edice_tb is
end edice_tb;
 
architecture tb of edice_tb is
    
    constant clk_period : time := 10 ns;
    component edice
        port (  CLK, Cheat, rst, run : in std_logic;
                R_in : in std_logic_vector(2 downto 0);    
                an : out std_logic_vector(3 downto 0);
                seg7, leds : out std_logic_vector(6 downto 0)
            );
    end component;
signal clk, Run, Cheat : std_logic;
signal R_in : std_logic_vector(2 downto 0);
signal rst : std_logic := '0';
signal an : std_logic_vector(3 downto 0);
signal seg7, leds : std_logic_vector(6 downto 0);   

begin
    uut : edice port map
            (
                clk => clk, leds => leds,
                seg7 => seg7, R_in => R_in, an => an,
                cheat => cheat, rst => rst, run => run
            );
 
 -- Clock Process:
clk_process : process
   begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
end process;
 
 
sim_run: process
    begin
        Run <= '0';
            wait for clk_period*5;
        Run <= '1'; 
            wait for clk_period*2;
end process; 


sim_cheat: process
    begin
        cheat <= '1';
            wait for clk_period*50;
        cheat <= '0'; 
            wait for clk_period*50;
end process; 
 
-- Stimuli process       
stim: process
       begin
            R_in <= "000";
            wait for clk_period*8;
            R_in <= "001";
            wait for clk_period*8;
            R_in <= "010";
            wait for clk_period*8;
            R_in <= "011";
            wait for clk_period*8;
            R_in <= "100";
            wait for clk_period*8;
            R_in <= "101";
            wait for clk_period*8;
            R_in <= "110";
            wait for clk_period*8;
            R_in <= "111";
            wait for clk_period*8;
    end process;
end;
