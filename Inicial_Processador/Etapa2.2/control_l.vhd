LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY control_l IS
    PORT (ir        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          ldpc      : OUT STD_LOGIC;
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC;
          immed_x2  : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC);
END control_l;


ARCHITECTURE Structure OF control_l IS

signal PC: std_LOGIC_VECTOR(15 downto 0);

BEGIN

    -- Aqui iria la generacion de las senales de control del datapath
	 ldpc <= '0' when ir = "1111111111111111" else '1';
	 --op <= "01" when ir(15 downto 12) = "0011" or ir(15 downto 12) = "0100" or ir(15 downto 12) = "1101" or ir(15 downto 12) = "1110"
				--else "0"&ir(8);
	
	with ir(15 downto 12) select wrd <=
		'1' when "0101", --	 MOVHI/MOVI
		'1' when "0011", -- LD
		'1' when "1101", -- LDB
		'0'when others; -- CASOS ST LD
	
	-- TODO: fer signal 
	 with ir(15 downto 12) select op <=
		'0'&ir(8) when "0101", --	 ARREGLAR AIXO EN UN FUTUR (CAS MOVI / MOVHI)
		"10" when others; -- CASOS ST LD
	 
	 
	 addr_d <= ir(11 downto 9);
	 addr_a <= ir(11 downto 9) when ir(15 downto 12) = "0101"
					else ir(8 downto 6);
	 addr_b <= ir(11 downto 9);
	 
	 -- wrd <= ir(12);
	 wr_m <= '1' when ir(12) = '0' else '0';
	 
	 in_d <= '1' when ir(15 downto 12) = "0011" or ir(15 downto 12) = "1101" else '0';
	 
	 immed_x2 <= '1' when ir(15 downto 12) = "0011" or ir(15 downto 12) = "0100" else '0';
	 
	 word_byte <= ir(15);
	 
	 immed <= std_logic_vector(resize(signed(ir(7 downto 0)), 16)) when ir(15 downto 12) = "0101" -- en les dimmediat, son 8 bits
					else std_logic_vector(resize(signed(ir(5 downto 0)), 16)); -- en les altres, son 6 bits
END Structure;