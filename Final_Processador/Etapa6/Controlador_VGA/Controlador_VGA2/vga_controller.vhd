--
-- Text Screen Video Controller.
-- Pixel resolution is 640x480/60Hz, 8 colors (3-bit DAC).
--
-- 2007 Javier Valcarce García, javier.valcarce@gmail.com
-- $Id$

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity vga_controller is
    port (clk_50mhz      : in  std_logic; -- system clock signal
          reset          : in  std_logic; -- system reset
		  --
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
          vga_cursor        : in std_logic_vector(15 downto 0);
          vga_cursor_enable : in std_logic);
end vga_controller;


architecture vga_controller_behavioral of vga_controller is

    component vga_80x40
        port (reset     : in  std_logic;
              clk25MHz  : in  std_logic;
              R         : out std_logic;
              G         : out std_logic;
              B         : out std_logic;
              TEXT_A    : out std_logic_vector(11 downto 0);
              TEXT_D    : in  std_logic_vector(07 downto 0);
              FONT_A    : out std_logic_vector(11 downto 0);
              FONT_D    : in  std_logic_vector(07 downto 0);
              hsync     : out std_logic;
              vsync     : out std_logic;
              ocrx      : in  std_logic_vector(7 downto 0);
              ocry      : in  std_logic_vector(7 downto 0);
              octl      : in  std_logic_vector(7 downto 0);
              blank_sig : out std_logic;
              cursor_e  : out std_logic);
    end component;

    component font_rom is
        generic (data_width : natural := 8;
                 addr_length : natural := 12);
        port (clk      : in std_logic;
              address  : in std_logic_vector(addr_length-1 downto 0);
              data_out : out std_logic_vector(data_width-1 downto 0));
    end component;

    component vga_ram is
        generic (DATA_WIDTH : natural := 16;
                 ADDR_WIDTH : natural := 12);
        port (clk  : in std_logic;
              addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
              data : in std_logic_vector((DATA_WIDTH-1) downto 0);
              we   : in std_logic := '1';
              q    : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;


    signal clk25MHz : std_logic;
    signal crx_oreg : std_logic_vector(7 downto 0);
    signal cry_oreg : std_logic_vector(7 downto 0);
    signal ctl_oreg : std_logic_vector(7 downto 0);

    -- Text Buffer RAM Memory Signals, Port B (to VGA core)
    signal ram_doB : std_logic_vector(07 downto 0);
    signal ram_adB : std_logic_vector(11 downto 0);

    -- Font Buffer RAM Memory Signals
    signal rom_adB : std_logic_vector(11 downto 0);
    signal rom_doB : std_logic_vector(07 downto 0);

    signal R :std_logic;
    signal G :std_logic;
    signal B :std_logic;


    signal old_addr : std_logic_vector(11 downto 0);
    signal old_we   : std_logic;
    signal change   : std_logic;

    signal ram_we : std_logic := '0';

    signal readed_data  : std_logic_vector(7 downto 0);
    signal ram_addr     : std_logic_vector(11 downto 0);
    signal ram_vga_mode : std_logic := '1';
    signal addr_reg     : std_logic_vector(12 downto 0);
    signal wr_data_reg  : std_logic_vector(15 downto 0);

    signal memory_write_byte : std_logic;

    type state_type is (vga_mode, memory_mode, memory_mode_write_byte);
    signal state   : state_type;

    signal mem_out   : std_logic_vector(15 downto 0);
    signal mem_out_latch : std_logic_vector(7 downto 0);
    signal vga_read  : std_logic;
    signal mem_read  : std_logic;
    signal mem_write : std_logic_vector(15 downto 0);
    signal mem_data  : std_logic_vector(15 downto 0);

    signal red   : std_logic_vector(7 downto 0);
    signal green : std_logic_vector(7 downto 0);
    signal blue  : std_logic_vector(7 downto 0);

    signal colors      : std_logic_vector(7 downto 0);
    signal count_color : std_logic_vector(4 downto 0);
    signal cursor_on   : std_logic;

    signal bitsRojo  : std_logic_vector(1 downto 0);
    signal bitsVerde : std_logic_vector(1 downto 0);
    signal bitsAzul  : std_logic_vector(1 downto 0);

    attribute keep : boolean;
    attribute keep of mem_out, vga_read, mem_read : signal is true;

begin

    --Clock divider /2. Pixel clock is 25MHz
    clk25MHz <= '0'          when reset = '1' else
                not clk25MHz when rising_edge(clk_50mhz);

    --red_out <= (others => R);
    --green_out <= (others => G);
    --blue_out <= (others => B);
    red_out   <= red when (G = '1' and cursor_on = '0') else "00000000";

    green_out <= (others => G) when (cursor_on = '1') else
                 green         when (G = '1') else
                 "00000000";

    blue_out  <= blue when (G = '1' and cursor_on = '0') else "00000000";

    csync_out <= clk25MHz;

    U_VGA: vga_80x40
    port map (
        reset     => reset,
        clk25MHz  => clk25MHz,
        R         => R,
        G         => G,
        B         => B,
        hsync     => horiz_sync_out,
        vsync     => vert_sync_out,
        TEXT_A    => ram_adB,
        TEXT_D    => ram_doB,
        FONT_A    => rom_adB,
        FONT_D    => rom_doB,
        ocrx      => crx_oreg,
        ocry      => cry_oreg,
        octl      => ctl_oreg,
        blank_sig => blank_out,
        cursor_e  => cursor_on
    );

    vgam0: font_rom
    port map (
        clk      => clk_50mhz,
        address  => rom_adB,
        data_out => rom_doB
    );

    vgam1: vga_ram
    port map (
        clk  => clk_50mhz,
        addr => ram_addr,
        data => mem_write,
        we   => ram_we,
        q    => mem_out
    );


    rd_data(7 downto 0)  <= mem_data(7 downto 0)  when (byte_m = '0' or addr_vga(0) = '0') else mem_data(15 downto 8);
    rd_data(15 downto 8) <= mem_data(15 downto 8)  when (byte_m = '0') else
                            (others => mem_out(7)) when (byte_m = '1' and addr_vga(0) = '0') else
                            (others => mem_out(15));

	--control del cursor
	--crx_oreg    <= std_logic_vector(TO_UNSIGNED(1, 8));
	--cry_oreg    <= std_logic_vector(TO_UNSIGNED(1, 8));
	ctl_oreg    <= "11110010";
	--ctl_oreg    <= '1'&vga_cursor_enable&"110010";

    process (clk_50mhz) begin
        if (clk_50mhz'event and clk_50mhz = '1') then
            if (reset = '1') then
                state <= vga_mode;
                memory_write_byte <= '0';
            else
                if (vga_cursor_enable = '1') then
                    crx_oreg <= std_logic_vector(TO_UNSIGNED(to_integer(unsigned(vga_cursor+1)) mod 80, 8));  --vga_cursor mod 80;
                    cry_oreg <= std_logic_vector(TO_UNSIGNED(to_integer(unsigned(vga_cursor)) / 80, 8));
                end if;
                case state is
                    when vga_mode=>
                        if (memory_write_byte = '1') then
                            state <= memory_mode_write_byte;
                        else
                            state <= memory_mode;
                        end if;
                    when memory_mode =>
                        state <= vga_mode;
                        if (byte_m = '1') then
                            memory_write_byte <= '1';
                        end if;
                    when memory_mode_write_byte =>
                        memory_write_byte <= '0';
                        state <= vga_mode;
                end case;
            end if;
        end if;
    end process;


    process (state) begin
        ram_addr <= "000000000000";
        ram_we <= '0';
        vga_read <= '0';
        mem_read <= '0';
        case state is
            when vga_mode=>
                ram_addr <= ram_adB;
                ram_we <= '0';
                vga_read <= '1';
                mem_read <= '0';
            when memory_mode=>
                ram_addr <= addr_vga(12 downto 1);
                if (byte_m = '1') then
                    ram_we <= '0';
                else
                    ram_we <= we;
                end if;
                vga_read <= '0';
                mem_read <= '1';
                mem_write <= wr_data_reg;
            when memory_mode_write_byte=>
                ram_addr <= addr_reg(12 downto 1);
                ram_we <= we;
                if (addr_reg(0) = '0') then
                    mem_write(7 downto 0) <= wr_data_reg(7 downto 0);
                    mem_write(15 downto 8) <= mem_data(15 downto 8);
                else
                    mem_write(7 downto 0) <= mem_data(7 downto 0);
                    mem_write(15 downto 8) <= wr_data_reg(7 downto 0);
                end if;

                vga_read <= '0';
                mem_read <= '1';
        end case;
    end process;


    process (clk_50mhz) begin
        if (clk_50mhz'event and clk_50mhz = '1') then
            if (count_color /= "00001") then
                count_color <= count_color - '1';
            else
                --DE1 (solo usa los bits del '3 downto 0')
                case bitsRojo is
                    when "00" => red <="00000000"; -- valor 0  (0%)
                    when "01" => red <="00000101"; -- valor 5  (33%)
                    when "10" => red <="00001010"; -- valor 10 (66%)
                    when "11" => red <="00001111"; -- valor 15 (100%)
                end case;
                case bitsverde is
                    when "00" => green <="00000000"; -- valor 0  (0%)
                    when "01" => green <="00000101"; -- valor 5  (33%)
                    when "10" => green <="00001010"; -- valor 10 (66%)
                    when "11" => green <="00001111"; -- valor 15 (100%)
                end case;
                case bitsAzul is
                    when "00" => blue <="00000000"; -- valor 0  (0%)
                    when "01" => blue <="00000101"; -- valor 5  (33%)
                    when "10" => blue <="00001010"; -- valor 10 (66%)
                    when "11" => blue <="00001111"; -- valor 15 (100%)
                end case;
            end if;

            if (vga_read = '0') then --we are in the mem_read state, so the last cycle the memory was accessed in vga memory
                ram_doB <= mem_out(7 downto 0);
                if (colors /= mem_out(15 downto 8)) then
                    colors   <= mem_out(15 downto 8);
                    bitsRojo <=mem_out(9 downto 8);
                    bitsVerde<=mem_out(11 downto 10);
                    bitsAzul <=mem_out(13 downto 12);
                    count_color <= "01111";
                end if;

            elsif (mem_read = '0') then
                mem_data <= mem_out;
                --The next two assigns are for keeping in a register the values of address and data to write
                --with the data out of the memory, for preventing them for changin when passing for memory mode to
                --memory_mode_write_byte. Without this, we may have some bugs in the vga ram
                addr_reg <= addr_vga;
                wr_data_reg <= wr_data;
            end if;
        end if;
    end process;

end vga_controller_behavioral;
