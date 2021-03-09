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

COMPONENT Controlador IS
	PORT (
		Clk  : IN std_logic;
		KEY0 : IN std_logic;
		KEY1 : IN std_logic;
		acabat: IN std_logic;
		LEDG : OUT std_logic;
		run  : OUT std_logic
	);
END COMPONENT;

COMPONENT CamiDades IS
	PORT (
		Clk  : IN std_logic;
		HEX0 : OUT std_logic_vector(6 downto 0);
		SW	  : IN std_logic_vector(2 DOWNTO 0);
		run  : IN std_logic;
		acabat: OUT std_logic;
		LEDR : OUT std_logic
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

signal tic: std_logic;
signal run: std_logic;
signal acabat: std_logic;

BEGIN
control : Controlador   -- Instanciem un controlador
	 PORT MAP(
		Clk => tic,
		KEY1 => KEY(1),
		KEY0 => KEY(0),
		acabat => acabat,
		LEDG => LEDG(0),
		run => run
	);

clk_05 : Rellotge GENERIC MAP (micros=> 500000) PORT MAP (CLOCK_50 => CLOCK_50,  rellotge=>tic); -- Tic cada 0.5s
	
cdd : CamiDades
	 PORT MAP (
		Clk => tic,
		HEX0 => HEX0,
		SW => SW,
		run => run,
		acabat => acabat,
		LEDR => LEDR(0)
	 );

end Comportament;