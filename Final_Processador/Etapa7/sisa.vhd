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
			 KEY		  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			 PS2_CLK   : inout std_logic; 
			 PS2_DAT	  : inout std_logic;
			 VGA_R     : OUT std_logic_vector(3 downto 0);
			 VGA_G     : OUT std_logic_vector(3 downto 0);
			 VGA_B     : OUT std_logic_vector(3 downto 0);
			 VGA_HS : OUT std_logic;
			 VGA_VS : OUT std_logic
			 );
			 
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
          SRAM_WE_N : out   std_logic := '1';
			 -- Senyals del controlador VGA
			 vga_addr  : out std_logic_vector(12 downto 0);
			 vga_we    : out std_logic;
			 vga_wr_data : out std_logic_vector(15 downto 0);
			 vga_rd_data : in std_logic_vector(15 downto 0);
			 vga_byte_m  : out std_logic
			 );
			 
end COMPONENT;

COMPONENT controladores_IO IS
    PORT (boot   : IN  STD_LOGIC;
			 CLOCK_50    : IN  std_logic; 
			 clk    : IN std_LOGIC;
			 addr_io     : IN  std_logic_vector(7 downto 0); 
			 wr_io  : in  std_logic_vector(15 downto 0); 
			 rd_io  : out std_logic_vector(15 downto 0); 
			 wr_out : in  std_logic; 
			 rd_in  : in  std_logic; 
			 led_verdes  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); 
			 led_rojos   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			 KEY : IN std_logic_vector(3 downto 0);
			 SW : IN std_LOGIC_VECTOR(7 downto 0);
			 HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 ps2_clk  : inout std_logic; 
			 ps2_data : inout std_logic
			 ); 
END COMPONENT;

COMPONENT vga_controller IS
	PORT  (clk_50mhz      : in  std_logic; -- system clock signal
         reset          : in  std_logic; -- system reset
         blank_out      : out std_logic; -- vga control signal
         csync_out      : out std_logic; -- vga control signal
         red_out        : out std_logic_vector(7 downto 0); -- vga red pixel value
         green_out      : out std_logic_vector(7 downto 0); -- vga green pixel value
         blue_out       : out std_logic_vector(7 downto 0); -- vga blue pixel value
         horiz_sync_out : out std_logic; -- vga control signal
         vert_sync_out  : out std_logic; -- vga control signal
         --
         addr_vga          : in std_logic_vector(12 downto 0);
         we                : in std_logic;
         wr_data           : in std_logic_vector(15 downto 0);
         rd_data           : out std_logic_vector(15 downto 0);
         byte_m            : in std_logic;
         vga_cursor        : in std_logic_vector(15 downto 0);  -- simplemente lo ignoramos, este controlador no lo tiene implementado
         vga_cursor_enable : in std_logic);
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
	
	signal addr_vga : std_logic_vector(12 downto 0);
	signal vga_we : std_logic;
	signal vga_wr_data : std_logic_vector(15 downto 0);
	signal vga_rd_data : std_logic_vector(15 downto 0);
	signal vga_byte_m  : std_logic;
	
	signal vga_red_out : std_logic_vector(7 downto 0);
	signal vga_green_out : std_logic_vector(7 downto 0);
	signal vga_blue_out : std_logic_vector(7 downto 0);
	
	
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
        SRAM_WE_N => SRAM_WE_N,
-- Senyals controlador VGA
			vga_addr  => addr_vga,
			vga_we    => vga_we,
			vga_wr_data => vga_wr_data,
			vga_rd_data => vga_rd_data,
			vga_byte_m  => vga_byte_m
   );
	
vga0 : vga_controller
	port map (
			clk_50mhz      => CLOCK_50,
         reset          => SW(9),
         blank_out      => open,
         csync_out      => open,
         red_out        => vga_red_out,
         green_out      => vga_green_out,
         blue_out       => vga_blue_out,
         horiz_sync_out => VGA_HS,
         vert_sync_out  => VGA_VS,
         --
         addr_vga          => addr_vga,
         we                => vga_we,
         wr_data           => vga_wr_data,
         rd_data           => vga_rd_data,
         byte_m            => vga_byte_m,
         vga_cursor        => "0000000000000000",
         vga_cursor_enable => '0'
	);
	
VGA_R <= vga_red_out(3 downto 0);
VGA_G <= vga_green_out(3 downto 0);
VGA_B <= vga_blue_out(3 downto 0);

io0 : Controladores_IO
	port map (
		boot => SW(9),
		CLOCK_50 => CLOCK_50,
		clk       => clk_proc,
	   addr_io => addr_io,
		wr_io  => wr_io, 
		rd_io  => rd_io, 
		wr_out => wr_out, 
		rd_in  => rd_in, 
		led_verdes  => LEDG, 
		led_rojos => LEDR,
		KEY => KEY,
		SW => SW(7 downto 0),
		HEX0 => HEX0,
		HEX1 => HEX1,
		HEX2 => HEX2,
		HEX3 => HEX3,
		ps2_clk => PS2_CLK,
		ps2_data => PS2_DAT
	);
	
-- Amb tres cicles ja tenim escrit. De fet podriem escriure en 2 segurament.
red0 : Reductora
	generic map (reductora => 4)
	port map (CLOCK_50 => CLOCK_50, Rellotge => clk_proc);

END Structure;