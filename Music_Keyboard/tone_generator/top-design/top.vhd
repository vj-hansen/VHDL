library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port(   clk, reset: in std_logic;
            note_sw : in std_logic_vector(2 downto 0);  
            audio_out : out std_logic
        );
end top;

architecture Behavioral of top is
begin
u1 : entity work.tone_gen port map(
            clk => clk, reset => reset, 
            note_sw => note_sw, audio_out=>audio_out     
);
end Behavioral;
