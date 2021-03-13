LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY control_l IS
    PORT (ir     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op     : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          ldpc   : OUT STD_LOGIC;
          wrd    : OUT STD_LOGIC;
          addr_a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END control_l;


ARCHITECTURE Structure OF control_l IS

signal PC: std_LOGIC_VECTOR(15 downto 0);

BEGIN

    -- Aqui iria la generacion de las senales de control del datapath
	 ldpc <= '0' when ir = "1111111111111111" else '1';
	 op <= ir(8);   -- AIXO HA DE CANVIAR PERQUE ARA L'OPCODE SON DOS BITS I NO UN!!!!
	 addr_d <= ir(11 downto 9);
	 addr_a <= ir(11 downto 9);
	 wrd <= '1' when ir(15) = '0' else '0';
	 
	 immed <= std_logic_vector(resize(signed(ir(7 downto 0)), 16));
END Structure;