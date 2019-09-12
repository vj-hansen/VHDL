-- top-design

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
  Port (clk, cheat, reset, run : in std_logic;
        R : in std_logic_vector(2 downto 0);
        an : out std_logic_vector (3 downto 0);
        seg7 : out STD_LOGIC_VECTOR (6 downto 0);
        leds : out STD_LOGIC_VECTOR (6 downto 0));
end top;

architecture Behavioral of top is

signal clear : std_logic;
signal q : std_logic_vector(2 downto 0);

begin
u1 : entity work.UniBitCnt port map (
            clk => clk,
            clear => clear,
            en => run,
            reset => reset,
            c_out => q
);

u2 : entity work.sseg port map (
            BCD => q,
            an => an,
            seg7 => seg7,
            leds => leds
);
-------------------- no logic here
    process (clk, cheat, R, run)
        begin
            if (R = "111") and (cheat = '0') then -- og R = "110"
                clear <= '1';
          -- X1 og X2
            elsif (((q = "110") OR (q = "111")) AND (cheat = '1')) then
                clear <= '0';
            elsif (cheat = '0' and R <= q) then
                clear <= '0';
            else
                clear <= '0';
            end if;
    end process;
  ------------------ some issues here            
end Behavioral;
