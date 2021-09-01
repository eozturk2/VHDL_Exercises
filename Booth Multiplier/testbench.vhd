-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
end testbench;

architecture tb of testbench is

component Booth_Mult is
port(
	 In_1,In_2	: in std_logic_vector(7 downto 0);
     clk		: in std_logic;
     ready		: in std_logic;
     done		: out std_logic;
     S			: out std_logic_vector(15 downto 0));
     
end component;

signal In_1,In_2	: std_logic_vector(7 downto 0);
signal clk 			: std_logic := '0';
signal ready		: std_logic := '1';
signal done			: std_logic;
signal S			: std_logic_vector(15 downto 0);

begin
	DUT: Booth_Mult port map(In_1, In_2, clk, ready, done, S);
    clk_process: process
	 	begin
     	clk <= '0';
     	wait for 0.5 ns;  --for 0.5 ns signal is '0'.
     	clk <= '1';
    	wait for 0.5 ns;  --for next 0.5 ns signal is '1'.
	end process;
    
    main_process: process
    	begin
    	In_1 <= "00000011"; -- 3
    	In_2 <= "11111001"; -- -7
        
        wait for 4.15 ns;
        ready <= '0';
    end process;

end tb;
