LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY control_l IS
    PORT (ir        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op        : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
          ldpc      : OUT STD_LOGIC;
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          immed_x2  : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
			 Rb_N		  : OUT STD_LOGIC;
			 addr_io	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			 rd_in	  : OUT STD_LOGIC;
			 wr_out    : OUT STD_LOGIC;
			 d_sys  	  : OUT  STD_LOGIC; -- no depen del cicle
			 a_sys  	  : OUT  STD_LOGIC; -- no depen del cicle
			 ei	  	  : OUT STD_LOGIC;  -- SI depen del cicle
			 di     	  : OUT STD_LOGIC;  -- SI depen del cicle
			 reti   	  : OUT STD_LOGIC;  -- SI depen del cicle
			 reg_intr  : OUT STD_LOGIC;  -- SI depen del cicle
			 reg_excp  : OUT STD_LOGIC;
			 inta 	  : OUT std_logic;   -- SI depen del cicle --> perque nomes ha destar amunt un cicle!!!
			 il_inst   : OUT std_logic;
			 e_no_align: OUT std_LOGIC;
			 exec_mode : IN STD_LOGIC;
			 no_priv	  : OUT STD_LOGIC);   -- Excepcio de instruccio privilegiada. 
END control_l;


ARCHITECTURE Structure OF control_l IS

signal PC	: std_LOGIC_VECTOR(15 downto 0);
signal arit	: std_LOGIC_VECTOR(4 downto 0);
signal cmp	: std_LOGIC_VECTOR(4 downto 0);
signal mult	: std_LOGIC_VECTOR(4 downto 0);
signal jmp	: std_logic;
signal io	: std_logic;
signal int	: std_logic;

BEGIN

	 ldpc <= '0'     when ir = "1111111111111111" else '1';
	 reg_intr <= '0' when ir = "1111111111111111" else '1';
	 reg_excp <= '0' when ir = "1111111111111111" else '1';
	
	
	
-- ALU	

-- CODIS D'OPERACIÓ
	--	00000 MOVI
	--	00001	MOVHI
	--	00010	AND
	--	00011 OR
	--	00100 XOR
	--	00101 NOT
	--	00110 ADD/ADDI/LOAD/STORE
	--	00111 SUB
	--	01000 SHA
	--	01001 SHL
	--	01010 CMPLT
	--	01011 CMPLE
	--	01100 CMPEQ
	--	01101 CMPLTU
	--	01110 CMPLEU
	--	01111 MUL
	--	10000 MULH
	--	10001 MULHU
	--	10010 DIV
	-- 10011	DIVU
	-- 10100 JMP --> fa passar el registre a la sortida.
	
-- Senyals funció
	 with ir(5 downto 3) select arit <=
		"00010" when "000", -- AND
		"00011" when "001", -- OR
		"00100" when "010", -- XOR
		"00101" when "011", -- NOT
		"00110" when "100", -- AND
		"00111" when "101", -- SUB
		"01000" when "110", -- SHA
		"01001" when "111", -- SHL
		"XXXXX" when others; 
		
	with ir(5 downto 3) select cmp <=
		"01010" when "000", -- CMPLT
		"01011" when "001", -- CMPLE
		"XXXXX" when "010", -- -
		"01100" when "011", -- CMPEQ
		"01101" when "100", -- CMPLTU
		"01110" when "101", -- CMPLEU
		"XXXXX" when "110", -- -
		"XXXXX" when "111", -- -
		"XXXXX" when others;
		
	with ir(5 downto 3) select mult <=
		"01111" when "000", -- MUL
		"10000" when "001", -- MULH
		"10001" when "010", -- MULHU
		"XXXXX" when "011", -- -
		"10010" when "100", -- DIV
		"10011" when "101", -- DIVU
		"XXXXX" when "110", -- -
		"XXXXX" when "111", -- -
		"XXXXX" when others;
	 

-- Senyal op
	 with ir(15 downto 12) select op <=
		"0000"&ir(8) 	when "0101", -- MOVHI i MOVI
		arit 				when "0000", -- Aritmeticologiques.
		cmp				when "0001", -- Comparacions.
		mult				when "1000", -- Multiplicacions i divisions
		"10100"			when "1010", -- JMP i Interrupcions --> Registre A cap a la sortida.
		"10100"			when "1111", -- JMP i Interrupcions --> Registre A cap a la sortida.
 		"00110"			when others; -- ADDI, Loads, Stores.
		
 -- Senyals pe Banc de registres
	 
	jmp <= '1' when ir(2 downto 0) = "100" else '0';
	io <= not ir(8);
	int <= '1' when (ir(5 downto 0) = "110000" or ir(5 downto 0) = "101100" or ir(5 downto 0) = "101000") and exec_mode = '1' else '0';
	
	with ir(15 downto 12) select wrd <=      -- Marquem com a 1 els casos en els que s'esriu perque no hi hagi lios al implementar noves instructs
		'1' when "0101", -- MOVHI/MOVI
		'1' when "0011", -- LD
		'1' when "1101", -- LDB
		'1' when "0000", -- aritmeticologiques
		'1' when "0001", -- comparacions
		'1' when "0010", -- ADDI
		'1' when "1000", -- muls i divs
		jmp when "1010", -- Pels jumps
		io  when "0111",
		int when "1111", -- interrupts
		'0' when others; -- CASOS ST LD
	
	 addr_d <= ir(11 downto 9);  -- Rd sempre està al mateix lloc
	 addr_a <= ir(11 downto 9) when ir(15 downto 12) = "0101"
					else ir(8 downto 6); 
	 addr_b <= ir(2 downto 0) when ir(15 downto 12) = "0000" 
											or ir(15 downto 12) = "0001" 
											or ir(15 downto 12) = "1000" -- Esta al darrere en arit. cmp. i mul.
					else ir(11 downto 9);  -- Rb canvia de lloc.
				
	d_sys <= '1' when ir(15 downto 12) = "1111" and ir(5 downto 0) = "110000" else '0';
	a_sys <= '1' when ir(15 downto 12) = "1111" and ir(5 downto 0) = "101100" else '0';
	
	ei 	<= '1' when ir(15 downto 12) = "1111" and ir(5 downto 0) = "100000" and exec_mode = '1' else '0';
	di 	<= '1' when ir(15 downto 12) = "1111" and ir(5 downto 0) = "100001" and exec_mode = '1' else '0';
	reti	<= '1' when ir(15 downto 12) = "1111" and ir(5 downto 0) = "100100" and exec_mode = '1' else '0';
	 
	-- Memoria
	 wr_m <= '1' when ir(15 downto 12) = "0100" or ir(15 downto 12) = "1110" else '0';  -- Nomes els store han d'escriure memoria
	  
	
	-- Senyals per a l'I/O
	 addr_io <= ir(7 downto 0);
	 rd_in <= '1' when ir(15 downto 12) = "0111" and ir(8) = '0' else '0';
	 wr_out <= '1' when ir(15 downto 12) = "0111" and ir(8) = '1' else '0';
	 inta <= '1' when ir(15 downto 12) = "1111" and ir(5 downto 0) = "101000" else '0';
	 
	 -- Senyals pel datapath
	 Rb_N <= '0' when ir(15 downto 12) = "0010" -- MOVHI/MOVI
							or ir(15 downto 12) = "0101" -- 
							or ir(15 downto 12) = "0011" 
							or ir(15 downto 12) = "0100" 
							or ir(15 downto 12) = "1101" 
							or ir(15 downto 12) = "1110" 
						else '1'; 
	 
	 in_d <= "01" when ir(15 downto 12) = "0011" or ir(15 downto 12) = "1101" 
							else "10" when ir(15 downto 12) = "1010" and ir(2 downto 0) = "100" 
							else "11" when ir(15 downto 12) = "0111" or (ir(15 downto 12) = "1111" and ir(5 downto 0) = "101000") else "00";
	 
	 immed_x2 <= '1' when ir(15 downto 12) = "0011" or ir(15 downto 12) = "0100" else '0';
	 
	 word_byte <= ir(15);
	 
	 immed <= std_logic_vector(resize(signed(ir(7 downto 0)), 16)) when ir(15 downto 12) = "0101" -- en les dimmediat, son 8 bits
					else std_logic_vector(resize(signed(ir(5 downto 0)), 16)); -- en les altres, son 6 bits
					
		with ir(15 downto 12) select il_inst <=      -- Marquem com a 1 els casos en els que s'esriu perque no hi hagi lios al implementar noves instructs
		'0' when "0101", -- MOVHI/MOVI
		'0' when "0011", -- LD
		'0' when "1101", -- LDB
		'0' when "0100", -- ST
		'0' when "1110", -- STB
		'0' when "0000", -- aritmeticologiques
		'0' when "0001", -- comparacions
		'0' when "0010", -- ADDI
		'0' when "1000", -- muls i divs
		'0' when "1010", -- Pels jumps
		'0' when "0110", -- Pels Branches
		'0' when "0111", -- I/O
		'0' when "1111", -- interrupts
		'1' when others; -- NO EXISTEIX, ILEGAL
		
		-- Altres senyals
		e_no_align <= '1' when ir(15 downto 12) = "0011" or ir(15 downto 12) = "0100" else '0'; -- Per detectar acessos no alineats.
		no_priv <= '1' when ir /= x"FFFF" and ir(15 downto 12) = "1111" and
							(ir(5 downto 0) = "101100" or ir(5 downto 0) = "110000" or ir(5 downto 0) = "100000" or ir(5 downto 0) = "100001" ir(5 downto 0) = "100100")
							 and exec_mode = '0' else '0';
	
END Structure;