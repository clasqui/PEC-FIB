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
			 
          SW        : in std_logic_vector(9 downto 0);
			 HEX0 	  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX1 	  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX2 	  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX3 	  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 LEDG 	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); 
			 LEDR  	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			 KEY		  : IN STD_LOGIC_VECTOR(3 DOWNTO 0));
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
			 addr_io	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			 rd_in	  : OUT STD_LOGIC;
			 wr_out    : OUT STD_LOGIC;
			 wr_io	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 rd_io	 : IN STD_LOGIC_VECTOR(15 DOWNTO 0));
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

COMPONENT controladores_IO IS
    PORT (boot   : IN  STD_LOGIC;
			 CLOCK_50    : IN  std_logic; 
			 addr_io     : IN  std_logic_vector(7 downto 0); 
			 wr_io  : in  std_logic_vector(15 downto 0); 
			 rd_io  : out std_logic_vector(15 downto 0); 
			 wr_out : in  std_logic; 
			 rd_in  : in  std_logic; 
			 led_verdes  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); 
			 led_rojos   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			 KEY : IN std_logic_vector(3 downto 0);
			 SW : IN std_LOGIC_VECTOR(7 downto 0)); 
END COMPONENT;

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
	signal addr_io     :   std_logic_vector(7 downto 0); 
	signal wr_io  :   std_logic_vector(15 downto 0); 
	signal rd_io  :  std_logic_vector(15 downto 0); 
	signal wr_out :   std_logic;
	signal rd_in :   std_logic;
	
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
		addr_io => addr_io,
		wr_io  => wr_io, 
		rd_io  => rd_io, 
		wr_out => wr_out,
		rd_in => rd_in
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

io0 : Controladores_IO
	port map (
		boot => SW(9),
		CLOCK_50 => CLOCK_50,
	   addr_io => addr_io,
		wr_io  => wr_io, 
		rd_io  => rd_io, 
		wr_out => wr_out, 
		rd_in  => rd_in, 
		led_verdes  => LEDG, 
		led_rojos => LEDR,
		KEY => KEY,
		SW => SW(7 downto 0)
	);
	
-- Amb tres cicles ja tenim escrit. De fet podriem escriure en 2 segurament.
red0 : Reductora
	generic map (reductora => 4)
	port map (CLOCK_50 => CLOCK_50, Rellotge => clk_proc);

END Structure;