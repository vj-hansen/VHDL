-- 3-bit counter

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.ALL;

entity counter_logic is
  Port (clk, run, reset, cheat : in std_logic;
        R_in : in std_logic_vector(2 downto 0);
        R_out : out std_logic_vector(2 downto 0));
end counter_logic;

architecture Behavioral of counter_logic is
    signal ffin, ffout : unsigned(2 downto 0);
    signal clear : std_logic;
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
ffin <= (others=>'0') when (clear='1') else 
        ffout when (run='0') else  -- no action
        ffout+1;

  --------- fix
clear <= '1' when (run='1' and cheat='0' and ffout="101") else
         '1' when (run='1' and cheat='1' and R_in="000" and ffout="101") else
         '1' when (run='1' and cheat='1' and R_in="111" and ffout="101");

  --------------
-- output logic (combinational)
R_out <= std_logic_vector(ffout) when ffout<="101" else
         std_logic_vector(unsigned(R_in)-1);
             
end Behavioral;
