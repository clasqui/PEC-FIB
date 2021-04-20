LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER

ENTITY controladores_IO IS
    PORT (boot   : IN  STD_LOGIC;
			 CLOCK_50    : IN  std_logic; 
			 addr_io     : IN  std_logic_vector(7 downto 0); 
			 wr_io  : in  std_logic_vector(15 downto 0); 
			 rd_io  : out std_logic_vector(15 downto 0); 
			 wr_out : in  std_logic; 
			 rd_in  : in  std_logic; 
			 led_verdes  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := "11111111"; 
			 led_rojos   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := "11111111";
			 KEY : IN std_logic_vector(3 downto 0);
			 SW : IN std_LOGIC_VECTOR(7 downto 0);
			 HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
			 ); 
END controladores_IO; 

ARCHITECTURE Structure OF controladores_IO IS 

	type io_ports_t is array (0 to 15) of std_logic_vector(15 downto 0); -- CAL CANVIAT AQUESTA MEMORIA PER FER-LA GRAN
	
	COMPONENT driver7Segmentos IS
		PORT (
			codiNum : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
			HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			enables : IN STD_LOGIC_VECTOR(3 DOWNTO 0));
	 END COMPONENT;
	
	signal io_ports : io_ports_t;
	
	signal entrada_botons: std_logic_vector(15 downto 0);
	signal entrada_switches: std_logic_vector(15 downto 0);
	signal codiNum: std_LOGIC_VECTOR(15 downto 0);
	signal visor_enable: std_LOGIC_VECTOR(3 downto 0);

BEGIN

-- Controladors
	driver : driver7Segmentos PORT MAP (
		codiNum => codiNum, 
		enables => visor_enable,
		HEX0 => HEX0, 
		HEX1 => HEX1, 
		HEX2 => HEX2, 
		HEX3 => HEX3);

-- Port 5 --> Leds verds
	led_verdes <= io_ports(5)(7 downto 0);
	
-- Port 6 --> Leds vermells
	led_rojos <= io_ports(6)(7 downto 0);
	
-- Port 7 --> Botons
	entrada_botons <= "000000000000"&KEY(3 downto 0);

-- Port 8 --> Switches
	entrada_switches <="00000000"&SW;

-- Port 9 --> Visors encesos/apagats.
	visor_enable <= io_ports(9)(3 downto 0);
	
-- Port 10 --> Visors
	codiNum <= io_ports(10);


-- BANC DE REGISTRES
	process (CLOCK_50)
	begin
		if(rising_edge(CLOCK_50)) then
			if wr_out = '1' then
				io_ports(conv_integer(addr_io)) <= wr_io;
			else 
				io_ports(7) <= entrada_botons;
				io_ports(8) <= entrada_switches;
			end if;
		end if;
	end process;
	
-- Altres sortides
	rd_io <= io_ports(conv_integer(addr_io(3 downto 0)));

END Structure; 