LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END alu;


ARCHITECTURE Structure OF alu IS
BEGIN
	with op select w <=
		y when "00",											-- MOVI
		y(7 DOWNTO 0) & x(7 DOWNTO 0) when "01",		-- MOVHI
		std_logic_vector(unsigned(y)+unsigned(x)) when "10",	-- ADD
		(others=>'0') when others;	

END Structure;