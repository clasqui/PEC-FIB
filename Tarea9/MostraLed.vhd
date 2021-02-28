LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY MostraLed IS
	PORT (
		pols	  : IN std_logic_vector(10 DOWNTO 0);
		llarg	  : IN std_logic_vector(3 DOWNTO 0);	-- Per passar un numero del 0 a l'11
		Clk     : IN std_logic;
		ini	  : IN std_logic;
		fi		  : IN std_logic;	
		acabat  : OUT std_logic;
		LEDR	  : OUT std_logic
	);
END MostraLed;

ARCHITECTURE Structure OF MostraLed IS
signal it : integer := to_integer(unsigned(llarg));
BEGIN
	LEDR <= pols(it) when ini = '1';
	acabat <= '1' when it = 0;
	it <= (it - 1) when ini = '1' when rising_edge(Clk) else 0 when parar='1'; --Cardem fora parar i ho fem tot amb ini?
		-- Podem pensar de treure la senyar parar.
END Structure;