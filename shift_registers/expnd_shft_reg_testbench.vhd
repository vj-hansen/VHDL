library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity w03d3_2tb is
end w03d3_2tb;

architecture Behavioral of w03d3_2tb is
    constant clk_period : time := 10ns;

component slr8bits
    port (clk, rst, sin : in std_logic;
          ctrl : in std_logic_vector(1 downto 0);
          p_load : in std_logic_vector(7 downto 0);
          dout : out std_logic_vector(7 downto 0));
end component;
    signal clk, rst, sin : std_logic;
    signal ctrl : std_logic_vector(1 downto 0);
    signal p_load : std_logic_vector(7 downto 0);
    signal dout : std_logic_vector(7 downto 0);
begin
uut: slr8bits port map(
        clk => clk, rst => rst, sin => sin,
        ctrl => ctrl, p_load => p_load, dout => dout
    );
-- clock process (f = 1/10ns = 100 MHz)
clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2; -- off for 5 ns
        clk <= '1';
        wait for clk_period/2; -- on for 5 ns
end process;
--------------
stim: process
begin
    rst <= '1';
    wait for clk_period*2;
    rst <= '0';
    ctrl <= "10"; -- right shift
    sin <= '1'; 
    wait for clk_period*8;
    rst <= '1';
    wait for clk_period*2;
    rst <= '0';
    ctrl <= "01"; -- left shift
    wait for clk_period*8;
    rst <= '1';
    wait for clk_period*2;
    rst <= '0';
    p_load <= "01010101";
    ctrl <= "11"; -- parallel
    wait for clk_period*8;
end process;
end;
