LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY driverHex7Segmentos IS
	PORT (
		codigoCaracter : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END driverHex7Segmentos;
ARCHITECTURE Structure OF driverHex7Segmentos IS BEGIN
	with codigoCaracter select bitsCaracter <=
		"0001000" when "000",
		"0000011" when "001",
		"1000110" when "010",
		"0100001" when "011",
		"0000110" when "100",
		"0001110" when "101",
		"0000100" when "110",
		"0001001" when "111";
END Structure;