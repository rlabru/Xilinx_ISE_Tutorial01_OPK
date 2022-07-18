----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:08:37 06/23/2022 
-- Design Name: 
-- Module Name:    OPK_vhdl_a7_system - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity OPK_vhdl_a7_system is
	PORT(
		LEDS : out STD_LOGIC_VECTOR(1 downto 0);
		KEY : in STD_LOGIC;
		--
		clkg : in STD_LOGIC; -- system clk
		rst : in STD_LOGIC
		);
end OPK_vhdl_a7_system;

architecture Behavioral of OPK_vhdl_a7_system is

component icon
  PORT (
    CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));
end component;

signal CONTROL0 : STD_LOGIC_VECTOR(35 DOWNTO 0);

component ila
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CLK : IN STD_LOGIC;
    DATA : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    TRIG0 : IN STD_LOGIC_VECTOR(0 TO 0));
end component;

signal DATA : STD_LOGIC_VECTOR(4 DOWNTO 0);
signal TRIG : STD_LOGIC_VECTOR(0 TO 0);

type opk_type is (opkwait, opk_t1, opk_t2);
signal opkp_current_state : opk_type;
signal opkp_next_state : opk_type;

signal clk : std_logic;
signal pulse : std_logic;
signal key_block : std_logic;
signal rewind : std_logic;

begin

BUFR_inst: BUFR
generic map (
	BUFR_DIVIDE => "2",
	SIM_DEVICE => "7SERIES"
)
port map (
	O => clk,
	CE => '1',
	CLR => '0',
	I => clkg
);

OPK_FSM: process (rst, clk)
begin
if rst = '0' then
	opkp_current_state <= opkwait;
	LEDS(0) <= '1';
	key_block <= '0';
	pulse <= '0';
else
	if(rising_edge(clk)) then
		opkp_current_state <= opkp_next_state;
		case opkp_current_state is
		when opkwait =>
			LEDS(0) <= '1';
			key_block <= '0';
			pulse <= '0';
		when opk_t1 =>
			LEDS(0) <= '0';
			key_block <= '1';
			pulse <= '1';
		when opk_t2 =>
			LEDS(0) <= '1';
			pulse <= '0';
		end case;
	end if;
end if;
end process OPK_FSM;

OPK_FSM_NEXT: process (opkp_current_state, KEY, rewind)
begin
	case opkp_current_state is
	when opkwait =>
		if KEY = '0' then
			opkp_next_state <= opk_t1;
		else
			opkp_next_state <= opkwait;
		end if;
	when opk_t1 =>
			opkp_next_state <= opk_t2;
	when opk_t2 =>
		if rewind = '1' then
			opkp_next_state <= opkwait;
		else
			opkp_next_state <= opk_t2;
		end if;
	end case;
end process OPK_FSM_NEXT;

OPK_WAIT: process (rst, clk)
variable count : integer range 0 to 99;
begin
if rst = '0' then
	count := 0;
	LEDS(1) <= '1';
	rewind <= '0';
else
	if(rising_edge(clk)) then
		if key_block = '1' then
			count := count + 1;
			LEDS(1) <= '0';
		else
			count := 0;
			LEDS(1) <= '1';
		end if;
		if count = 99 then
			rewind <= '1';
		else
			rewind <= '0';
		end if;
	end if;
end if;
end process OPK_WAIT;

U_ICON : icon
  port map (
    CONTROL0 => CONTROL0);

DATA(0) <= clk;
DATA(1) <= pulse;
DATA(2) <= rewind;
DATA(3) <= key_block;
DATA(4) <= key;

TRIG(0) <= key;

l1 : ila
  port map (
    CONTROL => CONTROL0,
    CLK => clkg,
    DATA => DATA,
    TRIG0 => TRIG);

end Behavioral;

