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
		load_store: IN std_LOGIC;
		e_fetch	 : IN std_LOGIC;
		no_priv	  : IN STD_LOGIC;
		calls     : IN STD_LOGIC;
		addr_no_ok : IN std_logic;
		intr : IN std_logic;
		miss_i : IN STD_LOGIC;
		miss_d : IN STD_LOGIC;
		inv_pg_i : IN STD_LOGIC;
		inv_pg_d : IN STD_LOGIC;
		pr_pg_i : IN STD_LOGIC;
		pr_pg_d : IN STD_LOGIC;
		ro_pg : IN STD_LOGIC;
		exec_mode : IN std_LOGIC;
		store 	  : IN STD_LOGIC
	);
END Exception_controller;


-- Valor parametritzable en microsegons.
ARCHITECTURE Structure OF Exception_controller IS 
	
	signal except_tractant : std_logic_vector (7 downto 0);
	signal acces_no_alineat : std_LOGIC;
	signal direccio_protegida_d: std_logic;
	signal direccio_protegida_i : std_logic;
	signal miss_dades : std_logic;
	signal miss_instr : std_logic;
	signal inv_dir_d : std_logic;
	signal inv_dir_i : std_logic;
	signal ro_pg_excep : std_logic;
	
BEGIN
	
	acces_no_alineat <= (e_fetch or load_store) and a_impar; -- hi ha un acces no alineat si es una situacio on es pot donar i la direccio a la que saccedeix es impar.
	direccio_protegida_d <= '1' when load_store = '1' and pr_pg_d = '1' and exec_mode = '0' else '0';
	direccio_protegida_i <= '1' when e_fetch = '1' and pr_pg_i = '1' and exec_mode = '0' else '0';
	miss_dades <= '1' when miss_d = '1' and load_store = '1' else '0';
	miss_instr <= '1' when miss_i = '1' and e_fetch = '1' else '0';
	inv_dir_d <= '1' when inv_pg_d = '1' and load_store = '1' else '0';
	inv_dir_i <= '1' when inv_pg_i = '1' and e_fetch = '1' else '0';
 	ro_pg_excep <= '1' when ro_pg_excep = '1' and store = '1' else '0';
	
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
				elsif miss_instr = '1' then
					except_tractant <= x"06";
				elsif miss_dades = '1' then
					except_tractant <= x"07";
				elsif inv_dir_i = '1' then
					except_tractant <= x"08";
				elsif inv_dir_d = '1' then
					except_tractant <= x"09";
				elsif direccio_protegida_i = '1' then
					except_tractant <= x"0A";
				elsif direccio_protegida_d = '1' then
					except_tractant <= x"0B";
				elsif ro_pg_excep = '1' then
					except_tractant <= x"0C";
				elsif no_priv = '1' and exec_mode = '0' then
					except_tractant <= x"0D";
				elsif calls = '1' then
					except_tractant <= x"0E";
				elsif intr = '1' then
					except_tractant <= x"0F";
				end if;
			end if;
		end if;
	end process;
	
	
	
	excpr <= '0' when boot = '1' else (i_ilegal or acces_no_alineat or zero_div
													or (no_priv and not exec_mode) or calls or direccio_protegida_d or miss_instr or miss_dades or
													direccio_protegida_i or ro_pg_excep or inv_dir_d or inv_dir_i); 
	excp_id <= except_tractant; 
	
END Structure;