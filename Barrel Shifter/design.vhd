-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity MUX is
	port(
    	A: in std_logic;
        B: in std_logic;
        S: in std_logic;
        F: out std_logic);
end MUX;

architecture struct of MUX is
begin
	-- If S is 1, output B. If S is 0, output A.
    -- => (S.B) + (!S.A)
	F <= ((NOT S) AND A) OR (S AND B);
end struct;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity barrel_shifter_structural is
	Port(X	: in std_logic_vector (3 downto 0);
    	 sel: in std_logic_vector (1 downto 0);
         Y	: out std_logic_vector (3 downto 0));
         
end barrel_shifter_structural;

architecture structural of barrel_shifter_structural is

signal mux1_out, mux2_out, mux3_out, mux4_out :std_logic;

component MUX
	port(A,B,S: in std_logic; F: out std_logic);
end component;

begin
MUX1: MUX port map (A => X(0), B => X(2), S => sel(1), F => mux1_out);
MUX2: MUX port map (A => X(1), B => X(3), S => sel(1), F => mux2_out);
MUX3: MUX port map (A => X(2), B => X(0), S => sel(1), F => mux3_out);
MUX4: MUX port map (A => X(3), B => X(1), S => sel(1), F => mux4_out);

MUX5: MUX port map (A => mux1_out, B => mux4_out, S => sel(0), F => Y(0));
MUX6: MUX port map (A => mux2_out, B => mux1_out, S => sel(0), F => Y(1));
MUX7: MUX port map (A => mux3_out, B => mux2_out, S => sel(0), F => Y(2));
MUX8: MUX port map (A => mux4_out, B => mux3_out, S => sel(0), F => Y(3));
end structural;

-- Behavioral
--library IEEE;
--use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;

--entity barrel_shifter_behavioral is
--	Port(X	: in std_logic_vector (3 downto 0);
--    	 sel: in std_logic_vector (1 downto 0);
--         Y	: out std_logic_vector (3 downto 0));
         
--end barrel_shifter_behavioral;

--architecture behavioral of barrel_shifter_behavioral is

--begin
--with sel select Y <=
--	 X(3) & X(2) & X(1) & X(0)  when "00",
--     X(2) & X(1) & X(0) & X(3)  when "01",
--     X(1) & X(0) & X(3) & X(2)  when "10",
--     X(0) & X(3) & X(2) & X(1)  when "11",
--     "0000" when others; --Should be unreachable, but compiler complains
--end behavioral;
