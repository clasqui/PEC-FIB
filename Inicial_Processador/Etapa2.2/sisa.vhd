LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY sisa IS
    PORT (CLOCK_50  : IN    STD_LOGIC;
          SRAM_ADDR : out   std_logic_vector(17 downto 0);
          SRAM_DQ   : inout std_logic_vector(15 downto 0);
          SRAM_UB_N : out   std_logic;
          SRAM_LB_N : out   std_logic;
          SRAM_CE_N : out   std_logic := '1';
          SRAM_OE_N : out   std_logic := '1';
          SRAM_WE_N : out   std_logic := '1';
          SW        : in std_logic_vector(9 downto 9);
			 HEX0 	  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX1 	  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX2 	  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX3 	  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END sisa;

ARCHITECTURE Structure OF sisa IS

COMPONENT proc IS
    PORT (clk       : IN  STD_LOGIC;
          boot      : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_m    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
			 HEX0 	  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX1 	  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX2 	  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX3 	  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END COMPONENT;

COMPONENT MemoryController is
    port (CLOCK_50  : in  std_logic;
	       addr      : in  std_logic_vector(15 downto 0);
          wr_data   : in  std_logic_vector(15 downto 0);
          rd_data   : out std_logic_vector(15 downto 0);
          we        : in  std_logic;
          byte_m    : in  std_logic;
          -- se�ales para la placa de desarrollo
          SRAM_ADDR : out   std_logic_vector(17 downto 0);
          SRAM_DQ   : inout std_logic_vector(15 downto 0);
          SRAM_UB_N : out   std_logic;
          SRAM_LB_N : out   std_logic;
          SRAM_CE_N : out   std_logic := '1';
          SRAM_OE_N : out   std_logic := '1';
          SRAM_WE_N : out   std_logic := '1');
end COMPONENT;

COMPONENT Reductora IS
GENERIC (reductora : integer := 1);
PORT (
		CLOCK_50 : IN std_logic;
		rellotge : OUT std_logic
	);
END COMPONENT;

-- Registres (entrades) i cables
   signal clk_proc          : std_logic := '0';		
   signal addr         : std_logic_vector(15 downto 0);
   signal rd_data      : std_logic_vector(15 downto 0);
   signal wr_data      : std_logic_vector(15 downto 0);
   signal reset_proc   : std_logic := '1';
   signal we               : std_logic;
   signal byte_m           : std_logic;	

BEGIN

-- Instanciament
pro0 : proc 
	port map (
		clk       => clk_proc,
      boot      => SW(9),
      datard_m  => rd_data,
      addr_m    => addr,
      data_wr   => wr_data,
      wr_m      => we,
      word_byte => byte_m,
		HEX0 => HEX0, 
		HEX1 => HEX1, 
		HEX2 => HEX2, 
		HEX3 => HEX3
	);

mem0 : MemoryController
	port map (
        CLOCK_50 => CLOCK_50,
        addr     => addr,
        wr_data  => wr_data,
        rd_data  => rd_data,
        we       => we,
        byte_m   => byte_m,
-- Senyals de la memoria
		  SRAM_ADDR => SRAM_ADDR,
        SRAM_DQ   => SRAM_DQ,
        SRAM_UB_N => SRAM_UB_N,
        SRAM_LB_N => SRAM_LB_N,
        SRAM_CE_N => SRAM_CE_N,
        SRAM_OE_N => SRAM_OE_N,
        SRAM_WE_N => SRAM_WE_N
		  
   );
	
-- Amb tres cicles ja tenim escrit. De fet podriem escriure en 2 segurament.
red0 : Reductora
	generic map (reductora => 4)
	port map (CLOCK_50 => CLOCK_50, Rellotge => clk_proc);

END Structure;