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
-- Purpose:
--  Unit test for the Event Logger circuit.
--   For simplicity always only one type of event is logged at a time!
--------------------------------------------------------------------------------
-- Revision History:
--    4.6.2016   Created file
--    4.6.2018	 Finished testbench. Took just 2 years to do it!
--------------------------------------------------------------------------------

context work.ctu_can_synth_context;
context work.ctu_can_test_context;

architecture Event_logger_unit_test of CAN_test is

    signal clk_sys              :   std_logic := '0';
    signal res_n                :   std_logic := '0';

    signal drv_bus              :   std_logic_vector(1023 downto 0) :=
                                        (OTHERS => '0');

    signal stat_bus             :   std_logic_vector(511 downto 0) :=
                                        (OTHERS => '0');

    signal sync_edge            :   std_logic := '0';
    signal data_overrun         :   std_logic := '0';

    signal timestamp            :   std_logic_vector(63 downto 0) :=
                                        (OTHERS => '0');

    signal bt_FSM               :   bit_time_type;
    signal loger_finished       :   std_logic;

    signal loger_act_data       :   std_logic_vector(63 downto 0) :=
                                        (OTHERS => '0');

    signal log_write_pointer    :   std_logic_vector(7 downto 0) :=
                                        (OTHERS => '0');

    signal log_read_pointer     :   std_logic_vector(7 downto 0) :=
                                        (OTHERS => '0');

    signal log_size             :   std_logic_vector(7 downto 0) :=
                                        (OTHERS => '0');

    signal log_state_out        :   logger_state_type;

    constant event_amount       :   integer := 21;
    constant trig_amount        :   integer := 18;


	----------------------------------------------------------------------------
	-- Internal testbench signals
	----------------------------------------------------------------------------

    signal PC_State             :   protocol_type := sof;
    signal OP_State             :   oper_mode_type := transciever;
    signal stat_bus_short       :   std_logic_vector(505 downto 0) :=
                                        (OTHERS => '0');
    -- Additional random counters
    signal rand_ctr_2           :   natural range 0 to RAND_POOL_SIZE := 0;

	-- Inputs to the Event logger generated by testbench
	signal trig_inputs          :   std_logic_vector(trig_amount - 1 downto 0)
                                       := (OTHERS => '0');
	signal evnt_inputs          :   std_logic_vector(event_amount - 1 downto 0)
                                       := (OTHERS => '0');
	signal evnt_inputs_edge     :   std_logic_vector(event_amount - 1 downto 0)
                                       := (OTHERS => '0');
	signal evnt_inputs_reg      :   std_logic_vector(event_amount - 1 downto 0)
                                       := (OTHERS => '0');

	-- Settings of Event logger generated by testbench
	signal drv_trig             :	std_logic_vector(trig_amount - 1 downto 0)
                                        := (OTHERS => '0');
	signal drv_capt             :	std_logic_vector(event_amount - 1 downto 0)
                                        := (OTHERS => '0');
	signal drv_start_logger     :   std_logic := '0';
    signal drv_up               :   std_logic := '0';

    -- SW model memory
    type log_mod_mem_type is array (0 to 20) of std_logic_vector(63 downto 0);
    signal log_mod_mem          :   log_mod_mem_type :=
                                        (OTHERS => (OTHERS => '0'));

    ----------------------------------------------------------------------------
    -- Generates random capture setting of event logger
    ----------------------------------------------------------------------------
    procedure generate_capture_setting(
        signal    rand_ctr      : inout  natural range 0 to RAND_POOL_SIZE;
        signal    drv_capt      : inout  std_logic_vector(event_amount - 1 downto 0)
    )is
        variable rand_val            : real     := 0.0;
        variable rand_index          : integer  := 0;
    begin
        -- Generate random events for capturing!
        rand_logic_vect_s(rand_ctr, drv_capt, 0.4);
    end procedure;


    ----------------------------------------------------------------------------
    -- Generate random trigger setting of event logger
    ----------------------------------------------------------------------------
    procedure generate_trigger_setting(
        signal rand_ctr         :inout natural range 0 to RAND_POOL_SIZE;
        signal drv_trig         :inout std_logic_vector(trig_amount - 1 downto 0)
    ) is
        constant trig_zero      :      std_logic_vector(trig_amount - 1 downto 0)
                                        := (OTHERS => '0');
    begin
        -- Generate random events for capturing!
        rand_logic_vect_s(rand_ctr, drv_trig, 0.4);
        wait for 0 ns;
        drv_trig(7) <= '0';
        if (drv_trig = trig_zero) then
            drv_trig(0) <= '1';
        end if;
        wait for 0 ns;
    end procedure;


    ----------------------------------------------------------------------------
    -- Give command to start event capturing
    ----------------------------------------------------------------------------
    procedure start_event_logger(
        signal   drv_start_logger :inout std_logic;
        signal   log_level        :in    log_lvl_type
    ) is
    begin
        info("Starting event logger");

        -- Give start command to event logger
        drv_start_logger <= '1';
        wait for 10 ns;
        drv_start_logger <= '0';
    end procedure;


    ----------------------------------------------------------------------------
    -- Give command to start event capturing
    ----------------------------------------------------------------------------
    procedure wait_till_trigger(
        signal   clk_sys          :in    std_logic;
        signal   log_state        :in    logger_state_type;
        signal   trig_inputs	  :in    std_logic_vector(trig_amount - 1 downto 0);
        signal   drv_trig         :in    std_logic_vector(trig_amount - 1 downto 0);
        variable outcome          :inout boolean
    ) is
        constant trig_zero        :      std_logic_vector(trig_amount - 1 downto 0)
                                            := (OTHERS => '0');
    begin
        info("Waiting for trigger");

        wait until (falling_edge(clk_sys) and (log_state_out = ready));

        info("Trigger here!");

        while ((trig_inputs and drv_trig) = trig_zero) loop
            wait until rising_edge(clk_sys);
        end loop;

        wait until rising_edge(clk_sys);

        info("Trigger condition met!");
        wait until rising_edge(clk_sys);
        wait for 1 ns;

        outcome := true;
        if (log_state /= running) then
            -- LCOV_EXCL_START
            outcome := false;
            -- LCOV_EXCL_STOP
        end if;
    end procedure;


    ----------------------------------------------------------------------------
    -- Check contents of Event logger memory for each event which was recorded
    -- by model! Event should be recorded with similar timestamp! On timestamp
    -- there is a jitter since real event logger might take some time to
    -- process the event via event harvesting mechanism
    ----------------------------------------------------------------------------
    procedure check_events(
        signal    drv_up             : out   std_logic;
        signal    clk_sys            : in    std_logic;
        signal    logger_act_dat     : in    std_logic_vector(63 downto 0);
        signal    log_mod_mem        : in    log_mod_mem_type;
        variable  outcome            : out   boolean
    ) is
        variable  found              :       boolean;
        variable  time_diff          :       integer;
    begin
        outcome := true;
        info("Starting event check");

        -- Browse through each event in logger memory
        for i in 0 to 15 loop
            found := false;

            -- Check if event is found in SW model!
            for j in 0 to 15 loop
                time_diff := to_integer(unsigned(log_mod_mem(j)(
                                EVENT_TS_15_0_L + 31 downto EVENT_TS_15_0_L))) -
                             to_integer(unsigned(logger_act_dat(
                                EVENT_TS_15_0_L + 31 downto EVENT_TS_15_0_L)));
                if ((log_mod_mem(j)(5 downto 0) = logger_act_dat(5 downto 0)) and
                    (abs(time_diff)) < 15)
                then
                    found := true;
                end if;
            end loop;

            check(found, "Event not found! Index: " & Integer'Image(i));

            drv_up <= '1';
            wait until rising_edge(clk_sys);
            drv_up <= '0';
            wait until rising_edge(clk_sys);
        end loop;
    end procedure;

begin

    ----------------------------------------------------------------------------
    -- DUT
    ----------------------------------------------------------------------------
    event_logger_comp : event_logger
    generic map(
        memory_size                =>  16 --Only 2^k possible!
    )
    port map(
        clk_sys                    =>  clk_sys,
        res_n                      =>  res_n,
        drv_bus                    =>  drv_bus,
        stat_bus                   =>  stat_bus,
        sync_edge                  =>  sync_edge,
        data_overrun               =>  data_overrun,
        timestamp                  =>  timestamp,
        bt_FSM                     =>  bt_FSM,
        loger_finished             =>  loger_finished,
        loger_act_data             =>  loger_act_data,
        log_write_pointer          =>  log_write_pointer,
        log_read_pointer           =>  log_read_pointer,
        log_size                   =>  log_size,
        log_state_out              =>  log_state_out
    );


    ----------------------------------------------------------------------------
    -- Clock generation
    ----------------------------------------------------------------------------
    clock_gen_proc(period => f100_Mhz, duty => 50, epsilon_ppm => 0,
                   out_clk => clk_sys);
    timestamp_gen_proc(clk_sys, timestamp);


    ----------------------------------------------------------------------------
    -- Connection of event logger settings to DUT
    ----------------------------------------------------------------------------
    drv_bus(552 + trig_amount - 1 downto 552)   <= drv_trig;
    drv_bus(580 + event_amount - 1 downto 580)  <= drv_capt;
    drv_bus(DRV_LOG_CMD_STR_INDEX)              <= drv_start_logger;


    ----------------------------------------------------------------------------
    -- Event sources connection to DUT. Emulation of "stat_bus", "sync_edge"
    -- and "data_overrun"
    ----------------------------------------------------------------------------
    PC_State <= sof             when evnt_inputs(C_SOF_IND) = '1' else
                arbitration     when evnt_inputs(C_ARBS_IND) = '1' else
                control         when evnt_inputs(C_CTRS_IND) = '1' else
                data            when evnt_inputs(C_DATS_IND) = '1' else
                crc          	when evnt_inputs(C_CRCS_IND) = '1' else
                overload        when evnt_inputs(C_OVL_IND) = '1' else
                interframe;

    stat_bus(STAT_PC_STATE_HIGH downto STAT_PC_STATE_LOW) <=
		    std_logic_vector(to_unsigned(protocol_type'pos(PC_State), 4));

    -- Event sources
    stat_bus(STAT_ARB_LOST_INDEX)               <= evnt_inputs(C_ARBL_IND);
    stat_bus(STAT_REC_VALID_INDEX)              <= evnt_inputs(C_REV_IND);
    stat_bus(STAT_TRAN_VALID_INDEX) 		<= evnt_inputs(C_TRV_IND);
    stat_bus(STAT_BR_SHIFTED) 	                <= evnt_inputs(C_BRS_IND);
    stat_bus(STAT_ACK_RECIEVED_OUT_INDEX) 	<= evnt_inputs(C_ACKR_IND);
    stat_bus(STAT_ACK_ERROR_INDEX)              <= evnt_inputs(C_ACKNR_IND);
    stat_bus(STAT_EWL_REACHED_INDEX) 		<= evnt_inputs(C_EWLR_IND);
    stat_bus(STAT_ERP_CHANGED_INDEX) 		<= evnt_inputs(C_ERC_IND);
    stat_bus(STAT_SET_TRANSC_INDEX) 		<= evnt_inputs(C_TRS_IND);
    stat_bus(STAT_SET_REC_INDEX) 	        <= evnt_inputs(C_RES_IND);
    sync_edge                                   <= evnt_inputs(C_SYNE_IND);
    stat_bus(STAT_DATA_HALT_INDEX)              <= evnt_inputs(C_STUFF_IND);
    stat_bus(STAT_DESTUFFED_INDEX)              <= evnt_inputs(C_DESTUFF_IND);
    data_overrun                                <= evnt_inputs(C_OVR_IND);

    stat_bus(STAT_ERROR_VALID_INDEX)            <= evnt_inputs(C_ERR_IND);

    -- Setting trig inputs in model
    trig_inputs(T_SOF_IND)               <= evnt_inputs(C_SOF_IND);
    trig_inputs(T_ARBL_IND)              <= evnt_inputs(C_ARBL_IND);
    trig_inputs(T_REV_IND)               <= evnt_inputs(C_REV_IND);
    trig_inputs(T_TRV_IND)               <= evnt_inputs(C_TRV_IND);
    trig_inputs(T_OVL_IND)               <= evnt_inputs(C_OVL_IND);
    trig_inputs(T_RES_IND)               <= evnt_inputs(C_RES_IND);

    trig_inputs(T_ERR_IND)               <= evnt_inputs(C_ERR_IND);
    trig_inputs(T_ACKR_IND)              <= evnt_inputs(C_ACKR_IND);
    -- Trigger by user write disabled in the test!
    trig_inputs(T_USRW_IND)              <= '0';
    trig_inputs(T_BRS_IND)               <= evnt_inputs(C_BRS_IND);
    trig_inputs(T_ARBS_IND)              <= evnt_inputs(C_ARBS_IND);
    trig_inputs(T_CTRS_IND)              <= evnt_inputs(C_CTRS_IND);
    trig_inputs(T_ACKNR_IND)             <= evnt_inputs(C_ACKNR_IND);
    trig_inputs(T_EWLR_IND)              <= evnt_inputs(C_EWLR_IND);
    trig_inputs(T_ERPC_IND)              <= evnt_inputs(C_ERC_IND);
    trig_inputs(T_DATS_IND)              <= evnt_inputs(C_DATS_IND);
    trig_inputs(T_TRS_IND)               <= evnt_inputs(C_TRS_IND);
    trig_inputs(T_CRCS_IND)              <= evnt_inputs(C_CRCS_IND);


    ----------------------------------------------------------------------------
    -- Generation of random events. Is completely not synced with event logger
    -- generation.
    ----------------------------------------------------------------------------
    ev_gen : process
        variable wt : time := 0 ns;
        variable rand_val : real := 0.0;
    begin
        wait until rising_edge(clk_sys);

        if (res_n = ACT_RESET) then
            apply_rand_seed(seed, 1, rand_ctr_2);
        end if;

        -- Generate random events
        rand_logic_vect_s(rand_ctr_2, evnt_inputs, 0.1);

        -- Make sure that protocol control is one  hot encoded for SW model!
        if (evnt_inputs(C_SOF_IND) = '1') then
            evnt_inputs(C_ARBS_IND) <= '0';
            evnt_inputs(C_CTRS_IND) <= '0';
            evnt_inputs(C_DATS_IND) <= '0';
            evnt_inputs(C_CRCS_IND) <= '0';
            evnt_inputs(C_OVL_IND) <= '0';

        elsif (evnt_inputs(C_ARBS_IND) = '1') then
            evnt_inputs(C_SOF_IND)  <= '0';
            evnt_inputs(C_CTRS_IND) <= '0';
            evnt_inputs(C_DATS_IND) <= '0';
            evnt_inputs(C_CRCS_IND) <= '0';
            evnt_inputs(C_OVL_IND) <= '0';

        elsif (evnt_inputs(C_CTRS_IND) = '1') then
            evnt_inputs(C_SOF_IND)  <= '0';
            evnt_inputs(C_ARBS_IND) <= '0';
            evnt_inputs(C_DATS_IND) <= '0';
            evnt_inputs(C_CRCS_IND) <= '0';
            evnt_inputs(C_OVL_IND) <= '0';

        elsif (evnt_inputs(C_DATS_IND) = '1') then
            evnt_inputs(C_SOF_IND)  <= '0';
            evnt_inputs(C_ARBS_IND) <= '0';
            evnt_inputs(C_CTRS_IND) <= '0';
            evnt_inputs(C_CRCS_IND) <= '0';
            evnt_inputs(C_OVL_IND) <= '0';

        elsif (evnt_inputs(C_CRCS_IND) = '1') then
            evnt_inputs(C_SOF_IND)  <= '0';
            evnt_inputs(C_ARBS_IND) <= '0';
            evnt_inputs(C_CTRS_IND) <= '0';
            evnt_inputs(C_DATS_IND) <= '0';
            evnt_inputs(C_OVL_IND) <= '0';

        elsif (evnt_inputs(C_OVL_IND) = '1') then
            evnt_inputs(C_SOF_IND)  <= '0';
            evnt_inputs(C_ARBS_IND) <= '0';
            evnt_inputs(C_CTRS_IND) <= '0';
            evnt_inputs(C_DATS_IND) <= '0';
            evnt_inputs(C_CRCS_IND) <= '0';
        end if;

        rand_real_v(rand_ctr_2, rand_val);
        wt := integer(rand_val * 100.0) * 1 ns;
        wt := wt + 10 ns;
        wait for wt;
    end process;


    ----------------------------------------------------------------------------
    -- Edge detection on event inputs for SW model
    ----------------------------------------------------------------------------
    ev_edge_proc : process(clk_sys, res_n)
    begin
        if (res_n = ACT_RESET) then
            evnt_inputs_reg <= (OTHERS => '0');
        elsif (rising_edge(clk_sys)) then
            evnt_inputs_reg <= evnt_inputs;
        end if;
    end process;

    evnt_edge_gen : for i in 0 to evnt_inputs'length - 1 generate
        evnt_inputs_edge(i) <= '1' when (evnt_inputs(i) = '1' and
                                         evnt_inputs_reg(i) = '0' and
                                         drv_capt(i) = '1')
                                   else
                               '0';
    end generate;


    ----------------------------------------------------------------------------
    -- SW model for event logger
    ----------------------------------------------------------------------------
    ev_logger_model_proc : process
        variable log_ptr           : natural := 0;
    begin
        while (res_n = ACT_RESET) loop
            wait until rising_edge(clk_sys);
        end loop;

        -- Wait till event logging starts
        while (log_state_out /= running) loop
            wait until rising_edge(clk_sys);
        end loop;

        -- Erase logger model memory
        log_mod_mem <= (OTHERS => (OTHERS => '0'));
        log_ptr     := 0;

        -- Record events in SW as long as logging is in progress
        while (log_state_out = running) loop
            for i in (event_amount - 1) downto 0 loop
                if (evnt_inputs_edge(i) = '1') then
                    -- Index of event corresponds to encoding in EVNT_TYPE !!
                    log_mod_mem(log_ptr)(4 downto 0) <=
                        std_logic_vector(to_unsigned(i + 1, 5));

                    -- Record Only 48 bits of timestamp
                    log_mod_mem(log_ptr)
                        (EVENT_TS_15_0_L + 31 downto EVENT_TS_15_0_L) <=
                            timestamp(31 downto 0);
                    log_ptr := log_ptr + 1;
                end if;
            end loop;
            wait until rising_edge(clk_sys);
        end loop;
    end process;

    errors <= error_ctr;


    ----------------------------------------------------------------------------
    -- Main test process
    ----------------------------------------------------------------------------
    test_proc : process
        variable ev_type    :  integer := 0;
        variable outcome    :  boolean := false;
    begin
        info("Restarting Event logget unit test!");
        wait for 5 ns;
        reset_test(res_n, status, run, error_ctr);
        apply_rand_seed(seed, 0, rand_ctr);
        info("Restarted Event logget unit test");
        print_test_info(iterations, log_level, error_beh, error_tol);

        while (loop_ctr < iterations or exit_imm)
        loop
            info("Starting loop nr " & integer'image(loop_ctr));

            generate_capture_setting(rand_ctr, drv_capt);
            generate_trigger_setting(rand_ctr, drv_trig);
            start_event_logger(drv_start_logger, log_level);
            wait_till_trigger(clk_sys, log_state_out, trig_inputs, drv_trig
                              , outcome);
            check(outcome, "Logger did not trigger as expected!");

            -- Wait till logging finishes
            wait until log_state_out = config;

            check_events(drv_up, clk_sys, loger_act_data, log_mod_mem
                         , outcome);
            check(outcome, "Recorded event not matching expected value");
            loop_ctr <= loop_ctr + 1;
        end loop;

        evaluate_test(error_tol, error_ctr, status);
    end process;

end architecture;