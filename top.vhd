-- top-design

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
  Port (clk, cheat, reset, run : in std_logic;
        R_in : in std_logic_vector(2 downto 0);
--        R_out : out std_logic_vector(2 downto 0);
        an : out std_logic_vector(3 downto 0);
        seg7 : out STD_LOGIC_VECTOR(6 downto 0);
        leds : out STD_LOGIC_VECTOR(6 downto 0));
end top;

architecture Behavioral of top is

--signal clear : std_logic;
signal Res : std_logic_vector(2 downto 0);

begin
counter : entity work.UniBitCnt port map (
            clk => clk,
            run => run,
            reset => reset,
            cheat => cheat,
            R_in  => R_in,
            R_out => Res
);

display : entity work.sseg port map (
            BCD => Res,
            an  => an,
            seg7 => seg7,
            leds => leds
);

end Behavioral;
