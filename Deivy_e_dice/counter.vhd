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
-- Tick generator is used in this design because Basys3 clock is at 100MHz(100000000 cycles per second)
-- this clock speed is too quick for digits to be visible while run is pressed.
-- Basys3 board will count pulses up to desired value and will activate flipflop logic for dice selection. 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity counter is
   port(
      clk, reset, run, cheat: in std_logic;
      dice: out std_logic_vector(2 downto 0);
      cheat_pins: in std_logic_vector(2 downto 0)
      );
end counter;

architecture arch of counter is

-- signals
   constant pulses: integer:=8000000; -- max value of 23bits=8388608, higher value = slower clock
   signal tick_in, tick_out: unsigned(22 downto 0); -- range must match max integer value chosen
   signal ff_in, ff_out: unsigned(2 downto 0); -- flipflops 3-bit dice
   signal ff_en, clear: std_logic; -- flipflop enable and clear
   
begin
-- clock register
    process(clk)
    begin
      if(reset = '1') then
        tick_out <= (others => '0'); -- reset tick generator
        ff_out <= (others => '0');   -- reset 
      elsif rising_edge(clk) then
         tick_out <= tick_in;        -- updates tick generator when clock edge is rising
         ff_out <= ff_in;            -- updates dice flipflops when clock edge is rising
      end if;
    end process;

-- next-state cascading logic
    -- tick generator, for slowing down the clock
   tick_in <= (others=>'0')  when (run='1' and tick_out=pulses) else  -- reset tick generator when counter matches desired value of pulses
               tick_out + 1   when run='1' else                       -- count further
               tick_out;                                              -- pause counter
        
   -- enable slowed down flip-flop updating logic
   ff_en <='1'   when tick_out=pulses else '0'; -- when tick generator matches desired value of pulses, activate flipflop logic

   -- flip-flop update logic for e-dice         
   ff_in <= (others=>'0') when (ff_en='1' and clear='1') else -- clear flipflops 
            ff_out + 1  when ff_en='1' else                   -- count further
            ff_out;                                           -- pause counter
             
     -- clear flip-flop logic for e-dice
   clear <= '1' when (cheat='0' and ff_out="101") else                       -- clear when ff exceed "5" w/o cheat is on 
            '1' when (cheat='1' and ff_out="101" and cheat_pins="000") else  -- clear when ff exceed "5" with cheat is on and invalid cheat combination
            '1' when (cheat='1' and ff_out="101" and cheat_pins="111") else  -- clear when ff exceed "5" with cheat is on and invalid cheat combination
            '0';                                                             -- if no condition is met, keep clear signal low                                                                                                                                                                                      

   -- output logic
   dice <= std_logic_vector(ff_out) when ff_out<=5 else -- count normally in all 5 states
           std_logic_vector(unsigned(cheat_pins)-1);    -- insert 2 states in counter if cheat is valid
end arch;
