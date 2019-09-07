library ieee;
use ieee.std_logic_1164.all;
 
entity edice_tb is
end edice_tb;
 
architecture tb of edice_tb is
    
    constant clk_period : time := 10 ns;
    component edice
        port (  CLK, Cheat, rst, run : in std_logic;
                R : in std_logic_vector(2 downto 0);
                dice_7 : out std_logic_vector(6 downto 0);
                seg_7 : out std_logic_vector(6 downto 0)
            );
    end component;
signal clk, Run, Cheat : std_logic;
signal R : std_logic_vector(2 downto 0);
signal rst : std_logic := '0';
signal dice_7 : std_logic_vector(6 downto 0);
signal seg_7 : std_logic_vector(6 downto 0);   

begin
    uut : edice port map
            (
                clk => clk, dice_7 => dice_7,
                seg_7 => seg_7, r => r,
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
 
-- Stimuli process       
stim: process
       begin
            run <='1';
            cheat <= '0';
            wait for clk_period*10;
            r <= "000";
            wait for clk_period*10;
            r <= "001";
            wait for clk_period*10;
            cheat <= '1';
            r <= "010";
            wait for clk_period*10;
            r <= "011";
            run <= '0';
            wait for clk_period*10;
            r <= "100";
            wait for clk_period*10;
            r <= "101";
            wait for clk_period*10;
            r <= "110";
            wait for clk_period*10;
            r <= "111";
            wait for clk_period*10;
    end process;
end;
