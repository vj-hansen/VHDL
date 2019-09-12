-- 3-bit counter (result generator)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity UniBitCnt is
  Port (clk, clear, en, reset : in std_logic;
        c_out : out std_logic_vector(2 downto 0));
end UniBitCnt;


architecture Behavioral of UniBitCnt is
    signal ffin, ffout : unsigned(2 downto 0);
begin
-- state register section
process (clk, reset)
begin
    if (reset = '1') then
        ffout <= (others => '0');
    elsif rising_edge(clk) then
        ffout <= ffin;
    end if;
end process;

      
      clear <= ((run and not cheat) ffout(2) and not (ffout(1)) and ffout(0)))
      or (run and cheat and not (rin(2)) and not (rin(1)) and not (rin(0))) -- R = 000
      or (run and cheat and (rin(2)) and (rin(1)) and (rin(0))) -- R = 111
      
      
      
-- Next-state logic (combinational)
ffin <= (others => '0') when (clear = '1') else
        ffout when (en = '0') else  -- no action (run = 0)
        ffout+1;   -- count up

  
  ---- sender ut tall fra counter om det er mindre enn 5 (=6 på terning),
  ---- men 
  rout <= std_logic_vector(ffout) when ffout <= 5 else
    std_logic_vector(unsigned(rin)-1) -- send verdi for cheat (ffout > 5 --> går til X1 og x2)

c_out <= std_logic_vector(ffout);
end Behavioral;
