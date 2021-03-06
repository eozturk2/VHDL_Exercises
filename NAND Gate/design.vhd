-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity my_NAND_gate is
port(
	a: in std_logic;
    b: in std_logic;
    q: out std_logic);
end my_NAND_gate;

architecture RTL of my_NAND_gate is
begin
	q <= NOT(a AND b);
end RTL;
