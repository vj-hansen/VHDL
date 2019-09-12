----------------------------------------------------------------------------------
-- Company: USN Kongsberg
-- Engineer: Deivydas Kazokas
-- 
-- Create Date: 2019.09.10 02:00 PM
-- Project Name: Electonic dice
-- Module Name: Main Testbeanch - architecture
-- Target Devices: Basys 3
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main_TB is
--  Port ( );
end main_TB;

architecture Behavioral of main_TB is

-- Define clock for test bench
constant clk_period : time := 10 ns;

component main is
   port(
      clk, run, clear, cheat: in std_logic;
      anode: out std_logic_vector(3 downto 0);
      sseg: out std_logic_vector(6 downto 0);
      cheat_pins: in std_logic_vector(2 downto 0)
   );   
end component;

-- Define signal
signal clk, run, clear, cheat: std_logic;
signal sseg: std_logic_vector(6 downto 0);
signal cheat_pins: std_logic_vector(2 downto 0);

-- Begin testing
begin

-- Initiate unit under testing
uut: main port map (
    clk => clk, run => run, clear => clear, cheat => cheat,
    sseg => sseg, cheat_pins => cheat_pins
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
-- Initial setup as in table
    clear <= '1'; -- reset flipflops only on start
    wait for clk_period*2; -- wait for 2 clock periods

-- everything off    
    clear <= '0'; 
    run <= '0'; 
    cheat <= '0'; 
    wait for clk_period*2;
    
-- Test run while cheat pins get assigned value
    run <= '1'; 
    cheat_pins <="011";
    wait for clk_period*10;
 
-- Test run and set cheat pin to high
    run <= '1';
    cheat <= '1';
    wait for clk_period*5; 

-- Set run to low and look if result is same as in cheat pins
    run <= '0'; 
    wait for clk_period*2; 
 
-- Set run to high and cheat to low to see if it counts further
    run <= '1';
    cheat <= '0'; 
    wait for clk_period*2;
 
 -- Terminate simulation
 assert false
    report "Simulation Completed"
 severity failure;
    
end process;
end Behavioral;
