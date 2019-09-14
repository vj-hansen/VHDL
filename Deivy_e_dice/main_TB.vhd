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
      clk, reset, run, cheat_en: in std_logic;
      sseg, led: out std_logic_vector(6 downto 0);
      cheat_pins: in std_logic_vector(2 downto 0)
      );   
end component;

-- Define signal
signal clk, run, reset, cheat_en: std_logic;
signal sseg, led: std_logic_vector(6 downto 0);
signal cheat_pins: std_logic_vector(2 downto 0);

-- ***Begin testing***
begin

-- Initiate unit under testing
uut: main port map (
    clk=>clk, run=>run, reset=>reset, cheat_en=>cheat_en,
    cheat_pins=>cheat_pins, sseg=>sseg, led=>led
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
-- Initial setup tu reset on startup
    reset <= '1'; -- reset flipflops only on start
    wait for clk_period*2; -- wait for 2 clock periods

-- everything off    
    reset <= '0'; 
    run <= '0'; 
    cheat_en <= '0'; 
    wait for clk_period;
    
-- Test run while cheat_en pins get assigned value
    run <= '1'; 
    cheat_pins <="011"; -- set cheat pins to 3
    wait for clk_period*7;
 
-- Test run and set cheat_en pin to high
    cheat_en <= '1';
    wait for clk_period*7; 

-- Set run to low and look if result is same as in cheat_en pins
    run <= '0'; 
    wait for clk_period*3; 
 
-- Set run to high and cheat_en to low to see if it counts further
    run <= '1';
    cheat_en <= '0'; 
    wait for clk_period*5;
 
 -- Terminate simulation
 assert false
    report "Simulation Completed"
 severity failure;
    
end process;
end Behavioral;
