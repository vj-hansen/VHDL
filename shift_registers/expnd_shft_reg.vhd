-- expanded shift-register
library ieee;
use ieee.std_logic_1164.all;

entity slr8bits is
    Port ( clk, rst, sin: in std_logic;
           ctrl: in std_logic_vector(1 downto 0);
           p_load: in std_logic_vector(7 downto 0);
           dout: out std_logic_vector(7 downto 0)
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
-- Next-state logic (combinational)
with ctrl select
    ffin <=
        ffout                      when "00",   -- no action
        ffout (6 downto 0) & sin   when "01",   -- left-shift
        sin & ffout(7 downto 1)    when "10",   -- right-shift
        p_load                     when others; -- parallel
-- output logic (combinational)
dout <= ffout;
end arch;
