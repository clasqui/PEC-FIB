LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Tarea2 IS
 PORT( SW : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
 KEY : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
 LEDR : OUT STD_LOGIC_VECTOR(0 DOWNTO 0));
END Tarea2;

ARCHITECTURE Structure OF Tarea2 IS
signal tmp: std_logic;
BEGIN

WITH SW SELECT tmp <=
	KEY(0) when "00",
	KEY(1) when "01",
	KEY(2) when "10",
	KEY(3) when "11";

LEDR(0) <= not tmp;
	
END Structure; 