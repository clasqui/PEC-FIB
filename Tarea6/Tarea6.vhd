LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY Tarea6 IS
	PORT (
		KEY : IN std_logic_vector(0 DOWNTO 0);
		SW : IN std_logic_vector(0 DOWNTO 0);
		HEX0 : OUT std_logic_vector(6 DOWNTO 0);
		HEX1 : OUT std_logic_vector(6 DOWNTO 0);
		HEX2 : OUT std_logic_vector(6 DOWNTO 0);
		HEX3 : OUT std_logic_vector(6 DOWNTO 0);
		LEDR : OUT std_logic_vector(2 DOWNTO 0)
	);
END Tarea6;
ARCHITECTURE Structure OF Tarea6 IS 
COMPONENT driver7Segmentos IS
	PORT (
		codigoCaracter : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;
SIGNAL contador : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL codi1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL codi2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL codi3 : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL codi4 : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
	 SEG1 : driver7Segmentos
	 PORT MAP(codigoCaracter => codi1, bitsCaracter => HEX0);
	 SEG2 : driver7Segmentos
	 PORT MAP(codigoCaracter => codi2, bitsCaracter => HEX1);
	 SEG3 : driver7Segmentos
	 PORT MAP(codigoCaracter => codi3, bitsCaracter => HEX2);
	 SEG4 : driver7Segmentos
	 PORT MAP(codigoCaracter => codi4, bitsCaracter => HEX3);
	 with contador select codi1 <=
		"000" when "101",
		"001" when "110",
		"010" when "111",
		"011" when "000",
		"100" when others;
	 with contador select codi2 <=
		"000" when "110",
		"001" when "111",
		"010" when "000",
		"011" when "001",
		"100" when others;
	 with contador select codi3 <=
		"000" when "111",
		"001" when "000",
		"010" when "001",
		"011" when "010",
		"100" when others;
	 with contador select codi4 <=
		"000" when "000",
		"001" when "001",
		"010" when "010",
		"011" when "011",
		"100" when others;
		contador <= (contador + 1) when rising_edge(KEY(0));
		LEDR(0) <= contador(0);
		LEDR(1) <= contador(1);
		LEDR(2) <= contador(2);
END Structure;