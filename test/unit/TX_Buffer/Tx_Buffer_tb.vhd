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
--  Unit test for the TX Buffer circuit
--------------------------------------------------------------------------------
-- Revision History:
--    14.6.2016   Created file
--    15.4.2018   Modified testbench to support new FSM in TX Buffer. Added
--                Random data checking and state transition checks.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Test implementation
--------------------------------------------------------------------------------

context work.ctu_can_synth_context;
context work.ctu_can_test_context;

architecture tx_buf_unit_test of CAN_test is

    -- Clocking and reset
    signal clk_sys                :   std_logic:='0';
    signal res_n                  :   std_logic:='0';

    -------------------------------
    --Driving Registers Interface--
    -------------------------------

    -- Data and address for SW access into the RAM of TXT Buffer
    signal tran_data              :     std_logic_vector(31 downto 0) :=
                                            (OTHERS => '0');
    signal tran_addr              :     std_logic_vector(4 downto 0) :=
                                            (OTHERS => '0');
    signal tran_cs                :     std_logic := '0';

    -- SW commands from user registers
    signal txt_sw_cmd             :     txt_sw_cmd_type := ('0','0','0');
    signal txt_sw_buf_cmd_index   :     std_logic_vector(3 downto 0) :=
                                        (OTHERS => '1');
    ------------------
    --Status signals--
    ------------------
    signal txtb_state             :     std_logic_vector(3 downto 0);

    ------------------------------------
    --CAN Core and TX Arbiter Interface-
    ------------------------------------

    -- Commands from the CAN Core for manipulation of the CAN
    signal txt_hw_cmd             :     txt_hw_cmd_type :=
                                          ('0', '0', '0', '0', '0', '0');

    signal txt_hw_cmd_int         :     std_logic;
    signal txt_hw_cmd_buf_index   :     natural range 0 to 3 := 0;

    -- Buffer output and pointer to the RAM memory
    signal txt_word               :     std_logic_vector(31 downto 0);
    signal txt_addr               :     natural range 0 to 19 := 0;

    -- Signals to the TX Arbitrator that it can be selected for transmission
    -- (used as input to priority decoder)
    signal txt_buf_ready          :     std_logic;

    -- Signals that immediate transition to Bus-off state occurred!
    signal bus_off_start          :     std_logic := '0';

    ------------------------------------
    -- Internal testbench signals
    ------------------------------------
    type shadow_memory_type is array (0 to 19) of std_logic_vector(31 downto 0);
    signal shadow_mem             :     shadow_memory_type
            := (OTHERS => (OTHERS => '0'));

    -- Random generator counters
    signal rand_gen_ctr           :     natural range 0 to RAND_POOL_SIZE;
    signal rand_read_ctr          :     natural range 0 to RAND_POOL_SIZE;
    signal rand_com_gen_ctr       :     natural range 0 to RAND_POOL_SIZE;

    -- Error counters
    signal data_coh_err_ctr       :     natural;
    signal state_coh_error_ctr    :     natural;

    -- Immediate exits
    signal exit_imm_1             :     boolean;
    signal exit_imm_2             :     boolean;

    signal txtb_exp_state         :     std_logic_vector(3 downto 0);

    procedure calc_exp_state(
        signal sw_cmd             : in  txt_sw_cmd_type;
        signal hw_cmd             : in  txt_hw_cmd_type;
        signal act_state          : in  std_logic_vector(3 downto 0);
        signal exp_state          : out std_logic_vector(3 downto 0)
    ) is
    begin

        -- By default, the state does not change. Only after command!
        exp_state   <= act_state;

        case act_state is
        when TXT_ETY =>
            if (sw_cmd.set_rdy = '1') then
                exp_state   <= TXT_RDY;
            end if;

        when TXT_RDY =>
            if (hw_cmd.lock = '1') then
                if (sw_cmd.set_abt = '1') then
                    exp_state   <= TXT_ABTP;
                else
                    exp_state   <= TXT_TRAN;
                end if;
            elsif (sw_cmd.set_abt = '1') then
                exp_state       <= TXT_ABT;
            end if;

        when TXT_TRAN =>
            if (sw_cmd.set_abt = '1') then
                exp_state   <= TXT_ABTP;
            end if;

            if (hw_cmd.unlock = '1') then
                if (hw_cmd.valid = '1') then
                    exp_state   <= TXT_TOK;
                elsif (hw_cmd.err = '1' or hw_cmd.arbl = '1') then
                    exp_state   <= TXT_RDY;
                elsif (hw_cmd.failed = '1') then
                    exp_state   <= TXT_ERR;
                end if;
            end if;

        when TXT_ABTP =>
            if (hw_cmd.unlock = '1') then
                if (hw_cmd.valid = '1') then
                    exp_state   <= TXT_TOK;
                elsif (hw_cmd.err = '1' or hw_cmd.arbl = '1') then
                    exp_state   <= TXT_ABT;
                elsif (hw_cmd.failed = '1') then
                    exp_state   <= TXT_ERR;
                end if;
            end if;

        when TXT_TOK =>
            if (sw_cmd.set_ety = '1') then
                exp_state   <= TXT_ETY;
            elsif (sw_cmd.set_rdy = '1') then
                exp_state   <= TXT_RDY;
            end if;

        when TXT_ABT =>
            if (sw_cmd.set_ety = '1') then
                exp_state   <= TXT_ETY;
            elsif (sw_cmd.set_rdy = '1') then
                exp_state   <= TXT_RDY;
            end if;

        when TXT_ERR =>
            if (sw_cmd.set_ety = '1') then
                exp_state   <= TXT_ETY;
            elsif (sw_cmd.set_rdy = '1') then
                exp_state   <= TXT_RDY;
            end if;
        when others =>
        end case;
    end procedure;

begin

    ----------------------------------------------------------------------------
    -- DUT - Create only one buffer instance
    ----------------------------------------------------------------------------
    txt_buffer_comp : txt_buffer
    generic map(
        buf_count               => 4,
        ID                      => 0
    )
    port map(
        clk_sys                 => clk_sys,
        res_n                   => res_n,
        tran_data               => tran_data,
        tran_addr               => tran_addr,
        tran_cs                 => tran_cs,
        txt_sw_cmd              => txt_sw_cmd,
        txt_sw_buf_cmd_index    => txt_sw_buf_cmd_index,
        txtb_state              => txtb_state,
        txt_hw_cmd              => txt_hw_cmd,
        txt_hw_cmd_int          => txt_hw_cmd_int,
        txt_hw_cmd_buf_index    => txt_hw_cmd_buf_index,
        bus_off_start           => bus_off_start,
        txt_word                => txt_word,
        txt_addr                => txt_addr,
        txt_buf_ready           => txt_buf_ready
    );


    ----------------------------------------------------------------------------
    -- Clock generation
    ----------------------------------------------------------------------------
    clock_gen_proc(period => f100_Mhz, duty => 50, epsilon_ppm => 0,
                   out_clk => clk_sys);


    ----------------------------------------------------------------------------
    -- Data generation - stored by user writes
    ----------------------------------------------------------------------------
    data_gen_proc : process
        variable buf_fsm : std_logic_vector(3 downto 0);
    begin
        tran_cs      <= '0';
        while res_n = ACT_RESET loop
            wait until rising_edge(clk_sys);
            apply_rand_seed(seed, 3, rand_gen_ctr);
        end loop;

        -- Generate random address and data and attempt to store it
        -- to the buffer.
        wait until rising_edge(clk_sys);
        rand_logic_vect_s(rand_gen_ctr, tran_data, 0.5);
        rand_logic_vect_s(rand_gen_ctr, tran_addr, 0.5);
        if (to_integer(unsigned(tran_addr)) > 19) then
            tran_addr  <= "00000";
        end if;
        tran_cs <=  '1';
        wait for 0 ns;

        wait until rising_edge(clk_sys);
        tran_cs <= '0';
        buf_fsm := txtb_state;
        wait until rising_edge(clk_sys);
        -- Data should be stored only if the buffer is accessible by user,
        -- when it is not ready, neither transmission is in progress.
        -- Store it in the shadow buffer!
        if (buf_fsm /= TXT_RDY and
            buf_fsm /= TXT_TRAN and
            buf_fsm /= TXT_ABTP)
        then
            shadow_mem(to_integer(unsigned(tran_addr))) <= tran_data;
        end if;

        tran_cs <=  '0';
        wait until rising_edge(clk_sys);
    end process;


    ----------------------------------------------------------------------------
    -- Reading the data like as If from CAN Core
    ----------------------------------------------------------------------------
    data_read_proc : process
        variable tmp   : std_logic_vector(4 downto 0);
    begin
        while res_n = ACT_RESET loop
            wait until rising_edge(clk_sys);
            apply_rand_seed(seed, 2, rand_read_ctr);
        end loop;

        data_coh_err_ctr <= 0;
        wait until falling_edge(clk_sys);
        -- Read data from random address in the buffer
        rand_logic_vect_v(rand_read_ctr, tmp, 0.5);
        if (to_integer(unsigned(tmp)) > 19) then
            tmp    := "00000";
        end if;

        txt_addr <= to_integer(unsigned(tmp));

        wait until falling_edge(clk_sys) and tran_cs = '0';

        -- At any point the data should be matching the data in
        -- the shadow buffer
        check(txt_word = shadow_mem(txt_addr), "Data coherency error!");
    end process;


    ----------------------------------------------------------------------------
    -- Sending random commands to the buffer from SW and HW
    ----------------------------------------------------------------------------
    commands_proc : process
        variable tmp_real : real;
    begin

        while res_n = ACT_RESET loop
            wait until rising_edge(clk_sys);
            apply_rand_seed(seed, 1, rand_com_gen_ctr);
        end loop;

        wait until falling_edge(clk_sys);

        -- Generate HW commands
        rand_logic_s(rand_com_gen_ctr, txt_hw_cmd.lock, 0.2);
        rand_logic_s(rand_com_gen_ctr, txt_hw_cmd.unlock, 0.2);

        if (txtb_state /= TXT_RDY) then
            txt_hw_cmd.lock   <= '0';
        end if;

        if (txtb_state /= TXT_TRAN and txtb_state /= TXT_ABTP) then
            txt_hw_cmd.unlock <= '0';
        end if;
        wait for 0 ns;

        if (txt_hw_cmd.unlock = '1') then
            rand_real_v(rand_com_gen_ctr, tmp_real);

            if (tmp_real < 0.3) then
                 txt_hw_cmd.valid  <= '1';
            elsif (tmp_real < 0.6) then
                 txt_hw_cmd.arbl   <= '1';
            elsif (tmp_real < 0.8) then
                 txt_hw_cmd.err    <= '1';
            else
                 txt_hw_cmd.failed <='1';
            end if;

        end if;

        -- Generate SW commands
        rand_logic_s(rand_com_gen_ctr, txt_sw_cmd.set_rdy, 0.2);
        rand_logic_s(rand_com_gen_ctr, txt_sw_cmd.set_ety, 0.2);
        rand_logic_s(rand_com_gen_ctr, txt_sw_cmd.set_abt, 0.2);
        wait for 0 ns;

        -- Calculate the expected state
        calc_exp_state(txt_sw_cmd, txt_hw_cmd, txtb_state, txtb_exp_state);

        wait until rising_edge(clk_sys);
        wait until falling_edge(clk_sys);
        -- Check whether the state ended up as expected
        check(txtb_state = txtb_exp_state,
              "State not updated as expected! Actual: " &
	               to_hstring(txtb_state) & " Expected: " &
                   to_hstring(txtb_exp_state));

        -- Set all the commands to be inactive
        txt_hw_cmd.valid   <= '0';
        txt_hw_cmd.err     <= '0';
        txt_hw_cmd.arbl    <= '0';
        txt_hw_cmd.failed  <= '0';
        txt_hw_cmd.lock    <= '0';
        txt_hw_cmd.unlock  <= '0';
        txt_sw_cmd.set_rdy <= '0';
        txt_sw_cmd.set_ety <= '0';
        txt_sw_cmd.set_abt <= '0';

    end process;


    ----------------------------------------------------------------------------
    ----------------------------------------------------------------------------
    -- Main Test process
    ----------------------------------------------------------------------------
    ----------------------------------------------------------------------------
    test_proc : process
        variable rand_nr    : real;
        variable rand_time  : time;
    begin
        info("Restarting TXT Buffer test!");
        wait for 5 ns;
        reset_test(res_n, status, run, error_ctr);
        apply_rand_seed(seed, 0, rand_ctr);
        info("Restarted TXT Buffer test");
        print_test_info(iterations, log_level, error_beh, error_tol);

        -------------------------------
        -- Main loop of the test
        -------------------------------
        info("Starting TXT Buffer main loop");

        while (loop_ctr < iterations  or  exit_imm)
        loop
            info("Starting loop nr " & integer'image(loop_ctr));
            
            wait until falling_edge(clk_sys);
            wait until rising_edge(clk_sys);
            wait until rising_edge(clk_sys);
            wait until rising_edge(clk_sys);

            -- Just add the errors from two separate processes
            error_ctr   <= state_coh_error_ctr + data_coh_err_ctr;

            loop_ctr    <= loop_ctr + 1;
        end loop;

        evaluate_test(error_tol, error_ctr, status);
    end process;

    errors <= error_ctr;

end architecture;