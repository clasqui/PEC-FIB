LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

ENTITY Interrupt_controller IS
GENERIC (micros : integer := 50);
PORT (
		clk : IN std_logic;
		boot : IN STD_logic;
		key_intr : in std_logic;
		ps2_intr : in std_logic;
		sw_intr : in std_logic;
		timer_intr : in std_logic;
		inta : IN std_logic;
		intr : OUT std_logic;
		key_inta : out std_logic;
		ps2_inta : out std_logic;
		sw_inta : out std_logic;
		timer_inta : out std_logic;
		iid : out std_logic_vector(7 downto 0)
	);
END Interrupt_controller;


-- Valor parametritzable en microsegons.
ARCHITECTURE Structure OF Interrupt_controller IS 
	
	signal interrupt_tractant : std_logic_vector (7 downto 0);
	
BEGIN
	
	process(clk)
	begin
		if rising_edge(clk) then
-- S'ordenen els ifs per prioritats
			if boot = '1' then
				--intr <= '0';
				key_inta <= '0';
				ps2_inta <= '0';
				sw_inta <= '0';
				timer_inta <= '0';		
			else
				if timer_intr = '1' then
					interrupt_tractant <= x"00";
				elsif key_intr = '1' then
					interrupt_tractant <= x"01";
				elsif sw_intr = '1' then
					interrupt_tractant <= x"02";
				elsif ps2_intr = '1' then
					interrupt_tractant <= x"03";
				end if;
				if inta = '1' then
					if interrupt_tractant = x"00" then
						timer_inta <= '0';
					elsif interrupt_tractant = x"01" then
						key_inta <= '0';
					elsif interrupt_tractant = x"02" then
						sw_inta <= '0';
					elsif interrupt_tractant = x"03" then
						ps2_inta <= '0';
					end if;
				end if;
			end if;
		end if;
	end process;
	
	intr <= (ps2_intr or timer_intr or sw_intr or key_intr) when boot = '0' else '0';
	iid <= interrupt_tractant(7 downto 0); 
	
END Structure;