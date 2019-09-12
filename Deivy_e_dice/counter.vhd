----------------------------------------------------------------------------------
-- Company: USN Kongsberg
-- Engineer: Deivydas Kazokas
-- 
-- Create Date: 2019.09.10 02:00 PM
-- Project Name: Electonic dice
-- Module Name: Counter - architecture
-- Target Devices: Basys 3
-- Additional Comments:
--
-- Tick generator is used in this design because Basys3 clock is at 450MHz(450000000 cycles per second)
-- this clock speed is too quick for digits to be visible while run is pressed.
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity counter is
   port(
      clk, reset, clear, run, cheat: in std_logic;
      dice: out std_logic_vector(2 downto 0);
      cheat_pins: in std_logic_vector(2 downto 0)
      );
end counter;

architecture arch of counter is

-- signals
   constant pulses: integer:=8300000; -- 23bits=8388608, higher value = slower clock
   signal tick_reg, tick_next: unsigned(22 downto 0); -- bits must match with max integer value
   signal dice_reg, dice_next: unsigned(2 downto 0); -- 3-bit dice values
   signal dice_enable: std_logic;
   
begin
-- clock register
    process(clk)
    begin
      if(reset = '1') then
        dice_reg <= (others => '0');
      elsif rising_edge(clk) then
         tick_reg <= tick_next; -- 23 flipflops for tick generator
         dice_reg <= dice_next; -- 4 flipflops for dice counting
      end if;
    end process;

-- next-state logic, cascading
    -- tick generator, for slowing down the clock
    tick_next <=
        (others=>'0')  when clear='1' or (tick_reg=pulses and run='1') else -- clear tick generator
        tick_reg + 1   when run='1' else
        tick_reg;
        
    -- enable dice counting logic for every time tick generator matches desired pulses
   dice_enable <='1'   when tick_reg=pulses else '0';
   
    -- counter logic for dice ***UNCOMMENT BEFORE IMPLEMENTATION***   
   dice_next <=
         "001"         when (clear='1') or (dice_enable='1' and dice_reg=6) else -- dice values displayed between 1-6
         dice_reg + 1  when dice_enable='1' else                
         "001"         when (run='0' and cheat='1'and cheat_pins="001") else
         "010"         when (run='0' and cheat='1'and cheat_pins="010") else
         "011"         when (run='0' and cheat='1'and cheat_pins="011") else
         "100"         when (run='0' and cheat='1'and cheat_pins="100") else
         "101"         when (run='0' and cheat='1'and cheat_pins="101") else
         "110"         when (run='0' and cheat='1'and cheat_pins="110") else
         "001"         when (run='0' and cheat='1'and cheat_pins="111") else
         dice_reg;
         
         
--    -- counter logic for dice ***UNCOMMENT ONLY FOR SIMULATION***   
--   dice_next <=
--         "001"         when (clear='1') or (run='1' and dice_reg=6) else -- dice values displayed between 1-6
--         dice_reg + 1  when run='1' else
--         "001"         when (run='0' and cheat='1'and cheat_pins="001") else
--         "010"         when (run='0' and cheat='1'and cheat_pins="010") else
--         "011"         when (run='0' and cheat='1'and cheat_pins="011") else
--         "100"         when (run='0' and cheat='1'and cheat_pins="100") else
--         "101"         when (run='0' and cheat='1'and cheat_pins="101") else
--         "110"         when (run='0' and cheat='1'and cheat_pins="110") else
--         "111"         when (run='0' and cheat='1'and cheat_pins="111") else
--         dice_reg;

-- output logic
   dice <= std_logic_vector(dice_reg);
end arch;