LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER

ENTITY regfile IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END regfile;


ARCHITECTURE Structure OF regfile IS
    -- Aqui iria la definicion de los registros
	 type regfile_t is array (0 to 7) of std_logic_vector(15 downto 0);
	 signal registres: regfile_t; 
	 signal index_a: integer;
	 signal index_d: integer;
	 
BEGIN
	index_a <= to_integer(unsigned(addr_a));
	index_d <= to_integer(unsigned(addr_d));
	
	process (clk)
	begin
		if(rising_edge(clk)) then
			if wrd = '1' then
				registres(index_d) <= d;
			end if;
		end if;
	end process;
	
    -- Aqui iria la definicion del comportamiento del banco de registros
    -- Os puede ser util usar la funcion "conv_integer" o "to_integer"
    -- Una buena (y limpia) implementacion no deberia ocupar m�s de 7 o 8 lineas
	 
	 -- registres(to_integer(unsigned(addr_d))) <= d when rising_edge(clk) and wrd = '1'; AQUESTA IMPLEMENTACIO NO ENS FUNCIONA. PER QUE?
	 
	 a <= registres(index_a);
	 
END Structure;