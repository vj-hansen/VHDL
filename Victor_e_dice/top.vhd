-- e-dice: top-design
-- Victor Johan Hansen

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
  Port (clk, cheat, reset, run : in std_logic;
        set_val : in std_logic_vector(2 downto 0);
        an : out std_logic_vector(3 downto 0);
        seg7, leds : out STD_LOGIC_VECTOR(6 downto 0));
end top;

architecture Behavioral of top is
signal Res : std_logic_vector(2 downto 0);
begin
counter : entity work.counter_logic port map (
            clk=>clk, run=>run, reset=>reset,
            cheat=>cheat, set_val=>set_val, state=>Res);

display : entity work.sseg port map (
            BCD=>Res, an=>an, seg7=>seg7, leds=>leds);
end Behavioral;
