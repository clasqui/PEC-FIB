LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY proc IS
    PORT (boot     : IN  STD_LOGIC;
          clk      : IN  STD_LOGIC;
          datard_m : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END proc;


ARCHITECTURE Structure OF proc IS

    -- Aqui iria la declaracion de las entidades que vamos a usar
    -- Usaremos la palabra reservada COMPONENT ...
    -- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
	 signal op: std_logic;
	 signal wrd: std_logic;
	 signal addr_a: std_lOGIC_VECTOR(2 downto 0);
	 signal addr_d: std_logic_vector(2 downto 0);
	 signal immed: std_logic_vector(15 downto 0);
	 
	 COMPONENT datapath IS
    PORT (clk    : IN STD_LOGIC;
          op     : IN STD_LOGIC;
          wrd    : IN STD_LOGIC;
          addr_a : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed  : IN STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT unidad_control IS
    PORT (boot   : IN  STD_LOGIC;
          clk    : IN  STD_LOGIC;
          ir     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op     : OUT STD_LOGIC;
          wrd    : OUT STD_LOGIC;
          addr_a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          pc     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END COMPONENT;

BEGIN

    -- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
    -- En los esquemas de la documentacion a la instancia del DATAPATH le hemos llamado e0 y a la de la unidad de control le hemos llamado c0

	e0 : datapath PORT MAP (
		clk => clk,
		op => op,
		wrd => wrd,
		addr_a => addr_a,
		addr_d => addr_d,
		immed => immed
	);
	
	c0 : unidad_control PORT MAP (
		boot => boot,
		clk => clk,
		ir => datard_m,
		op => op,
		wrd => wrd,
		addr_a => addr_a,
		addr_d => addr_d,
		immed => immed,
		pc => addr_m
	);
END Structure;