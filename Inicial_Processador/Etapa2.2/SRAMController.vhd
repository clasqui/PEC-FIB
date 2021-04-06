library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity SRAMController is
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
end SRAMController;

architecture comportament of SRAMController is

type estat_t is (wr0, wr1);
signal estat: estat_t;

signal dataRD : std_logic_vector(15 downto 0);
signal dataWR : std_logic_vector(15 downto 0);
signal permiso_escritura : std_logic := '0';

begin

-- senyals de lectura i escriptura a memoria.
	dataWR <= "ZZZZZZZZ" & dataToWrite(7 DOWNTO 0) when byte_m = '1' else dataToWrite; -- Si byte o word
	dataReaded <= SRAM_DQ when byte_m = '0'  
							else std_logic_vector(resize(signed(SRAM_DQ(7 DOWNTO 0)),16)) when address(0) = '1' and byte_m = '1'
							else std_logic_vector(resize(signed(SRAM_DQ(15 DOWNTO 8)),16)); -- Agafem una part o l'alta del que ens dona la mem

-- https://www.digchip.com/datasheets/parts/datasheet/211/IS61LV25616-10T-pdf.php
-- Senyals que van a la placa.
	SRAM_ADDR <= "000" & address(15 downto 1); -- Van 17 bits a la placa. Hi va address/2. 
	SRAM_DQ <= dataWR when WR = '1' else "ZZZZZZZZZZZZZZZZ";
	SRAM_LB_N <= '1' when WR = '1' and byte_m = '1' and address(0) = '1' else '0'; -- Nomes es 1 quan escric byte alt		
	SRAM_UB_N <= '1' when WR = '1' and byte_m = '1' and address(0) = '0' else '0'; -- Nomes es 1 quan escric byte baix						
	SRAM_CE_N <= '0'; -- Baix sempre
	SRAM_OE_N <= '0'; -- Baix a la lectura i a l'escriptura dona igual.
   SRAM_WE_N <= '0' when estat = wr1 else '1'; -- Alt a la lectura, baix a l'escriptura. Això és el permis d'esctiptura. Caldria sincronitzar-lo amb el clock.
-- AQUI FALTA UNA MANERA INTELIGENT DE PENSAR COM SINCONITZAR L'ESCRIPTURA AMB EL RELLOTGE
-- El cicle de rellotge del controlador son 20ns, mes que suficient per l'escriptura, que en necessita 10ns. Per tant amb dos estats (cicles)
-- ja ho tindriem.
	
	process(clk)
	begin
		if rising_edge(clk) then
		 case estat is
			when wr0 =>
				if(WR = '1') then
					estat <= wr1;
					permiso_escritura <= '1';
				else estat <= wr0;
				end if;
			when others =>
				estat <= wr0;
		 end case;
		end if;
	end process;
end comportament;
