LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

ENTITY TLB IS
GENERIC (micros : integer := 50000);
PORT (
		clk : IN std_logic;
		boot : IN STD_logic;
		vtag : IN std_logic_vector (3 downto 0);
		p : IN std_logic;
		v : IN std_logic;
		tag_in : IN std_logic_vector(15 downto 0);
		addr : IN std_logic_vector(2 downto 0);
		v_p : IN std_logic;
		we : IN std_logic;
		ptag : OUT std_logic_vector(3 downto 0);
		miss : OUT std_logic;
		inv_pg : OUT std_logic;
		pr_pg : OUT std_logic;
		ro_pg : OUT std_logic
	);
END TLB;

ARCHITECTURE Structure OF TLB IS 
	type virtual_t is array (0 to 7) of std_logic_vector(3 downto 0);
	type fisica_t is array (0 to 7) of std_logic_vector(3 downto 0);
	
	signal virtual : virtual_t;
	signal fisica : fisica_t;
	
	signal addr_tlb : std_logic_vector(3 downto 0);
	signal sortida : std_logic_vector(5 downto 0);
	
	
BEGIN
	process(clk)
	begin
		if rising_edge(clk) then
			if boot = '1' then
				fisica(0)(5) <= '0';
				fisica(1)(5) <= '0';
				fisica(2)(5) <= '0';
				fisica(3)(5) <= '0';
				fisica(4)(5) <= '0';
				fisica(5)(5) <= '0';
				fisica(6)(5) <= '0';
				fisica(7)(5) <= '0';
			end if;
			if we = '1' then    
				if v_p = '0' then
					fisica(conv_integer(addr)) <= tag_in(5 downto 0);
				else
					virtual(conv_integer(addr))<= tag_in(3 downto 0);
				end if;
			end if;
		end if;
	end process;
	
	with vtag select addr_tlb <=
	"0000" when virtual(0),
	"0001" when virtual(1),
	"0010" when virtual(2),
	"0011" when virtual(3),
	"0100" when virtual(4),
	"0101" when virtual(5),
	"0110" when virtual(6),
	"0111" when virtual(7),
	"1000" when others;
	
	miss <= '1' when addr_tlb = "1000" else '0';
	
	with addr_tlb(2 downto 0) select sortida <=
	
	sortida <= "000000" when miss else fisica(conv_integer(addr_tlb(2 downto 0));

	v <= sortida(5);
	p <= sortida(4);
	
	ptag <= sortida(3 downto 0);
	
	inv_pg <= '1' when v = '1';
	
	--FALTEN LA RESTA D'ACCEPCIONS
	
	
END Structure;