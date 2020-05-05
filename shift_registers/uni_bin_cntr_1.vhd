-- universal binary counter

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity UniBitCnt is
  Port (clk, clear, enable, load, direction, reset : in std_logic;
        c_in : in std_logic_vector(7 downto 0);
        c_out : out std_logic_vector(7 downto 0));
end UniBitCnt;

architecture Behavioral of UniBitCnt is
    signal ffin, ffout : unsigned(7 downto 0);
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
-- Next-state logic (combinational)
ffin <= (others => '0') when (clear = '1') else -- clear c_out
        ffout when (enable = '0') else          -- no action
        unsigned(c_in) when (load = '1') else   -- load initial value c_in
        ffout+1 when (direction = '1') else     -- count up
        ffout-1;                                -- count down
-- output logic (combinational)
c_out <= std_logic_vector(ffout);
end Behavioral;
