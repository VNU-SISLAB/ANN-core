---------------------------------------------------------------------------------
--
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : sigmoid.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : Mar 28 2018       @Modified Date : Mar 28 2018 13:38
-- @Project         : Artificial Neural Network
-- @Module          : sigmoid
-- @Description     :
-- @Version         :
-- @ID              :
--
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.conf.all;
use ieee.math_real.all;
--pragma synthesis_off
use work.tb_conf.all;
--pragma synthesis_on
-- library xil_defaultlib;
-- use xil_defaultlib.conf.all;

entity sigmoid is
  port (
    clk    : in std_logic;
    reset  : in std_logic;
    enable : in std_logic;
    input  : in std_logic_vector(BIT_WIDTH-1 downto 0);
    output : out std_logic_vector(BIT_WIDTH-1 downto 0)
  );
end sigmoid;

architecture LUT_funct of sigmoid is
  function sigmoid_funct(input: real) return real is
  begin
      return 1.0 / (1.0 + exp(-input));
  end function;

  function real_to_stdlv (
    constant real_val : real;
    constant size     : integer;
    constant fract    : integer
  )
    return std_logic_vector
  is
    variable actual_val : integer;
  begin
    actual_val := integer(real_val * 2.0**fract);
    if actual_val < 0 then
        return std_logic_vector(to_signed(0, size));
    elsif actual_val > 2**(size-1) - 1 then
        return std_logic_vector(to_signed(2**(size-1)-1, size));
    else
        return std_logic_vector(to_signed(integer(actual_val), size));
    end if;
  end function real_to_stdlv;

  -- IF tanh(): output.range=fraction bit + 1 (sign bit)
  constant DEPTH : integer := 2**BIT_WIDTH;
  type mem_type is array(-DEPTH/2 to DEPTH/2 - 1)
    of std_logic_vector(FRACTION downto 0);

  function init_mem return mem_type is
    variable temp_mem   : mem_type;
    variable input_real : real := 0.0;
  begin
    for i in -DEPTH/2 to DEPTH/2 - 1 loop
      input_real := real(i) / 2.0**(FRACTION);

      temp_mem(i) :=
        real_to_stdlv(sigmoid_funct(input_real), FRACTION+1, FRACTION);
      end loop;
      return temp_mem;
  end function;

    signal mem: mem_type := init_mem;
begin
  process (reset, clk) is
    variable output_tmp : std_logic_vector(FRACTION downto 0);
  begin
    if reset = '1' then
      output <= (others => '0');
    elsif rising_edge(clk) then
      if (enable = '1') then
        output_tmp := mem(to_integer(signed(input)));
        output <= (BIT_WIDTH - FRACTION - 2 downto 0 => '0' )
                 & output_tmp;
        end if;
    end if;
  end process;
end LUT_funct;

-- architecture behav of sigmoid is
  -- function sigmoid_funct(input: real) return real is
  -- begin
      -- return 1.0 / (1.0 + exp(-input));
  -- end function;

-- begin
  -- process (reset, clk) is
    -- variable out_real : real;
    -- variable counter  : integer := 1;
  -- begin

    -- if reset = '1' then
        -- output <= (others => '0');
    -- elsif rising_edge(clk) then
      -- if (enable = '1') then
        -- out_real := sigmoid_funct(real(to_integer(signed(input))) / 2.0**FRACTION);
        -- output <= std_logic_vector(to_signed(integer(out_real * 2.0**FRACTION), BIT_WIDTH));

        -- --pragma synthesis_off
        -- -- print("Sigmoid out(" & integer'image(counter mod (NEURONS_N) ) & ") = "
             -- -- & real'image(out_real) & "  =>  "
             -- -- & integer'image((integer(out_real*2.0**FRACTION))));
        -- --pragma synthesis_on

        -- counter := counter + 1;
      -- end if;
    -- end if;
  -- end process;
-- end behav;
