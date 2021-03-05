----------------------------------------------------------------------------------
-- Testbench

-- USN Kongsberg
-- Engineers: Deivydas Kazokas, Victor J. Hansen
-- Project Name: OOP4200 CCW-2: FSM-based e-dice
-- Target Device: Basys 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_fsm_edice is
end tb_fsm_edice;

architecture Behavioral of tb_fsm_edice is
constant clk_period : time := 10 ns;

component fsm_edice is
   port(
      clk, rst, run: in std_logic;
      R: in std_logic_vector(2 downto 0);
      M: in std_logic_vector(1 downto 0);
      anode: out std_logic_vector(3 downto 0);
      sseg, leds: out std_logic_vector(6 downto 0)
      );   
end component;

-- Define signal
signal clk, run, rst: std_logic;
signal sseg, leds: std_logic_vector(6 downto 0);
signal R: std_logic_vector(2 downto 0);
signal M: std_logic_vector(1 downto 0);

begin
-- Initiate unit under testing
uut: fsm_edice port map (
    clk=>clk, run=>run, rst=>rst, M=>M,
    R=>R, sseg=>sseg, leds=>leds
    );

-- Clock process
clk_process: process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

-- Stimulus process
stim: process
begin
-- Initial setup to reset on startup
    rst <= '1'; -- rst flipflops only on start
    wait for clk_period*2; -- wait for 2 clock periods

-- everything off    
    rst <= '0'; 
    run <= '0'; 
    M <= "00"; 
    wait for clk_period;
    
-- COUNT as usual
    run <= '1'; 
    wait for clk_period*7;
 
 -- reset
    run <= '0';
    R <="000"; 
    M <= "00";
    wait for clk_period*2; 
    
-- Test run and set cheat_en pin to high
    run <= '1';
    M <= "11";
    R <="011";
    wait for clk_period*7; 

-- reset
    run <= '0';
    R <="000"; 
    M <= "00";
    wait for clk_period*2; 
 
-- FORBIDDEN
    run <= '1';
    M <= "01";
    R <="011"; -- skip result 3
    wait for clk_period*7;
 
 -- reset
    run <= '0';
    R <="000"; 
    M <= "00";
    wait for clk_period*2;
 
 -- PREDEFINED
    run <= '1';
    M <= "10";
    R <="110"; -- allways result 5
    wait for clk_period*3;
    
    run <= '0';
    wait for clk_period*2;
    
    run <= '1';
    wait for clk_period*7;
 
end process;
end Behavioral;
