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
		excpr : OUT std_logic;
		excp_id : out std_logic_vector(7 downto 0);
		excp_of_fp_e : in std_logic;
		e_no_align: IN std_LOGIC;
		no_priv	  : OUT STD_LOGIC
	);
END Exception_controller;


-- Valor parametritzable en microsegons.
ARCHITECTURE Structure OF Exception_controller IS 
	
	signal except_tractant : std_logic_vector (7 downto 0);
	signal acces_no_alineat : std_LOGIC;
	
BEGIN
	
	acces_no_alineat <= e_no_align and a_impar; -- hi ha un acces no alineat si es una situacio on es pot donar i la direccio a la que saccedeix es impar.
	
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
				elsif acces_no_alineat = '1' then
					except_tractant <= x"01";
				elsif zero_div = '1' then
					except_tractant <= x"04";
				elsif no_priv = '1' then
					except_tractant <= x"0D";
				end if;
			end if;
		end if;
	end process;
	
	
	
	excpr <= '0' when boot = '1' else (i_ilegal or acces_no_alineat or zero_div or no_priv); 
	excp_id <= except_tractant; 
	
END Structure;