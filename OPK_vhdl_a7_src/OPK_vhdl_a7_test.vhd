--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:53:55 06/23/2022
-- Design Name:   
-- Module Name:   D:/xilinx_prj/OPK_vhdl_a7/OPK_vhdl_a7_test.vhd
-- Project Name:  OPK_vhdl_a7
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: OPK_vhdl_a7_system
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY OPK_vhdl_a7_test IS
END OPK_vhdl_a7_test;
 
ARCHITECTURE behavior OF OPK_vhdl_a7_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT OPK_vhdl_a7_system
    PORT(
         LEDS : OUT  std_logic_vector(1 downto 0);
         KEY : IN  std_logic;
         clkg : IN  std_logic;
         rst : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal KEY : std_logic := '1';
   signal clkg : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal LEDS : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clkg_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: OPK_vhdl_a7_system PORT MAP (
          LEDS => LEDS,
          KEY => KEY,
          clkg => clkg,
          rst => rst
        );

   -- Clock process definitions
   clkg_process :process
   begin
		clkg <= '0';
		wait for clkg_period/2;
		clkg <= '1';
		wait for clkg_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		rst <= '1';

      wait for clkg_period*20;
		
		KEY <= '0';

      wait for clkg_period*40;

		KEY <= '1';

      wait for clkg_period*220;

      wait;
   end process;

END;
