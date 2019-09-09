library IEEE;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity e_dice is
  Port (
        clk, reset, run, cheat, clear: in std_logic; --clock and reset
        count: out std_logic_vector (2 downto 0) --control signals 

        );
end e_dice;

architecture arch of e_dice is
-- Signals
    signal state: unsigned (2 downto 0);
    signal new_state: unsigned (2 downto 0);
begin

process (clk, reset)
begin
    if(reset = '1') then
        state <= (others => '0'); --if reset is high flipflop states goes to 0
    elsif rising_edge(clk) then
        state <= new_state; --when clock becomes positive it updates existing flipflop state
    end if;   
end process;

-- Counter
new_state <=    "001"       when clear = '1' else -- Clears register and sets counter to 1
                "001"       when state = "110" else -- If counter reches 6 set it to 1
                state + 1   when run = '1' else -- Counts up
                state; -- Pause Output

-- Output logic
    count <= std_logic_vector(state); -- Converts unsigned to vector form
end arch;
