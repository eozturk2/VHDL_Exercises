-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

-- Sort In1 and In2 in ascending order.
-- If In1 > In2, Out1 = In1 and Out2 = In2
-- Elsif In2 > In1, Out1 = In2 and Out2 = In1

entity SO is
	port(In1,In2	: in std_logic_vector (5 downto 0);
    	 Out1,Out2	: out std_logic_vector (5 downto 0);
    	 Permutation_out : out std_logic);
end SO;

architecture sort of SO is

signal comparator_out :std_logic;

component MUX
	port(A,B  : in std_logic_vector(5 downto 0);
    	 S	  : in std_logic;
    	 Y	  : out std_logic_vector(5 downto 0));
end component;

component comparator
	port(A,B : in std_logic_vector(5 downto 0);
         F   : out std_logic);
end component;

begin
COMP: comparator port map(A => In1, B => In2, F => comparator_out);
MUX1: MUX port map (A => In1, B => In2, S => comparator_out, Y => Out1);
MUX2: MUX port map (A => In2, B => In1, S => comparator_out, Y => Out2);
Permutation_out <= comparator_out;

end sort;
