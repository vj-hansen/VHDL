-- universal binary counter

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity UniBitCnt2 is
  Port (clk, reset : in std_logic;
        c_in : in std_logic_vector(7 downto 0);
        c_out : out std_logic_vector(7 downto 0);
        ctrl : in std_logic_vector(2 downto 0));
end UniBitCnt2;

architecture Behavioral of UniBitCnt2 is
    signal ffin, ffout : unsigned(7 downto 0);
begin

process (clk, reset)
begin
    if (reset = '1') then       -- reset input
        ffout <= (others => '0');
    elsif rising_edge(clk) then
        ffout <= ffin;
    end if;
end process;

with ctrl select
    ffin <= ffout           when "000", -- pause
            ffout+1         when "001", -- count up
            ffout-1         when "010", -- count down
            unsigned(c_in)  when "011", -- load
            (others => '0') when others; --clear
            
c_out <= std_logic_vector(ffout);
end Behavioral;
