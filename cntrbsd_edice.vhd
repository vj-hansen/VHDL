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
use IEEE.std_logic_unsigned.all;

entity edice is
    Port ( clk      : in std_logic;
           R        : in STD_LOGIC_VECTOR(2 downto 0);
           cheat    : in std_logic;
           rst      : in STD_LOGIC;
           run      : in STD_LOGIC; -- run sequence
           an       : out std_logic_vector(3 downto 0); -- select 7seg-disp -- default=1110
           dice_7   : out STD_LOGIC_VECTOR(6 downto 0); -- leds dice
           seg_7    : out STD_LOGIC_VECTOR(6 downto 0); -- 7 segment display
           dp       : out std_logic); -- decimal point
end edice;

--architecture Behavioral of dice is
--    type eg_state_type is (s0, s1, s2, s3, s4, s5, s6, s7);
--    signal state_reg, state_next: eg_state_type;
--    signal s_value, l_value : std_logic_vector(6 downto 0);'
--begin

architecture Behavioral of edice is
    signal state, next_state : std_logic_vector (2 downto 0);
    --signal bcd_in : std_logic_vector(2 downto 0);
    --signal State, NxtState : integer range 0 to 7;
    signal seg_val, led_val : std_logic_vector(6 downto 0);
begin

------------------------ ok    
    process (CLK, RST)
    begin
        if (RST = '1') then
            state <= "000";
        elsif (rising_edge(CLK)) then
            if (run = '1') then
                state <= next_state; 
            else
                state <= state;
            end if;
        end if;
    end process;
------------------------ ok

process(state, R, run, cheat)
  begin
    an <= "1110";
    dp <= '1';
    if (Run = '1') then -- if running 
        dice_7 <= "0000000";
        seg_7 <= "1111111";
    end if;
--------------------------------------  
    case State is
        when "000" => -- dice = 1 
            if (Run = '0') then  -- stop
                dice_7 <= "0000000"; -- display 1
                seg_7 <= "1111111";
                next_State <= "000";    
            elsif ((cheat = '0') AND (R = "001")) then
                next_State <= "000";
            elsif ((cheat = '1') AND (R = "001")) then -- 3x probability
                seg_val <= "0000000"; -- display 1 fix
                led_val <= "0000000"; -- display 1 fix
                next_State <= "001";
            else 
                next_state <= "001";
            end if;
        -------------------  
        when "001" => -- dice = 2 
            if (Run = '0') then 
                dice_7 <= "0000000"; -- display 2 fix
                seg_7 <= "1111111"; -- fix
                next_state <= "001";    
            elsif ((cheat = '0') AND (R = "010")) then
                next_state <= "001";
            elsif ((cheat = '1') AND (R = "010")) then -- 3x probability
                seg_val <= "0000000"; -- display 2 fix
                led_val <= "0000000"; -- display 2 fix
                next_state <= "010";
            else 
                next_state <= "010";
            end if;
        -------------------  
        when "010" => -- dice = 3 
            if (Run = '0') then 
                dice_7 <= "0000000"; -- display 3 fix
                seg_7 <= "1111111"; -- fix
                next_state <= "010";    
            elsif ((cheat = '0') AND (R = "011")) then
                next_state <= "010";
            elsif ((cheat = '1') AND (R = "011")) then -- 3x probability
                seg_val <= "0000000"; -- display 3 fix
                led_val <= "0000000"; -- display 3 fix
                next_state <= "011";
            else 
                next_state <= "011";
            end if;
        -------------------  
        when "011" => -- dice = 4 
            if (Run = '0') then 
                dice_7 <= "0000000"; -- display 4 fix
                seg_7 <= "1111111"; -- fix 4
                next_State <= "011";    
            elsif ((cheat = '0') AND (R = "100")) then
                next_State <= "011";
            elsif ((cheat = '1') AND (R = "100")) then -- 3x probability
                seg_val <= "0000000"; -- display 4 fix
                led_val <= "0000000"; -- display 4 fix
                next_State <= "100";
            else 
                next_State <= "100";
            end if;   
        -------------------      
        when "100" => -- dice = 5 
            if (Run = '0') then 
                dice_7 <= "0000000"; -- display 5 fix
                seg_7 <= "1111111"; -- fix
                next_State <= "100" ;    
            elsif ((cheat = '0') AND (R = "101")) then
                next_State <= "100";
            elsif ((cheat = '1') AND (R = "101")) then -- 3x probability
                seg_val <= "0000000"; -- display 5 fix
                led_val <= "0000000"; -- display 5 fix
                next_State <= "101";
            else 
                next_State <= "101";
            end if;
        -------------------  
        when "101" => -- dice = 6 
            if (Run = '0') then 
                dice_7 <= "0000000"; -- display 6 fix
                seg_7 <= "1111111"; -- fix
                next_State <= "101";    
            elsif ((cheat = '0') AND (R = "110")) then
                next_State <= "101";
            
            elsif (cheat = '1') then
                if (R = "110") then -- 3x probability
                    seg_val <= "0000000"; -- display 6 fix
                    led_val <= "0000000"; -- display 6 fix
                end if;
            next_state <= "110";
            if ((R = "000") OR (R = "111")) then
                next_state <= "000";
            end if;
            else 
             next_state <= "000";
            end if;
        -------------------  
        when "110" => -- extra round 1 
            if (Run = '0') then 
                dice_7 <= led_val;
                seg_7 <= seg_val;
                next_State <= "110";    
            else 
                next_State <= "110";
            end if;
        -------------------  
        when "111" => -- x2 
            if (Run = '0') then 
                dice_7 <= led_val;
                seg_7 <= seg_val;
                next_State <= "111";    
            else
                next_State <= "000";
            end if;
        -------------------      
        when others =>
            dice_7 <= "0000000";
            seg_7 <= "1111111";                              
        end case;
    end process;
end Behavioral;
