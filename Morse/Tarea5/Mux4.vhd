LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY Mux4 IS
	PORT (
		Control : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Bus0 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		Bus1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		Bus2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		Bus3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		Salida : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END Mux4;
ARCHITECTURE Structure OF Mux4 IS BEGIN
	with Control select Salida(0) <=
		Bus0(0) when "00",
		Bus1(0) when "01",
		Bus2(0) when "10",
		Bus3(0) when "11";
	
	with Control select Salida(1) <=
		Bus0(1) when "00",
		Bus1(1) when "01",
		Bus2(1) when "10",
		Bus3(1) when "11";
		
	with Control select Salida(2) <=
		Bus0(2) when "00",
		Bus1(2) when "01",
		Bus2(2) when "10",
		Bus3(2) when "11";
END Structure;