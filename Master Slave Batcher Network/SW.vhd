library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

-- As described by the lab manual:

entity SW is
	port(Idx1,Idx2	: in std_logic_vector (2 downto 0);
    	 Permutation_in : in std_logic;
    	 Out_idx1,Out_idx2	: out std_logic_vector (2 downto 0));
    	 
end SW;

architecture switch of SW is

component MUX_small
	port(A    : in std_logic_vector(2 downto 0);
    	 B	  : in std_logic_vector(2 downto 0);
    	 S	  : in std_logic;
    	 Y	  : out std_logic_vector(2 downto 0));
end component;

begin

MUX1: MUX_small port map (A => Idx1, B => Idx2, S => Permutation_in, Y => Out_idx1);

MUX2: MUX_small port map (A => Idx2, B => Idx1, S => Permutation_in, Y => Out_idx2);

end switch;
