library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UniBitCnt_tb2 is
end UniBitCnt_tb2;

architecture Behavioral of UniBitCnt_tb2 is
    constant clk_period : time := 10ns;

component UniBitCnt2
    port (clk, reset : in std_logic;
          c_in : in std_logic_vector(7 downto 0);
          c_out : out std_logic_vector(7 downto 0);
          ctrl : in std_logic_vector(2 downto 0));
end component;

signal clk, reset : std_logic;
signal c_in, c_out : std_logic_vector(7 downto 0);
signal ctrl : std_logic_vector(2 downto 0);

begin
uut: UniBitCnt2 port map
        (
            clk => clk, reset => reset,
            c_in => c_in, c_out => c_out, ctrl => ctrl
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
        reset <= '1';
    wait for clk_period;
        reset <= '0';
        ctrl <= "000";
    wait for clk_period*2;
        ctrl <= "001"; -- count up
    wait for clk_period*8;
        ctrl <= "010"; -- count down
    wait for clk_period*8;
        c_in <= "00011111";
        ctrl <= "011"; -- load
    wait for clk_period;
        ctrl <= "001";
    wait for clk_period*8; -- count up from c_in
end process;
end;
