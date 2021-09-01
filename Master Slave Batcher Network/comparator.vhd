library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity comparator is
	port (A, B		: in std_logic_vector(5 downto 0);
          F         : out std_logic);
end comparator;

architecture boolean of comparator is

signal abig	: std_logic_vector(5 downto 0);
signal eq   : std_logic_vector(5 downto 0);

begin

-- Dummy logic vector to check A > B in every digit
abig(0) <= A(0) AND (NOT B(0));
abig(1) <= A(1) AND (NOT B(1));
abig(2) <= A(2) AND (NOT B(2));
abig(3) <= A(3) AND (NOT B(3));
abig(4) <= A(4) AND (NOT B(4));
abig(5) <= A(5) AND (NOT B(5));

-- Dummy logic vector to check digitwise equality
eq(0) <= A(0) XNOR B(0);
eq(1) <= A(1) XNOR B(1);
eq(2) <= A(2) XNOR B(2);
eq(3) <= A(3) XNOR B(3);
eq(4) <= A(4) XNOR B(4);
eq(5) <= A(5) XNOR B(5);

-- Starting from MSB, check every digit for equality or if
-- A > B when every more significant digit is equal

F <= abig(5) OR (eq(5) AND abig(4))
             OR (eq(5) AND eq(4) AND abig(3))       
             OR (eq(5) AND eq(4) AND eq(3) AND abig(2)) 
             OR (eq(5) AND eq(4) AND eq(3) AND eq(3) AND abig(2)) 
             OR (eq(5) AND eq(4) AND eq(3) AND eq(3) AND eq(2) AND abig(1))
             OR (eq(5) AND eq(4) AND eq(3) AND eq(3) AND eq(2) AND eq(1) AND abig(0));


end boolean;
