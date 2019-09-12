----------------------------------------------------------------------------------
-- Company: USN Kongsberg
-- Engineer: Deivydas Kazokas
-- 
-- Create Date: 2019.09.10 02:00 PM
-- Project Name: Electonic dice
-- Module Name: Display - architecture
-- Target Devices: Basys 3
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
entity display is
   port(
      hex: in std_logic_vector(2 downto 0);
      anode: out std_logic_vector(3 downto 0);
      sseg, led: out std_logic_vector(6 downto 0) 
      );
end display ;

architecture arch of display is

begin
-- turn anode to constant 1 digit orig "1110"
   anode <= "0111";
   
-- Process for hex-to-7-segment led decoding   
    sseg <= 
        "0000001" when hex = "000" else
        "1001111" when hex = "001" else
        "0010010" when hex = "010" else
        "0000110" when hex = "011" else
        "1001100" when hex = "100" else
        "0100100" when hex = "101" else
        "0100000" when hex = "110" else
        "0001111";

-- Process for led decoding   
    led <= 
        "0000000" when hex = "000" else
        "0000001" when hex = "001" else
        "0000011" when hex = "010" else
        "0000111" when hex = "011" else
        "0001111" when hex = "100" else
        "0011111" when hex = "101" else
        "0111111" when hex = "110" else
        "1111111";    
    
    
        
end arch;