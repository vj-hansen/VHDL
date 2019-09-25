-- e-dice: dice_logic
-- Victor Johan Hansen

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.ALL;

entity counter_logic is
  Port (clk, run, reset, cheat : in std_logic;
        set_val : in std_logic_vector(2 downto 0); -- set value
        state : out std_logic_vector(2 downto 0)); -- state
end counter_logic;

architecture Behavioral of counter_logic is
    signal ffin, ffout : unsigned(2 downto 0);
    signal clear : std_logic;
begin

-- State register
process (clk, reset)
begin
    if (reset = '1') then
        ffout <= (others => '0');
    elsif rising_edge(clk) then
        ffout <= ffin;
    end if;
end process;

-- Next-state logic
ffin <= (others=>'0') when (clear='1') else 
        ffout when (run='0') else  -- no action
        ffout+1;
  
clear <='1' when ((run='1') AND (cheat='0') AND (ffout="101")) else
        '1' when ((run='1') AND (cheat='1') AND (set_val="000") AND (ffout="101")) else
        '1' when ((run='1') AND (cheat='1') AND (set_val="111") AND (ffout="101")) else
        '0';

-- output logic
state <= std_logic_vector(ffout) when ffout<="101" else
         std_logic_vector(unsigned(set_val)-1);             
end Behavioral;
