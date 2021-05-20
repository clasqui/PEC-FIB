library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity MemoryController is
    port (CLOCK_50  : in  std_logic;
	       addr      : in  std_logic_vector(15 downto 0);
          wr_data   : in  std_logic_vector(15 downto 0);
          rd_data   : out std_logic_vector(15 downto 0);
          we        : in  std_logic;
          byte_m    : in  std_logic;
			 no_align  : out std_logic;
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
			 vga_byte_m  : out std_logic);
			 
end MemoryController;

architecture comportament of MemoryController is

COMPONENT SRAMController is
    port (clk         : in    std_logic;
          -- se�ales para la placa de desarrollo
          SRAM_ADDR   : out   std_logic_vector(17 downto 0);
          SRAM_DQ     : inout std_logic_vector(15 downto 0);
          SRAM_UB_N   : out   std_logic;
          SRAM_LB_N   : out   std_logic;
          SRAM_CE_N   : out   std_logic := '1';
          SRAM_OE_N   : out   std_logic := '1';
          SRAM_WE_N   : out   std_logic := '1';
          -- se�ales internas del procesador
          address     : in    std_logic_vector(15 downto 0) := "0000000000000000";
          dataReaded  : out   std_logic_vector(15 downto 0);
          dataToWrite : in    std_logic_vector(15 downto 0);
          WR          : in    std_logic;
          byte_m      : in    std_logic := '0');
end COMPONENT;

signal wr_sram : std_logic;
signal rd_data_from_sram: std_logic_vector(15 downto 0); -- Necessitem senyal auxiliar per decidir si tornem lo de 

begin
	
	wr_sram <= we when addr < "1100000000000000" else '0';
	-- wr_sram <= '1' when addr(15 DOWNTO 14) = "00" else '0';
	
	sram : SRAMController
		port map (
			clk => CLOCK_50,
			SRAM_ADDR => SRAM_ADDR,
			SRAM_DQ => SRAM_DQ,
			SRAM_UB_N => SRAM_UB_N,
			SRAM_LB_N => SRAM_LB_N,
			SRAM_CE_N => SRAM_CE_N,
			SRAM_OE_N => SRAM_OE_N, 
			SRAM_WE_N => SRAM_WE_N,
			address => addr,
			dataReaded => rd_data_from_sram,
			dataToWrite => wr_data,
			byte_m => byte_m,
			WR => wr_sram
 		);
		
		-- LOGICA MAPEIG MEMORIA DE VIDEO
		-- Rang memoria de video: 0xA000 - 0xBFFF
		
		vga_addr <= addr(12 downto 0) when (addr >= x"A000" and addr < x"BFFF") else (others=>'0');
		vga_we <= we when (addr >= x"A000" and addr < x"BFFF") else '0';
		vga_wr_data <= wr_data ; --when (addr >= x"A000" and addr < x"BFFF") else (others=>'0');
		vga_byte_m <= byte_m;
		
		rd_data <= rd_data_from_sram;--vga_rd_data when (addr >= x"A000" and addr < x"BFFF") else rd_data_from_sram;
		
		no_align <= not byte_m and addr(0);

end comportament;
