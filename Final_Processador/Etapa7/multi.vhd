library ieee;
USE ieee.std_logic_1164.all;

entity multi is

    port(clk       : IN  STD_LOGIC;
         boot      : IN  STD_LOGIC;
         ldpc_l    : IN  STD_LOGIC;
         wrd_l     : IN  STD_LOGIC;
         wr_m_l    : IN  STD_LOGIC;
			ei_l	    : IN  STD_LOGIC;  
			di_l      : IN  STD_LOGIC; 
			reti_l    : IN  STD_LOGIC;
         w_b       : IN  STD_LOGIC;
			d_sys_l   : IN  STD_LOGIC;
			reg_intr_l: IN  STD_LOGIC;
			op_l		 : IN std_LOGIC_VECTOR(4 downto 0);
			in_d_l    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			inta_l    : IN std_logic;
         ldpc      : OUT STD_LOGIC;
         wrd       : OUT STD_LOGIC;
         wr_m      : OUT STD_LOGIC;
         ldir      : OUT STD_LOGIC;
         ins_dad   : OUT STD_LOGIC;
         word_byte : OUT STD_LOGIC;
			ei  	  	 : OUT STD_LOGIC;  
			di     	 : OUT STD_LOGIC; 
			reti   	 : OUT STD_LOGIC;
			reg_intr  : OUT STD_LOGIC;
			int_e     : IN STD_LOGIC;
			d_sys  	 : OUT  STD_LOGIC;
			op			 : OUT std_LOGIC_VECTOR(4 downto 0);
			in_d	    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			inta 	    : OUT std_logic;
			intr 	    : IN std_logic);
end entity;

architecture Structure of multi is

    -- Aqui iria la declaracion de las los estados de la maquina de estados

	-- Build an enumerated type for the estat machine
	type estat_t is (FETCH, DEMW, SYSTEM);

	-- Register to hold the current estat
	signal estat   : estat_t;

begin

	-- Logic to advance to the next estat
	process (clk, boot)
	begin
		if boot = '1' then
			estat <= FETCH;
		elsif (rising_edge(clk)) then
			case estat is
				when FETCH =>
					estat <= DEMW;
				when DEMW=>
					if intr = '1' and int_e = '1' then
						estat <= SYSTEM;
					else
						estat <= FETCH;
					end if;
				when SYSTEM =>
					estat <= FETCH;
			end case;
		end if;
	end process;

	
	
	ldpc <= ldpc_l when estat = DEMW else '0'; 		-- Carrego o no el NOU PC
	wrd <= wrd_l when estat = DEMW else '1' when estat = SYSTEM else '0'; -- Escriure al banc de reg
	wr_m <= wr_m_l when estat = DEMW else '0'; 		-- Escriure a memoria
	word_byte <=  w_b when estat = DEMW else '0';	-- Escriure word o byte a memoria
	ins_dad <= '0' when estat = FETCH else '1';		-- Mem address ve de alu o de memoria
	ldir <= '1' when estat = FETCH else '0';			
	ei <= ei_l when estat = DEMW else '0';				-- Interrupt enable
	di <= di_l when estat = DEMW else '0';          -- Interrupt disable
	reti <= reti_l when estat = DEMW else '0';		-- Return interrupt
	reg_intr <= reg_intr_l	when estat = SYSTEM else '0';
	op <= "10100" when estat = SYSTEM else op_l;     -- OP coode ha de fer passar la A al PC.
	in_d <= "00" when estat = SYSTEM else in_d_l;    -- Per guardar pcUP al banc de reg
	d_sys <= '1' when estat = SYSTEM else d_sys_l;
	inta <= inta_l when estat = SYSTEM else '0';
	

end Structure;