LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

ENTITY Timer IS
GENERIC (micros : integer := 50000);
PORT (
		CLOCK_50 : IN std_logic;
		boot : IN STD_logic;
		intr : OUT std_logic;
		inta : IN std_logic
	);
END Timer;


-- Valor parametritzable en microsegons.
ARCHITECTURE Structure OF Timer IS 
	signal contador : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(micros*50,32));
	signal intr_b : std_logic;
BEGIN
	
	--rellotge <= '1' when contador = 0 else '0';
	intr <= intr_b;
	process (CLOCK_50)
	BEGIN
		if rising_edge(CLOCK_50) then
--			if contador = 0 or boot = '1' then
--				contador <= std_logic_vector(to_unsigned(micros*50,32));
--				intr_b <= '1';
--			else 
--				contador <= contador - 1;
--			end if;
			if boot = '1' then
             contador <= std_logic_vector(to_unsigned(micros*50,32));
				 intr_b <= '0';
			elsif contador = 0 then
				 contador <= std_logic_vector(to_unsigned(micros*50,32));
				 intr_b <= '1';
			else
				 contador <= contador - 1;
         end if;
			if inta = '1' then
				intr_b <= '0';
			end if;
		end if;
	END process;
	
END Structure;