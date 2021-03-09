LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Traductor IS
	PORT (
		SW	  : IN std_logic_vector(2 DOWNTO 0);
		llarg: OUT std_logic_vector(3 DOWNTO 0);	-- Per passar un numero del 0 a l'11
		pols : OUT std_logic_vector(10 DOWNTO 0)
	);
END Traductor;
ARCHITECTURE Structure OF Traductor IS
BEGIN
	with SW select pols <=
		"00000010111" when "000", -- Test.
		"00111010101" when "001",
		"11101011101" when "010",
		"00001110101" when "011",
		"00000000001" when "100",
		"00101011101" when "101",
		"00111011101" when "110",
		"00001010101" when "111";
	
	with SW select llarg <=
		"0101" when "000", --5
		"1001" when "001", --9
		"1011" when "010", --11
		"0111" when "011", --7
		"0001" when "100", --1
		"1001" when "101", --9
		"1001" when "110", --9
		"0111" when "111"; --7
		
END Structure;