LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.ALL;

ENTITY datapath IS
    PORT (clk      : IN  STD_LOGIC;
          op       : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
          wrd      : IN  STD_LOGIC;
          addr_a   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          immed_x2 : IN  STD_LOGIC;
          datard_m : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad  : IN  STD_LOGIC;
          pc       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          in_d     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
          addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 Rb_N		 : IN STD_LOGIC;
			 z 		 : OUT STD_LOGIC;
			 aluout	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 rd_io	 : IN	 STD_LOGIC_VECTOR(15 DOWNTO 0);
			 wr_io	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 HEX0 	 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX1 	 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX2 	 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX3 	 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 d_sys  	  : IN  STD_LOGIC;
			 a_sys  	  : IN  STD_LOGIC; 
			 ei	  	  : IN STD_LOGIC;  
			 di     	  : IN STD_LOGIC; 
			 reti   	  : IN STD_LOGIC;
			 boot      : IN STD_LOGIC);
END datapath;

ARCHITECTURE Structure OF datapath IS

COMPONENT alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 z  : OUT STD_LOGIC);
END COMPONENT;

COMPONENT regfile IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 d_sys  : IN  STD_LOGIC;
			 a_sys  : IN  STD_LOGIC;
			 ei	  : IN STD_LOGIC;
			 di     : IN STD_LOGIC;
			 reti   : IN STD_LOGIC;
			 boot	  : IN STD_LOGIC);
END COMPONENT;

signal d : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal x : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal y : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- la poso aqui perque despres ens serà util quan tinguem dos operands
signal a : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal b : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal alu_out : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

	reg0 : regfile
		PORT MAP (clk => clk, wrd => wrd, addr_a => addr_a, addr_b => addr_b, addr_d => addr_d, d => d, a => a, b => b, a_sys => a_sys, d_sys => d_sys, ei => ei, di => di, reti => reti, boot => boot);
	alu0 : alu
		PORT MAP (x => x, y => y, op => op, w => alu_out, z => z);
	
	-- ENTRADA DEL BANC DE REGISTRES.	
	d <= datard_m when in_d = "01" else alu_out when in_d = "00" else pc+2 when in_d = "10" else rd_io when in_d = "11" else (others=>'0');
	
	-- SORTIDES DEL DATAPATH
	addr_m <= alu_out when ins_dad = '1' else pc when ins_dad = '0' else (others=>'0');
	data_wr <= b;
	aluout <= alu_out; -- Per que hi vagi el PC en cas de JMP.
	wr_io <= b;

	-- MUX DE LES ENTRADES DE LA ALU
	x <= a;
	y <= b when Rb_N = '1' else immed when immed_x2 = '0' else 
			immed(14 DOWNTO 0) & '0' when immed_x2 = '1' else 
			(others=>'0'); 
	
END Structure;