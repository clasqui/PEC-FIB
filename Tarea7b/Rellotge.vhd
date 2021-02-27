LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY Rellotge IS
GENERIC (micros : integer := 1000000);
PORT (
		CLOCK_50 : IN std_logic;
		rellotge : OUT std_logic
	);
END Rellotge;


-- Valor parametritzable en microsegons.
ARCHITECTURE Structure OF Rellotge IS 
	signal contador : integer := micros*50;
BEGIN
	rellotge <= '1' when contador = 0 else '0';
	contador <= micros*50 when contador = 0 else (contador - 1) when rising_edge(CLOCK_50);
END Structure;