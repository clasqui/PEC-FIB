LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

ENTITY Exception_controller IS
PORT (
		clk : IN std_logic;
		boot : IN STD_logic;
		i_ilegal : in std_logic;
		a_impar : in std_logic;
		zero_div : in std_logic;
		excpa : IN std_logic;
		excpr : OUT std_logic;
		excp_id : out std_logic_vector(7 downto 0)
	);
END Exception_controller;


-- Valor parametritzable en microsegons.
ARCHITECTURE Structure OF Exception_controller IS 
	
	signal except_tractant : std_logic_vector (7 downto 0);
	
BEGIN
	
	process(clk)
	begin
		if rising_edge(clk) then
-- S'ordenen els ifs per prioritats
			if boot = '1' then
--				key_inta <= '0';
--				ps2_inta <= '0';
--				sw_inta <= '0';
--				timer_inta <= '0';		
			else
				if i_ilegal = '1' then
					except_tractant <= x"00";
				elsif a_impar = '1' then
					except_tractant <= x"01";
				elsif zero_div = '1' then
					except_tractant <= x"04";
				end if;
			end if;
		end if;
	end process;
	
	
	
	excpr <= '0' when boot = '1' else '0' when excpa = '1' else (ps2_intr or timer_intr or sw_intr or key_intr); -- Quedara el flag aixecat fins que hi hagi un excpta
	eid <= interrupt_tractant; 
	
END Structure;