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
			 HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 ps2_clk  : inout std_logic; 
			 ps2_data : inout std_logic;
			 vga_cursor : out std_logic_vector(15 downto 0);
			 vga_cursor_enable : out std_logic
			 ); 
END controladores_IO; 

ARCHITECTURE Structure OF controladores_IO IS 

	type io_ports_t is array (0 to 31) of std_logic_vector(15 downto 0); -- CAL CANVIAT AQUESTA MEMORIA PER FER-LA GRAN
	
	COMPONENT driver7Segmentos IS
		PORT (
			codiNum : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			enables : IN STD_LOGIC_VECTOR(3 DOWNTO 0));
	 END COMPONENT;
	 
	 COMPONENT keyboard_controller is
    Port (clk        : in    STD_LOGIC;
          reset      : in    STD_LOGIC;
          ps2_clk    : inout STD_LOGIC;
          ps2_data   : inout STD_LOGIC;
          read_char  : out   STD_LOGIC_VECTOR (7 downto 0);
          clear_char : in    STD_LOGIC;
          data_ready : out   STD_LOGIC);
	end COMPONENT;
	
	signal io_ports : io_ports_t;
	
	signal entrada_botons: std_logic_vector(15 downto 0);
	signal entrada_switches: std_logic_vector(15 downto 0);
	signal codiNum: std_LOGIC_VECTOR(15 downto 0);
	signal visor_enable: std_LOGIC_VECTOR(3 downto 0) := "1111";
	signal tecla_pulsada: std_LOGIC_VECTOR(7 DOWNTO 0);
	signal tecla_pillada: std_LOGIC;
	signal tecla_disponible: std_LOGIC;
	signal contador_ciclos       : STD_LOGIC_VECTOR(15 downto 0):=x"0000"; 
	signal contador_milisegundos : STD_LOGIC_VECTOR(15 downto 0):=x"0000";

BEGIN

-- Controladors
	kb0 : keyboard_controller PORT MAP (
		clk => CLOCK_50,
		reset => boot,
		ps2_clk => ps2_clk, -- Sortida del modul sisa
		ps2_data => ps2_data,
		read_char => tecla_pulsada,
		clear_char => tecla_pillada,
		data_ready => tecla_disponible
	);
	
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
	--led_rojos <= tecla_pulsada; --debug
	
-- Port 7 --> Botons
	entrada_botons <= "000000000000"&KEY(3 downto 0);

-- Port 8 --> Switches
	entrada_switches <="00000000"&SW;

-- Port 9 --> Visors encesos/apagats.
	visor_enable <= io_ports(9)(3 downto 0);
	
-- Port 10 --> Visors
	codiNum <= "0000000000000000" when boot = '1' else io_ports(10);

-- Port 15 -- Ascii teclat
-- Port 16 -- enquesta Teclat
-- Port 20 -- nombre aleatori.
-- Port 21 -- Timer



-- BANC DE REGISTRES
	process (CLOCK_50)
	begin
		if(rising_edge(CLOCK_50)) then
			if boot = '1' then    -- valors d'inici
				io_ports(9) <= x"FFFF";
			end if;
			tecla_pillada <= '0';
			-- Del joc snake
			if contador_ciclos=0 then
				contador_ciclos<=x"C350";   -- tiempo de ciclo=20ns(50Mhz) 1ms=50000ciclos 
				if contador_milisegundos>0 then
					contador_milisegundos <= contador_milisegundos-1; 
				end if; 
		   else
				contador_ciclos <= contador_ciclos-1; 
			end if;
			-- end joc snake
			if wr_out = '1' then
				if addr_io = 16 then -- S'està escribint el clear de teclat
					tecla_pillada <= '1';
				elsif addr_io = 21 then
					contador_milisegundos <= wr_io;
				else
					io_ports(conv_integer(addr_io)) <= wr_io;
				end if;
			else 
				io_ports(7) 	<= entrada_botons;
				io_ports(8) 	<= entrada_switches;
				io_ports(15) 	<= "00000000"&tecla_pulsada;
				io_ports(16)	<= "000000000000000"&tecla_disponible;
				io_ports(20)   <= contador_ciclos;
			end if;
		end if;
	end process;	
	
-- Altres sortides
	rd_io <= io_ports(conv_integer(addr_io(4 downto 0)));  -- Lectura AQUI HEM DE BLOQUEJAR LA LECTURA!!

END Structure; 

