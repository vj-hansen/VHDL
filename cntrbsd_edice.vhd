----------------------------------------------------------------------------------
-- OOP-4200
-- Engineer: Victor J. Hansen
-- Create Date: 04.09.2019
-- Project Name: Counter-based e-dice
-- Target Devices: Basys-3
-- Description: 
--  Cheating e-dice that triples the probability of any result at will
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity edice is
    Port ( clk   : in std_logic;
           R     : in STD_LOGIC_VECTOR(2 downto 0);
           cheat : in std_logic;
           rst   : in STD_LOGIC;
           run   : in STD_LOGIC; -- run sequence   
           dice_7 : out STD_LOGIC_VECTOR(6 downto 0); -- leds dice
           seg_7  : out STD_LOGIC_VECTOR(6 downto 0)); -- 7 segment display
end edice;

architecture Behavioral of edice is
    signal cnt : unsigned (2 downto 0);
    signal bcd_in : std_logic_vector(2 downto 0);
begin
    process (CLK, RST)
    begin
        if (RST = '1') then
            cnt <= (others => '0'); -- clear
        elsif (rising_edge(CLK)) then
            if (run = '1') then
                cnt <= cnt+1;
            else
                cnt <= cnt;
            end if;
        end if;
    end process;
bcd_in <= std_logic_vector(cnt);      
with BCD_IN select
        SEG_7 <= "0000001" when "000", -- 0
                 "1001111" when "001", -- 1
                 "0010010" when "010", -- 2
                 "0000110" when "011", -- 3
                 "1001100" when "100", -- 4
                 "0100100" when "101", -- 5
                 "0100000" when "110", -- 6
                 "1111111" when others; -- off       
end Behavioral;