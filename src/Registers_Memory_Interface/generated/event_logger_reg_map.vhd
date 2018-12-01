--------------------------------------------------------------------------------
-- 
-- CTU CAN FD IP Core
-- Copyright (C) 2015-2018
-- 
-- Authors:
--     Ondrej Ille <ondrej.ille@gmail.com>
--     Martin Jerabek <martin.jerabek01@gmail.com>
-- 
-- Project advisors: 
-- 	Jiri Novak <jnovak@fel.cvut.cz>
-- 	Pavel Pisa <pisa@cmp.felk.cvut.cz>
-- 
-- Department of Measurement         (http://meas.fel.cvut.cz/)
-- Faculty of Electrical Engineering (http://www.fel.cvut.cz)
-- Czech Technical University        (http://www.cvut.cz/)
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this VHDL component and associated documentation files (the "Component"),
-- to deal in the Component without restriction, including without limitation
-- the rights to use, copy, modify, merge, publish, distribute, sublicense,
-- and/or sell copies of the Component, and to permit persons to whom the
-- Component is furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Component.
-- 
-- THE COMPONENT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHTHOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE COMPONENT OR THE USE OR OTHER DEALINGS
-- IN THE COMPONENT.
-- 
-- The CAN protocol is developed by Robert Bosch GmbH and protected by patents.
-- Anybody who wants to implement this IP core on silicon has to obtain a CAN
-- protocol license from Bosch.
-- 
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Register map implementation of: Event_Logger
--------------------------------------------------------------------------------
-- This file is autogenerated, DO NOT EDIT!

Library ieee;
use ieee.std_logic_1164.all;

Library work;
use work.can_registers_pkg.all;
use work.cmn_reg_map_pkg.all;

entity event_logger_reg_map is
generic (
    constant DATA_WIDTH          : natural := 32;
    constant ADDRESS_WIDTH       : natural := 8;
    constant REGISTERED_READ     : boolean := true;
    constant CLEAR_READ_DATA     : boolean := true;
    constant RESET_POLARITY      : std_logic := "0"
);
port (
    signal clk_sys               :in std_logic;
    signal res_n                 :in std_logic;
    signal address               :in std_logic_vector(address_width - 1 downto 0);
    signal w_data                :in std_logic_vector(data_width - 1 downto 0);
    signal r_data                :out std_logic_vector(data_width - 1 downto 0);
    signal cs                    :in std_logic;
    signal read                  :in std_logic;
    signal write                 :in std_logic;
    signal be                    :in std_logic_vector(data_width / 8 - 1 downto 0);
    signal event_logger_out      :out Event_Logger_out_t;
    signal event_logger_in       :in Event_Logger_in_t
);
end entity event_logger_reg_map;


architecture rtl of event_logger_reg_map is
  signal reg_sel  : std_logic_vector(5 downto 0);
  constant ADDR_VECT
                 : std_logic_vector(35 downto 0) := "000101000100000011000010000001000000";
  signal read_data_mux_in : std_logic_vector(159 downto 0);
  signal read_data_mask_n : std_logic_vector(31 downto 0);
  signal event_logger_out_i : Event_Logger_out_t;
  signal read_mux_ena                : std_logic;
begin

    ----------------------------------------------------------------------------
    -- Write address to One-hot decoder
    ----------------------------------------------------------------------------

    address_decoder_event_logger_comp : address_decoder
    generic map(
        address_width                   => 6 ,
        address_entries                 => 6 ,
        addr_vect                       => ADDR_VECT ,
        registered_out                  => false ,
        reset_polarity                  => RESET_POLARITY 
    )
    port map(
        clk_sys                         => clk_sys ,-- in
        res_n                           => res_n ,-- in
        address                         => address(8 downto 2) ,-- in
        addr_dec                        => reg_sel -- out
    );

    ----------------------------------------------------------------------------
    -- LOG_TRIG_CONFIG register
    ----------------------------------------------------------------------------

    log_trig_config_reg_comp : memory_reg
    generic map(
        data_width                      => 32 ,
        data_mask                       => "00000000000000111111111111111111" ,
        reset_polarity                  => RESET_POLARITY ,
        reset_value                     => "00000000000000000000000000000000" ,
        auto_clear                      => "00000000000000000000000000000000" 
    )
    port map(
        clk_sys                         => clk_sys ,-- in
        res_n                           => res_n ,-- in
        data_in                         => w_data(31 downto 0) ,-- in
        write                           => write ,-- in
        cs                              => reg_sel(0) ,-- in
        w_be                            => be(3 downto 0) ,-- in
        reg_value                       => event_logger_out_i.log_trig_config -- out
    );

    ----------------------------------------------------------------------------
    -- LOG_CAPT_CONFIG register
    ----------------------------------------------------------------------------

    log_capt_config_reg_comp : memory_reg
    generic map(
        data_width                      => 32 ,
        data_mask                       => "00000000000111111111111111111111" ,
        reset_polarity                  => RESET_POLARITY ,
        reset_value                     => "00000000000000000000000000000000" ,
        auto_clear                      => "00000000000000000000000000000000" 
    )
    port map(
        clk_sys                         => clk_sys ,-- in
        res_n                           => res_n ,-- in
        data_in                         => w_data(31 downto 0) ,-- in
        write                           => write ,-- in
        cs                              => reg_sel(1) ,-- in
        w_be                            => be(3 downto 0) ,-- in
        reg_value                       => event_logger_out_i.log_capt_config -- out
    );

    ----------------------------------------------------------------------------
    -- LOG_COMMAND register
    ----------------------------------------------------------------------------

    log_command_reg_comp : memory_reg
    generic map(
        data_width                      => 8 ,
        data_mask                       => "00001111" ,
        reset_polarity                  => RESET_POLARITY ,
        reset_value                     => "00000000" ,
        auto_clear                      => "00001111" 
    )
    port map(
        clk_sys                         => clk_sys ,-- in
        res_n                           => res_n ,-- in
        data_in                         => w_data(7 downto 0) ,-- in
        write                           => write ,-- in
        cs                              => reg_sel(3) ,-- in
        w_be                            => be(0) ,-- in
        reg_value                       => event_logger_out_i.log_command -- out
    );

    ----------------------------------------------------------------------------
    -- Read data multiplexor enable 
    ----------------------------------------------------------------------------
    read_data_keep_gen : if (CLEAR_READ_DATA = false) generate
        read_mux_ena <= read;
    end generate read_data_keep_gen;

    read_data_clear_gen : if (CLEAR_READ_DATA = true) generate
        read_mux_ena <= '1';
    end generate read_data_clear_gen;

    ----------------------------------------------------------------------------
    -- Read data multiplexor
    ----------------------------------------------------------------------------

    data_mux_event_logger_comp : data_mux
    generic map(
        data_out_width                  => 32 ,
        data_in_width                   => 416 ,
        sel_width                       => 8 ,
        registered_out                  => REGISTERED_READ ,
        reset_polarity                  => RESET_POLARITY 
    )
    port map(
        clk_sys                         => clk_sys ,-- in
        res_n                           => res_n ,-- in
        data_selector                   => address(8 downto 2) ,-- in
        data_in                         => read_data_mux_in ,-- in
        data_mask_n                     => read_data_mask_n ,-- out
        enable                          => read_mux_ena ,-- in
        data_out                        => r_data -- out
    );

  ------------------------------------------------------------------------------
  -- Read data driver
  ------------------------------------------------------------------------------
  read_data_mux_in  <= 
    -- Adress:0
    event_logger_out_i.log_trig_config &

    -- Adress:4
    event_logger_out_i.log_capt_config &

    -- Adress:8
    event_logger_in.log_pointers & event_logger_in.log_status &

    -- Adress:12
    "00000000" & "00000000" & "00000000" & "00000000" &

    -- Adress:16
    event_logger_in.log_capt_event_1;

    ----------------------------------------------------------------------------
    -- Read data mask - Byte enables
    ----------------------------------------------------------------------------
    read_data_mask_n  <= not (
      be(3) & be(3) & be(3) & be(3) & be(3) & be(3) & be(3) & be(3) &
      be(2) & be(2) & be(2) & be(2) & be(2) & be(2) & be(2) & be(2) &
      be(1) & be(1) & be(1) & be(1) & be(1) & be(1) & be(1) & be(1) &
      be(0) & be(0) & be(0) & be(0) & be(0) & be(0) & be(0) & be(0));

    Event_Logger_out <= Event_Logger_out_i;

end architecture rtl;
