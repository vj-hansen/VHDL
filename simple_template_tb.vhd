library ieee;
use ieee.std_logic_1164.all;

entity tb_module_name is
end tb_module_name;

architecture tb of tb_module_name is

    component module_name
        port (clk, reset : in std_logic;
              ...   : in std_logic;
			  ...   : in std_logic_vector(M downto 0);
              ...   : out std_logic;
			  ...   : out std_logic_vector(N downto 0)
			  );
    end component;

    signal clk, reset : std_logic;
    signal ...   : std_logic; -- module inputs
	signal ...   : std_logic_vector(M downto 0); -- module inputs
    signal ...   : std_logic; -- module outputs
	signal ...   : std_logic_vector(N downto 0); -- module outputs

    constant clk_period : time := 10 ns;

begin

    uut : module_name
    port map (clk => clk, reset => reset,
              ... => ..., ... => ...,
              ... => ..., ... => ...);


clk_process: process 
   begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
   end process;

-- Stimuli process 
   stim_proc: process
      begin
         ... <= '0';
         reset <= '1';      
         wait for clk_period*2;
         reset <= '0';      
		 
         ... <= '1';      
		 ...
         wait for clk_period*...;
         ...
        
      end process ;

end tb;
