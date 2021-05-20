LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

ENTITY TLB IS
PORT (
		clk : IN std_logic;
		boot : IN STD_logic;
		vtag : IN std_logic_vector (3 downto 0);
		--p : OUT std_logic;
		--v : OUT std_logic;
		tag_in : IN std_logic_vector(15 downto 0);
		addr : IN std_logic_vector(2 downto 0);
		v_p : IN std_logic;
		we : IN std_logic;
		ptag : OUT std_logic_vector(3 downto 0);
		miss : OUT std_logic;
		inv_pg : OUT std_logic;
		pr_pg : OUT std_logic;
		ro_pg : OUT std_logic;
		flush : IN std_logic
	);
END TLB;

ARCHITECTURE Structure OF TLB IS 
	type virtual_t is array (0 to 7) of std_logic_vector(3 downto 0);
	type fisica_t is array (0 to 7) of std_logic_vector(5 downto 0);
	
	signal virtual : virtual_t;
	signal fisica : fisica_t;
	
	signal addr_tlb : std_logic_vector(3 downto 0);
	signal sortida : std_logic_vector(5 downto 0);
	
	signal miss_b : std_logic;
	
	
BEGIN
	process(clk)
	begin
		if rising_edge(clk) then
			if boot = '1' then
				fisica(0) <= "100000";  -- user
				virtual(0)<= "0000";    -- user
				fisica(1) <= "100001";  -- user
				virtual(1)<= "0001";    -- user
				fisica(2) <= "100010";	-- user
				virtual(2)<= "0010";		-- user
				fisica(3) <= "101000";  -- system data
				virtual(3)<= "1000";		-- system data
				fisica(4) <= "101100";	-- system codi
				virtual(4)<= "1100";		-- system codi
				fisica(5) <= "101101";	-- system codi
				virtual(5)<= "1101";		-- system codi
				fisica(6) <= "101110";	-- system codi
				virtual(6)<= "1110";		-- system codi
				fisica(7) <= "101111";	-- system codi
				virtual(7)<= "1111";		-- system codi
			elsif flush = '1' then 
				fisica(0)(5) <= '0'; 
				fisica(1)(5) <= '0'; 
				fisica(2)(5) <= '0'; 
				fisica(3)(5) <= '0'; 
				fisica(4)(5) <= '0'; 
				fisica(5)(5) <= '0'; 
				fisica(6)(5) <= '0'; 
				fisica(7)(5) <= '0'; 
			elsif we = '1' then    
				if v_p = '1' then
					fisica(conv_integer(addr)) <= tag_in;
				else
					virtual(conv_integer(addr))<= tag_in(3 downto 0);
				end if;
			end if;
		end if;
	end process;
	
	addr_tlb <=
	"0000" when vtag = virtual(0) else
	"0001" when vtag = virtual(1) else
	"0010" when vtag = virtual(2) else
	"0011" when vtag = virtual(3) else
	"0100" when vtag = virtual(4) else
	"0101" when vtag = virtual(5) else
	"0110" when vtag = virtual(6) else
	"0111" when vtag = virtual(7) else
	"1000";
	
	miss_b <= '1' when addr_tlb = "1000" else '0';
	
	miss <= miss_b;
	
	sortida <= "000000" when miss_b = '1' else fisica(conv_integer(addr_tlb(2 downto 0)));

--	v <= sortida(5);
--	p <= sortida(4);
	
	ptag <= sortida(3 downto 0);
	
	inv_pg <= '1' when sortida(5) = '0' else '0';
	pr_pg <= '1' when sortida(3 downto 0) > x"8" and (sortida(3 downto 0) < x"A" or sortida(3 downto 0) > x"B") else '0';
	ro_pg <= '1' when sortida(4) = '1' else '0';
	
	
	
	
END Structure;