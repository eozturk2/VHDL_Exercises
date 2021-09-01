-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity MUX_structural is
	port(
    	A: in std_logic;
        B: in std_logic;
        S: in std_logic;
        Y: out std_logic);
end MUX_structural;

architecture structural of MUX_structural is
begin
	-- If S is 1, output B. If S is 0, output A.
    -- => (S.B) + (!S.A)
	Y <= ((NOT S) AND A) OR (S AND B);
end structural;

--library IEEE;
--use IEEE.std_logic_1164.all;
--use IEEE.NUMERIC_STD.all;

--entity MUX_behavioral is
--	port(
--    	A: in std_logic;
--      B: in std_logic;
--      S: in std_logic;
--      Y: out std_logic);
--end MUX_behavioral;

--architecture behavioral of MUX_behavioral is

-- If S is 1, output B. If S is 0, output A.
--begin
--	with S select
--    Y <= B when '1',
--    A when others;
--end behavioral;
