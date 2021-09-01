-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end testbench;

architecture tb of testbench is

-- Since the MUX isn't supposed to change, we can just
-- replace MUX_structural/MUX_behavioral and use
-- the same testbench

component MUX_structural is
port(
	A: in std_logic;
    B: in std_logic;
    S: in std_logic;
    Y: out std_logic);
end component;

signal A_in, B_in, S_in, Y_out: std_logic;

begin
	DUT: MUX_structural port map (A_in, B_in, S_in, Y_out);
    process
    --MUX truth table:
    -- S  A  B => Y
    -- 0  0  0 => 0
    -- 0  0  1 => 0
    -- 0  1  0 => 1
    -- 0  1  1 => 1
    -- 1  0  0 => 0
    -- 1  0  1 => 1
    -- 1  1  0 => 0
    -- 1  1  1 => 1
    
    -- Same table below:
    begin
    	S_in <= '0';
        A_in <= '0';
        B_in <= '0';
        -- Expected output: 0
        wait for 1 ns;
        
        S_in <= '0';
        A_in <= '0';
        B_in <= '1';
        -- Expected output: 0
        wait for 1 ns;
        
        S_in <= '0';
        A_in <= '1';
        B_in <= '0';
        -- Expected output: 1
        wait for 1 ns;
        
        S_in <= '0';
        A_in <= '1';
        B_in <= '1';
        -- Expected output: 1
        wait for 1 ns;
        
        S_in <= '1';
        A_in <= '0';
        B_in <= '0';
        -- Expected output: 0
        wait for 1 ns;
        
        S_in <= '1';
        A_in <= '0';
        B_in <= '1';
        -- Expected output: 1
        wait for 1 ns;
        
        S_in <= '1';
        A_in <= '1';
        B_in <= '0';
        -- Expected output: 0
        wait for 1 ns;
        
        S_in <= '1';
        A_in <= '1';
        B_in <= '1';
        -- Expected output: 1
        wait for 1 ns;
        
        --Clearing signals
        S_in <= '0';
        A_in <= '0';
        B_in <= '0';
        wait for 1 ns;
        
        wait;
    end process;
end tb;
