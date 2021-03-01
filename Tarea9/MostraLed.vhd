LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY MostraLed IS
	PORT (
		pols	  : IN std_logic_vector(10 DOWNTO 0);
		llarg	  : IN std_logic_vector(3 DOWNTO 0);	-- Per passar un numero del 0 a l'11
		Clk     : IN std_logic;
		ini	  : IN std_logic;
		acabat  : OUT std_logic;
		LEDR	  : OUT std_logic
	);
END MostraLed;

ARCHITECTURE Structure OF MostraLed IS
signal it : integer := to_integer(unsigned(llarg)); --Cal començar desde llarg perque al primer cicle ja s'a restat 1 a l'iterador
BEGIN
	LEDR <= pols(it) when ini = '1' else '0';
	acabat <= '1' when it = 0 else '0';
	it <= (it - 1) when ini = '1' and rising_edge(Clk) else
		to_integer(unsigned(llarg)) when ini = '0' and rising_edge(Clk);
	END Structure;