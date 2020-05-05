----------------------------------------------------------------------------------
-- USN Kongsberg
-- Engineers: Deivydas Kazokas, Victor Hansen
-- 
-- Project Name: CCW-2 FSM-based electronic dice
-- Module Name: FSM_e-dice - architecture
-- Target Devices: Basys 3
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity fsm_edice is
   port(
      clk, reset, run:   in std_logic;
      M:   in std_logic_vector(1 downto 0);  -- Cheat Mode
      R:  in std_logic_vector(2 downto 0);   -- Selected result
      anode:        out std_logic_vector(3 downto 0);
      sseg, led:    out std_logic_vector(6 downto 0)
      );
end fsm_edice;

architecture arch of fsm_edice is
-- signals   
   signal dice: std_logic_vector(2 downto 0);
   type state is (s0, s1, s2, s3, s4, s5, s6, s7, predefined);
   signal state_reg, state_next: state;
   
begin
-- state register
    process(clk)
      begin
         if (reset = '1') then
            state_reg <= s0;  
         elsif rising_edge(clk) then
            state_reg <= state_next;    
         end if;
    end process;

-- next-state logic, based on state diagram
process (state_reg, run, M, R)
begin
   state_next <= state_reg; --stay in state
   case state_reg is
      
      -- State 0: dice = 1 -------------------- 
      when s0 =>
        dice<="001";         
        if (run='1' and M="01" and R="010") then -- Cheat: forbidden
           state_next <= s2;  -- skip state 1
        elsif (run='0' and M="10") then -- Cheat: predefined
           state_next <= predefined;
        else
           state_next <= s1;  -- go to next state
        end if;
      
      -- State 1: dice = 2 --------------------  
      when s1 =>
        dice<="010";         
        if (run='1' and M="01" and R="011") then -- Cheat: forbidden
           state_next <= s3;  -- skip state 2
        elsif (run='0' and M="10") then -- Cheat: predefined
           state_next <= predefined;
        else
           state_next <= s2;  -- go to next state
        end if;
      
      -- State 2: dice = 3 --------------------
      when s2 =>
        dice<="011";         
        if (run='1' and M="01" and R="100") then -- Cheat: forbidden
           state_next <= s4;  -- skip state 3
        elsif (run='0' and M="10") then -- Cheat: predefined
           state_next <= predefined;
        else
           state_next <= s3;  -- go to next state
        end if;
      
      -- State 3: dice = 4 --------------------  
      when s3 =>
        dice<="100";         
        if (run='1' and M="01" and R="101") then -- Cheat: forbidden
           state_next <= s5;  -- skip state 4
        elsif (run='0' and M="10") then -- Cheat: predefined
           state_next <= predefined;
        else
           state_next <= s4;  -- go to next state
        end if;
      
      -- State 4: dice = 5 --------------------
      when s4 =>
        dice<="101";
        if (run='1' and M="01" and R="110") then -- Cheat: forbidden
           state_next <= s0;  -- skip state 5
        elsif (run='0' and M="10") then -- Cheat: predefined
           state_next <= predefined;
        else 
           state_next <= s5;  -- go to next state
        end if;
       
      -- State 5: dice = 6 --------------------
      when s5 =>
        dice<="110";         
        if (run='1' and M="11" and (R /= ("111" or "000"))) then -- Cheat: 3x probability
           state_next <= s6;     -- go to extra state X1
        elsif (run='1' and M="01" and R="001") then -- Cheat: forbidden
           state_next <= s1;     -- skip state 0
        elsif (M = "10") then    -- Cheat: predefined
           state_next <= predefined;
        else 
           state_next <= s0;     -- go to next state
        end if;
      
      -- State 6: cheat X1 --------------------  
      when s6 =>
        if (run='1') then
           dice <=  R;        -- display dice-result
           state_next <= s7;  -- go to extra state X2
        elsif (M="10") then -- Cheat: predefined
           state_next <= predefined;
        end if;                                                                                                        
         
      -- State 7: cheat X2 --------------------  
      when s7 =>
        if (run='1') then     
           dice <=  R;        -- display dice-result
           state_next <= s0;  -- go to next state
        elsif (M="10") then -- Cheat: predefined
           state_next <= predefined;
        end if;
      
      -- Predefined state ---------------------  
      when predefined =>      -- Enter predefined state when run is released
        if (run='0' and (R /= ("111" or "000"))) then
            dice <= R;
        else state_next <= s0;                                                 
        end if;
   end case;
end process; 
-----------------------------------------
-- Decoding for 7-segment display
    anode <= "0111";
    sseg <= 
      -- abcdefg
        "1001111" when dice = "001" else  -- 1
        "0010010" when dice = "010" else  -- 2
        "0000110" when dice = "011" else  -- 3
        "1001100" when dice = "100" else  -- 4
        "0100100" when dice = "101" else  -- 5
        "0100000";                        -- 6

-- LED decoding   
    led <=                 
        "0000001" when dice = "001" else  -- 1
        "0000011" when dice = "010" else  -- 2
        "0000111" when dice = "011" else  -- 3
        "0001111" when dice = "100" else  -- 4
        "0011111" when dice = "101" else  -- 5
        "0111111";                        -- 6 
end arch;
