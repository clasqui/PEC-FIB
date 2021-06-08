LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

ENTITY Pulsadors IS
PORT (
		boot : IN std_logic;
		clk  : IN std_logic;
		inta : IN std_logic;
		intr : OUT std_logic;
		KEY  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		key_read : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END Pulsadors;

ARCHITECTURE Structure OF Pulsadors IS 

	signal nou_key_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal key_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal nested_canvi : STD_LOGIC := '0';
	signal intr_b : std_logic := '0';

BEGIN
	
	nou_key_out <= KEY;
	process(clk)
	begin
		if rising_edge(clk) then   
			if boot = '1' then
				-- nou_key_out <= KEY;
				nested_canvi <= '0';
				intr_b <= '0';
			else
				if nou_key_out /= key_out then  -- cas de hi ha hagut canvi.
					if intr_b = '1' then  -- no s'ha tractat lanterior canvi. s'ignoren els canvis.
						nested_canvi <= '1';
					else
						intr_b <= '1';
						key_out <= nou_key_out;
						-- nou_key_out <= KEY;
					end if;
				end if;
				if intr_b = '0' and nested_canvi = '1' then -- hi ha hagut un canvi mentre estavem tractant un altre.
					intr_b <= '1';
					nested_canvi <= '0';
					-- nou_key_out <= KEY;
				end if;
				if inta = '1' then
					intr_b <= '0';
				end if;
			end if;
		end if;
	end process;	

	
	key_read <= key_out;
	intr <= intr_b;
END Structure;