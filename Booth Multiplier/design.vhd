-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Booth_Mult is
	port(In_1, In_2		: in std_logic_vector(7 downto 0);
    	 clk			: in std_logic;
         ready			: in std_logic;
         done			: out std_logic;
         S				: out std_logic_vector(15 downto 0));
end Booth_Mult;

architecture multiplier of Booth_Mult is

signal M		: std_logic_vector(7 downto 0);
signal Q		: std_logic_vector(8 downto 0);
signal A		: std_logic_vector(7 downto 0);
signal ANQ_TEST : std_logic_vector(16 downto 0);
signal cycles	: integer := 0;

begin

process(clk, ready)

variable A_AND_Q 	: std_logic_vector(16 downto 0);
variable something_loaded 	: std_logic := '0';

begin
    
    if ready = '1' then
        -- cycles <= 0;
    
    	if rising_edge(clk) then
        	done <= '0';
        	something_loaded := '1';
        	M <= In_1;
            Q(8 downto 1) <= In_2;
            Q(0) <= '0';
            A <= "00000000";
           	-- S <= A & Q(8 downto 1);
            A_AND_Q := (A & Q);
            --ANQ_TEST <= A_AND_Q;
        end if;
        
     elsif (ready = '0' and something_loaded = '1') then
     
     	if rising_edge(clk) then
     
     		if (A_AND_Q(1 downto 0) = "00" or A_AND_Q(1 downto 0) = "11") then
                -- A & Q <= shift A & Q one place to the right, arithmetically
                ANQ_TEST <= A_AND_Q;
                
                        
            elsif A_AND_Q(1 downto 0) = "01" then
                 -- A & Q <= shift (A+M) & Q one place to the right, arithmetically
                 A_AND_Q(16 downto 9) := std_logic_vector(signed(A_AND_Q(16 downto 9)) + signed(M));
                 ANQ_TEST <= A_AND_Q;
                 
                        
            elsif A_AND_Q(1 downto 0) = "10" then
                 -- A & Q <= shift (A-M) & Q one place to the right, arithmetically
                 -- A = A_AND_Q's first 8 (N) bits
                 -- Q = A_AND_Q's last 9 (N+1) bits
                 A_AND_Q(16 downto 9) := std_logic_vector(signed(A_AND_Q(16 downto 9)) - signed(M));
                 
                 ANQ_TEST <= A_AND_Q;
                 
                 
            end if;
            
            A_AND_Q := std_logic_vector(shift_right(signed(A_AND_Q), 1));
            
            if something_loaded = '1' then
            	cycles <= cycles + 1;
            end if;
            
            if cycles = 7 then
            	done <= '1';
                something_loaded := '0';
                S <= A_AND_Q(16 downto 1);
            end if;
       end if;
    end if;
        
    
end process;         
end multiplier;
