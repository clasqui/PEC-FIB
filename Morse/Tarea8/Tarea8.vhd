LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY Tarea8 IS
	PORT (
		SW : IN std_logic_vector(0 DOWNTO 0);
		HEX0 : OUT std_logic_vector(6 DOWNTO 0);
		HEX1 : OUT std_logic_vector(6 DOWNTO 0);
		HEX2 : OUT std_logic_vector(6 DOWNTO 0);
		HEX3 : OUT std_logic_vector(6 DOWNTO 0);
		LEDR : OUT std_logic_vector(2 DOWNTO 0);
		CLOCK_50 : IN std_logic
	);
END Tarea8;
ARCHITECTURE Structure OF Tarea8 IS 
COMPONENT driver7Segmentos IS
	PORT (
		codigoCaracter : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT Rellotge IS
	GENERIC (micros : integer := 1000000);
	PORT (
		CLOCK_50 : IN std_logic;
		rellotge : OUT std_logic
	);
END COMPONENT;

SIGNAL contador : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL codi1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL codi2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL codi3 : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL codi4 : STD_LOGIC_VECTOR(2 DOWNTO 0);

SIGNAL tic : std_logic;

BEGIN
	 SEG1 : driver7Segmentos
	 PORT MAP(codigoCaracter => codi1, bitsCaracter => HEX0);
	 SEG2 : driver7Segmentos
	 PORT MAP(codigoCaracter => codi2, bitsCaracter => HEX1);
	 SEG3 : driver7Segmentos
	 PORT MAP(codigoCaracter => codi3, bitsCaracter => HEX2);
	 SEG4 : driver7Segmentos
	 PORT MAP(codigoCaracter => codi4, bitsCaracter => HEX3);
	 
	 clk : Rellotge GENERIC MAP (micros=>1000000) PORT MAP (CLOCK_50 => CLOCK_50,  rellotge=>tic);
		
		codi4 <= contador;
		codi3 <= contador+1;
		codi2 <= contador+2;
		codi1 <= contador+3;
		
		contador <= (contador + 1) when rising_edge(tic) and SW(0) = '0' else (contador - 1) when rising_edge(tic) and SW(0) = '1';
		LEDR(0) <= contador(0);
		LEDR(1) <= contador(1);
		LEDR(2) <= contador(2);
END Structure;