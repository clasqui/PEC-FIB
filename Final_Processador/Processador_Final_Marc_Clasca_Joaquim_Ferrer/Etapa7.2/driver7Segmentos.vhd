LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY driver7Segmentos IS
	PORT (
		codiNum : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		enables : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111"
	);
END driver7Segmentos;
ARCHITECTURE Structure OF driver7Segmentos IS 

--signal eHEX0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
--signal eHEX1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
--signal eHEX2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
--signal eHEX3 : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

---- Per a que no s'encenguin els HEX.
--	eHEX0 <= "ZZZZ" when enables(0) = '1' else "1111";
--	eHEX1 <= "ZZZZ" when enables(1) = '1' else "1111";
--	eHEX2 <= "ZZZZ" when enables(2) = '1' else "1111";
--	eHEX3 <= "ZZZZ" when enables(3) = '1' else "1111";
--	
	HEX0 <= "1111111" when enables(0) = '0' else
				"1000000" when codiNum(3 DOWNTO 0) = "0000" else
				"1111001" when codiNum(3 DOWNTO 0) = "0001" else
				"0100100" when codiNum(3 DOWNTO 0) = "0010" else
				"0110000" when codiNum(3 DOWNTO 0) = "0011" else
				"0011001" when codiNum(3 DOWNTO 0) = "0100" else
				"0010010" when codiNum(3 DOWNTO 0) = "0101" else
				"0000010" when codiNum(3 DOWNTO 0) = "0110" else
				"1111000" when codiNum(3 DOWNTO 0) = "0111" else
				"0000000" when codiNum(3 DOWNTO 0) = "1000" else
				"0010000" when codiNum(3 DOWNTO 0) = "1001" else
				"0001000" when codiNum(3 DOWNTO 0) = "1010" else
				"0000011" when codiNum(3 DOWNTO 0) = "1011" else
				"1000110" when codiNum(3 DOWNTO 0) = "1100" else
				"0100001" when codiNum(3 DOWNTO 0) = "1101" else
				"0000110" when codiNum(3 DOWNTO 0) = "1110" else
				"0001110" when codiNum(3 DOWNTO 0) = "1111" else
				"1111111";
				
	HEX1 <= "1111111" when enables(1) = '0' else
				"1000000" when codiNum(7 DOWNTO 4) = "0000" else
				"1111001" when codiNum(7 DOWNTO 4) = "0001" else
				"0100100" when codiNum(7 DOWNTO 4) = "0010" else
				"0110000" when codiNum(7 DOWNTO 4) = "0011" else
				"0011001" when codiNum(7 DOWNTO 4) = "0100" else
				"0010010" when codiNum(7 DOWNTO 4) = "0101" else
				"0000010" when codiNum(7 DOWNTO 4) = "0110" else
				"1111000" when codiNum(7 DOWNTO 4) = "0111" else
				"0000000" when codiNum(7 DOWNTO 4) = "1000" else
				"0010000" when codiNum(7 DOWNTO 4) = "1001" else
				"0001000" when codiNum(7 DOWNTO 4) = "1010" else
				"0000011" when codiNum(7 DOWNTO 4) = "1011" else
				"1000110" when codiNum(7 DOWNTO 4) = "1100" else
				"0100001" when codiNum(7 DOWNTO 4) = "1101" else
				"0000110" when codiNum(7 DOWNTO 4) = "1110" else
				"0001110" when codiNum(7 DOWNTO 4) = "1111" else
				"1111111";
				
	HEX2 <= "1111111" when enables(2) = '0' else
				"1000000" when codiNum(11 DOWNTO 8) = "0000" else
				"1111001" when codiNum(11 DOWNTO 8) = "0001" else
				"0100100" when codiNum(11 DOWNTO 8) = "0010" else
				"0110000" when codiNum(11 DOWNTO 8) = "0011" else
				"0011001" when codiNum(11 DOWNTO 8) = "0100" else
				"0010010" when codiNum(11 DOWNTO 8) = "0101" else
				"0000010" when codiNum(11 DOWNTO 8) = "0110" else
				"1111000" when codiNum(11 DOWNTO 8) = "0111" else
				"0000000" when codiNum(11 DOWNTO 8) = "1000" else
				"0010000" when codiNum(11 DOWNTO 8) = "1001" else
				"0001000" when codiNum(11 DOWNTO 8) = "1010" else
				"0000011" when codiNum(11 DOWNTO 8) = "1011" else
				"1000110" when codiNum(11 DOWNTO 8) = "1100" else
				"0100001" when codiNum(11 DOWNTO 8) = "1101" else
				"0000110" when codiNum(11 DOWNTO 8) = "1110" else
				"0001110" when codiNum(11 DOWNTO 8) = "1111" else
				"1111111";
		
	HEX3 <= "1111111" when enables(3) = '0' else
				"1000000" when codiNum(15 DOWNTO 12) = "0000" else
				"1111001" when codiNum(15 DOWNTO 12) = "0001" else
				"0100100" when codiNum(15 DOWNTO 12) = "0010" else
				"0110000" when codiNum(15 DOWNTO 12) = "0011" else
				"0011001" when codiNum(15 DOWNTO 12) = "0100" else
				"0010010" when codiNum(15 DOWNTO 12) = "0101" else
				"0000010" when codiNum(15 DOWNTO 12) = "0110" else
				"1111000" when codiNum(15 DOWNTO 12) = "0111" else
				"0000000" when codiNum(15 DOWNTO 12) = "1000" else
				"0010000" when codiNum(15 DOWNTO 12) = "1001" else
				"0001000" when codiNum(15 DOWNTO 12) = "1010" else
				"0000011" when codiNum(15 DOWNTO 12) = "1011" else
				"1000110" when codiNum(15 DOWNTO 12) = "1100" else
				"0100001" when codiNum(15 DOWNTO 12) = "1101" else
				"0000110" when codiNum(15 DOWNTO 12) = "1110" else
				"0001110" when codiNum(15 DOWNTO 12) = "1111" else
				"1111111";
	
	
END Structure;