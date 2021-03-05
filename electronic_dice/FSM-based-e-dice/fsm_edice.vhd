----------------------------------------------------------------------------------
-- USN Kongsberg
-- Engineers: Deivydas Kazokas, Victor J. Hansen
-- Project Name: OOP4200 CCW-2: FSM-based e-dice
-- Target Device: Basys 3 Artix-7
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fsm_edice is
    port(
        clk, rst, RUN : in std_logic;
        R : in std_logic_vector(2 downto 0); -- Result selection
        M : in std_logic_vector(1 downto 0); -- Cheat mode
        anode : out std_logic_vector(3 downto 0);
        sseg, leds : out std_logic_vector(6 downto 0) -- display dice value
        );
end fsm_edice;

architecture arch of fsm_edice is
   signal BCD, BCD_temp: std_logic_vector(2 downto 0);
   type state is (S0, S1, S2, S3, S4, S5, S6, S7);
   signal PS, NS: state; -- present state, next state
begin
-- state register
process(clk)
    begin
        if(rst = '1') then
            PS <= S0;   
        elsif rising_edge(clk) then
            PS <= NS;            
        end if;
end process;

-- next-state outputs section, based on state diagram
process (PS, RUN)
begin
    case PS is
      -----------------------------------------
      -- State 0: dice = 1 -------------------- 
        when S0 =>
            BCD <= "001";         
            if (RUN='0' AND M="10") then -- Cheat: predefined
                BCD <= R;
                NS <= S0;   -- stay in state
            elsif (RUN='0') then
                NS <= S0;   -- stay in state
            elsif (RUN='1' AND M="01" AND R="010") then -- Cheat: forbidden
                NS <= S2;   -- skip next state
            elsif (M="11" AND R="001") then -- Cheat: 3x probability
                BCD_temp <= R;
                NS <= S1;   -- go to next state
            else NS <= S1;  -- go to next state
            end if;
      -----------------------------------------
      -- State 1: dice = 2 --------------------  
        when S1 =>
            BCD <= "010";         
            if (RUN='0' AND M="10") then -- Cheat: predefined
                BCD <= R;
                NS <= S1;   -- stay in state
            elsif (RUN='0') then
                NS <= S1;   -- stay in state
            elsif (RUN='1' AND M="01" AND R="011") then -- Cheat: forbidden
                NS <= S3;   -- skip next state
            elsif (M="11" AND R="010") then -- Cheat: 3x probability
                BCD_temp <= R;
                NS <= S2;   -- go to next state
            else NS <= S2;  -- go to next state
            end if;
      -----------------------------------------
      -- State 2: dice = 3 --------------------
        when S2 =>
            BCD <= "011";         
            if (RUN='0' AND M="10") then -- Cheat: predefined
                BCD <= R;
                NS <= S2;   -- stay in state
            elsif (RUN='0') then
                NS <= S2;   -- stay in state
            elsif (RUN='1' AND M="01" AND R="100") then -- Cheat: forbidden
                NS <= S4;   -- skip next state
            elsif (M="11" AND R="011") then -- Cheat: 3x probability
                BCD_temp <= R;
                NS <= S3;   -- go to next state
            else NS <= S3;  -- go to next state
            end if;
      -----------------------------------------
      -- State 3: dice = 4 --------------------  
        when S3 =>
            BCD <= "100";         
            if (RUN='0' AND M="10") then -- Cheat: predefined
                BCD <= R;
                NS <= S3;   -- stay in state
            elsif (RUN='0') then
                NS <= S3;   -- stay in state
            elsif (RUN='1' AND M="01" AND R="101") then -- Cheat: forbidden
                NS <= S5;   -- skip next state
            elsif (M="11" AND R="100") then -- Cheat: 3x probability
                BCD_temp <= R;
                NS <= S4;   -- go to next state
            else NS <= S4;  -- go to next state
            end if;
      -----------------------------------------
      -- State 4: dice = 5 --------------------
        when S4 =>
            BCD <= "101";
            if (RUN='0' AND M="10") then -- Cheat: predefined
                BCD <= R;       
                NS <= S4;   -- stay in state
            elsif (RUN='0') then
                NS <= S4;   -- stay in state
            elsif (RUN='1' AND M="01" AND R="110") then -- Cheat: forbidden
                NS <= S0;   -- skip next state
            elsif (M="11" AND R="101") then -- Cheat: 3x probability
                BCD_temp <= R;
                NS <= S5;   -- go to next state
            else NS <= S5;  -- go to next state
            end if;
      -----------------------------------------
      -- State 5: dice = 6 --------------------
        when S5 =>
            BCD <= "110";         
            if (RUN='0' AND M="10") then -- Cheat: predefined
                BCD <= R;
                NS <= S5;   -- stay in state
            elsif (RUN='1' AND M="01" AND R="001") then -- Cheat: forbidden
                NS <= S1;   -- skip next state
            elsif (M="11") then -- Cheat: 3x probability
                if (R = "110") then
                    BCD_temp <= R;
                end if;
                NS <= S6;   -- go to extra state X1
            elsif (RUN='1') then
                NS <= S0;   -- go to next state
            else NS <= S5;  -- stay in state
            end if;
      -----------------------------------------
      -- State 6: X1 --------------------------  
        when S6 =>
            if (RUN = '0') then
                BCD <= BCD_temp;
            else
                NS <= S7;
            end if;
      -----------------------------------------
      -- State 7: X2 --------------------------  
        when S7 =>
            if (RUN = '0') then
                BCD <= BCD_temp;
            else
                NS <= S0;
            end if;
    end case;
end process;
-----------------------------------------
-- Decoding for seven-segment display ----
    anode <= "0111";
    sseg <= 
        "1001111" when BCD = "001" else  -- 1
        "0010010" when BCD = "010" else  -- 2
        "0000110" when BCD = "011" else  -- 3
        "1001100" when BCD = "100" else  -- 4
        "0100100" when BCD = "101" else  -- 5
        "0100000" when BCD = "110" else  -- 6
        "1111111";  -- blank

-- LED decoding
    leds <=                 
        "0000001" when BCD = "001" else  -- 1
        "0000011" when BCD = "010" else  -- 2
        "0000111" when BCD = "011" else  -- 3
        "0001111" when BCD = "100" else  -- 4
        "0011111" when BCD = "101" else  -- 5
        "0111111" when BCD = "110" else  -- 6 
        "0000000"; -- blank
end arch;
