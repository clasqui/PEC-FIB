LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY CamiDades IS
	PORT (
		Clk  : IN std_logic;
		SW	  : IN std_logic_vector(2 DOWNTO 0);
		run  : IN std_logic;
		parar: IN std_logic	
		acabat: OUT std_logic;
		LEDR : OUT std_logic;
	);
END CamiDades;
ARCHITECTURE Structure OF CamiDades IS

--COMPONENT driverHex7Segmentos IS
--	PORT (
--		codigoCaracter : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
--		bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
--	);
--END COMPONENT;


BEGIN
 -- Buit
END Structure;