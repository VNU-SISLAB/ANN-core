library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library xil_defaultlib;
use xil_defaultlib.conf.all;

entity controller_tb is
end controller_tb;

architecture behavioral of controller_tb is
    component controller
        port (
            clk : in std_logic;
            start : in std_logic;
            read_ena : out std_logic;
            reg_ena : out std_logic;
            mux_i_sel : out std_logic;
            mem_i_adr : out std_logic_vector(MEM_I_N-1 downto 0);
            mem_w_adr : out std_logic_vector(MEM_W_N-1 downto 0)
        );
    end component;

    signal clk : std_logic := '0';
    signal start, read_ena, reg_ena, mux_i_sel : std_logic := '0';
    signal mem_i_adr : std_logic_vector(MEM_I_N-1 downto 0);
    signal mem_w_adr : std_logic_vector(MEM_W_N-1 downto 0);

    constant period : time := 10 ns;
begin
    uut: controller port map (clk,start,read_ena,reg_ena,mux_i_sel);

    clk <= not clk after 5 ns;

    stim_proc : process
    begin
        wait for 3*period;
        start <= '1';
        wait for period;
        start <= '0';
        wait for 10000*period;
        assert (false) report "end" severity failure; -- to stop sim
    end process;
end behavioral;
