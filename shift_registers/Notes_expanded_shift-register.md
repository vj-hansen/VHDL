## Expanded shift-register

Consider an 8-bit shift-left register and its corresponding VHDL description, and assume that we want to expand it in order to support bidirectional shifting (shift-right) and parallel load inputs.


```vhdl
-- USN VHDL 101 course
-- 8-bit shift-left register
library ieee;
use ieee.std_logic_1164.all;
entity slr8bits is
    Port ( clk, rst, sin: in std_logic;
           dout: out std_logic_vector (7 downto 0)
                );
end slr8bits;
architecture arch of slr8bits is
signal ffin, ffout: std_logic_vector (7 downto 0);
begin

-- state register section
process (clk, rst)
        begin
                if (rst = '1') then
                        ffout <= (others => '0');
                elsif rising_edge(clk) then
                        ffout <= ffin;
        end if;
end process;

-- outputs section
ffin <= ffout (6 downto 0) & sin;
dout <= ffout;
end arch;
```


Shift registers consist of D flip-flops. An 8-bit shift register consists of 8 D flip-flops. Bidirectional shift registers are able to shift data right or left.


#### 1.	Function table describing the operations of the expanded shift-register.


clk    |reset  | ctrl | dout 
------ |------ |----  |-----
x      |1      | X    | Clear to zero
↑      |0      | 00   | Hold state
↑      |0      | 01   | left-shift
↑      |0      | 10   | right-shift
↑      |0      | 11   | parallel load
