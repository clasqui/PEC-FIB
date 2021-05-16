LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY proc IS
    PORT (clk       : IN  STD_LOGIC;
          boot      : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_m    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
			 addr_io	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			 rd_in	  : OUT STD_LOGIC;
			 wr_out    : OUT STD_LOGIC;
			 
			 wr_io	  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 rd_io	  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			 inta 	  : OUT std_logic;
			 intr 	  : IN std_logic;
			 int_e     : OUT std_LOGIC;
			 no_align  : IN std_logic);
END proc;


ARCHITECTURE Structure OF proc IS

    -- Aqui iria la declaracion de las entidades que vamos a usar
    -- Usaremos la palabra reservada COMPONENT ...
    -- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
	 signal op: std_logic_vector(4 downto 0);
	 signal wrd: std_logic;
	 signal addr_a: std_lOGIC_VECTOR(2 downto 0);
	 signal addr_d: std_logic_vector(2 downto 0);
	 signal immed: std_logic_vector(15 downto 0);
	 signal immed_x2 : std_logic;
	 signal addr_b : std_logic_vector(2 downto 0);
	 signal pc : std_logic_vector(15 downto 0);
	 signal in_d : std_logic_vector(1 DOWNTO 0);
	 signal ins_dad : std_logic;
	 signal Rb_N : std_LOGIC;
	 signal z	 : std_logic;	
	 signal aluout: std_logic_vector(15 downto 0);  -- Per que arribi el PC a control.	
	 signal d_sys  : STD_LOGIC;
	 signal a_sys  : STD_LOGIC; 
	 signal ei	  	: STD_LOGIC;  
	 signal di     : STD_LOGIC; 
	 signal reti  	: STD_LOGIC;
	 signal reg_intr : STD_LOGIC;
	 signal int_e_b : std_LOGIC;
	 
	 signal flag_div_zero : std_logic;
	 signal flag_excp_ack : std_logic;
	 signal flag_excp_recv: std_logic;
	 signal flag_i_inst   : std_logic;
	 signal flag_odd_addr : std_logic;
	 signal exception_number : std_logic_vector(7 downto 0);
	 signal flag_reg_excp    : std_logic;
	 signal flag_excp_of_fp_e : std_logic;
		 
	 COMPONENT datapath IS
    PORT (clk    : IN STD_LOGIC;
          op       : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
          wrd      : IN  STD_LOGIC;
          addr_a   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          immed_x2 : IN  STD_LOGIC;
          datard_m : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad  : IN  STD_LOGIC;
          pc       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          in_d     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
          addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 Rb_N		 : IN STD_LOGIC;
			 z 		 : OUT STD_LOGIC;
			 aluout	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 rd_io	 : IN	 STD_LOGIC_VECTOR(15 DOWNTO 0);
			 wr_io	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 d_sys  	  : IN  STD_LOGIC;
			 a_sys  	  : IN  STD_LOGIC; 
			 ei	  	  : IN STD_LOGIC;  
			 di     	  : IN STD_LOGIC; 
			 reti   	  : IN STD_LOGIC;
			 boot      : IN STD_LOGIC;
			 reg_intr  : IN STD_LOGIC;
			 reg_excp  : IN STD_LOGIC;
			 int_e     : OUT STD_LOGIC;
			 div_zero   : OUT STD_LOGIC;
			 excep_num : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			 excp_of_fp_e : OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT unidad_control IS
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
          in_d      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          immed_x2  : OUT STD_LOGIC;
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
			 Rb_N		  : OUT STD_LOGIC;
			 z 		  : IN STD_LOGIC;
			 aluout	  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			 addr_io	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			 rd_in	  : OUT STD_LOGIC;
			 wr_out    : OUT STD_LOGIC;
			 d_sys  	  : OUT  STD_LOGIC;
			 a_sys  	  : OUT  STD_LOGIC; 
			 ei	  	  : OUT STD_LOGIC;  
			 di     	  : OUT STD_LOGIC; 
			 reti   	  : OUT STD_LOGIC;
			 reg_intr  : OUT STD_LOGIC;
			 reg_excp  : OUT STD_LOGIC;
			 int_e     : IN STD_LOGIC;
			 inta 	  : OUT std_logic;
			 intr 	  : IN std_logic;
			 excpr     : IN STD_LOGIC;
			 il_inst   : OUT STD_LOGIC);
END COMPONENT;

COMPONENT Exception_controller IS
PORT (
		clk : IN std_logic;
		boot : IN STD_logic;
		i_ilegal : in std_logic;
		a_impar : in std_logic;
		zero_div : in std_logic;
		excpa : IN std_logic;
		excpr : OUT std_logic;
		excp_id : out std_logic_vector(7 downto 0);
		excp_of_fp_e : IN std_logic
	);
END COMPONENT;

BEGIN

    -- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
    -- En los esquemas de la documentacion a la instancia del DATAPATH le hemos llamado e0 y a la de la unidad de control le hemos llamado c0

	
	e0 : datapath PORT MAP (
		clk => clk,
		boot => boot,
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
		addr_m => addr_m,
		Rb_N => Rb_N,
		z => z,
		aluout => aluout,
		wr_io => wr_io,
		rd_io => rd_io,
		d_sys => d_sys,
		a_sys => a_sys,
		ei => ei,
		di => di,
		reti => reti,
		reg_intr => reg_intr,
		reg_excp => flag_reg_excp,
		int_e => int_e_b,
		excep_num => exception_number,
		excp_of_fp_e => flag_excp_of_fp_e
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
		immed_x2 => immed_x2,
		Rb_N => Rb_N,
		z => z,
		aluout => aluout,
		wr_out => wr_out,
		rd_in => rd_in,
		addr_io => addr_io,
		ei => ei,
		di => di,
		reti => reti,
		a_sys => a_sys,
		d_sys => d_sys,
		inta => inta,
		intr => intr,
		reg_intr => reg_intr,
		reg_excp => flag_reg_excp,
		int_e => int_e_b,
		excpr => flag_excp_recv,
		il_inst => flag_i_inst
	);
	
	flag_odd_addr <= no_align;
	
	exc0 : Exception_controller PORT MAP (
		clk => clk,
		boot => boot,
		i_ilegal => flag_i_inst,
		a_impar => flag_odd_addr,
		zero_div => flag_div_zero,
		excpa => flag_excp_ack,
		excpr => flag_excp_recv,
		excp_id => exception_number,
		excp_of_fp_e => flag_excp_of_fp_e -- si les excepcions overflow floating point estan activades
	);
END Structure;