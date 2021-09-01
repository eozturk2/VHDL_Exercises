-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FP_Adder is
	Port(A,B	: in std_logic_vector(31 downto 0);
    	 S		: out std_logic_vector(31 downto 0));
end FP_Adder;

architecture add of FP_Adder is

signal exponent_a,exponent_b	: std_logic_vector(7 downto 0);
signal mantissa_a,mantissa_b	: std_logic_vector(22 downto 0);

signal new_mantissa_a			: std_logic_vector(63 downto 0);
signal new_mantissa_b			: std_logic_vector(63 downto 0);

signal a_larger,b_larger		: std_logic;

signal S1						: std_logic_vector(31 downto 0);

-- Test Signals

signal test_mantissa_b					: std_logic_vector(63 downto 0);
signal test_raw_result					: std_logic_vector(66 downto 0);
signal temp_exponent_test				: std_logic_vector(8 downto 0);
signal temp_mantissa_test				: std_logic_vector(66 downto 0);
signal hidden_bit_overflow_test			: std_logic;
signal hidden_bit_test					: std_logic;
signal final_exponent_test				: std_logic_vector(7 downto 0);
signal final_mantissa_test				: std_logic_vector(22 downto 0);
signal inf_rollover						: std_logic;
signal final_sign_test					: std_logic;
signal comp								: std_logic;
signal comp2							: std_logic;
signal last_array						: std_logic_vector(5 downto 0);
signal dummy_vector_2_test				: std_logic_vector(5 downto 0);
signal final_result_test				: std_logic_vector(31 downto 0);
signal a_pos_b_neg						: std_logic;
signal both_pos							: std_logic;
signal both_neg							: std_logic;
signal a_neg_b_pos						: std_logic;


begin

process(A,B,S,S1)

variable test_mantissa_a			: std_logic_vector(63 downto 0);

variable sign_bit_a,sign_bit_b		: std_logic;

variable shifted_mantissa_a			: std_logic_vector(63 downto 0);
variable shifted_mantissa_b			: std_logic_vector(63 downto 0);
variable raw_result					: std_logic_vector(66 downto 0);

variable signed_add_mantissa_a		: std_logic_vector(66 downto 0);
variable signed_add_mantissa_b		: std_logic_vector(66 downto 0);

variable temp_exponent				: std_logic_vector(8 downto 0);
variable temp_mantissa				: std_logic_vector(66 downto 0);
variable hidden_bit_overflow		: std_logic;
variable hidden_bit					: std_logic;

variable final_exponent				: std_logic_vector(7 downto 0);
variable final_mantissa				: std_logic_vector(22 downto 0);
variable final_sign					: std_logic;
variable raw_result_shifted			: std_logic_vector(66 downto 0);

variable dummy_vector				: std_logic_vector(5 downto 0);
variable dummy_vector_2				: std_logic_vector(5 downto 0);

variable final_result				: std_logic_vector(31 downto 0);
variable difference					: unsigned(7 downto 0);

variable special_case_flag			: std_logic;
variable special_case_result		: std_logic_vector(31 downto 0);

variable a_is_ninf					: std_logic := '0';
variable a_is_pinf					: std_logic := '0';
variable a_is_nan					: std_logic := '0';

variable b_is_ninf					: std_logic := '0';
variable b_is_pinf					: std_logic := '0';
variable b_is_nan					: std_logic := '0';


begin
	-- Before anything, check for special cases. If one is found, a flag is
    -- set and rest of the operations will be ignored at the end.
    
    if (A(30 downto 23) = "11111111") then
    	if (A(31) = '0' and (unsigned(A(22 downto 0)) = 0)) then
    		a_is_pinf := '1';
            
    	elsif (A(31) = '1' and (unsigned(A(22 downto 0)) = 0)) then
    		a_is_ninf := '1';
            
    	elsif unsigned(A(22 downto 0)) /= 0 then
    		a_is_nan := '1';
        end if;
    end if;
    
    if (B(30 downto 23) = "11111111") then
    	if (B(31) = '0' and (unsigned(B(22 downto 0)) = 0)) then
    		b_is_pinf := '1';
            
    	elsif (B(31) = '1' and (unsigned(B(22 downto 0)) = 0)) then
    		b_is_ninf := '1';
            
    	elsif unsigned(B(22 downto 0)) /= 0 then
    		b_is_nan := '1';
        end if;
    end if;
    
    if (a_is_pinf and b_is_ninf) or (a_is_ninf and b_is_pinf) then
    	special_case_flag := '1';
        special_case_result := "01111111100000000000000000000001";
    end if;
    
    if a_is_ninf and b_is_ninf then
    	special_case_flag := '1';
        special_case_result := "11111111100000000000000000000000";
    end if;
        
    if a_is_pinf and b_is_pinf then
    	special_case_flag := '1';
        special_case_result := "01111111100000000000000000000000";
    end if;
    
    if a_is_pinf and not (b_is_pinf or b_is_ninf or b_is_nan) then
    	special_case_flag := '1';
        special_case_result := "01111111100000000000000000000000";
    end if;
        
    if a_is_ninf and not (b_is_pinf or b_is_ninf or b_is_nan) then
    	special_case_flag := '1';
        special_case_result := "11111111100000000000000000000000";
    end if;
    
    if b_is_pinf and not (a_is_pinf or a_is_ninf or a_is_nan) then
    	special_case_flag := '1';
        special_case_result := "01111111100000000000000000000000";
    end if;
        
    if b_is_ninf and not (a_is_pinf or a_is_ninf or a_is_nan) then
    	special_case_flag := '1';
        special_case_result := "11111111100000000000000000000000";
    end if;
    
    
	-- Using A and B, load intermediate signals with their intended values.
    -- A(30 downto 23) is the exponent for A. Likewise for B
    
    if A(30 downto 23) > B(30 downto 23) then
        difference := unsigned(A(30 downto 23)) - unsigned(B(30 downto 23));
        a_larger <= '1';
        b_larger <= '0';
        
        
    elsif B(30 downto 23) > A(30 downto 23) then
        difference := unsigned(B(30 downto 23)) - unsigned(A(30 downto 23));
        a_larger <= '0';
        b_larger <= '1';
        
    else
    	difference := "00000000";
    end if;
    
    -- Populating the new mantissas that will be the one shifted,
    -- while taking care of the implicit 0/1
    
    if unsigned(A(30 downto 23)) = 0 then
    	new_mantissa_a(63) <= '0';
    else
    	new_mantissa_a(63) <= '1';
    end if;
    
    new_mantissa_a(62 downto 40) <= A(22 downto 0);
    new_mantissa_a(39 downto 0) <= "0000000000000000000000000000000000000000";
    
    -- Same for B
    
    if unsigned(B(30 downto 23)) = 0 then
    	new_mantissa_b(63) <= '0';
    else
    	new_mantissa_b(63) <= '1';
    end if;
    
    new_mantissa_b(62 downto 40) <= B(22 downto 0);
    new_mantissa_b(39 downto 0) <= "0000000000000000000000000000000000000000";
    
    
    sign_bit_a := A(31);
    sign_bit_b := B(31);

	exponent_a <= A(30 downto 23);
	exponent_b <= B(30 downto 23);

	mantissa_a <= A(22 downto 0);
	mantissa_b <= B(22 downto 0);
    
    shifted_mantissa_b := new_mantissa_b;
    shifted_mantissa_a := new_mantissa_a;
    -- test_mantissa_a <= shifted_mantissa_a;
    -- test_mantissa_b <= shifted_mantissa_b;
    
-- Alignment of Radix Points:

    if a_larger then
    	shifted_mantissa_b := std_logic_vector(shift_right(unsigned(new_mantissa_b), to_integer(difference)));
        
        shifted_mantissa_a := new_mantissa_a;
        exponent_b <= A(30 downto 23);
       
    elsif b_larger then
    	shifted_mantissa_a := std_logic_vector(shift_right(unsigned(new_mantissa_a), to_integer(difference)));
        
        shifted_mantissa_b := new_mantissa_b;
        
        exponent_a <= B(30 downto 23);
      
    end if;
    
    --test_mantissa_a := shifted_mantissa_a;
    --test_mantissa_b <= shifted_mantissa_b;
    
    -- Addition of Mantissas:
    
    -- signed_add_mantissa and raw_result signals have extra 3 bits.
    -- 66 represents the sign, 65 acts as an overflow flag,
    -- 0 is there to capture the last mantissa bit in case it needs to
    -- be shifted.
    
    signed_add_mantissa_a(66) := '0';
    signed_add_mantissa_a(65) := '0';
    signed_add_mantissa_a(64 downto 1) := shifted_mantissa_a;
    signed_add_mantissa_a(0) := '0';
    
    signed_add_mantissa_a(66) := '0';
    signed_add_mantissa_b(65) := '0';
    signed_add_mantissa_b(64 downto 1) := shifted_mantissa_b;
    signed_add_mantissa_b(0) := '0';
     
    -- Unsigned floating point addition. Considering the signs and adding/subtracting mantissas,
    -- and then setting the raw_result(66) sign bit accordingly.
    
    if (sign_bit_a = '0' and sign_bit_b = '0') then
    	--both_pos <= '1';
        
    	raw_result(66) := '0';
    	raw_result(65 downto 0) := std_logic_vector(unsigned(signed_add_mantissa_a(65 downto 0)) + unsigned(signed_add_mantissa_b(65 downto 0)));
        
    elsif (sign_bit_a = '1' and sign_bit_b = '1') then
    	--both_neg <= '1';
        
    	raw_result(66) := '1';
        raw_result(65 downto 0) := std_logic_vector(unsigned(signed_add_mantissa_a(65 downto 0)) + unsigned(signed_add_mantissa_b(65 downto 0)));
        
    elsif (sign_bit_a = '0' and sign_bit_b = '1') then
    	--a_pos_b_neg <= '1';
        
    	raw_result(65 downto 0) := std_logic_vector(unsigned(signed_add_mantissa_a(65 downto 0)) - unsigned(signed_add_mantissa_b(65 downto 0)));
        
        if (shifted_mantissa_a >= shifted_mantissa_b) then
        	raw_result(66) := '0';
        else
        	raw_result(66) := '1';
        end if;
        
    elsif (sign_bit_a = '1' and sign_bit_b = '0') then
    	-- a_neg_b_pos <= '1';
        
    	raw_result(65 downto 0) := std_logic_vector(unsigned(signed_add_mantissa_a(65 downto 0)) - unsigned(signed_add_mantissa_b(65 downto 0)));
        
        if (shifted_mantissa_a >= shifted_mantissa_b) then
        	raw_result(66) := '1';
        else
        	raw_result(66) := '0';
        end if;
        
    end if;
        
        
    
    -- (Unit test)
    -- dummy_vector := "010000";
    -- test_raw_result <= raw_result;
    
    -- Normalization:
    
    --temp_exponent has an extra bit that acts as an overflow flag, in
    --case the sum rolls over to infinity.
    
    temp_exponent(8) := '0';
    temp_exponent(7 downto 0) := exponent_a;
    -- temp_exponent_test <= temp_exponent;
    
    final_sign := raw_result(66);
    final_sign_test <= final_sign;
    
    hidden_bit_overflow := raw_result(65);
    
    --(Unit test)
    --raw_result(65) := '1';
    --raw_result(0) := '1';
    -- hidden_bit_overflow_test <= hidden_bit_overflow;
    
    -- "If the sum of mantissas overflows the position of the hidden bit, then the
    --  mantissa must be shifted one bit to the right and the exponent incremented
    --  by 1."
    
    if hidden_bit_overflow = '1' then
    	raw_result := std_logic_vector(shift_right(unsigned(raw_result), 1));
        temp_exponent := std_logic_vector(unsigned(temp_exponent) + 1);
        temp_exponent_test <= temp_exponent;
        
    end if;
    
    temp_mantissa(66 downto 2) := raw_result(64 downto 0);
    temp_mantissa(1 downto 0) := "00";
    
    
    -- (Unit test)
    -- test_raw_result <= raw_result;
    -- dummy_vector_2_test <= dummy_vector;
    -- temp_mantissa(66) := '0';
    -- temp_mantissa(65) := '0';
    -- temp_mantissa(0) := '1';
    
    hidden_bit := temp_mantissa(66);
    
    -- temp_exponent(8 downto 0) := "000000000";
    
    
    --"If the hidden bit is zero in the sum and 1 ≤ E ≤ 254, then the 
    -- mantissa must be shifted to the left and the exponent decremented
    -- until the hidden bit becomes 1. Note that if the hidden bit is
    -- zero in the sum and E = 0, then the sum is already normalized."
    
    while hidden_bit = '0' and unsigned(temp_exponent) /= 0 loop
--    	comp2 <= '1';
    	temp_mantissa := std_logic_vector(shift_left(unsigned(temp_mantissa), 1));
        temp_exponent := std_logic_vector(unsigned(temp_exponent) - 1);
        hidden_bit := temp_mantissa(66);
    end loop;
    
--    (Unit test)
--    temp_mantissa_test <= temp_mantissa;
--    temp_exponent_test <= temp_exponent;
--    hidden_bit_test <= hidden_bit;
--    last_array <= temp_mantissa(66 downto 61);

-- "If the sum is larger than the positive
-- representable range of the IEEE single-precision standard, the result
-- must be set to the representation for infinity (i.e., E = 255, M = 0 
-- and S = 0). Similarly, if the sum is smaller than the negative
-- representable range of the IEEE single-precision standard, the result
-- must be set to the representation for -infinity (i.e., E = 255,
-- M = 0 and S = 1)."
    
    if temp_exponent(8) = '1' or temp_exponent(7 downto 0) = "11111111" then
    	-- inf_rollover <= '1';
    	final_exponent := "11111111";
        final_mantissa := "00000000000000000000000";
    else
    	final_exponent := temp_exponent(7 downto 0);
        final_mantissa := temp_mantissa(65 downto 43);
    end if;
    
    final_result(31) := final_sign;
    final_result(30 downto 23) := final_exponent;
    final_result(22 downto 0) := final_mantissa;
    
--    final_result_test <= final_result;
       
    if special_case_flag then
    	S1 <= special_case_result;
    else
    	S1 <= final_result;
    end if;
    
    S <= S1;

end process;
end add;
