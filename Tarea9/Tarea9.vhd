library ieee;
use ieee.std_logic_1164.all;


entity Tarea9 is 
port ( SW : IN std_logic_vector(2 downto 0);
			KEY : IN std_logic_vector(1 downto 0);
			HEX0 : OUT std_logic_vector(6 downto 0);
			LEDR : OUT std_logic_vector(0 downto 0);
			LEDG : OUT std_logic_vector(0 downto 0);
			CLOCK_50 : IN std_logic
			);
end Tarea9;

architecture Comportament of Tarea9 is
COMPONENT driverHex7Segmentos IS
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

type tipoestat is (REPOS, IMPRIMINT);
signal estat, proximestat: tipoestat;

signal tic: std_logic;

begin

controlador : Control
	 PORT MAP(codigoCaracter => SW, bitsCaracter => HEX0);
clk_05 : Rellotge GENERIC MAP (micros=> 500000) PORT MAP (CLOCK_50 => CLOCK_50,  rellotge=>tic); -- Tic cada 0.5s
	
cdd : CamiDades
	 PORT MAP
	

end Comportament;