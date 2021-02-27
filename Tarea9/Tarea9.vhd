library ieee;
use ieee.std_logic_1164.all;


entity Tarea9 is 
port ( SW : IN std_logic_vector(2 downto 0);
			KEY : IN std_logic_vector(1 downto 0);
			HEX0 : OUT std_logic_vector(6 downto 0);
			LEDR : OUT std_logic_vector(0 downto 0);
			LEDG : OUT std_logic_vector(0 downto 0)
			);
end Tarea9;

architecture Comportament of Tarea9 is
COMPONENT driverHex7Segmentos IS
	PORT (
		codigoCaracter : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

type tipoestat is (
				REPOS,
				A1,A2,A3,
				B1,B2,B3);

begin

SEG1 : driverHex7Segmentos
	 PORT MAP(codigoCaracter => SW, bitsCaracter => HEX0);
	 



end Comportament;