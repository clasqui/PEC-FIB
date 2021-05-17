library ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity multiplicador is
    port(
		x    		 : IN std_logic_vector(15 DOWNTO 0);
		y    		 : IN std_logic_vector(15 DOWNTO 0);
		baix 		 : OUT std_logic_vector(15 DOWNTO 0);
		alt_unsig : OUT std_logic_vector(15 DOWNTO 0);
		alt_sig	 : OUT std_logic_vector(15 DOWNTO 0)
	 );
end entity;


architecture Structure of multiplicador is

signal result_sig : std_logic_vector(31 DOWNTO 0);
signal result_unsig : std_logic_vector(31 DOWNTO 0);

begin
	
	result_sig <= std_logic_vector(signed(x)*signed(y));
	result_unsig <= std_logic_vector(unsigned(x)*unsigned(y));
	
	baix <= result_sig(15 DOWNTO 0);
	alt_sig <= result_sig(31 DOWNTO 16);
	alt_unsig <= result_unsig(31 DOWNTO 16);
	
end Structure;