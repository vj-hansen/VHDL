library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sseg is
    Port ( BCD : in std_logic_vector(2 downto 0);
           an  : out STD_LOGIC_vector(3 downto 0);
           seg7 : out STD_LOGIC_VECTOR (6 downto 0);
           leds : out STD_LOGIC_VECTOR (6 downto 0));
end sseg;

architecture Behavioral of sseg is
begin

an <="1110";

process (BCD)
    begin
        case BCD is
            when "000" =>
                seg7  <= "1001111"; -- 1
                leds  <= "0000001";
            when "001" =>
                seg7  <= "0010010"; -- 2
                leds  <= "0000011";
            when "010" =>
                seg7  <= "0000110"; -- 3
                leds  <= "0000111";
            when "011" =>
                seg7  <= "1001100"; -- 4
                leds  <= "0001111";
            when "100" =>
                seg7  <= "0100100"; -- 5
                leds  <= "0011111";
            when "101" =>
                seg7  <= "0100000"; -- 6
                leds  <= "0111111";
            when others =>
                seg7  <= "1111111"; -- blank
                leds  <= "0000000";
        end case;
    end process;                          
end Behavioral;
