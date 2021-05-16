LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER

ENTITY regfile IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			 addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			 d_sys  : IN  STD_LOGIC;
			 a_sys  : IN  STD_LOGIC;
			 ei	  : IN STD_LOGIC;
			 di     : IN STD_LOGIC;
			 reti   : IN STD_LOGIC;
			 boot	  : IN STD_LOGIC;
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 reg_intr : IN STD_LOGIC;
			 reg_excep: IN STD_LOGIC;
			 int_e  : OUT STD_LOGIC;
			 excep_num : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			 d_efect : IN STD_LOGIC_VECTOR(15 DOWNTO 0));
END regfile;


ARCHITECTURE Structure OF regfile IS
    -- Aqui iria la definicion de los registros
	 type regfile_t is array (0 to 7) of std_logic_vector(15 downto 0);
	 signal registres: regfile_t; 
	 signal registres_sistema: regfile_t;
	 signal wrd_sistema: std_logic;
	 signal wrd_dades: std_logic;
	 
BEGIN
	
   wrd_dades <= wrd and not d_sys;
	wrd_sistema <= wrd and d_sys;
	 
	process (clk)
	begin
		if(rising_edge(clk)) then
			if boot = '1' then
				registres_sistema(2) <= "0000000000000000";
				registres_sistema(5) <= x"0000"; -- AQUI HA D-ANAR EL CODI DE LA RSG.
				registres_sistema(7) <= x"0000";
			elsif reg_excep = '1' then
				registres_sistema(0) <= registres_sistema(7);
				registres_sistema(1) <= d-2;
				registres_sistema(2) <= excep_num;
				registres_sistema(3) <= d_efect;
				registres_sistema(7)(1) <= '0';
			elsif reg_intr = '1' then  -- estat SYSTEM
				registres_sistema(0) <= registres_sistema(7);
				registres_sistema(1) <= d-2;
				registres_sistema(2) <= x"000F";
				registres_sistema(7)(1) <= '0';
			elsif wrd_dades = '1' then
				registres(conv_integer(addr_d)) <= d;
			elsif wrd_sistema = '1' then
				registres_sistema(conv_integer(addr_d)) <= d;
			elsif ei = '1' then
				registres_sistema(7)(1) <= '1'; 
			elsif di = '1' then 
				registres_sistema(7)(1) <= '0';
			elsif reti = '1' then
				registres_sistema(7) <= registres_sistema(0);
				registres_sistema(7)(1) <= '1';
				registres_sistema(2) <= "0000000000000000";
			end if;
		end if;
	end process;
	
	a <= 	registres_sistema(5) when reg_intr = '1' or reg_excep = '1' -- Estem en cicle system.
				else registres_sistema(1) when reti = '1' 
				else registres_sistema(conv_integer(addr_a)) when a_sys = '1'
				else registres(conv_integer(addr_a));
	b <= registres(conv_integer(addr_b));
	int_e <= registres_sistema(7)(1);
	 
END Structure;