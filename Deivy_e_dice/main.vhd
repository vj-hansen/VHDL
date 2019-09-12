----------------------------------------------------------------------------------
-- Company: USN Kongsberg
-- Engineer: Deivydas Kazokas
-- 
-- Create Date: 2019.09.10 02:00 PM
-- Project Name: Electonic dice
-- Module Name: Main - architecture
-- Target Devices: Basys 3
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity main is
   port(
      clk, run, clear, cheat: in std_logic;
      anode: out std_logic_vector(3 downto 0);
      sseg, led: out std_logic_vector(6 downto 0);
      cheat_pins: in std_logic_vector(2 downto 0)
      );
end main;

architecture arch of main is
    
    signal dice: std_logic_vector(2 downto 0);

begin
   display_unit: entity work.display(arch)
      port map(
         anode=>anode, sseg=>sseg, led=>led,
         -- dice chooses hex value to display
         hex=>dice );

  counter_unit: entity work.counter(arch)
     port map(
        clk=>clk, run=>run, clear=>clear, dice=>dice, cheat=>cheat, cheat_pins=>cheat_pins );
end arch;