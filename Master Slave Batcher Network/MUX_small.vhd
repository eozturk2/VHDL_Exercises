library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity MUX_small is
	port(
    	A: in std_logic_vector(2 downto 0);
        B: in std_logic_vector(2 downto 0);
        S: in std_logic;
        Y: out std_logic_vector(2 downto 0));
end MUX_small;

architecture behavioral of MUX_small is
begin
	with S select
   		Y <= B when '1',
        A when others;
end behavioral;
