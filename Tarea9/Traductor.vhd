LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY Traductor IS
	PORT (
		SW	  : IN std_logic_vector(2 DOWNTO 0);
		llarg: OUT std_logic_vector(3 DOWNTO 0);	-- Per passar un numero del 0 a l'11
		pols : OUT std_logic_vector(10 DOWNTO 0);
	);
END Traductor;
ARCHITECTURE Structure OF Traductor IS
BEGIN
	with SW select pols <=
		"10111000000" when "000",
		"11101010100" when "001",
		"11101011101" when "010",
		"11101010000" when "011",
		"10000000000" when "100",
		"10101110100" when "101",
		"11101110100" when "110",
		"10101010000" when "111";
	
	with SW select llarg <=
		std_logic_vector(to_unsigned(5,llarg'length)) when "000",
		std_logic_vector(to_unsigned(9,llarg'length)) when "001",
		std_logic_vector(to_unsigned(11,llarg'length)) when "010",
		std_logic_vector(to_unsigned(7,llarg'length)) when "011",
		std_logic_vector(to_unsigned(1,llarg'length)) when "100",
		std_logic_vector(to_unsigned(9,llarg'length)) when "101",
		std_logic_vector(to_unsigned(9,llarg'length)) when "110",
		std_logic_vector(to_unsigned(7,llarg'length)) when "111";
		
END Structure;