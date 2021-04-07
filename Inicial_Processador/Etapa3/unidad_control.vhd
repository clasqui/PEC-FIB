LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY unidad_control IS
    PORT (boot      : IN  STD_LOGIC;
          clk       : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op        : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
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
          word_byte : OUT STD_LOGIC;
			 Rb_N		  : OUT STD_LOGIC);
END unidad_control;

ARCHITECTURE Structure OF unidad_control IS

    -- Aqui iria la declaracion de las entidades que vamos a usar
    -- Usaremos la palabra reservada COMPONENT ...
    -- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
    -- Aqui iria la definicion del program counter
	 
COMPONENT control_l IS
    PORT (ir   	  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op        : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
          ldpc      : OUT STD_LOGIC;
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC;
          immed_x2  : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
			 Rb_N		  : OUT STD_LOGIC);
END COMPONENT;

COMPONENT multi IS
    port(clk       : IN  STD_LOGIC;
         boot      : IN  STD_LOGIC;
         ldpc_l    : IN  STD_LOGIC;
         wrd_l     : IN  STD_LOGIC;
         wr_m_l    : IN  STD_LOGIC;
         w_b       : IN  STD_LOGIC;
         ldpc      : OUT STD_LOGIC;
         wrd       : OUT STD_LOGIC;
         wr_m      : OUT STD_LOGIC;
         ldir      : OUT STD_LOGIC;
         ins_dad   : OUT STD_LOGIC;
         word_byte : OUT STD_LOGIC);
END COMPONENT;

signal ldpc: std_logic;
signal nou_pc: std_logic_vector(15 downto 0);

SIGNAL ir_actual: std_logic_vector(15 downto 0);

signal ldpc_l : std_logic;
signal wrd_l : std_logic;
signal w_b : std_logic;
signal wr_m_l : std_logic;
signal ldir : std_logic;

BEGIN

    -- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
    -- En los esquemas de la documentacion a la instancia de la logica de control le hemos llamado c0
    -- Aqui iria la definicion del comportamiento de la unidad de control y la gestion del PC

	 c0 : control_l PORT MAP (
		ir => ir_actual,
		op => op,
		ldpc => ldpc_l,
		wrd => wrd_l,
		addr_a => addr_a,
		addr_b => addr_b,
		addr_d => addr_d,	
		wr_m => wr_m_l,
		immed => immed,
		in_d => in_d,
		immed_x2 => immed_x2,
		word_byte => w_b,
		Rb_N => Rb_N
	 );
	 
	 ac : multi PORT MAP (
			clk => clk,
		   boot => boot,
         ldpc_l => ldpc_l,
         wrd_l => wrd_l,
         wr_m_l => wr_m_l,
         w_b  => w_b,
         ldpc => ldpc,
         wrd => wrd,
         wr_m => wr_m,
         ldir => ldir,
         ins_dad => ins_dad,
         word_byte => word_byte
	 );
	 
	 
	 -- Logica Program Counter
	 nou_pc <= nou_pc+2 when rising_edge(clk) and ldpc = '1' and boot = '0' else
				nou_pc when rising_edge(clk) and ldpc = '0' and boot = '0' else
				x"C000" when rising_edge(clk) and boot = '1';
				
	 pc <= nou_pc;
	 
	 
--	 process (clk)
--	 begin
--		if(rising_edge(clk)) then
--			if boot = '1' then
--				ir_actual <= x"0000";
--			elsif ldir = '1' then
--				ir_actual <= datard_m;
--			end if;
--		end if;
--	 end process;
	 
	 ir_actual <= x"0000" when rising_edge(clk) and boot = '1'
					else datard_m when rising_edge(clk) and ldir = '1';
					--else ir_actual when rising_edge(clk);
	 

END Structure;