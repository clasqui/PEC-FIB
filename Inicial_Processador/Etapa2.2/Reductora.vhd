-- Ãƒâ€°s el rellotge de la tarea7 convertit en una reductora.

-- SERIA ESSENCIAL CANVIAR AIXÃƒâ€™ PER USAR EL PLL DE LA PLACA I NO UN CONTADOR PERO DE MOMENT TENIM AIXÃƒâ€™.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

ENTITY Reductora IS
GENERIC (reductora : integer := 1);   -- Per defecte no hi ha reducciÃƒÂ³.
PORT (
		CLOCK_50 : IN std_logic;
		rellotge : OUT std_logic
	);
END Reductora;


ARCHITECTURE Structure OF Reductora IS 

	type estat_t is (BAIX, ALT);

	signal contador : std_logic_vector(63 downto 0) := std_logic_vector(to_unsigned(reductora-1, 64));
	signal estat : estat_t := BAIX;
	--signal pols : std_logic;
	signal rellotge_intern : std_logic := '0';
BEGIN
	-- pols <= '1' when contador = 0 else '0';
	
	
	process(CLOCK_50)
	begin
	if rising_edge(CLOCK_50) then   -- PERQUÈ NOMÉS FUNCIONA A LA PLACA SI HI HA EL IF RISING EDGE AQUEST ??!!
			if contador = 0 then
	--			if estat = BAIX then
	--				estat <= ALT;
	--			else
	--				estat <= BAIX;
	--			end if;
				rellotge_intern <= not rellotge_intern;
				contador <= std_logic_vector(to_unsigned(reductora-1, 64));
			else 
				contador <= contador - 1;
			end if;
	end if;
	end process;
	
	--rellotge <= '1' when estat = ALT else '0';
	rellotge <= rellotge_intern;   --Per no assignar les senyals de sortida d'una entity en un process
	
--	-- LÃƒÂ²gica d'estat
--	process (pols)
--	begin
--		if rising_edge(pols) then
--			if estat = BAIX then
--				estat <= ALT;
--			else
--				estat <= BAIX;
--			end if;			
--		end if;
--	end process;
		
	
END Structure;