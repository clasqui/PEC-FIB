LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
--USE IEEE.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 z	 : OUT STD_LOGIC);
END alu;

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



ARCHITECTURE Structure OF alu IS

signal shift_l 	: std_LOGIC_VECTOR (15 downto 0);
signal shift_a 	: std_LOGIC_VECTOR (15 downto 0);
signal cmplt 		: std_LOGIC_VECTOR (15 downto 0);
signal cmple 		: std_LOGIC_VECTOR (15 downto 0);
signal cmpeq 		: std_LOGIC_VECTOR (15 downto 0);
signal cmpltu 		: std_LOGIC_VECTOR (15 downto 0);
signal cmpleu 		: std_LOGIC_VECTOR (15 downto 0);
signal mult_baix	: std_LOGIC_VECTOR (15 downto 0);
signal alt_sig 	: std_LOGIC_VECTOR (15 downto 0);
signal alt_unsig 	: std_LOGIC_VECTOR (15 downto 0);

COMPONENT multiplicador is
    port(
		x    		 : IN std_logic_vector(15 DOWNTO 0);
		y    		 : IN std_logic_vector(15 DOWNTO 0);
		baix 		 : OUT std_logic_vector(15 DOWNTO 0);
		alt_unsig : OUT std_logic_vector(15 DOWNTO 0);
		alt_sig	 : OUT std_logic_vector(15 DOWNTO 0)
	 );
end COMPONENT;

BEGIN

-- Multiplicació
	mul : multiplicador port map (
		x => x,
		y => y,
		alt_sig => alt_sig,
		alt_unsig => alt_unsig,
		baix => mult_baix
	);


-- Shifts
	shift_a <= std_logic_vector(shift_left(signed(x), to_integer(unsigned(y(4 downto 0))))) when y(4) = '0' else 
						std_logic_vector(shift_right(signed(x), to_integer(unsigned((not y(4 downto 0)) + 1))));
	shift_l <= std_logic_vector(shift_left(unsigned(x), to_integer(unsigned(y(4 downto 0))))) when y(4) = '0' else -- SHL (esquerra, positiu)
						std_logic_vector(shift_right(unsigned(x), to_integer(unsigned((not y(4 downto 0)) + 1)))); -- SHL (dreta, negatiu)
						
-- Comparacions
	cmplt  <= "0000000000000001" when signed(x) < signed (y) else "0000000000000000";
	cmple  <= "0000000000000001" when (signed(x) < signed(y)) or (signed(x) = signed(y)) else "0000000000000000"; 
	cmpeq <= "0000000000000001" when signed(x) = signed(y) else "0000000000000000";
	cmpltu <= "0000000000000001" when unsigned(x) < unsigned(y) else "0000000000000000";
	cmpleu <= "0000000000000001" when (unsigned(x) < unsigned(y)) or (unsigned(x) = unsigned(y)) else "0000000000000000";
	
	
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

	
-- Sortida

	z <= '1' when y = 0 else '0';
	
	with op select w <=
		y when "00000",													-- MOVI
		y(7 DOWNTO 0) & x(7 DOWNTO 0) when "00001",				-- MOVHI
		std_logic_vector(unsigned(y)+unsigned(x)) when "00110",	-- ADD/ADDI/LOAD/STORE
		y and x when "00010", -- AND 
		y or x when "00011",  -- OR
		y xor x when "00100", -- XOR
		not x when "00101",   -- NOT
		std_logic_vector(unsigned(x) - unsigned(y)) when "00111", -- SUB
		shift_a when "01000", -- SHA
		shift_l when "01001", -- SHL 
		cmplt when "01010", -- CMPLT
		cmple when "01011", -- CMPLE
		cmpeq when "01100", -- CMPEQ
		cmpltu when "01101", -- CMPLTU
		cmpleu when "01110", -- CMPLEU
		mult_baix when "01111", -- MUL
		alt_sig when "10000", -- MULH
		alt_unsig when "10001", -- MULHU
		std_logic_vector(signed(x)/signed(y)) when "10010", -- DIV
		std_LOGIC_VECTOR(unsigned(x)/unsigned(y)) when "10011", --DIVU
		x when "10100",
		(others=>'0') when others;	

END Structure;