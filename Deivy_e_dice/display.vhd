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
      dice_disp: in std_logic_vector(2 downto 0);
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
        "1001111" when dice_disp = "000" else  --"001"
        "0010010" when dice_disp = "001" else  --"010"
        "0000110" when dice_disp = "010" else  --"011"
        "1001100" when dice_disp = "011" else  --"100"
        "0100100" when dice_disp = "100" else  --"101"
        "0100000";                             --"110"
                           
-- Process for led decoding   
    led <=                 
        "0000001" when dice_disp = "000" else  --"001"
        "0000011" when dice_disp = "001" else  --"010"
        "0000111" when dice_disp = "010" else  --"011"
        "0001111" when dice_disp = "011" else  --"100"
        "0011111" when dice_disp = "100" else  --"101"
        "0111111";                             --"110"   
            
end arch;
