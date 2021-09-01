-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end testbench;

architecture tb of testbench is

component MSBN is
port(
	In_1,In_2,In_3,In_4,In_5,In_6,In_7,In_8:in std_logic_vector(5 downto 0);
    
    Out_1,Out_2,Out_3,Out_4,Out_5,Out_6,Out_7,Out_8: out std_logic_vector (2 downto 0));
end component;

signal In_1,In_2,In_3,In_4,In_5,In_6,In_7,In_8 :std_logic_vector(5 downto 0);

signal Out_1,Out_2,Out_3,Out_4,Out_5,Out_6,Out_7,Out_8		:std_logic_vector(2 downto 0);

    
begin
	DUT: MSBN port map (In_1, In_2, In_3, In_4, In_5, In_6, In_7, In_8,
    Out_1, Out_2, Out_3, Out_4, Out_5, Out_6, Out_7, Out_8);
    process
    
    begin
    	In_1 <= "011101"; -- 25
        In_2 <= "001001"; -- 1
        In_3 <= "100100"; -- 32
        In_4 <= "010011"; -- 27
        In_5 <= "111010"; -- 60
        In_6 <= "001010"; -- 12
        In_7 <= "110110"; -- 54
        In_8 <= "110001"; -- 48
        -- Expected output: 2, 0, 4, 3, 7, 1, 6, 5
        wait for 3 ns;
        wait;
     
    end process;
end tb;
