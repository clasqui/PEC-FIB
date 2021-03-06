LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY datapath IS
    PORT (clk      : IN  STD_LOGIC;
          op       : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
          wrd      : IN  STD_LOGIC;
          addr_a   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          immed_x2 : IN  STD_LOGIC;
          datard_m : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad  : IN  STD_LOGIC;
          pc       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          in_d     : IN  STD_LOGIC;
          addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END datapath;

ARCHITECTURE Structure OF datapath IS

COMPONENT alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END COMPONENT;

COMPONENT regfile IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END COMPONENT;

signal d : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal a : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal b : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- la poso aqui perque despres ens serà util quan tinguem dos operands
signal alu_out : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

	reg0 : regfile
		PORT MAP (clk => clk, wrd => wrd, addr_a => addr_a, addr_b => addr_b, addr_d => addr_d, d => d, a => a, b => data_wr);
	alu0 : alu
		PORT MAP (x => a, y => b, op => op, w => alu_out);
	
	d <= datard_m when ins_dad = '1' else alu_out when ins_dad = '0' else (others=>'0');
	b <= immed when immed_x2 = '0' else 
			immed(14 DOWNTO 0) & '0' when immed_x2 = '1' else 
			(others=>'0'); -- oju amb el sll que podria donar problemes (https://stackoverflow.com/questions/9018087/shift-a-std-logic-vector-of-n-bit-to-right-or-left)
	addr_m <= alu_out when ins_dad = '0' else pc when ins_dad = '1' else (others=>'0');
END Structure;