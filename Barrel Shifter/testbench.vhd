-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end testbench;

architecture tb of testbench is

component barrel_shifter_structural is
port(
	X: in std_logic_vector (3 downto 0);
    sel: in std_logic_vector (1 downto 0);
    Y: out std_logic_vector (3 downto 0));
end component;

signal X_in: std_logic_vector (3 downto 0);
signal sel_in: std_logic_vector (1 downto 0);
signal Y_out: std_logic_vector (3 downto 0);

begin
	DUT: barrel_shifter_structural port map (X_in, sel_in, Y_out);
    process
    --4 bit barrel shifter truth table:
    -- Input	sel		Expected Output
    -- 0001     00      0001 (1 for behavioral)
    -- 0001     01      0010 (2 for behavioral)
    -- 0001     10      0100 (4 for behavioral)
    -- 0001		11		1000 (8 for behavioral)
    
    -- Same table below:
    begin
    	X_in <= "0001";
        sel_in <= "00";
        -- Expected output: 0001
        wait for 4 ns;
        
        X_in <= "0001";
        sel_in <= "01";
        -- Expected output: 0010
        wait for 4 ns;
        
        X_in <= "0001";
        sel_in <= "10";
        -- Expected output: 0100
        wait for 4 ns;
        
        X_in <= "0110";
        sel_in <= "11";
        -- Expected output: 1000
        wait for 4 ns;
        
        X_in <= "0001";
        sel_in <= "00";
        -- Expected output: 0001
        wait for 4 ns;
        
        
        wait;
    end process;
end tb;
