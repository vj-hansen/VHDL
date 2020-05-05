library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UniBitCnt_tb is
end UniBitCnt_tb;

architecture Behavioral of UniBitCnt_tb is
    constant clk_period : time := 10ns;

component UniBitCnt
    port (clk, clear, enable, load, direction, reset : in std_logic;
        c_in : in std_logic_vector(7 downto 0);
        c_out : out std_logic_vector(7 downto 0));
end component;

signal clk, clear, enable, load, direction, reset : std_logic;
signal c_in, c_out : std_logic_vector(7 downto 0);

begin
uut: UniBitCnt port map
        (
            clk => clk, clear => clear, enable => enable,
            load => load, direction => direction, 
            reset => reset, c_in => c_in, c_out => c_out
        );

clk_process: process
begin 
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

stim: process
begin
        reset <='1';
    wait for clk_period;
        reset <= '0';
        c_in <= "00001111";
        load <= '1';
    wait for clk_period;
        load <= '0';
        enable <= '1';
        direction <= '1';   -- count up
    wait for clk_period*16;
        direction <= '0';   -- count down
    wait for clk_period*16;
        clear <= '1';
    wait for clk_period;
end process;
end;
