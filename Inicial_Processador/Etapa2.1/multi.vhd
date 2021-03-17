library ieee;
USE ieee.std_logic_1164.all;

entity multi is
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
end entity;

architecture Structure of multi is

    -- Aqui iria la declaracion de las los estados de la maquina de estados

	-- Build an enumerated type for the estat machine
	type estat_t is (FETCH, DEMW);

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
					estat <= FETCH;
			end case;
		end if;
	end process;

	
	
--	process (clk)
--	begin
--		case estat is
--			when FETCH =>
--				ldpc <= '0';
--				wrd <= '0';
--				wr_m <= '0';
--				word_byte <= '0';
--				ins_dad <= '0';
--				ldir <= '1';
--			when DEMW =>
--				ldpc <= ldpc_l;
--				wrd <= wrd_l;
--				wr_m <= wr_m_l;
--				word_byte <= w_b;
--				ins_dad <= '1';
--				ldir <= '0';
--		end case;
--	end process;
	
	ldpc <= '0' when estat = FETCH else ldpc_l;
	wrd <= '0' when estat = FETCH else wrd_l;
	wr_m <= '0' when estat = FETCH else wr_m_l;
	word_byte <= '0' when estat = FETCH else w_b;
	ins_dad <= '0' when estat = FETCH else '1';
	ldir <= '1' when estat = FETCH else '0';
	
	
	
    -- Aqui iria la máquina de estados del modelos de Moore que gestiona el multiciclo
    -- Aqui irian la generacion de las senales de control que su valor depende del ciclo en que se esta.

end Structure;