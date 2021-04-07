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
          in_d      : OUT STD_LOGIC;
          immed_x2  : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
			 Rb_N		  : OUT STD_LOGIC);
END control_l;


ARCHITECTURE Structure OF control_l IS

signal PC	: std_LOGIC_VECTOR(15 downto 0);
signal arit	: std_LOGIC_VECTOR(4 downto 0);
signal cmp	: std_LOGIC_VECTOR(4 downto 0);
signal mult	: std_LOGIC_VECTOR(4 downto 0);

BEGIN

    -- Aqui iria la generacion de las senales de control del datapath
	 ldpc <= '0' when ir = "1111111111111111" else '1';
	 --op <= "01" when ir(15 downto 12) = "0011" or ir(15 downto 12) = "0100" or ir(15 downto 12) = "1101" or ir(15 downto 12) = "1110"
				--else "0"&ir(8);
	
	with ir(15 downto 12) select wrd <=
		'1' when "0101", --	 MOVHI/MOVI
		'1' when "0011", -- LD
		'1' when "1101", -- LDB
		'0'when others; -- CASOS ST LD
	
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
	
-- Senyals funció
	 with ir(5 downto 3) select arit <=
		"00010" when "000", -- AND
		"00011" when "001", -- OR
		"00100" when "010", -- XOR
		"00101" when "011", -- NOT
		"00110" when "100", -- AND
		"00111" when "101", -- SUB
		"01000" when "110", -- SHA
		"01001" when "111"; -- SHL
		
	with ir(5 downto 3) select cmp <=
		"01010" when "000", -- CMPLT
		"01011" when "001", -- CMPLE
		"XXXXX" when "010", -- -
		"01100" when "011", -- CMPEQ
		"01101" when "100", -- CMPLTU
		"01110" when "101", -- CMPLEU
		"XXXXX" when "110", -- -
		"XXXXX" when "111"; -- -
		
	with ir(5 downto 3) select mult <=
		"01111" when "000", -- MUL
		"10000" when "001", -- MULH
		"10001" when "010", -- MULHU
		"XXXXX" when "011", -- -
		"10010" when "100", -- DIV
		"10011" when "101", -- DIVU
		"XXXXX" when "110", -- -
		"XXXXX" when "111"; -- -
	 

-- Senyal op
	 with ir(15 downto 12) select op <=
		"0000"&ir(8) 	when "0101", -- MOVHI i MOVI
		arit 				when "0000", -- Aritmeticologiques.
		cmp				when "0001", -- Comparacions.
		mult				when "1000", -- Multiplicacions i divisions
		"00110"			when others; -- ADDI, Loads, Stores i altres coses que passin per aquí.
		
	 -- ATENCIO QUE CAL LA SENYAL Rb_N !!!!
	 with ir(15 downto 12) select Rb_N <=
		'1' when ("0010" or "0101" or "0011" or "0100" or "1101" or "1110"),   -- Ocasions en les que hi d'anar un immediat
		'0' when others; 
	 
	 addr_d <= ir(11 downto 9);  -- Rd sempre està al mateix lloc
	 addr_a <= ir(11 downto 9) when ir(15 downto 12) = "0101"
					else ir(8 downto 6); 
	 addr_b <= ir(2 downto 0) when ir(15 downto 12) = "0000" or ir(15 downto 12) = "0001" or ir(15 downto 12) = "1000" -- Esta al darrere en arit. cmp. i mul.
					else ir(11 downto 9);  -- Rb canvia de lloc.
	 
	 -- wrd <= ir(12);
	 wr_m <= '1' when ir(12) = '0' else '0';
	 
	 in_d <= '1' when ir(15 downto 12) = "0011" or ir(15 downto 12) = "1101" else '0';
	 
	 immed_x2 <= '1' when ir(15 downto 12) = "0011" or ir(15 downto 12) = "0100" else '0';
	 
	 word_byte <= ir(15);
	 
	 immed <= std_logic_vector(resize(signed(ir(7 downto 0)), 16)) when ir(15 downto 12) = "0101" -- en les dimmediat, son 8 bits
					else std_logic_vector(resize(signed(ir(5 downto 0)), 16)); -- en les altres, son 6 bits
END Structure;