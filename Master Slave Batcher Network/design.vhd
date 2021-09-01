library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity MSBN is
	port (In_1,In_2,In_3,In_4,In_5,In_6,In_7,In_8:     in std_logic_vector(5 downto 0);
    
    	  Out_1,Out_2,Out_3,Out_4,Out_5,Out_6,Out_7,Out_8: out      std_logic_vector (2 downto 0));
end MSBN;

architecture sorter of MSBN is

component SO
    port(In1,In2	: in std_logic_vector (5 downto 0);
    	 Out1,Out2	: out std_logic_vector (5 downto 0);
    	 Permutation_out : out std_logic);
end component;

component SW
	port(Idx1,Idx2	: in std_logic_vector (2 downto 0);
    	 Permutation_in : in std_logic;
    	 Out_idx1,Out_idx2	: out std_logic_vector (2 downto 0));
end component;

-- Intermediary bits for permutation outputs
signal SO1_permout,SO2_permout,SO3_permout,SO4_permout,SO5_permout, SO6_permout,SO7_permout,SO8_permout,SO9_permout,SO10_permout,SO11_permout,
SO12_permout,SO13_permout,SO14_permout,SO15_permout,SO16_permout,
SO17_permout,SO18_permout,SO19_permout      :std_logic;

-- Intermediary bit vectors for sorter outputs
signal SO1out1,SO2out1,SO3out1,SO4out1,SO5out1,SO6out1,SO7out1,SO8out1,SO9out1,
SO10out1,SO11out1,SO12out1,SO13out1,SO14out1,SO15out1,SO16out1,SO17out1,
SO18out1,SO19out1,SO1out2,SO2out2,SO3out2,SO4out2,SO5out2,SO6out2,SO7out2,
SO8out2,SO9out2,SO10out2,SO11out2,SO12out2,SO13out2,SO14out2,SO15out2,
SO16out2,SO17out2,SO18out2,SO19out2	        :std_logic_vector (5 downto 0);

-- Intermediary bit vectors for switch outputs
signal SW1_out1,SW2_out1,SW3_out1,SW4_out1,SW5_out1,SW6_out1,SW7_out1,SW8_out1,SW9_out1,
       SW10_out1,SW11_out1,SW12_out1,SW13_out1,SW14_out1,SW15_out1,SW16_out1,SW17_out1,
     SW18_out1,SW19_out1,SW1_out2,SW2_out2,SW3_out2,SW4_out2,SW5_out2,SW6_out2,SW7_out2,
      SW8_out2,SW9_out2,SW10_out2,SW11_out2,SW12_out2,SW13_out2,SW14_out2,SW15_out2, SW16_out2,SW17_out2,SW18_out2,SW19_out2	:std_logic_vector (2 downto 0);

begin

-- [MASTER NETWORK] --

-- First layer of sorters taking inputs directly from the device's inputs
SO1: SO port map(In1 => In_1, In2 => In_2, Out1 =>SO1out1, Out2 => SO1out2, Permutation_out => SO1_permout);
SO2: SO port map(In1 => In_3, In2 => In_4, Out1 =>SO2out1, Out2 => SO2out2, Permutation_out => SO2_permout);
SO3: SO port map(In1 => In_5, In2 => In_6, Out1 =>SO3out1, Out2 => SO3out2, Permutation_out => SO3_permout);
SO4: SO port map(In1 => In_7, In2 => In_8, Out1 =>SO4out1, Out2 => SO4out2, Permutation_out => SO4_permout);

-- Second layer of sorters taking inputs from the first layer
SO5: SO port map(In1 => SO1out1, In2 => SO3out1, Out1 =>SO5out1, Out2 => SO5out2, Permutation_out => SO5_permout);
SO6: SO port map(In1 => SO2out1, In2 => SO4out1, Out1 =>SO6out1, Out2 => SO6out2, Permutation_out => SO6_permout);
SO7: SO port map(In1 => SO1out2, In2 => SO3out2, Out1 =>SO7out1, Out2 => SO7out2, Permutation_out => SO7_permout);
SO8: SO port map(In1 => SO2out2, In2 => SO4out2, Out1 =>SO8out1, Out2 => SO8out2, Permutation_out => SO8_permout);

-- Third layer
SO9: SO port map(In1 => SO5out1, In2 => SO6out1, Out1 =>SO9out1, Out2 => SO9out2, Permutation_out => SO9_permout);
SO10: SO port map(In1 => SO5out2, In2 => SO7out1, Out1 =>SO10out1, Out2 => SO10out2, Permutation_out => SO10_permout);
SO11: SO port map(In1 => SO6out2, In2 => SO8out1, Out1 =>SO11out1, Out2 => SO11out2, Permutation_out => SO11_permout);
SO12: SO port map(In1 => SO7out2, In2 => SO8out2, Out1 =>SO12out1, Out2 => SO12out2, Permutation_out => SO12_permout);

-- Fourth layer
SO13: SO port map(In1 => SO10out1, In2 => SO11out1, Out1 =>SO13out1, Out2 => SO13out2, Permutation_out => SO13_permout);
SO14: SO port map(In1 => SO10out2, In2 => SO11out2, Out1 =>SO14out1, Out2 => SO14out2, Permutation_out => SO14_permout);

-- Fifth layer
SO15: SO port map(In1 => SO9out2, In2 => SO14out1, Out1 =>SO15out1, Out2 => SO15out2, Permutation_out => SO15_permout);
SO16: SO port map(In1 => SO13out2, In2 => SO12out1, Out1 =>SO16out1, Out2 => SO16out2, Permutation_out => SO16_permout);

-- Last layer
SO17: SO port map(In1 => SO15out1, In2 => SO13out1, Out1 =>SO17out1, Out2 => SO17out2, Permutation_out => SO17_permout);
SO18: SO port map(In1 => SO16out1, In2 => SO15out2, Out1 =>SO18out1, Out2 => SO18out2, Permutation_out => SO18_permout);
SO19: SO port map(In1 => SO14out2, In2 => SO16out2, Out1 =>SO19out1, Out2 => SO19out2, Permutation_out => SO19_permout);

-- [SLAVE NETWORK] --
-- Has the same structure with the master network, only connected in reverse

-- Last layer
SW19: SW port map(Idx1 => "101", Idx2 => "110", Permutation_in => SO19_permout, Out_idx1 => SW19_out1, Out_idx2 => SW19_out2);

SW18: SW port map(Idx1 => "011", Idx2 => "100", Permutation_in => SO18_permout, Out_idx1 => SW18_out1, Out_idx2 => SW18_out2);

SW17: SW port map(Idx1 => "001", Idx2 => "010", Permutation_in => SO17_permout, Out_idx1 => SW17_out1, Out_idx2 => SW17_out2);

-- Fifth layer
SW16: SW port map(Idx1 => SW18_out1, Idx2 => SW19_out2, Permutation_in => SO16_permout, Out_idx1 => SW16_out1, Out_idx2 => SW16_out2);

SW15: SW port map(Idx1 => SW17_out1, Idx2 => SW18_out2, Permutation_in => SO15_permout, Out_idx1 => SW15_out1, Out_idx2 => SW15_out2);

-- Fourth layer 
SW14: SW port map(Idx1 => SW15_out2, Idx2 => SW19_out1, Permutation_in => SO14_permout, Out_idx1 => SW14_out1, Out_idx2 => SW14_out2);

SW13: SW port map(Idx1 => SW17_out2, Idx2 => SW16_out1, Permutation_in => SO13_permout, Out_idx1 => SW13_out1, Out_idx2 => SW13_out2);

-- Third layer
SW12: SW port map(Idx1 => SW16_out2, Idx2 => "111", Permutation_in => SO12_permout, Out_idx1 => SW12_out1, Out_idx2 => SW12_out2);

SW11: SW port map(Idx1 => SW13_out2, Idx2 => SW14_out2, Permutation_in => SO11_permout, Out_idx1 => SW11_out1, Out_idx2 => SW11_out2);

SW10: SW port map(Idx1 => SW13_out1, Idx2 => SW14_out1, Permutation_in => SO10_permout, Out_idx1 => SW10_out1, Out_idx2 => SW10_out2);

SW9: SW port map(Idx1 => "000", Idx2 => SW15_out1, Permutation_in => SO9_permout, Out_idx1 => SW9_out1, Out_idx2 => SW9_out2);

-- Second layer
SW8: SW port map(Idx1 => SW11_out2, Idx2 => SW12_out2, Permutation_in => SO8_permout, Out_idx1 => SW8_out1, Out_idx2 => SW8_out2);

SW7: SW port map(Idx1 => SW10_out2, Idx2 => SW12_out1, Permutation_in => SO7_permout, Out_idx1 => SW7_out1, Out_idx2 => SW7_out2);

SW6: SW port map(Idx1 => SW9_out2, Idx2 => SW11_out1, Permutation_in => SO6_permout, Out_idx1 => SW6_out1, Out_idx2 => SW6_out2);

SW5: SW port map(Idx1 => SW9_out1, Idx2 => SW10_out1, Permutation_in => SO5_permout, Out_idx1 => SW5_out1, Out_idx2 => SW5_out2);

-- First layer (output layer)
SW4: SW port map(Idx1 => SW6_out2, Idx2 => SW8_out2, Permutation_in => SO4_permout, Out_idx1 => SW4_out1, Out_idx2 => SW4_out2);

SW3: SW port map(Idx1 => SW5_out2, Idx2 => SW7_out2, Permutation_in => SO3_permout, Out_idx1 => SW3_out1, Out_idx2 => SW3_out2);

SW2: SW port map(Idx1 => SW6_out1, Idx2 => SW8_out1, Permutation_in => SO2_permout, Out_idx1 => SW2_out1, Out_idx2 => SW2_out2);

SW1: SW port map(Idx1 => SW5_out1, Idx2 => SW7_out1, Permutation_in => SO1_permout, Out_idx1 => SW1_out1, Out_idx2 => SW1_out2);

-- Final outputs:
Out_1 <= SW1_out1;
Out_2 <= SW1_out2;
Out_3 <= SW2_out1;
Out_4 <= SW2_out2;
Out_5 <= SW3_out1;
Out_6 <= SW3_out2;
Out_7 <= SW4_out1;
Out_8 <= SW4_out2;

end sorter;
