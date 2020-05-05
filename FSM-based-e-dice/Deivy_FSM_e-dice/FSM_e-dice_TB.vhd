----------------------------------------------------------------------------------
-- USN Kongsberg
-- Engineers: Deivydas Kazokas, Victor Hansen
-- 
-- Project Name: CCW-2 FSM-based electronic dice
-- Module Name: FSM_e-dice - testbench
-- Target Devices: Basys 3
----------------------------------------------------------------------------------

library ieee;
use ieee.STD_LOGIC_1164.ALL;

entity fsm_edice_TB is
end fsm_edice_TB;

architecture Behavioral of fsm_edice_TB is
-- Define clock for testbench
constant clk_period : time := 10 ns;

component fsm_edice is
   port(
      clk, reset, run: in std_logic;
      R: in std_logic_vector(2 downto 0);
      M: in std_logic_vector(1 downto 0);
      anode: out std_logic_vector(3 downto 0);
      sseg, led: out std_logic_vector(6 downto 0)
      );   
end component;

-- Define signals
signal clk, run, reset: std_logic;
signal led: std_logic_vector(6 downto 0);
signal R: std_logic_vector(2 downto 0);
signal M: std_logic_vector(1 downto 0);

begin
-- Initiate unit under testing
uut: fsm_edice port map (
    clk=>clk, run=>run, reset=>reset, M=>M,
    R=>R, led=>led
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
    reset <= '1'; -- reset flip flops only on start
    wait for clk_period*2; -- wait for 2 clock periods

-- everything off    
    reset <= '0'; 
    run <= '0'; 
    M <= "00"; 
    wait for clk_period;
    
-- 'rolling' the dice
    run <= '1'; 
    wait for clk_period*7;
 
 -- reset
    run <= '0';
    R <="000"; 
    M <= "00";
    wait for clk_period*2; 
    
-- Test run and Cheat Mode pins
    run <= '1';
    M <= "11";
    R <="011";
    wait for clk_period*7; 

-- Pause
    run <= '0';
    R <="000"; 
    M <= "00";
    wait for clk_period*2; 
 
-- TEST FORBIDDEN
    run <= '1';
    M <= "01";
    R <="011"; -- skip result 3
    wait for clk_period*7;
 
 -- Pause
    run <= '0';
    R <="000"; 
    M <= "00";
    wait for clk_period*2;
 
 -- TEST PREDEFINED
    run <= '1';
    M <= "10";
    R <="101"; -- always result 5
    wait for clk_period*3;
    
    run <= '0';
    wait for clk_period*2;
    reset <= '1';
    wait for clk_period*2;
 
 -- Terminate simulation
 assert false
    report "Simulation Completed"
 severity failure;
    
end process;
end Behavioral;
