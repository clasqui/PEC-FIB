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
			 Rb_N		  : OUT STD_LOGIC;
			 z 		  : IN STD_LOGIC;
			 aluout	  : IN STD_LOGIC_VECTOR(15 DOWNTO 0));
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
	 
	 -- Salts
	jmp <= ALU_OUT when (ir_actual(2 downto 0) = "000" and z = '1') or -- JZ
							 (ir_actual(2 downto 0) = "001" and z = '0') or -- JNZ
							 (ir_actual(2 downto 0) = "011")				  or -- JMP
							 (ir_actual(2 downto 0) = "100") else PC2;
							 
	tknbr <= INI when boot = '1' else  	 -- BOOT
				PC_ACT when ldpc = '0' else -- NO ES CARREGA PC
				BR when ir_actual(15 downto 12) = "0110" and (ir_actual(8) xor z) = '1' else -- HI HA UN BRANCH TAKEN 
				jmp when ir_actual(15 downto 12) = "1010" else PC2;  -- Els jmp tenen una logica complicada que es calcula a part.
	 
	 -- Logica Program Counter
	 
	 pc_saltat <= (nou_PC+2)+("0000000"&ir_actual(7 downto 0)&'0');   -- pc + 2 + ir[7:0]*2 
	 
	 with tknbr select nou_pc <=
		x"C000"   when INI,
		nou_pc 	 when PC_ACT,
		nou_pc+2	 when PC2,
		pc_saltat when BR,
		aluout 	 when others;  -- Cas del JMP que ve d'un registre.
	 
--	 nou_pc <= x"C000" when rising_edge(clk) and boot = '1' else   -- amb boot
--						nou_pc when rising_edge(clk) and ldpc = '0' else    -- No hi ha nou PC
--						nou_pc+2 when rising_edge(clk) and tknbr = PC2 else
--						pc_saltat;  
--				
	 pc <= nou_pc when rising_edge(clk);
	 
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