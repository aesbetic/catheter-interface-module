library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arty_top is
    port (
        clk : in std_logic;

        sw   : in std_logic_vector(3 downto 0);
		btn  : in std_logic_vector(1 downto 0);

        jb : out std_logic_vector(5 downto 0);
        led : out std_logic_vector(3 downto 0)
    );
end entity arty_top;

architecture rtl of arty_top is

    signal sw_meta : std_logic := '0';
    signal sw_sync : std_logic := '0';
	
	signal reset : std_logic;
	
	signal nextFiring : std_logic;

    signal tx1_i : std_logic;
    signal tx2_i : std_logic;
    signal tx3_i : std_logic;

begin

    led(0) <= '1';
    led(3 downto 1) <= (others => '0');
	
	RESET_DEBOUNCER: entity work.ButtonDebouncer
		generic map (
			STABLE_PERIOD => 10
		)
		port map (
			reset => '0',
			clock => clk,
			asyncButton => btn(0),
			cleanButton => reset
		);
	
	NEXT_FIRING_DEBOUNCER: entity work.ButtonDebouncer
		generic map (
			STABLE_PERIOD => 10
		)
		port map (
			reset => reset,
			clock => clk,
			asyncButton => btn(1),
			cleanButton => nextFiring
		);

    -- Simple 2-FF synchronizers.
    -- sw(0) is used as active-high run switch.
    SYNC_INPUTS : process(clk)
    begin
        if rising_edge(clk) then
            sw_meta <= sw(0);
            sw_sync <= sw_meta;
        end if;
    end process SYNC_INPUTS;


    u_tx_core : entity work.tx_core
        generic map (
            SYS_CLK_HZ  => 100_000_000,
            PROG_CLK_HZ => 10_000_000
        )
        port map (
            clk       => clk,
            rst       => reset,
            switch_on => sw_sync,
			next_firing => nextFiring,

            tx1 => tx1_i,
            tx2 => tx2_i,
            tx3 => tx3_i
        );


    -- Differential PMOD JB used as single ended
    jb(0) <= tx1_i;
	jb(1) <= '0';
    jb(2) <= tx2_i;
	jb(3) <= '0';
    jb(4) <= tx3_i;
	jb(5) <= '0';

end architecture rtl;
