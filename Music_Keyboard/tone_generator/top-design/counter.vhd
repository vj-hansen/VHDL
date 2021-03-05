library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tone_gen is
    Port (  clk, reset: in std_logic;
            note_sw : in std_logic_vector(2 downto 0);
            audio_out : out std_logic);
end tone_gen;

architecture Behavioral of tone_gen is
    signal Q : std_logic_vector(17 downto 0) := (others => '0');
    signal buzz: std_logic := '0'; 
    signal clear : std_logic;
    signal ffin, ffout : unsigned(17 downto 0);
    
    constant n_Do  : std_logic_vector := "101110101010001001";  -- 191 113
    constant n_Re  : std_logic_vector := "101001100100010110";  -- 170 262
    constant n_Mi  : std_logic_vector := "100101000010000110";  -- 151 686
    constant n_Fa  : std_logic_vector := "100010111101000101";  -- 143 173
    constant n_Sol : std_logic_vector := "011111001001000001";   -- 127 553
    constant n_La  : std_logic_vector := "011011101111100100";   -- 113 636
    constant n_Ti  : std_logic_vector := "011000101101110111";   -- 101 239
begin

-- state register section
process (clk, reset)
begin
    if (reset='1') then
        ffout <= (others => '0');
    elsif rising_edge(clk) then
        ffout <= ffin;
    end if;
end process;
-- Next-state logic (combinational)
ffin <= (others => '0') when clear = '1' 
         else ffout+1;
-- output logic (combinational)
Q <= std_logic_vector(ffout);
             
process(Q, note_sw)
    begin
        case (note_sw) is
            when "001" =>
                if(Q >= n_Do) then
                    clear <= '1';
                    buzz <= not buzz;
                else
                    clear <= '0';
                end if;
            when "010" =>
                if(Q >= n_Re) then
                    clear <= '1';
                    buzz <= not buzz;
                else
                    clear <= '0';
                end if;
            when "011" =>
                if(Q >= n_Mi) then
                    clear <= '1';
                    buzz <= not buzz;
                else
                    clear <= '0';
                end if;
            when "100" =>
                if(Q >= n_Fa) then
                    clear <= '1';
                    buzz <= not buzz;
                else
                    clear <= '0';
                end if;
            when "101" =>
                if(Q >= n_Sol) then
                    clear <= '1';
                    buzz <= not buzz;
                else
                    clear <= '0';
                end if;
            when "110" =>
                if(Q >= n_La) then
                    clear <= '1';
                    buzz <= not buzz;
                else
                    clear <= '0';
                end if;
            when "111" =>
                if(Q >= n_Ti) then
                    clear <= '1';
                    buzz <= not buzz;
                else
                    clear <= '0';
                end if;         
            when others =>
                buzz <= '0';
                clear <= '1';
        end case;
audio_out <= buzz;
end process;
end Behavioral;
