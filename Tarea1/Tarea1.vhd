LIBRARY ieee;
USE IEEE.std_logic_1164.all;

ENTITY Tarea1 IS
 PORT(SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		LEDR : OUT  STD_LOGIC_VECTOR(9 DOWNTO 0));
END Tarea1;

ARCHITECTURE Structure OF Tarea1 IS

BEGIN

LEDR <= SW;

END Structure;