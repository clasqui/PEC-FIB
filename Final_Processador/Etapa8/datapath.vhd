LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.ALL;

ENTITY datapath IS
    PORT (clk      : IN  STD_LOGIC;
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
			 HEX0 	 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX1 	 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX2 	 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX3 	 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 d_sys  	  : IN  STD_LOGIC;
			 a_sys  	  : IN  STD_LOGIC; 
			 ei	  	  : IN STD_LOGIC;  
			 di     	  : IN STD_LOGIC; 
			 reti   	  : IN STD_LOGIC;
			 boot      : IN STD_LOGIC;
			 reg_intr  : IN STD_LOGIC;
			 reg_excp  : IN STD_LOGIC;
			 int_e     : OUT STD_LOGIC;
			 div_zero  : OUT STD_LOGIC;
			 excep_num : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			 excp_of_fp_e : OUT STD_LOGIC;
			 exec_mode: OUT STD_LOGIC;
			 miss_i : OUT STD_LOGIC;
			 miss_d : OUT STD_LOGIC;
			 inv_pg_i : OUT STD_LOGIC;
			 inv_pg_d : OUT STD_LOGIC;
			 pr_pg_i : OUT STD_LOGIC;
			 pr_pg_d : OUT STD_LOGIC;
			 ro_pg : OUT STD_LOGIC;
			 we_tlb : IN STD_LOGIC;
			 v_p : IN STD_LOGIC;
			 flush : IN STD_LOGIC;
			 i_d		  : IN STD_LOGIC);
END datapath;

ARCHITECTURE Structure OF datapath IS

COMPONENT alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 z  : OUT STD_LOGIC;
			 div_zero : OUT STD_LOGIC);
END COMPONENT;

COMPONENT regfile IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 d_sys  : IN  STD_LOGIC;
			 a_sys  : IN  STD_LOGIC;
			 ei	  : IN STD_LOGIC;
			 di     : IN STD_LOGIC;
			 reti   : IN STD_LOGIC;
			 boot	  : IN STD_LOGIC;
			 reg_intr : IN STD_LOGIC;
			 reg_excep: IN STD_LOGIC;
			 int_e  : OUT STD_LOGIC;
			 excep_num : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			 d_efect : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			 excp_of_fp_e : OUT STD_LOGIC;
			 exec_mode: OUT STD_LOGIC);
END COMPONENT;

COMPONENT TLB IS
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
END COMPONENT;

signal d : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal x : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal y : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- la poso aqui perque despres ens serà util quan tinguem dos operands
signal a : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal b : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal alu_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal dir_efectiva : STD_LOGIC_VECTOR(15 DOWNTO 0);


 -- Senyals pel TLB
 signal addr_virt : STD_LOGIC_VECTOR(15 DOWNTO 0);
 signal ptag_d : std_logic_vector(3 downto 0);
 signal ptag_i : std_logic_vector(3 downto 0);
 signal addr_w_tlb : std_LOGIC_VECTOR(2 downto 0);
 signal vtag : std_logic_vector(3 downto 0);
 signal tag_in : std_logic_vector(15 downto 0);
 signal ptag : std_logic_vector(3 downto 0);
 signal we_tlb_d : std_LOGIC;
 signal we_tlb_i : std_LOGIC;
 signal ro_pg_i : std_LOGIC;
 signal ro_pg_d : std_LOGIC;
 
BEGIN

	reg0 : regfile
		PORT MAP (clk => clk, 
					 wrd => wrd, 
					 addr_a => addr_a, 
					 addr_b => addr_b, 
					 addr_d => addr_d, 
					 d => d, 
					 a => a, 
					 b => b, 
					 a_sys => a_sys, 
					 d_sys => d_sys, 
					 ei => ei, 
					 di => di, 
					 reti => reti, 
					 boot => boot,
					 int_e => int_e,
					 reg_intr => reg_intr,
					 reg_excep => reg_excp,
					 d_efect => dir_efectiva,
					 excep_num => excep_num,
					 excp_of_fp_e => excp_of_fp_e,
					 exec_mode => exec_mode);
	alu0 : alu
		PORT MAP (x => x, 
					 y => y, 
					 op => op, 
					 w => alu_out, 
					 z => z,
					 div_zero => div_zero);
					 

	
	tlbi : TLB PORT MAP (
		clk => clk,
		boot => boot,
		vtag => vtag,
		--p => p_i,
		--v => v_i,
		tag_in => tag_in,
		addr => addr_w_tlb,
		v_p => v_p,
		we => we_tlb_i,
		ptag => ptag_i,
		miss => miss_i,
		inv_pg => inv_pg_i,
		pr_pg => pr_pg_i,
		ro_pg => ro_pg_i,
		flush => flush
	);
	
	tlbd : TLB PORT MAP (
		clk => clk,
		boot => boot,
		vtag => vtag,
		--p => p_i,
		--v => v_i,
		tag_in => tag_in,
		addr => addr_w_tlb,
		v_p => v_p,
		we => we_tlb_d,
		ptag => ptag_d,
		miss => miss_d,
		inv_pg => inv_pg_d,
		pr_pg => pr_pg_d,
		ro_pg => ro_pg_d,
		flush => flush
	);
	
	-- HISTORIES DE LA TLB
	
		vtag <= addr_virt(15 downto 12);
		ptag <= ptag_i when ins_dad = '0' else ptag_d;
		addr_m <=  ptag&addr_virt(11 downto 0);
		tag_in <= b;
		addr_w_tlb <= a(2 downto 0);
		we_tlb_d <= '1' when i_d = '1' and we_tlb = '1' else '0';
		we_tlb_i <= '1' when i_d = '0' and we_tlb = '1' else '0';
		ro_pg <= ro_pg_d or ro_pg_i;
	
	-- ENTRADA DEL BANC DE REGISTRES.	
	d <= datard_m when in_d = "01" else alu_out when in_d = "00" else pc+2 when in_d = "10" else rd_io when in_d = "11" else (others=>'0');
	
	-- SORTIDES DEL DATAPATH
	dir_efectiva <= alu_out when ins_dad = '1' else pc when ins_dad = '0' else (others=>'0');
	addr_virt <= dir_efectiva;
	data_wr <= b;
	aluout <= alu_out; -- Per que hi vagi el PC en cas de JMP.
	wr_io <= b;

	-- MUX DE LES ENTRADES DE LA ALU
	x <= a;
	y <= b when Rb_N = '1' else immed when immed_x2 = '0' else 
			immed(14 DOWNTO 0) & '0' when immed_x2 = '1' else 
			(others=>'0'); 
			
	
END Structure;