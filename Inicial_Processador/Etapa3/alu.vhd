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
		
		(others=>'0') when others;	

END Structure;