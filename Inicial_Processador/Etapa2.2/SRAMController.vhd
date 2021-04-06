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

signal dataRD 		: std_logic_vector(15 downto 0);
signal dataWR 		: std_logic_vector(15 downto 0);
signal espera 		: std_logic := '0';
signal escrivint 	: std_logic := '0';
-- signal ctrl 		: std_logic := '0';

begin

-- senyals de lectura i escriptura a memoria.
	dataWR <= dataToWrite when byte_m = '1' else "ZZZZZZZZ" & dataToWrite(7 DOWNTO 0) when address(0) = '0' else dataToWrite(7 DOWNTO 0) & "ZZZZZZZZ"; -- Si byte o word
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
	
	
	-- AIXO CAL REVISAR. SEGUR QUE POT SER MÉS SENZILL.
	process(WR,clk)  -- No podem fer dos process diferents per WR i clk perque canvien a l'hora.
	begin
		if (WR = '0') then
			espera <= '1';   -- Per fer una espera d'un cicle. Si no la fem podriem començar a escriure por ahí random.
			estat <= wr0;
			-- ctrl <= '0';  
		elsif rising_edge(clk) then   -- Si hem entrat al process pq ha canviat el WR no hem d'executar això. 
		 case estat is
			when wr0 =>
				if (WR = '1' and espera = '1') then
					espera <= '0'; --s'acabó fer el vago.
					-- ctrl <= '1';
				elsif(WR = '1' and espera = '0') then   -- Només pot passar si s'ha fet el cicle d'espera
					estat <= wr1;
					-- escrivint <= '1';
					-- permiso_escritura <= '0'; -- ens quedarem en aquest estat fins que baixi la senyal d'escriptura.
				end if;
			when others =>
				estat <= estat;
--				if (escrivint = '1') then --ja hem escrit. nomes cal un cicle.
--					estat <= wr1;
--				else 
--					estat <= wr0;
--				end if;
		 end case;
		end if;
	end process;
end comportament;
