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
    Port ( clk, cheat, rst, run : in std_logic;
           R : in STD_LOGIC_VECTOR(2 downto 0);
           an : out std_logic_vector(3 downto 0); -- select 7seg-disp -- default=1110
           led : out STD_LOGIC_VECTOR(6 downto 0); -- leds dice
           seg_7 : out STD_LOGIC_VECTOR(6 downto 0)); -- 7 segment display
end edice;

-- lag egen komponent for bcd->7seg


architecture Behavioral of edice is
    signal state : std_logic_vector (2 downto 0);
    signal seg_val, led_val : std_logic_vector(6 downto 0);
    signal cnt : unsigned(2 downto 0);
begin
an <= "1110";



count_process: process (CLK, state, cheat, Run, R, rst)
    begin
        if (rst = '1') then
            cnt <= (others => '0');
        elsif (rising_edge(CLK)) then
            case State is
                when "000" => -- dice = 1 
                    if (Run = '0') then  -- stop
                        led <= "0000001"; -- display 1
                        seg_7 <= "1001111";
                        cnt <= cnt;    
                    elsif ((cheat = '0') AND (R = "001")) then
                        cnt <= cnt;
                    elsif ((cheat = '1') AND (R = "001")) then -- 3x probability
                        seg_val <= "1001111"; -- display 1
                        led_val <= "0000001"; -- display 1
                        cnt <= cnt+1;
                    else 
                        cnt <= cnt+1;
                    end if;
        -------------------  
                when "001" => -- dice = 2 
                    if (Run = '0') then 
                        led <= "0000010"; -- display 2
                        seg_7 <= "0010010";
                        cnt <= cnt;    
                    elsif ((cheat = '0') AND (R = "010")) then
                        cnt <= cnt;
                    elsif ((cheat = '1') AND (R = "010")) then -- 3x probability
                        seg_val <= "0010010"; -- display 2
                        led_val <= "0000010"; -- display 2 fix
                        cnt <= cnt+1;
                    else 
                        cnt <= cnt+1;
                    end if;
        -------------------  
                when "010" => -- dice = 3 
                    if (Run = '0') then 
                        led <= "0000100"; -- display 3 fix
                        seg_7 <= "0000110"; -- fix
                        cnt <= cnt;    
                    elsif ((cheat = '0') AND (R = "011")) then
                        cnt <= cnt;
                    elsif ((cheat = '1') AND (R = "011")) then -- 3x probability
                        seg_val <= "0000110"; -- display 3
                        led_val <= "0000100"; -- display 3 fix
                        cnt <= cnt+1;
                    else 
                        cnt <= cnt+1;
                    end if;
        -------------------  
                when "011" => -- dice = 4 
                    if (Run = '0') then 
                        led <= "0001000"; -- display 4
                        seg_7 <= "1001100"; -- fix 4
                        cnt <= cnt;    
                    elsif ((cheat = '0') AND (R = "100")) then
                        cnt <= cnt;
                    elsif ((cheat = '1') AND (R = "100")) then -- 3x probability
                        seg_val <= "1001100"; -- display 4
                        led_val <= "0001000"; -- display 4 fix
                        cnt <= cnt+1;
                    else 
                        cnt <= cnt+1;
                    end if;   
        
        
        
        -------------------      
                when "100" => -- dice = 5 
                    if (Run = '0') then 
                        led <= "0010000"; -- display 5
                        seg_7 <= "0100100";
                        cnt <= cnt;    
                    elsif ((cheat = '0') AND (R = "101")) then
                        cnt <= cnt;
                    elsif ((cheat = '1') AND (R = "101")) then -- 3x probability
                        seg_val <= "0100100"; -- display 5
                        led_val <= "0010000"; -- display 5 fix
                        cnt <= cnt+1;
                    else 
                        cnt <= cnt+1;
                    end if;
        
        
        -------------------  
                when "101" => -- dice = 6 
                    if (Run = '0') then 
                        led <= "0100000"; -- display 6 fix
                        seg_7 <= "0100000";
                        cnt <= cnt;    
                    elsif ((cheat = '0') AND (R = "110")) then
                        cnt <= cnt;
                    elsif ((cheat = '1') AND (R = "110")) then
                            seg_val <= "0100000"; -- display 6
                            led_val <= "0100000"; -- display 6 
                            cnt <= cnt+1;
                    elsif ((R = "000") OR (R = "111")) then
                        cnt <= (others => '0');
                    else cnt <= (others => '0');
                    end if;
                
                
                
                -------------------  
                when "110" => -- X1 
                    if (Run = '0') then 
                        led <= led_val;
                        seg_7 <= seg_val;
                        cnt <= cnt;    
                    else 
                        cnt <= cnt+1;
                    end if;
                -------------------  
                when "111" => --  X2 
                    if (Run = '0') then 
                        led <= led_val;
                        seg_7 <= seg_val;
                        cnt <= cnt;    
                    else
                        cnt <= (others => '0');
                    end if;
                -------------------      
        when others =>
            led <= "0000000";
           seg_7 <= "1111111";                              
        end case;
        end if;
    end process count_process;
roll : process(cnt, Run)
        begin
            if cnt <= "000" then
                state <= "000"; -- 0
            elsif cnt <= "001" then
                state <= "001"; -- 1
            elsif cnt <= "010" then
                state <= "010"; -- 2
            elsif cnt <= "011" then
                state <= "011"; -- 3
            elsif cnt <= "100" then
                state <= "100"; -- 4
            elsif cnt <= "101" then
                state <= "101"; -- 5
            elsif cnt <= "110" then
                state <= "110"; -- 6
            elsif cnt <= "111" then
                state <= "111";
            end if;
    end process roll;
end Behavioral;
