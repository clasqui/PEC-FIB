LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY Tarea7a IS
	PORT (
		CLOCK_50 : IN std_logic;
		HEX0 : OUT std_logic_vector(6 DOWNTO 0);
		LEDR : OUT std_logic_vector(3 DOWNTO 0)
	);
END Tarea7a;
ARCHITECTURE Structure OF Tarea7a IS 
	signal counter : std_logic_vector(3 DOWNTO 0):="0000";
	signal relotxe : std_logic_vector(24 DOWNTO 0):=(others=>'0');
BEGIN
	with counter select HEX0 <=
		"1000000" when "0000",
		"1111001" when "0001",
		"0100100" when "0010",
		"0110000" when "0011",
		"0011001" when "0100",
		"0010010" when "0101",
		"0000010" when "0110",
		"1111000" when "0111",
		"0000000" when "1000",
		"0010000" when "1001",
		"1111111" when others;
		
	relotxe <= (relotxe + 1) when rising_edge(CLOCK_50);
	counter <= "0000" when counter = "1010" else (counter + 1) when rising_edge(relotxe(24));
	LEDR <= counter;
END Structure;