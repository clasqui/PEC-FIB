LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
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
BEGIN
	with op select w <=
		y when "00000",													-- MOVI
		y(7 DOWNTO 0) & x(7 DOWNTO 0) when "00001",				-- MOVHI
		
		std_logic_vector(signed(y)+signed(x)) when "00110",	-- ADD/ADDI/LOAD/STORE
		
		y and x when "00010", -- AND
		y or x when "00011",  -- OR
		y xor x when "00100", -- XOR
		not x when "00101",   -- NOT
		std_logic_vector(signed(x) - signed(y)) when "00111", -- SUB
		(shift_left(signed(x), unsigned(y(4 downto 0))) when y(4) = '0' else -- SHA (esquerra, positiu)
		shift_right(signed(x), (unsigned(not y(4 downto 0)) + 1))) when "01000", -- SHA (dreta, negatiu)
		(shift_left(unsigned(x), unsigned(y(4 downto 0))) when y(4) = '0' else -- SHL (esquerra, positiu)
		shift_right(unsigned(x), (unsigned(not y(4 downto 0)) + 1))) when "01001", -- SHL (dreta, negatiu)
		("0000000000000001" when signed(x) < signed (y) else "0000000000000000") when "01010", -- CMPLT
		("0000000000000001" when signed(x) < signed (y) or signed(x) = signed (y) else "0000000000000000") when "01011", --CMPLE
		("0000000000000001" when signed(x) = signed (y) else "0000000000000000") when "01100", --CMPEQ
		("0000000000000001" when unsigned(x) < unsigned (y) else "0000000000000000") when "01101", -- CMPLTU
		("0000000000000001" when unsigned(x) < unsigned (y) or unsigned(x) = unsigned (y) else "0000000000000000") when "01110", --CMPLEU
		
		
		
		(others=>'0') when others;	

END Structure;