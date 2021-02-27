LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY Tarea7b IS
	PORT (
		CLOCK_50 : IN std_logic;
		HEX0 : OUT std_logic_vector(6 DOWNTO 0);
		HEX1 : OUT std_logic_vector(6 DOWNTO 0);
		HEX2 : OUT std_logic_vector(6 DOWNTO 0);
		HEX3 : OUT std_logic_vector(6 DOWNTO 0);
		LEDR : OUT std_logic_vector(9 DOWNTO 0)
	);
END Tarea7b;
ARCHITECTURE Structure OF Tarea7b IS 
signal tic : std_logic;
signal codi : std_logic_vector (15 DOWNTO 0) := (others => '0'); 
COMPONENT driver7Segmentos IS
	PORT (
		codiNum : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;
COMPONENT Rellotge IS
	GENERIC (micros : integer := 1000000);
	PORT (
		CLOCK_50 : IN std_logic;
		rellotge : OUT std_logic
	);
END COMPONENT;	
BEGIN
	Relotxe : Rellotge 
		GENERIC MAP (micros => 200000) PORT MAP (CLOCK_50 => CLOCK_50, rellotge => tic);
	driver : driver7Segmentos
		PORT MAP (codiNum => codi, HEX0 => HEX0, HEX1 => HEX1, HEX2 => HEX2, HEX3 => HEX3);
	codi <= (codi + 1) when rising_edge(tic);
	LEDR <= codi(9 DOWNTO 0);
END Structure;