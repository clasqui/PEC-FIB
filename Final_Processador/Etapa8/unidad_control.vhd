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
          in_d      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          immed_x2  : OUT STD_LOGIC;
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
			 Rb_N		  : OUT STD_LOGIC;
			 z 		  : IN  STD_LOGIC;
			 aluout	  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 addr_io	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			 rd_in	  : OUT STD_LOGIC;
			 wr_out    : OUT STD_LOGIC;
			 d_sys  	  : OUT STD_LOGIC;
			 a_sys  	  : OUT STD_LOGIC; 
			 ei	  	  : OUT STD_LOGIC;  
			 di     	  : OUT STD_LOGIC; 
			 reti   	  : OUT STD_LOGIC;
			 reg_intr  : OUT STD_LOGIC;
			 reg_excp : OUT STD_LOGIC;
			 int_e     : IN STD_LOGIC; 
			 inta 	  : OUT std_logic;
			 intr 	  : IN std_logic;
			 excpr     : IN std_logic;
			 il_inst   : OUT std_logic;
			 excep_num : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			 e_no_align: OUT std_LOGIC;
			 exec_mode : IN STD_LOGIC;
			 no_priv	  : OUT STD_LOGIC;
			 calls     : OUT STD_LOGIC;
			 no_align  : IN std_logic;
			 addr_no_ok : IN std_logic);
END unidad_control;

ARCHITECTURE Structure OF unidad_control IS

type tknbr_t is (INI,PC_ACT,PC2,ALU_OUT,BR);

signal ldpc: std_logic;
signal nou_pc: std_logic_vector(15 downto 0);
signal pc_saltat: std_logic_vector(15 downto 0);
SIGNAL ir_actual: std_logic_vector(15 downto 0);
signal ldpc_l : std_logic;
signal wrd_l : std_logic;
signal w_b : std_logic;
signal wr_m_l : std_logic;
signal ldir : std_logic;
signal tknbr: tknbr_t := INI;
signal jmp: tknbr_t;
signal ei_l	  	  : STD_LOGIC;  
signal di_l     	  : STD_LOGIC; 
signal reti_l   	  : STD_LOGIC;
signal d_sys_l : STD_LOGIC;
signal reg_intr_l : STD_LOGIC;
signal reg_excp_l : STD_LOGIC;
signal op_l : STD_LOGIC_VECTOR(4 DOWNTO 0);
signal inta_l : STD_LOGIC;
signal in_d_l : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal system_cicle_int : std_LOGIC;
signal system_cicle_exc : std_LOGIC;
signal e_no_align_l : std_LOGIC;
signal calls_l     : STD_LOGIC;
	 
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
          in_d      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          immed_x2  : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
			 Rb_N		  : OUT STD_LOGIC;
			 addr_io	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			 rd_in	  : OUT STD_LOGIC;
			 wr_out    : OUT STD_LOGIC;
			 d_sys  	  : OUT  STD_LOGIC;
			 a_sys  	  : OUT  STD_LOGIC; 
			 ei	  	  : OUT STD_LOGIC;
			 di     	  : OUT STD_LOGIC; 
			 reti   	  : OUT STD_LOGIC;
			 reg_intr  : OUT STD_LOGIC;
			 reg_excp  : out STD_LOGIC;
			 inta 	  : OUT std_logic;
			 il_inst   : OUT std_logic;
			 e_no_align: OUT std_LOGIC;
			 exec_mode : IN STD_LOGIC;
			 no_priv	  : OUT STD_LOGIC;
			 calls     : OUT STD_LOGIC;
			 excep_num : IN STD_LOGIC_VECTOR(7 DOWNTO 0));
END COMPONENT;

COMPONENT multi IS
    port(clk       : IN  STD_LOGIC;
         boot      : IN  STD_LOGIC;
         ldpc_l    : IN  STD_LOGIC;
         wrd_l     : IN  STD_LOGIC;
         wr_m_l    : IN  STD_LOGIC;
         w_b       : IN  STD_LOGIC;
			ei_l	    : IN STD_LOGIC;  
			di_l      : IN STD_LOGIC; 
			reti_l    : IN STD_LOGIC;
			d_sys_l 	 : IN  STD_LOGIC;
			reg_intr_l: IN STD_LOGIC;
			reg_excp_l: IN STD_LOGIC;
			op_l		 : IN std_LOGIC_VECTOR(4 downto 0);
			in_d_l    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			inta_l    : IN std_logic;
			e_no_align_l: IN std_LOGIC;
			calls_l   : IN STD_LOGIC;
         ldpc      : OUT STD_LOGIC;
         wrd       : OUT STD_LOGIC;
         wr_m      : OUT STD_LOGIC;
         ldir      : OUT STD_LOGIC;
         ins_dad   : OUT STD_LOGIC;
         word_byte : OUT STD_LOGIC;
			d_sys  	 : OUT  STD_LOGIC;
			ei  	  	 : OUT STD_LOGIC;  
			di     	 : OUT STD_LOGIC; 
			reti   	 : OUT STD_LOGIC;
			reg_intr  : OUT STD_LOGIC;
			reg_excp  : OUT STD_LOGIC;
			op			 : OUT std_LOGIC_VECTOR(4 downto 0);
			in_d      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			inta 	 	 : OUT std_logic;
			e_no_align: OUT std_LOGIC;
			calls     : OUT STD_LOGIC;
			intr 	  	 : IN std_logic;
			int_e     : IN STD_LOGIC;
			excpr     : IN STD_LOGIC;
			no_align  : IN std_logic;
			addr_no_ok: IN std_logic);
END COMPONENT;


BEGIN

    -- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
    -- En los esquemas de la documentacion a la instancia de la logica de control le hemos llamado c0
    -- Aqui iria la definicion del comportamiento de la unidad de control y la gestion del PC

	 c0 : control_l PORT MAP (
		ir => ir_actual,
		op => op_l,
		ldpc => ldpc_l,
		wrd => wrd_l,
		addr_a => addr_a,
		addr_b => addr_b,
		addr_d => addr_d,	
		wr_m => wr_m_l,
		immed => immed,
		in_d => in_d_l,
		immed_x2 => immed_x2,
		word_byte => w_b,
		Rb_N => Rb_N,
		addr_io => addr_io,
		rd_in => rd_in,
		wr_out => wr_out, 
	   a_sys => a_sys,
		ei	  	=> ei_l, 
		di    => di_l, 
		reti  => reti_l,
		d_sys => d_sys_l,
		reg_intr => reg_intr_l,
		inta => inta_l,
		reg_excp => reg_excp_l,
		il_inst => il_inst,
		e_no_align => e_no_align_l,
		exec_mode => exec_mode,
		no_priv => no_priv,
		excep_num => excep_num,
		calls => calls_l);
	 
	 ac : multi PORT MAP (
			clk => clk,
		   boot => boot,
         ldpc_l => ldpc_l,
         wrd_l => wrd_l,
         wr_m_l => wr_m_l,
			ei_l => ei_l,
			di_l => di_l,
			reti_l => reti_l,
			reg_intr_l => reg_intr_l,
			reg_excp_l => reg_excp_l,
			inta_l => inta_l,
			d_sys_l => d_sys_l,
			in_d_l => in_d_l,
			op_l => op_l,
			e_no_align_l => e_no_align_l,
			calls_l => calls_l,
         w_b  => w_b,
         ldpc => ldpc,
         wrd => wrd,
         wr_m => wr_m,
         ldir => ldir,
         ins_dad => ins_dad,
         word_byte => word_byte,
			ei => ei,
			di => di,
			reti => reti,
			d_sys => d_sys,
			reg_intr => system_cicle_int,
			reg_excp => system_cicle_exc,
			in_d => in_d,
			inta => inta,
			intr => intr,
			int_e => int_e,
			op => op,
			excpr => excpr,
			e_no_align => e_no_align,
			calls => calls,
			no_align => no_align,
			addr_no_ok => addr_no_ok);
			
	reg_intr <= system_cicle_int;
	reg_excp <= system_cicle_exc;
	
	 -- Salts
	jmp <= ALU_OUT when (ir_actual(2 downto 0) = "000" and z = '1') or -- JZ
						  	 (ir_actual(2 downto 0) = "001" and z = '0') or -- JNZ
							 (ir_actual(2 downto 0) = "011")				  or -- JMP
							 (ir_actual(2 downto 0) = "100")    -- JAL 
								else PC2;
							 
	tknbr <= INI when boot = '1' else  	 -- BOOT
				ALU_OUT when (system_cicle_int = '1' or system_cicle_exc = '1') else  -- ESTAT SYSTEM
				PC_ACT when ldpc = '0' else -- NO ES CARREGA PC
				BR when ir_actual(15 downto 12) = "0110" and (ir_actual(8) xor z) = '1' else -- HI HA UN BRANCH TAKEN 
				jmp when ir_actual(15 downto 12) = "1010" else  -- Els jmp tenen una logica complicada que es calcula a part.
				ALU_OUT when ir_actual(15 downto 12) = "1111" and ir_actual(5 downto 0) = "100100" -- reti
						else PC2;  
	 
	 -- Logica Program Counter
	 
	 pc_saltat <= nou_PC+2+std_logic_vector(resize(signed(ir_actual(7 downto 0)&'0'), 16));

	 process(clk)
	 begin
		if rising_edge(clk) then
			case tknbr is 
				when INI => nou_pc <= x"C000";
				when ALU_OUT => nou_pc <= aluout;
				when PC2 => nou_pc <= nou_pc+2;
				when BR => nou_pc <= pc_saltat;
				when PC_ACT => NULL;
				when others => nou_pc <= nou_pc;
			 end case;
		 end if;
	 end process;
	 pc <= nou_pc;
	 

	 
	 -- Cal convertir aixo en un process
	 ir_actual <= x"0000" when rising_edge(clk) and boot = '1'
					else datard_m when rising_edge(clk) and ldir = '1';
					--else ir_actual when rising_edge(clk);
	 

END Structure;