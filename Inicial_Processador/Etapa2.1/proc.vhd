LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY proc IS
    PORT (clk       : IN  STD_LOGIC;
          boot      : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_m    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC);
END proc;


ARCHITECTURE Structure OF proc IS

    -- Aqui iria la declaracion de las entidades que vamos a usar
    -- Usaremos la palabra reservada COMPONENT ...
    -- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
	 signal op: std_logic_vector(1 downto 0);
	 signal wrd: std_logic;
	 signal addr_a: std_lOGIC_VECTOR(2 downto 0);
	 signal addr_d: std_logic_vector(2 downto 0);
	 signal immed: std_logic_vector(15 downto 0);
	 signal immed_x2 : std_logic;
	 signal addr_b : std_logic_vector(2 downto 0);
	 signal pc : std_logic_vector(15 downto 0);
	 signal in_d : std_logic;
	 signal ins_dad : std_logic;
	 
	 COMPONENT datapath IS
    PORT (clk    : IN STD_LOGIC;
          op       : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
          wrd      : IN  STD_LOGIC;
          addr_a   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          immed_x2 : IN  STD_LOGIC;
          datard_m : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad  : IN  STD_LOGIC;
          pc       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          in_d     : IN  STD_LOGIC;
          addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT unidad_control IS
    PORT (boot   : IN  STD_LOGIC;
          clk       : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          pc        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad   : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC;
          immed_x2  : OUT STD_LOGIC;
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC);
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
		addr_b => addr_b,
		immed => immed,
		datard_m => datard_m,
		pc => pc,
		ins_dad => ins_dad,
		in_d => in_d,
		data_wr => data_wr,
		immed_x2 => immed_x2,
		addr_m => addr_m
	);
	
	c0 : unidad_control PORT MAP (
		boot => boot,
		clk => clk,
		op => op,
		wrd => wrd,
		addr_a => addr_a,
		addr_d => addr_d,
		addr_b => addr_b,
		immed => immed,
		pc => pc,
		datard_m => datard_m,
		ins_dad => ins_dad,
		in_d => in_d,
		wr_m => wr_m,
		word_byte => word_byte,
		immed_x2 => immed_x2
	);
END Structure;