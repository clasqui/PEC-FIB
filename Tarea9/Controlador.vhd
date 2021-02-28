LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Controlador IS
	PORT (
		Clk  : IN std_logic;
		KEY0 : IN std_logic;
		KEY1 : IN std_logic;
		acabat: IN std_logic;
		LEDG : OUT std_logic;
		run  : OUT std_logic;
		parar: OUT std_logic	
	);
END Controlador;
ARCHITECTURE Structure OF Controlador IS
type tipoestat is (REPOS, IMPRIMINT);
signal estat, prxestat : tipoestat := REPOS;
BEGIN
	
-- Logica de proxim estat
	prxestat <= IMPRIMINT when estat = REPOS and rising_edge(KEY1) else 
					REPOS when estat = IMPRIMINT and (rising_edge(KEY0) or rising_edge(acabat));

-- Accions d'estat 
	LEDG <= '1' when estat = REPOS else '0' when estat = IMPRIMINT;
	run <= '0'	when estat = REPOS else '1' when estat = IMPRIMINT;
	parar <= '1' when estat = REPOS else '0' when estat = IMPRIMINT;
	

	estat <= prxestat when rising_edge(Clk);
END Structure;