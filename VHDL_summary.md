# VHDL SUMMARY


### Basic rules of VHDL
White space and case insensitive.

**Object names:**: Must start by a letter. Limited to letters, digits and underscores. Cannot end with an underscore(`a_`), and cannot have two consecutive underscores(`a__b`).

---
### Main sections in a VHDL description file
**Design file:**
* Library: contains packages that predefine data types, no need to declare data types.
* Entity: describes the interface of our circuit (I/O).
* Architecture: describes the function of our circuit.

**Entity**
```vhdl
entity abc is
    generic ( N : integer := 1); -- optional   
    port ( a : in std_logic;
           b : out std_logic );
end abc;
```

**Architecture**
```vhdl
architecture arch of abc is
    signal xx : std_logic;
begin
    -- do stuff here
end arch;
```


**VHDL architectures**
* Dataflow: shows the flow of data explicitly.
* Behavioral: focus on what the function does.
* Structural: ties the synthesizer to a fixed structure.


Multiple architectures may coexist with a single entity in the same file. If no binding indication is given, the most recently analyzed architecture body will be used.
```vhdl
architecture arch1 of dec2to4 is
begin
  -- ...
end arch1;

architecture arch2 of dec2to4 is -- use this.
begin
   -- ...
end arch2;
```

**VHDL objects and data types**
An object is a named entity that contains a value of a type.
* Constants: useful for representing commonly used values.
* Signals: declared without «direction».
* Variables
* Files
---
### Hierarchical design
#### Declaring a component
You can tie together several components or drivers in a top-module, this is known as hierarchical design.

```vhdl
architecture arch of abc is
    signal a, b : std_logic;
    component xyz 
        --generic ( );
        port ( x : in std_logic;
               y : out std_logic );
    end component;
begin
 label: xyz 
    port map(x=>a, y=>b); -- connect ports to signals
    -- alt: port map(a, b);
end arch;
```

**other method**
```vhdl
entity XOR_GATE_4 is
   port ( IN1,IN2: in BIT_VECTOR(0 to 3);
        OUT1 : out BIT_VECTOR(0 to 3) );
end entity XOR_GATE_4;
architecture XOR_BODY_4 of XOR_GATE_4 is
begin
   OUT1 <= IN1 xor IN2;
end architecture XOR_BODY_4;
------------------------------------------
entity EXAMPLE is
end entity EXAMPLE;
architecture STRUCTURE_1 of EXAMPLE is
    signal S1, S2 : BIT_VECTOR(0 to 3);
    signal S3 : BIT_VECTOR(0 to 3);
begin
   X1 : entity WORK.XOR_GATE_4(XOR_BODY_4)
          port map (S1, S2, S3);
end architecture STRUCTURE_1;
```

### Generate Statement
```vhdl
gen_label: FOR i IN 0 TO 7 GENERATE
    comp_label: xyz PORT MAP( x(i)=>a(i), y(i)=>b(i) );
    -- alt: port map(a(i), b(i));
END GENERATE gen_label;
```

### IEEE library packages
**`std_logic_1164`:** comprises the data types, procedures and functions that are most commonly used (e.g. data types `std_logic` and `std_logic_vector`).

**`numeric_std`:** defines the unsigned and signed data types, and the use of relational and arithmetic operators upon them (operator overloading).

Example (just use this for every program you write):
```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
```

### Data types
`std_logic` is a data type comprising 9 values (character literals): U, X, 0, 1, Z, W, L, H, -.
```vhdl
'U' -- uninitialized (default value)
'X' -- Strong drive, unknown logic value
'0' -- Strong drive, logic zero
'1' -- Strong drive, logic one
'Z' -- High impedance, for tri-state logic
'W' -- Weak drive, unknown logic value
'L' -- Weak drive, logic zero
'H' -- Weak drive, logic one
'-' -- Dont' care
```

**Synthesizable data types:** most synthesis tools do not support any I/O format other than `std_logic_vector` and `std_logic`. 
Other commonly used data types are:
```vhdl
bit, bit_vector, integer, natural, boolean, character, string
```

### Type casting
Not all operators work on all data types. std_logic_vector can be used with logical operators, but not with arithmetic operators. Type casting is therefore required to change the data type of multi-bit operands defined in the entity declaration as std_logic_vector.

#### Bits and Vectors in Port
Bits and vectors declared in port with direction.
```vhdl
port ( a : in std_logic; -- signal comes in to port a from outside
       b : out std_logic; -- signal is sent out to the port b
       c : inout std_logic; -- bidirectional port
       x : in std_logic_vector(7 downto 0); -- 8-bit input vector
       y : out std_logic_vector(7 downto 0) -- no ‘;’ for the last item
    );
```

#### Signals
Signals are declared without direction.
```vhdl
signal s1, s2 : std_logic;
signal X, Y : std_logic_vector(31 downto 0);
```

#### Constants
Constants are useful for representing commonly-used values of specific types.
```vhdl
-- in the declaration area:
constant init : std_logic_vector(3 downto 0) := “1100”;
signal sig_vec : std_logic_vector(3 downto 0);
-- In the body:
sig_vec <= init;
```

#### Relational Operators
Return a Boolean result and thus used in if or when clauses.
```vhdl
=   -- equal to: highest precedence
/=  -- not equal to
<   -- less than
<=  -- less than equal
>   -- greater than
>=  -- greater than equal: lowest precedence
```

#### Logical Operators
Bit-by-bit logical operations.
```vhdl
not     -- highest precedence
and, or, nand, nor, xor
xnor    -- lowest precedence
```

#### Other functions: 
```vhdl
maximum, minimum, rising_edge, falling_edge, to_string
```

#### Assignments
```vhdl
<= -- signal assignment
:= -- variable assignment, signal initialization

-- Example:
    signal q: std_logic_vector(3 downto 0);

-- Multiple bits are enclosed using a pair of double quotations:
    q <= “1011”;
-- Hexadecimals are represented using X”….”:
    q <= X”B”;
-- A single bit is enclosed using single quotations:
    q <= (‘1’, ’0’, ’1’, ’1’);
-- You may use named association:
    q <= (3=>’1’, 2=>’0’, 1=>’1’, 0=>’1’);
-- Named association allows position independence, i.e., you can write
    q <= (0=>’1’, 2=>’0’, 1=>’1’, 3=>’1’);
-- You may combine indices.
    q <= (3|1|0 => ‘1’, 2 => ‘0’);
-- Use the keyword ‘others’ to simplify the expression.
    q <= (2=>’0’, others => ‘1’);
-- We frequently use others for initialization or setting bits.
    x <= “00000000”; -- is same as
    x <= (others => ‘0’);
```

#### Concatenation, &
```vhdl
signal a, b : std_logic_vector(7 downto 0) := “10111111”;
b <= a(7 downto 2) & “00”;  -- b contains “10111100”
```
---
### Concurrent Statements and combinational circuits
The distinctive feature of combinational circuits is their lack of information about past events (time information). For this reason, the outputs of a combinational circuit **depend solely on the present value of the inputs**. Each input pattern corresponds to a unique output pattern, but the opposite is not true. The complexity of combinational circuits is widely variable (from simple multiplexers to large multipliers). 

Most applications of digital electronics require the ability to hold time information (e.g. the last digit pressed in an electronic lock will – or will not – open the door according to the previous digits pressed). For this reason, combinational blocks are normally used as part of a larger circuit that is able to hold the memory of past events.

#### Concurrent Signal Assignment
```vhdl
A <= B AND C;
DAT <= (D AND E) OR (F AND G);
```

#### Conditional Signal Assignment "when-else"
```vhdl
F3 <= '1' when (L='0' AND M='0') else
      '1' when (L='1' AND M='1') else
      '0';
```

#### Selective Signal Assignment "with-select"
```vhdl
with SEL select
  MX_OUT <= D3 when “11”,
            D2 when “10”,
            D1 when “01”,
            D0 when “00”,
            ‘0’ when others;
```
---
#### Process
A process statement defines an independent sequential process representing the behavior of some portion of the design. The process statement executes concurrently with other statements, but the sequential statements that it encapsulates «execute in the order in which they appear».

**Sensitivity list**: The process is activated whenever at least *one* signal in its sensitivity list *changes* its value. Choosing the signals to include in the sensitivity list is critical (and a frequent source of design problems). A process *without* a sensitivity list will trigger immediately.

```vhdl
proc1: process(A,B,C) begin
    if (A = '1' and B = ‘0’) then
        F_OUT <= '1';
    elsif (B = '1' and C = '1') then
        F_OUT <= '1';
    else
        F_OUT <= '0';
    end if;
end process proc1;
```
---
### Sequential Statements and circuits
Sequential circuits store information about past events (in the form of internal states). In a sequential circuit the outputs depend on the present value of the inputs and on their past values (there may be more than one output pattern for each input pattern, depending on internal state information. 

#### Synchronous sequential circuits 
Information about past events may be available via feedback or by using storage elements (normally edge-triggered flip-flops). We are only interested in synchronous sequential circuits, where information about past events is stored in flip-flops driven by a common clock signal. Regular sequential circuits have predefined state transition diagrams and output behavior (the combinational logic is predefined to implement commonly used functions). Examples of regular sequential circuits: registers (e.g. the “state register”), counters and shift registers.

#### Simulation source file
The simulation source file for sequential circuits extends the template used for combinational circuits:
* Adds another process statement to generate the clock signal. `clk_process`
* Changes the timeout clause of the wait statement to consider clock period units. `wait for clk_period`

```vhdl
clk_process: process begin
    clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
end process;
```

#### Variables
Variables are objects used to store intermediate values between sequential VHDL statements.
Variables are only allowed in processes, procedures and functions, and they are always local to those functions. 
When a value is assigned to a variable, `:=` is used. Both signals and variables carry data from place to place. However, you must always use signals to carry information between concurrent elements of your design.

Example:
```vhdl
signal A, B: std_logic;
process(Rst, Clk)
    variable Q1, Q2, Q3: std_logic;
begin
    if Rst=’1’ then
        Q1 := '0'; Q2 := '0'; Q3 := '0';
    elsif (Clk=’1’ and Clk’event) then
    Q1 := A; Q2 := B; Q3 := Q1 or Q2;
    end if;
end process;
```

#### *if* statements
```vhdl
if (SEL = “111”) then 
    F_CTRL <= D(7);
elsif (SEL = “110”) then 
    F_CTRL <= D(6);
elsif (SEL = “101”) then 
    F_CTRL <= D(1);
elsif (SEL = “000”) 
    then F_CTRL <= D(0);
else F_CTRL <= ‘0’;
end if;
```

#### *case* statements
```vhdl
case ABC is
    when “100” => F_OUT <= ‘1’;
    when “011” => F_OUT <= ‘1’;
    when “111” => F_OUT <= ‘1’;
    when others => F_OUT <= ‘0’;
end case;    
```
---
## :warning:`when` and `select` can only be used *outside* a process. `if` and `case` can only be used *inside* a process.:warning:

#### For-loop
```vhdl
for index in loop_range loop
    sequential_statements;
end loop;
------------------------------
for i in (10) downto 0 loop
    y(i) <= a(i) xor b(i)
end loop;
```

#### While Loop
```vhdl
loop_name: while (condition) loop
    ---repeated statements
end loop loop_name;
---------------------------------
while (e /= ‘1’ AND d /='1') loop
    clock <= not clock;
    wait for CLK_PERIOD/2;
end loop;
```
#### Infinite Loop
```vhdl
loop_name: loop
    ---
    exit when (condition)
end loop loop_name;
-------------------------
loop
    clock <= not clock;
    wait for CLK_PERIOD/2;
    if done = '1' or error_flag = '1' then
        exit;
    end if;
end loop;
```
---
#### Wait statement
«wait» is meant to suspend the execution of a process or procedure (particularly necessary when the process does not have a sensitivity list). We use it for suspending process execution during simulation.

#### Generics 
Makes it possible to re-use code. Specifies properties for a circuit, such as number of bits in a vector and the value of constants. Is placed right before the port declaration. Example:
```vhdl
entity gen_add_w_carry is
    generic(N: integer:=4);
    port( a, b: in std_logic_vector(N-1 down to 0);
          cout: out std_logic;
          sum: out std_logic_vector(N-1 down to 0));
end gen_add_w_carry;
```
------

### Template testbench
```
-- template for test bench development
library ieee;
use ieee.std_logic_1164.all;
-------------------------------
entity tb_module_name is
end tb_module_name;
-------------------------------
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
-------------------------------
clk_process: process begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
   end process;
-------------------------------
-- Stimuli process 
   stim_proc: process begin
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
```
---

### 4:1 MUX

```vhdl
entity MUX_4T1 is
    Port ( SEL : in std_logic_vector(1 downto 0);
           D_IN : in std_logic_vector(3 downto 0);
           F : out std_logic);
end MUX_4T1;
-----------------------------------------------
architecture my_mux of MUX_4T1 is
begin
    F <= D_IN(0) when (SEL = "00") else
         D_IN(1) when (SEL = "01") else
         D_IN(2) when (SEL = "10") else
         D_IN(3) when (SEL = "11") else
         '0';
end my_mux;
```
---
### 2:4 Decoder
```vhdl
entity DECODER is
    Port ( SEL : in std_logic_vector(1 downto 0);
           F : out std_logic_vector(3 downto 0));
end DECODER;
--------------------------------------------
architecture my_dec of DECODER is
begin
    with SEL select
        F <= "0001" when "00",
             "0010" when "01",
             "0100" when "10",
             "1000" when "11",
             "0000" when others;
end my_dec;
```
```vhdl
entity dec2to4 is
	Port (in1, in0, en: in STD_LOGIC;
	out3, out2, out1, out0: out STD_LOGIC);
end dec2to4;
--------------------------------------------
architecture arch of dec2to4 is
begin
process (in1,in0,en) begin
		out3 <= in1 AND in0 AND en;
		out2 <= in1 AND NOT (in0) AND en; 	
		out1 <= NOT (in1) AND in0 AND en;
		out0 <= NOT (in1) AND NOT (in0) AND en;
	end process;
end arch;
```
---

### 3:8 decoder using components
```vhdl
architecture arch1 of dec3to8 is
    component dec2to4 Port (
        in1, in0, en: in STD_LOGIC;
        out3, out2, out1, out0: out STD_LOGIC);
    end component;
begin
-- ports of component => new I/O
U1: dec2to4 Port Map (
    en => in2, in1 => in1, in0 => in0,
    out3 => out7, out2 => out6,
    out1 => out5, out0 => out4);

U2: dec2to4 Port Map (
    en => not(in2), in1 => in1, in0 => in0,
    out3 => out3, out2 => out2,
    out1 => out1, out0 => out0);
end arch1;
```
This can also be done in the following way:
```vhdl
architecture arch2 of dec3to8 is
    signal in2_int: STD_LOGIC;
begin

-- instantiate two 2:4 decoders
decoder1: entity work.dec2to4(arch)
    port map (in1 => in1, in0 => in0, en => in2,
              out3 => out7, out2 => out6,
              out1 => out5, out0 => out4);

decoder2: entity work.dec2to4(arch)
    port map (in1 => in1, in0 => in0,
              en => in2_int,
              out3 => out3, out2 => out2,
              out1 => out1, out0 => out0);
    in2_int <= not(in2);
end arch2;
```
---

### 4-bit adder (type casting)
The ports are of the type `STD_LOGIC_VECTOR`, they have to be type-casted to `UNSIGNED` to enable addition (or other arithmetic operations). The use of unsigned requires `ieee.numeric_std.all`.

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------
entity add4bits is
    Port ( opA, opB: in STD_LOGIC_VECTOR (3 downto 0);
           resC: out STD_LOGIC_VECTOR (4 downto 0) );
end add4bits;
--------------------------------------------
architecture arch of add4bits is
    signal valA, valB: unsigned (4 downto 0);
    signal valC: unsigned (4 downto 0);
begin
	valA <= unsigned('0' & opA);
	valB <= unsigned('0' & opB);
	valC <= valA + valB;
	resC <= std_logic_vector(valC);
end arch;
```

```vhdl
-- Testbench
ENTITY add4bits_tb IS 
END add4bits_tb;
--------------------------------------------
ARCHITECTURE behavior OF add4bits_tb IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT add4bits
        Port ( opA, opB: in STD_LOGIC_VECTOR (3 downto 0);
               resC: out STD_LOGIC_VECTOR (4 downto 0)); 
    END COMPONENT;
    signal opA, opB: STD_LOGIC_VECTOR (3 downto 0); -- module inputs
    signal resC: STD_LOGIC_VECTOR (4 downto 0); -- module outputs
begin
-- Instantiate the Unit Under Test (UUT) 
uut: add4bits PORT MAP (
        opA => opA, opB => opB, resC => resC );  
-- Stimulus process 
stim: process begin 
    opA  <= "0001"; opB  <= "0011";
    wait for 30 ns;
    opA  <= "0010";
    wait for 30 ns;
    opA  <= "0011";
    wait for 30 ns;
    opA  <= "0100";
    wait for 30 ns;
    opA  <= "0101";
    wait for 30 ns;
end process; 
end;
```
---
### 8-bit register with chip load enable
```vhdl
entity REG is
    port ( LD, CLK : in std_logic;
           D_IN : in std_logic_vector (7 downto 0);
           D_OUT : out std_logic_vector (7 downto 0));
end REG;
--------------------------------------------
architecture my_reg of REG is
begin
    process (CLK,LD) begin
        if (LD = '1' and rising_edge(CLK)) then D_OUT <= D_IN;
        end if;
    end process;
end my_reg;
```
---
### Expanded Shift-Register
Shift registers consist of D flip-flops. An 8-bit shift register consists of 8 D flip-flops. Bidirectional shift registers are able to shift data right or left.

```vhdl
entity slr8bits is
    Port ( clk, rst, sin: in std_logic;
           ctrl: in std_logic_vector(1 downto 0);
           p_load: in std_logic_vector(7 downto 0);
           dout: out std_logic_vector(7 downto 0)
         );
end slr8bits;
--------------------------------------------
architecture arch of slr8bits is
    signal ffin, ffout: std_logic_vector (7 downto 0);
begin
-- state register section
process (clk, rst) begin
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
        p_load                     when others; -- parallel load
-- output logic (combinational)
dout <= ffout;
end arch;
```

```vhdl
-- TESTBENCH expanded shift-register
entity w03d3_2tb is
end w03d3_2tb;
--------------------------------------------------------
architecture Behavioral of w03d3_2tb is
    constant clk_period : time := 10ns;
--------------------------------------------------------    
    component slr8bits
        port (clk, rst, sin : in std_logic;
              ctrl : in std_logic_vector(1 downto 0);
              p_load : in std_logic_vector(7 downto 0);
              dout : out std_logic_vector(7 downto 0));
    end component;
--------------------------------------------------------    
    signal clk, rst, sin : std_logic;
    signal ctrl : std_logic_vector(1 downto 0);
    signal p_load : std_logic_vector(7 downto 0);
    signal dout : std_logic_vector(7 downto 0);
begin
uut: slr8bits port map(
        clk => clk, rst => rst, sin => sin,
        ctrl => ctrl, p_load => p_load, dout => dout );
--------------------------------------------------------        
-- clock process (f = 1/10ns = 100 MHz)
clk_process: process begin
        clk <= '0';
        wait for clk_period/2; -- off for 5 ns
        clk <= '1';
        wait for clk_period/2; -- on for 5 ns
end process;
--------------------------------------------------------
stim: process begin
    rst <= '1';
    wait for clk_period*2;
    rst <= '0';
    ctrl <= "10"; -- right shift
    sin <= '1'; 
    wait for clk_period*8;
    rst <= '1';
    wait for clk_period*2;
    rst <= '0';
    ctrl <= "01"; -- left shift
    wait for clk_period*8;
    rst <= '1';
    wait for clk_period*2;
    rst <= '0';
    p_load <= "01010101";
    ctrl <= "11"; -- parallel
    wait for clk_period*8;
end process;
end;
```
---
### Universal Binary Counter 1
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
------------------------------------------------------------------
entity UniBitCnt is
  Port (clk, clear, enable, load, direction, reset : in std_logic;
        c_in : in std_logic_vector(7 downto 0);
        c_out : out std_logic_vector(7 downto 0));
end UniBitCnt;
------------------------------------------------------------------
architecture Behavioral of UniBitCnt is
    signal ffin, ffout : unsigned(7 downto 0);
begin
-- state register section
process (clk, reset) begin
    if (reset = '1') then
        ffout <= (others => '0');
    elsif rising_edge(clk) then
        ffout <= ffin;
    end if;
end process;
-- Next-state logic (combinational)
ffin <= (others => '0') when (clear = '1') else -- clear c_out
        ffout when (enable = '0') else          -- no action
        unsigned(c_in) when (load = '1') else   -- load initial value c_in
        ffout+1 when (direction = '1') else     -- count up
        ffout-1;                                -- count down
-- output logic (combinational)
c_out <= std_logic_vector(ffout);
end Behavioral;
```

```vhdl
-- testbench universal binary counter 1
entity UniBitCnt_tb is
end UniBitCnt_tb;
--------------------------------------------
architecture Behavioral of UniBitCnt_tb is
    constant clk_period : time := 10ns;
----------------------------------------------------------------------
    component UniBitCnt
        port (clk, clear, enable, load, direction, reset : in std_logic;
            c_in : in std_logic_vector(7 downto 0);
            c_out : out std_logic_vector(7 downto 0));
    end component;
----------------------------------------------------------------------
    signal clk, clear, enable, load, direction, reset : std_logic;
    signal c_in, c_out : std_logic_vector(7 downto 0);
begin
uut: UniBitCnt port map (
            clk => clk, clear => clear, enable => enable,
            load => load, direction => direction, 
            reset => reset, c_in => c_in, c_out => c_out );
--------------------------------------------------------
clk_process: process begin 
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;
--------------------------------------------------------
stim: process begin
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
```
---
#### Universal Binary Counter 2
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
--------------------------------------------
entity UniBitCnt2 is
  Port (clk, reset : in std_logic;
        c_in : in std_logic_vector(7 downto 0);
        c_out : out std_logic_vector(7 downto 0);
        ctrl : in std_logic_vector(2 downto 0));
end UniBitCnt2;
--------------------------------------------
architecture Behavioral of UniBitCnt2 is
    signal ffin, ffout : unsigned(7 downto 0);
begin
process (clk, reset) begin
    if (reset = '1') then  -- reset input
        ffout <= (others => '0');
    elsif rising_edge(clk) then
        ffout <= ffin;
    end if;
end process;
with ctrl select
    ffin <= ffout           when "000", -- pause
            ffout+1         when "001", -- count up
            ffout-1         when "010", -- count down
            unsigned(c_in)  when "011", -- load
            (others => '0') when others; --clear          
c_out <= std_logic_vector(ffout);
end Behavioral;
```

```vhdl
-- testbench universal binary counter 2
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--------------------------------------------
entity UniBitCnt_tb2 is
end UniBitCnt_tb2;
--------------------------------------------
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
uut: UniBitCnt2 port map (
            clk => clk, reset => reset,
            c_in => c_in, c_out => c_out, ctrl => ctrl
        );

clk_process: process begin 
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

stim: process begin
        reset <= '1';
    wait for clk_period;
        reset <= '0'; ctrl <= "000";
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
```
---
### 16-bit binary U/D counter
```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------
entity counter is
port(  clk: in std_logic;
        reset: in std_logic;
        en: in std_logic;
        direction: in std_logic;
        count_out: out std_logic_vector (15 downto 0));
end counter;
--------------------------------------------
architecture barch of counter is
signal count_int: unsigned(15 downto 0) := (others => '0');
begin
process (clk) begin
    if rising_edge(clk) then
        if reset='1' then
            count_int <= (others => '0');
        elsif en='1' then
            if direction='1' then
                count_int <= count_int + 1;
            else
                count_int <= count_int - 1;
            end if;
        end if;
    end if;
end process;
count_out <= std_logic_vector(count_int);
end barch;
```
```vhdl
-- u/d testbench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------
entity udtb is
end udtb;
--------------------------------------------
architecture Behavioral of udtb is
    constant clk_pr : time := 10ns;
    component counter
        port (clk, reset, en, direction: in std_logic;
              count_out : out std_logic_vector(15 downto 0));
    end component;

    signal clk, reset, en, direction : std_logic;
    signal count_out : std_logic_vector(15 downto 0);
begin
    uut: counter port map (
        clk => clk, reset => reset, en => en, direction => direction,
        count_out => count_out);

    clkpro : process begin
        clk <= '0';
        wait for clk_pr;
        clk <= '1';
        wait for clk_pr;
    end process;

    stim : process begin
        reset <= '1';
        wait for clk_pr;
        reset<='0'; en<='1'; direction<='1';
        wait for clk_pr*10;
    end process;
end Behavioral;
```
---
### 2:4 decoder with enable input

en  | in1 | in0 | out3| out2 | out1 | out0
--- | --- | --- | --- | ---  | ---  | ---
0   | x   | x   | 0   | 0    | 0    | 0
1   | 0   | 0   | 0   | 0    | 0    | 1
1   | 0   | 1   | 0   | 0    | 1    | 0
1   | 1   | 0   | 0   | 1    | 0    | 0
1   | 1   | 1   | 1   | 0    | 0    | 0


```vhdl
-- outputs are active high
-- dataflow description
library ieee;
use ieee.std_logic_1164.all;
--------------------------------------------
entity dec2to4 is
    Port ( in1, in0, en: in STD_LOGIC;
           out3, out2, out1, out0: out STD_LOGIC);
end dec2to4;
--------------------------------------------
architecture darch of dec2to4 is
begin
	out3 <=      in1  AND      in0  AND en;
	out2 <=      in1  AND NOT (in0) AND en;
	out1 <= NOT (in1) AND      in0  AND en;
	out0 <= NOT (in1) AND NOT (in0) AND en;
end darch;
--------------------------------------------
architecture barch of dec2to4 is
begin
    process(in1, in0, en) begin
        if en = '0' then
            out3 <= '0'; out2 <= '0'; out1 <= '0'; out0 <= '0';
        elsif (in1 = '0' and in0 = '0') then
            out3 <= '0'; out2 <= '0'; out1 <= '0'; out0 <= '1';
        elsif (in1 = '0' and in0 = '1') then
            out3 <= '0'; out2 <= '0'; out1 <= '1'; out0 <= '0';
        elsif (in1 = '1' and in0 = '0') then
            out3 <= '0'; out2 <= '1'; out1 <= '0'; out0 <= '0';
        else
            out3 <= '1'; out2 <= '0'; out1 <= '0'; out0 <= '0';
        end if;
    end process;
end barch;
```
```vhdl
-- testbench
LIBRARY ieee;
USE ieee.std_logic_1164.ALL; 
--------------------------------------------
ENTITY dec2to4_tb IS 
END dec2to4_tb;
--------------------------------------------
ARCHITECTURE behavior of dec2to4_tb IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT dec2to4
    PORT ( in1, in0, en: in STD_LOGIC;
           out3, out2, out1, out0: out STD_LOGIC ); 
    END COMPONENT;
    signal in1, in0, en: std_logic; -- module inputs
    signal out3, out2, out1, out0: std_logic; -- module outputs
BEGIN
    -- Instantiate the Unit Under Test (UUT) 
    uut: dec2to4 PORT MAP (
        in1 => in1, in0 => in0, en => en,
        out3 => out3, out2 => out2 , out1 => out1 , out0 => out0);

    -- Stimulus process 
    stim: process begin 
        en  <= '0'; in1 <= '0'; in0 <= '0'; -- 0,0,0
        wait for 30 ns;
        en  <= '1'; -- 1,0,0
        wait for 30 ns;
        in1 <= '0'; in0 <= '1'; -- 1,0,1
        wait for 30 ns;
        in1 <= '1'; in0 <= '0'; -- 1,1,0
        wait for 30 ns;
        in1 <= '1'; in0 <= '1'; -- 1,1,1
        wait for 30 ns;
        wait;
    end process; 
end;
```
---
### 2:4 decoder with enable input
-- outputs are active high
-- behavioral description
```vhdl
library ieee;
use ieee.std_logic_1164.all;
--------------------------------------------
entity dec2to4 is
    Port ( in1, in0, en: in STD_LOGIC;
           out3, out2, out1, out0: out STD_LOGIC);
end dec2to4;
--------------------------------------------
architecture barch2 of dec2to4 is
signal sel: std_logic_vector (2 downto 0);
begin
	sel <= en & in1 & in0;
	with sel select
	    out3 <= '1' when "111", '0' when others;
	with sel select
	    out2 <= '1' when "110", '0' when others;
	with sel select
	    out1 <= '1' when "101", '0' when others;
	with sel select
	    out0 <= '1' when "100", '0' when others;
end barch2;
```
---
### 3:8 decoder
-- outputs are active high
```vhdl
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--------------------------------------------
entity dec3to8 is
    Port ( in2, in1, in0: in STD_LOGIC;
           out7, out6, out5, out4: out STD_LOGIC;
           out3, out2, out1, out0: out STD_LOGIC);
end dec3to8;
--------------------------------------------
architecture sarch2 of dec3to8 is
  signal in2_int: STD_LOGIC;
begin
-- instantiate two 2:4 decoders
    decoder1: entity work.dec2to4(darch)
        port map (in1 => in1, in0 => in0, en => in2,
           out3 => out7, out2 => out6, out1 => out5, out0 => out4);
    decoder2: entity work.dec2to4(darch)
        port map (in1 => in1, in0 => in0, en => in2_int,
           out3 => out3, out2 => out2, out1 => out1, out0 => out0);
    in2_int <= not(in2);
end sarch2;
```

```vhdl
-- testbench
LIBRARY ieee;
USE ieee.std_logic_1164.ALL; 
--------------------------------------------
ENTITY dec3to8_tb IS 
END dec3to8_tb;
--------------------------------------------
architecture behavior OF dec3to8_tb IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT dec3to8
    PORT( in2, in1, in0: in STD_LOGIC;
          out7, out6, out5, out4 : out STD_LOGIC;
          out3, out2, out1, out0 : out STD_LOGIC); 
    END COMPONENT;

    signal in2, in1, in0: std_logic; -- module inputs
    signal out7, out6, out5, out4 : std_logic; -- module outputs
    signal out3, out2, out1, out0 : std_logic; -- module outputs
begin
    -- Instantiate the Unit Under Test (UUT) 
    UUT: dec3to8 PORT MAP (
        in2 => in2, in1 => in1, in0 => in0, 
        out7 => out7, out6 => out6 , out5 => out5 , out4 => out4,
        out3 => out3, out2 => out2 , out1 => out1 , out0 => out0
    );

    -- Stimulus process 
    stim: process begin 
        in2 <= '0'; in1 <= '0'; in0 <= '0'; -- 0
        wait for 30 ns;
        in2 <= '0'; in1 <= '0'; in0 <= '1'; -- 1
        wait for 30 ns;
        ... -- same for 2, 3, 4, 5, 6
        in2 <= '1'; in1 <= '1'; in0 <= '1'; 
        wait for 30 ns;
        wait;
    end process; 
END;
```
---
### full adder
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------
entity min_full_adder is
    Port ( a,b, cin : in STD_LOGIC;
           cout, sum : out STD_LOGIC
           );
end min_full_adder;
--------------------------------------------
architecture Behavioral of min_full_adder is
begin
    sum <= a xor b xor cin;
    cout <= (a and b) or (cin and a) or (cin and b); 
end Behavioral;
```
### three bit adder
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------
entity three_bit_adder is
    Port ( a : in STD_LOGIC_VECTOR (2 downto 0);
           b : in STD_LOGIC_VECTOR (2 downto 0);
           sum : out STD_LOGIC_VECTOR (3 downto 0));
end three_bit_adder;
--------------------------------------------
architecture Behavioral of three_bit_adder is
    signal carry: std_logic_vector(1 downto 0); 
begin
   add_bit0: entity work.min_full_adder(Behavioral)
       port map(a=>a(0), b=>b(0), cin=>'0', cout=>carry(0), sum=>sum(0));
   add_bit1: entity work.min_full_adder(Behavioral)
       port map(a=>a(1), b=>b(1), cin=>carry(0), cout=>carry(1), sum=>sum(1));
   add_bit2: entity work.min_full_adder(Behavioral)
       port map(a=>a(2), b=>b(2), cin=>carry(1), cout=>sum(3), sum=>sum(2));

end Behavioral;
```
-----
## Finite State Machines
Finite state machines (FSM) are synchronous sequential circuits without predefined state transition
diagrams and output behaviors. Contrary to regular sequential circuits, the state transition diagram of a FSM is designed from scratch (the state diagram is the function of the FSM).

### Moore vs. Mealy
In a **Moore** FSM the outputs are solely a function of the present state of the circuit, therefore it is a *synchronous machine* and the output is available after 1 clock cycle (i.e. the outputs can only change at the rising edge of the clock). 

In a **Mealy** FSM the outputs are a function of the present state **and** the external inputs (and therefore can change at any time), i.e. the output depends on states along with external inputs; and the output is available as soon as the input is changed, therefore it is a *asynchronous machine*.

Generally a Mealy machine has fewer states than a Moore machine. From a practical point of view, you have that output is placed on states in a Moore machine (so every state has its output), while on the latter you have outputs on transitions (so an ouput is decided from the current state AND the outgoing transition).

```vhdl
-- template for FSM development
library ieee;
use ieee.std_logic_1164.all;
--------------------------------------------
entity _name_ is
   port ( clk, rst, _din1_, _din2_, ...: in std_logic;
          _dout1_, _dout2_, ...: out std_logic );
end _name_;
--------------------------------------------
architecture arch of _name_ is
    type state is (S0, S1, S2, ...);
    signal prest, nxtst: state;  -- present state, next state
begin
------- state register
    process (clk, rst) begin
       if (rst = '1') then
          prest <= S0; -- initial state
       elsif rising_edge(clk) then
          prest <= nxtst;
       end if;
    end process;
--------------------------------------------
------- next-state logic
    process (prest, _din_, _din_, ...) begin
       nxtst <= prest; -- stay in current state by default
       case prest is
          when S0 =>
             if _condition_ then nxtst <= _st_;
                else nxtst <= _st_; -- unnecessary if the same
             end if;
          when S1 =>
             if _condition_ then nxtst <= _st_;
                else nxtst <= _st_;
             end if;
          ...
             end if;
       end case;
    end process;
--------------------------------------------
------- Moore outputs logic
    process (prest) begin
       case prest is 
          when _st_ | _st_ | _st_ | ... =>  
             _dout_ <= '0';
          when _st_ | _st_ | ... =>
             _dout_ <= '1'; 
       end case;
    end process;
--------------------------------------------       
------- Mealy outputs logic 
    process (prest, _din_, _din_, ...) begin
       case prest is 
          when _st_ =>
             if _condition_ then 
                _dout_ <= '0';
             else
                _dout_ <= '1';
          when _st_ =>
             if _condition_ then 
                _dout_ <= '0';
             else
                _dout_ <= '1';
          ...
       end case;
    end process;
end arch;
```
---
### 5-bit sequence detector for 10110

```vhdl
-- 5-bit sequence detector for 10110
--------------------------------------------       
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------       
entity seqdet is
   Port ( clk, rst, din: in std_logic;
          dout: out std_logic);
end seqdet;
--------------------------------------------       
architecture arch of seqdet is
type state is (S0, S1, S2, S3, S4, S5);
signal st_pre, st_nxt: state;

begin
    -- state register section
    process (clk, rst) begin
       if (rst = '1') then
          st_pre <= S0;
       elsif rising_edge(clk) then
          st_pre <= st_nxt;
       end if;
    end process;
--------------------------------------------
    -- next-state outputs section
    process (st_pre, din) begin
       case st_pre is
          when S0 =>
             if din='1' then st_nxt <= S1; -- (1)0110
                else st_nxt <= S0; -- stay
             end if;
          when S1 =>
             if din='1' then st_nxt <= S1; -- stay
             else st_nxt <= S2; -- (10)110
             end if;
          when S2 =>
             if din='1' then st_nxt <= S3; -- (101)10
             else st_nxt <= S0; -- go back
             end if;
          when S3 =>
             if din='1' then st_nxt <= S4; -- (1011)0
             else st_nxt <= S2; -- go back
             end if;
          when S4 =>
             if din='1' then st_nxt <= S1; -- go back to state 1
             else st_nxt <= S5; -- (10110)
             end if;
          when S5 =>
             if din='1' then st_nxt <= S3; -- go back to state 3
             else st_nxt <= S0; -- go to start
             end if;
       end case;
    end process;
--------------------------------------------
    -- Moore outputs section
    process (st_pre) begin
       case st_pre is 
          when S0 | S1 | S2 | S3 | S4 =>  
             dout <= '0';
          when S5 => 
             dout <= '1'; -- output is only high when we reach state 5
       end case;
    end process;
--------------------------------------------    
    -- Mealy outputs section (void)
end arch;
```
---
```vhdl
-- testbench: 5-bit sequence detector for 10110
--------------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
--------------------------------------------
entity seqdet_tb IS 
end seqdet_tb;
--------------------------------------------
architecture behavior of seqdet_tb is
-- Component Declaration for the Unit Under Test (UUT)
component seqdet
    port ( clk, rst, din: in std_logic;
           dout: out std_logic); 
end component;
    signal clk, rst, din: std_logic; 
    signal dout: std_logic;
    constant clk_period : time := 10 ns;
begin
    -- Instantiate the Unit Under Test (UUT) 
    uut: seqdet port map (clk => clk, rst => rst, din => din, dout => dout);

    clk_process: process begin
          clk <= '0';
          wait for clk_period/2;
          clk <= '1';
          wait for clk_period/2;
       end process;

    -- Stimulus process 
    stim: process begin 
        rst <= '1';
        wait for clk_period*2;
        rst <= '0'; din <= '0';
        wait for clk_period*2;
        din <= '1';
        wait for clk_period;
        din <= '0';
        wait for clk_period;
        din <= '1';
        wait for clk_period*2;
        din <= '0';
        wait for clk_period;
        din <= '1';
        wait for clk_period*2;
        din <= '0';
        wait for clk_period;
    end process; 
end;
```

---
### ASM Charts
A comparison between a state diagram and an ASM chart for a sequence detector (101) is shown below:

<img src="https://github.com/deivyka/OOP4200/blob/master/Exams/cpp_pics/asm.png" alt="drawing" width="450"/>


---
### Stop watch  (random example)
```vhdl
-- stop_watch.vhd
-- Tick generator is used in this design because Basys3 clock is at 450MHz(450000000 cycles per second)
-- this clock speed is too quick for digits to be visible while run is pressed.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity stop_watch is
   port( clk: in std_logic;
         run, clear: in std_logic;
         dice: out std_logic_vector(2 downto 0) );
end stop_watch;

architecture cascade_arch of stop_watch is
   constant pulses: integer:=8300000; -- 23bits=8388608, higher value = slower clock
   signal tick_reg, tick_next: unsigned(22 downto 0); -- bits must match with max integer value
   signal dice_reg, dice_next: unsigned(2 downto 0); -- 3-bit dice values
   signal dice_enable: std_logic;
   
begin
-- clock register
    process(clk) begin
      if rising_edge(clk) then
         tick_reg <= tick_next; -- 23 flipflops for tick counting
         dice_reg <= dice_next; -- 4 flipflops for dice counting
      end if;
    end process;

-- next-state logic, cascading
    -- tick generator, for slowing down the clock
    tick_next <=
        (others=>'0')  when clear='1' or (tick_reg=pulses and run='1') else -- clear tick generator
        tick_reg + 1   when run='1' else
        tick_reg;
        
    -- enable dice counting logic for every time tick generator matches desired pulses
   dice_enable <='1'   when tick_reg=pulses else '0';
   
    -- counter logic for dice 
   dice_next <=
         "001"         when (clear='1') or (dice_enable='1' and dice_reg=6) else -- dice values displayed between 1-6
         dice_reg + 1  when dice_enable='1' else
         dice_reg;

-- output logic
   dice <= std_logic_vector(dice_reg);
end cascade_arch;
```


```vhdl
--- disp_hex_mux.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity disp_hex_mux is
   port(
      clk, clear: in std_logic;
      hex: in std_logic_vector(2 downto 0);
      anode: out std_logic_vector(3 downto 0);
      leds: out std_logic_vector(6 downto 0); -- all possible leds
      sseg: out std_logic_vector(6 downto 0) );
end disp_hex_mux ;

architecture arch of disp_hex_mux is
   signal counter: unsigned(2 downto 0); -- need 
begin

-- counter with next state logic
   process(clk,clear) begin
      if clear='1' then
         counter <= "001"; -- when clear set to 1
      elsif rising_edge(clk) then
         counter <= counter+1;
      end if;
   end process;

-- turn anode to constant 1 digit
   anode <= "0111";
  
---- With/select for hex-to-7-segment led decoding
--with hex select
--  sseg(6 downto 0) <= 
--  -- sseg value     hex value    
--     "0000001"  when "0000", -- 0   
--     "1001111"  when "0001", -- 1   
--     "0010010"  when "0010", -- 2   
--     "0000110"  when "0011", -- 3   
--     "1001100"  when "0100", -- 4   
--     "0100100"  when "0101", -- 5   
--     "0100000"  when "0110", -- 6   
--     "0001111"  when "0111", -- 7   
--     "0000000"  when "1000", -- 8   
--     "0000100"  when "1001", -- 9   
--     "0001000"  when "1010", -- a   
--     "1100000"  when "1011", -- b   
--     "0110001"  when "1100", -- c   
--     "1000010"  when "1101", -- d   
--     "0110000"  when "1110", -- e   
--     "0111000"  when others; -- f   

-- Process for hex-to-7-segment led decoding
    process(hex) begin
        case hex is
        when "0000"=> sseg <= "0000001"; -- 0     
        when "0001"=> sseg <= "1001111"; -- 1 orig
        when "0010"=> sseg <= "0010010"; -- 2 
        when "0011"=> sseg <= "0000110"; -- 3 
        when "0100"=> sseg <= "1001100"; -- 4 
        when "0101"=> sseg <= "0100100"; -- 5 
        when "0110"=> sseg <= "0100000"; -- 6 
        when "0111"=> sseg <= "0001111"; -- 7 
        when "1000"=> sseg <= "0000000"; -- 8 
        when "1001"=> sseg <= "0000100"; -- 9 
        when "1010"=> sseg <= "0001000"; -- a 
        when "1011"=> sseg <= "1100000"; -- b 
        when "1100"=> sseg <= "0110001"; -- c 
        when "1101"=> sseg <= "1000010"; -- d 
        when "1110"=> sseg <= "0110000"; -- e 
        when others=> sseg <= "0111000"; -- f 
        end case;
    end process;
end arch;
```

```
--- top.vhd
library ieee;
use ieee.std_logic_1164.all;
entity stop_watch_test is
   port(
      clk, run, clear: in std_logic;
      anode: out std_logic_vector(3 downto 0);
      sseg: out std_logic_vector(6 downto 0)
   );
end stop_watch_test;

architecture arch of stop_watch_test is
    signal dice: std_logic_vector(2 downto 0);
begin
   disp_unit: entity work.disp_hex_mux
      port map( clk=>clk, clear=>clear,anode=>anode, sseg=>sseg,
                hex=>dice );   -- dice chooses hex value on display
                
  watch_unit: entity work.stop_watch(cascade_arch)
     port map( clk=>clk, run=>run, clear=>clear, dice=>dice );
end arch;
```

---
### Constraints 
Adding constraints: Uncomment and update the names in the constraints file according to the entity description.

---
### Design verification
Design verification checks if the circuit operation complies with the specification used to design it. The complexity enabled by multi-million gate devices makes design verification very difficult (exhaustive design verification is only possible for simple circuits). Vivado provides several types of simulation that can be used for design verification. The simplest form is behavioral simulation, which ignores all timing aspects.

---
## FPGA – Field programmable gate arrays
A programmable device able to implement wide variety of digital systems ranging from elementary combinational blocks to multi-core computing platforms. Xilinx FPGAs provide three main types of building blocks: **CLBs** (configurable logic blocks), **interconnection resources** and **I/O blocks**. 

Switch matrixes connect the CLBs to the global routing resources. They connect the CLB input and output signals to the general interconnect and dedicated global routing resources. Vivado comprises a «place and route» tool that makes the whole placement and interconnection process invisible to the user. 

Each CLB contains a pair of slices holding the configurable logic. Each slice contains four 6-input Look-Up Tables (LUT), plus multiplexers and logic gates, and edge-triggered D-type flip-flops og level-sensitive latches. An *n*-input LUT can be seen as a 2^n-by-1 memory that is capable of implementing any logic function with n inputs. Some LUTs can be used as memory.

### Slice types (M, L)
The LUTs in approx. 1/3 of the slices can be used as 64-bit RAM or as 16/32-bit shift registers. SLICEM and SLICEL can both be used to implement combinational logic functions. SLICEM can also be used as a distributed memory element. Each SLICEM can be used as a 32-bit shift register.

#### Logic resources per CLB
Each slice contains 4 LUTs, 8 storage elements, wide-function MUXs and carry logic.
