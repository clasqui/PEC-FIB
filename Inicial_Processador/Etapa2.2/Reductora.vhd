-- És el rellotge de la tarea7 convertit en una reductora.

-- SERIA ESSENCIAL CANVIAR AIXÒ PER USAR EL PLL DE LA PLACA I NO UN CONTADOR PERO DE MOMENT TENIM AIXÒ.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY Reductora IS
GENERIC (reductora : integer := 1);   -- Per defecte no hi ha reducció.
PORT (
		CLOCK_50 : IN std_logic;
		rellotge : OUT std_logic
	);
END Reductora;


ARCHITECTURE Structure OF Reductora IS 

	type estat_t is (BAIX, ALT);

	signal contador : integer := reductora;
	signal estat : estat_t := ALT;
	signal pols : std_logic;
BEGIN
	pols <= '1' when contador = 0 else '0';
	
	
	process(CLOCK_50)
	begin
		if contador = 0 then
			contador <= reductora-1;
		else 
			contador <= contador - 1;
		end if;
	end process;
	
	rellotge <= '1' when estat = ALT else '0';
	
	-- Lògica d'estat
	process (pols)
	begin
		if rising_edge(pols) then
			if estat = BAIX then
				estat <= ALT;
			else
				estat <= BAIX;
			end if;			
		end if;
	end process;
		
	
END Structure;