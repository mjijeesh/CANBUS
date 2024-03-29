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
--  Circuit handling Fault Confinement. Bit Error is also detected in this cir-
--  cuit. Error counters increment is handled here by signals inc_one, inc_eight,
--  dec_one. Logic for signalling this increments is in Protocol control. RX TX
--  counters for fault confinement are availiable. Two more counters are avai-
--  liable to distinguish between errors in Data phase and normal phase. All 
--  counters are pressetable from driving bus. Treshold for signalling error war-
--  ning limit and transition to error_pssive are also parameters given by dri-
--  ving bus. Default values are compliant with CAN FD standard.
--------------------------------------------------------------------------------
-- Revision History:
--    June 2015  Created file
--    19.6.2016  Modified counters for error couting in both FD and NORMAL mode.
--               Counters extended to 16 bits wide, to match the format in the 
--               registers!
--    27.6.2016  Bug fix. Changed error warning limit reached detection to greater
--               than and equal instead of only equal.
--    30.6.2016  Bug fix. Added equal or greater to fault confinement error 
--               passive state. According to CAN spec. error counter value equal
--               or greater than 128 is error passive, not only greater than!
--    05.1.2018  Added "erc_capt_r" register for last error capture.
--    08.5.2018  Added pragmas for one-hot decoding on increment, decrement
--               error counters.
--    12.7.2018  Added counters for erasing error counters upon reception of
--               128 consecutive 11 recessive bits as protocol compliant way
--               to transfer from Bus-off to Error active!
--------------------------------------------------------------------------------

Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
use ieee.math_real.ALL;

Library work;
use work.id_transfer.all;
use work.can_constants.all;
use work.can_components.all;
use work.can_types.all;
use work.cmn_lib.all;
use work.drv_stat_pkg.all;
use work.endian_swap.all;
use work.reduce_lib.all;

use work.CAN_FD_register_map.all;
use work.CAN_FD_frame_format.all;

entity fault_confinement is 
    PORT(
        -------------------
        --Clock and reset--
        -------------------
        signal clk_sys                :in   std_logic; --System clock
        signal res_n                  :in   std_logic; --Async reset

        --Driving registers interface-
        signal drv_bus                :in   std_logic_vector(1023 downto 0);

        -----------------
        --Error inputs --
        -----------------

        --Stuffing Error from bit destuffing
        signal stuff_Error            :in   std_logic;
          
        ----------------------------------
        --Error signalling for interrupt--
        ----------------------------------
        -- At least one error appeared
        signal error_valid            :out  std_logic;

        -- Error passive state changed
        signal error_passive_changed  :out  std_logic;

        --Error warning limit was reached
        signal error_warning_limit    :out  std_logic; 

        ----------------------
        --OP State interface--
        ----------------------
        signal OP_State               :in   oper_mode_type;

        ----------------------------------
        --Driving and trigerring signals--
        ----------------------------------
        -- Recieved data. Valid with the same signal as rec_trig in CAN Core
        signal data_rx                :in   std_logic; 

        -- Transcieved data by CAN Core. Valid with one clk_sys delay from 
        -- tran_trig! The same trigger signal as Bit-Stuffing!
        signal data_tx                :in   std_logic;   
        signal rec_trig               :in   std_logic; -- Recieve data trigger

        -- Transcieve data trigger one clk_sys delayed behind the tran_trig
        signal tran_trig_1            :in   std_logic; 

        ----------------------
        --PC State Interface--
        ----------------------
        signal PC_State               :in   protocol_type;
        signal sp_control             :in   std_logic_vector(1 downto 0);  
        signal form_Error             :in   std_logic; --Form Error from PC State
        signal CRC_Error              :in   std_logic; --CRC Error from PC State
        signal ack_Error              :in   std_logic; --Acknowledge Error from PC

        -- Error signal for PC control FSM from fault
        -- confinement unit (Bit error or Stuff Error appeared)
        signal bit_Error_valid        :out  std_logic;
        signal stuff_Error_valid      :out  std_logic;
         
        signal bit_Error_out          :out  std_logic;

        -- Interface for increment and decrementing error counters
        signal inc_one                :in   std_logic;
        signal inc_eight              :in   std_logic;
        signal dec_one                :in   std_logic;

        -- Enable for error counting
        signal enable                 :in   std_logic;

        -- Bit Error detected with secondary sampling point at busSync.vhd
        signal bit_Error_sec_sam      :in   std_logic; 
        signal err_capt               :out  std_logic_vector(7 downto 0);

        -- Signals transition from any Fault confinement state to Bus-off
        signal bus_off_start          :out  std_logic;

        -------------------
        -- Status outputs
        -------------------
        -- Error counters
        signal tx_counter_out         :out  std_logic_vector(8 downto 0);
        signal rx_counter_out         :out  std_logic_vector(8 downto 0);
        signal err_counter_norm_out   :out  std_logic_vector(15 downto 0);
        signal err_counter_fd_out     :out  std_logic_vector(15 downto 0);

        -- Fault confinement status
        signal error_state_out        :out  error_state_type

    );
end entity;


architecture rtl of fault_confinement is

    -----------------------
    --Internal registers --
    -----------------------

    -- Error signal for PC control FSM from fault confinement unit 
    -- (Bit error or Stuff Error appeared)
    signal bit_Error_valid_r       :    std_logic;
    signal stuff_Error_valid_r     :    std_logic;

    --Internal bit Error detection (out of BusSync)
    --Note: Bit Error detection functionality moved from busSync.vhd to this 
    --      module due to compactness reasons!
    --
    --Note 2: Only bit error detection in busSync.vhd  is for 
    --        secondary sample point!!
    signal bit_Error_int            :     std_logic;   

    --Error state
    signal error_state              :     error_state_type;  

    --Error counters
    signal tx_counter               :     natural range 0 to 511;
    signal rx_counter               :     natural range 0 to 511;
    signal err_counter_norm         :     natural range 0 to 65535;
    signal err_counter_fd           :     natural range 0 to 65535;
    --Note: Maximal increase of error counter is 8. Before bus off state the 
    --      highest value of Error counter is 255. Therefore 303 is the biggest 
    --      possible value of the counter after switching to bus off! 303 is 9 
    --      bits. 9 bits cover up to 512 range!!

    -- Interrupt registers
    signal ewl_reached               :     std_logic;

    -- Registred value of error warning limit reached 
    signal error_warning_limit_reg   :     std_logic;

    -- Value of previous fault conf state to detect changes
    signal erp_prev_state            :     error_state_type;

    signal erp_changed_reg           :     std_logic;
    signal error_valid_reg           :     std_logic; 

    -- Error code capture register as in SJA1000
    signal erc_capt_r                :     std_logic_vector(7 downto 0);

    signal joined_ctr                :     std_logic_vector(2 downto 0);

    ----------------------------------------------------------------------------
    -- Counters for Bus-off to Error active transition according to 
    -- CAN FD standard
    ----------------------------------------------------------------------------

    -- Counter for 11 consecutive recessive bits!
    signal cons_rec_ctr              :     natural range 0 to 15;

    -- Counter for 128 ocurrences of 11 consecutive bits
    signal cons_128_11_rec_ctr       :     natural range 0 to 127;

    -- Command that is generated upon ocurrence of 11 consecutive recessive bits
    -- 128 times. Upon this command, TX, RX error counters are erased and thus
    -- Fault confinement state is set to error_active.
    signal reset_err_counters        :     std_logic;

    -- Counting has started and is in progress...
    signal cons_128_11_progress      :     std_logic;
 
    ------------------------
    -- Driving bus aliases  
    ------------------------
    signal drv_ewl                   :     std_logic_vector(7 downto 0);
    signal drv_erp                   :     std_logic_vector(7 downto 0);
    signal drv_ctr_val               :     std_logic_vector(8 downto 0);
    signal drv_ctr_sel               :     std_logic_vector(3 downto 0);
    signal drv_clr_err_ctrs          :     std_logic;

    -- Bus off treshold
    constant bus_off_th              :     natural := 255;


begin
  
    -- Driving bus aliases
    drv_ewl                 <=  drv_bus(DRV_EWL_HIGH downto DRV_EWL_LOW);
    drv_erp                 <=  drv_bus(DRV_ERP_HIGH downto DRV_ERP_LOW);

    drv_ctr_val             <=  drv_bus(DRV_CTR_VAL_HIGH downto 
                                      DRV_CTR_VAL_LOW);

    drv_ctr_sel             <=  drv_bus(DRV_CTR_SEL_HIGH downto
                                      DRV_CTR_SEL_LOW);

    drv_clr_err_ctrs        <=  drv_bus(DRV_ERR_CTR_CLR);


    -- Counters to output propagation
    tx_counter_out          <=  std_logic_vector(to_unsigned(tx_counter, 9));
    rx_counter_out          <=  std_logic_vector(to_unsigned(rx_counter, 9));

    err_counter_norm_out    <=  std_logic_vector(to_unsigned(
                                err_counter_norm, 16));
    err_counter_fd_out      <=  std_logic_vector(to_unsigned(
                                err_counter_fd, 16));

    -- Fault confinement state propagation
    error_state_out         <=  error_state;
  
    ----------------------------------
    -- Interrupt Outputs
    ----------------------------------

    --Error warning limit reached
    error_warning_limit     <=  error_warning_limit_reg;

    --Error passive state changed
    error_passive_changed   <=  erp_changed_reg; 

    --At least one valid error appeared
    error_valid             <=  error_valid_reg; 

    --Bit Error or stuff error register to output propagation
    bit_Error_valid         <=  bit_Error_valid_r;
    stuff_Error_valid       <=  stuff_Error_valid_r;

    bit_Error_out           <=  bit_Error_int;

    --Detecting bit Error
    bit_Error_int   <=  bit_Error_sec_sam when (sp_control = SECONDARY_SAMPLE)
                                          else
                                    '1'   when ((rec_trig = '1') and 
                                                (not(data_tx = data_rx)))
                                          else 
                                    '0';

    joined_ctr              <=  inc_one & inc_eight & dec_one;
  
    -----------------------------------------
    -- Bit Error and Stuff Error validation
    -----------------------------------------
    b_s_error_proc : process(clk_sys, res_n)
    begin
        if (res_n = ACT_RESET) then
            bit_Error_valid_r         <= '0';
            stuff_Error_valid_r       <= '0';
        elsif rising_edge(clk_sys) then
            if (OP_State = transciever 
                and 
                (PC_State = control or PC_State = data or PC_State = crc)
                and 
                (bit_Error_int = '1'))
            then
                bit_Error_valid_r         <= '1';
            else
                bit_Error_valid_r         <= '0';  
            end if;


            if ((stuff_Error = '1') 
                and 
                (not(sp_control = SECONDARY_SAMPLE)))
            then
                stuff_Error_valid_r   <=  '1';
            else
                stuff_Error_valid_r   <=  '0';
            end if; 
        end if;
    end process;

  
    -----------------------------------------
    -- Transcieve Counter assignment process 
    -----------------------------------------
    tx_err_ctr_proc : process(clk_sys, res_n)
    begin
        if (res_n = ACT_RESET) then
            tx_counter                          <= 0;
        elsif rising_edge(clk_sys) then
          
            tx_counter                          <=  tx_counter;
          
            -- Presetting the counter from registers
            if (drv_ctr_sel(0) = '1') then 
                tx_counter                      <=
                    to_integer(unsigned(drv_ctr_val));

            elsif (reset_err_counters = '1') then
                tx_counter                      <= 0;

            else
                -- Counting the errors when transmitting
                if (OP_State = transciever) then
                    case joined_ctr is 
                    when INC_ONE_CON   => tx_counter  <=  tx_counter + 1;
                    when INC_EIGHT_CON => tx_counter  <=  tx_counter + 8;
                    when DEC_ONE_CON   =>  
                        if (tx_counter > 0) then 
                            tx_counter                <=  tx_counter - 1;
                        else
                            tx_counter                <=  0;
                        end if;
                    when others => tx_counter         <=  tx_counter;
                    end case;
                end if;
            end if;      
        end if;
    end process tx_err_ctr_proc;
  
  
    ---------------------------------------
    -- Recieve Counter assignment process
    ---------------------------------------
    rx_err_ctr_proc : process(clk_sys, res_n)
    begin
        if (res_n = ACT_RESET) then
            rx_counter                                  <= 0;
        elsif rising_edge(clk_sys) then
          
            rx_counter                                  <= rx_counter;

            -- Presetting the counter from registers
            if (drv_ctr_sel(1) = '1') then 
                rx_counter                              <=
                    to_integer(unsigned(drv_ctr_val));

            elsif (reset_err_counters = '1') then
                rx_counter                      <= 0;

            else

                if (OP_State = reciever) then
                    case joined_ctr is 
                    when INC_ONE_CON   => rx_counter    <= rx_counter + 1;
                    when INC_EIGHT_CON => rx_counter    <= rx_counter + 8;
                    when DEC_ONE_CON   =>  
                        if (rx_counter < 127) then
                            if (rx_counter > 0) then 
                                rx_counter              <= rx_counter - 1; 
                            else 
                                rx_counter              <= 0; 
                            end if;
                        else
                            rx_counter                  <= 120;
                        end if;
                    when others => rx_counter           <= rx_counter;
                    end case;          
                end if; 
            end if;      
        end if;
    end process rx_err_ctr_proc;


    ----------------------------------------------------------------------------
    -- Assertions on INC and DEC commands. At the moment Protocol control should
    -- set only one of these commands (ONE HOT)!
    ----------------------------------------------------------------------------
    inc_dec_assert_proc : process(clk_sys)
    begin
        -- pragma translate_off
        if (rising_edge(clk_sys) and now /= 0 fs) then
            if (joined_ctr /= "000" and joined_ctr /= "001" and
                joined_ctr /= "010" and joined_ctr /= "100")
            then
                -- LCOV_EXCL_START
                report "Error counters commands from Protocol Control to " &
                       "Fault confinemnet corrupt one hot decoding" severity
                        error;
                -- LCOV_EXCL_STOP
            end if;
        end if;
        -- pragma translate_on
    end process;


    ------------------------------------------------------------
    -- Special counters for counting errors in two data rates
    ------------------------------------------------------------
    spec_err_ctr_proc : process(clk_sys, res_n)
    begin
        if (res_n = ACT_RESET) then
            err_counter_norm                      <= 0;
            err_counter_fd                        <= 0;

        elsif rising_edge(clk_sys) then
            err_counter_norm                      <= err_counter_norm;
            err_counter_fd                        <= err_counter_fd;

            -- Erasing the counters from registers!
            if (drv_ctr_sel(2) = '1' or drv_ctr_sel(3) = '1') then 

                if (drv_ctr_sel(2) = '1') then 
                    err_counter_norm              <=
                        to_integer(unsigned(drv_ctr_val)); 
                end if;

                if (drv_ctr_sel(3) = '1') then 
                    err_counter_fd                <=
                        to_integer(unsigned(drv_ctr_val)); 
                end if;

            else
                -- Couting the errors in two modes separately
                if (sp_control = NOMINAL_SAMPLE) then
                    if (inc_one = '1' or inc_eight = '1') then
                        err_counter_norm          <= err_counter_norm + 1;
                    end if;
                else
                    if (inc_one = '1' or inc_eight = '1') then
                        err_counter_fd            <= err_counter_fd + 1;
                    end if;
                end if;
            end if;

        end if; 
    end process;


    ------------------------------------------
    -- Fault Confinement process
    ------------------------------------------
    err_state_proc : process(clk_sys, res_n)
    begin
        if (res_n = ACT_RESET) then
            error_state             <=  error_active;
 
        elsif rising_edge(clk_sys) then
            if (tx_counter > bus_off_th or rx_counter > bus_off_th) then
                error_state         <=  bus_off;
            elsif (tx_counter >= unsigned(drv_erp) or
                   rx_counter >= unsigned(drv_erp))
            then  
                error_state         <=  error_passive;
            else
                error_state         <=  error_active;      
            end if;           
        end if;
    end process;


    ----------------------------------------------------------------------------
    -- Detection of Transition to Bus-off to put TXT Buffers to "failed"
    ----------------------------------------------------------------------------
    bus_off_transition_proc : process(clk_sys, res_n)
    begin
        if (res_n = ACT_RESET) then
            bus_off_start   <= '0';

        elsif rising_edge(clk_sys) then
            if (error_state = bus_off and erp_prev_state /= bus_off) then
                bus_off_start <= '1';
            else
                bus_off_start <= '0';
            end if;

        end if;
    end process;

  
    -------------------------------------------------------------------
    -- Interrupt Signalling for Error warning limit and State changed 
    -------------------------------------------------------------------
    err_wrn_proc : process(clk_sys, res_n)
    begin
        if (res_n = ACT_RESET) then
            ewl_reached                           <= '0';
            erp_prev_state                        <= error_active;
            erp_changed_reg                       <= '0';
            error_valid_reg                       <= '0';
            error_warning_limit_reg               <= '0';
        elsif rising_edge(clk_sys) then
          
            -- Error passive transition detection
            erp_prev_state                        <= error_state;
            if (erp_prev_state = error_state) then
                erp_changed_reg                   <= '0';
            else
                erp_changed_reg                   <= '1';
            end if;

            -- Error warning limit transition detection
            if ((tx_counter >= unsigned(drv_ewl) or 
                 rx_counter >= unsigned(drv_ewl)) 
                and 
                ewl_reached = '0')
            then
                ewl_reached                       <= '1';
                error_warning_limit_reg           <= '1';

            elsif ((tx_counter < unsigned(drv_ewl)) and 
                   (rx_counter < unsigned(drv_ewl)))
            then
                ewl_reached                       <= '0';
                error_warning_limit_reg           <= '0';
            else
                ewl_reached                       <= ewl_reached;
                error_warning_limit_reg           <= '0';
            end if;

            -- At least one of the errors immediately appeared
            if (bit_error_valid_r = '1'        or
                stuff_error_valid_r = '1'      or 
                form_Error = '1'               or 
                CRC_Error = '1'                or 
                ack_Error = '1')
            then
                error_valid_reg                   <=  '1';
            else
                error_valid_reg                   <=  '0';
            end if;
        end if;
    end process;


    -------------------------------------------------------------------
    -- Error code capture register
    -------------------------------------------------------------------
    err_captr_proc : process(clk_sys, res_n)
    begin
        if (res_n = ACT_RESET) then
            erc_capt_r <= "00011111";
        elsif (rising_edge(clk_sys)) then
          
            ---------------------------------------------
            -- Decoding of error type into the register
            ---------------------------------------------
            if (bit_error_valid_r = '1') then
                erc_capt_r(7 downto 5) <= "000";
            elsif (CRC_Error = '1') then
                erc_capt_r(7 downto 5) <= "001";
            elsif (form_Error = '1') then
                erc_capt_r(7 downto 5) <= "010";
            elsif (ack_Error = '1') then
                erc_capt_r(7 downto 5) <= "011";
            elsif (stuff_error_valid_r = '1') then
                erc_capt_r(7 downto 5) <= "100";
            else
                erc_capt_r(7 downto 5) <= erc_capt_r(7 downto 5);
            end if;

            ---------------------------------------------
            -- Decoding where error occured
            ---------------------------------------------
            if (error_valid_reg = '1') then

                case PC_State is
                when  sof => 
                   erc_capt_r(4 downto 0) <= "00000";
                when  arbitration =>
                   erc_capt_r(4 downto 0) <= "00001"; 
                when  control =>
                   erc_capt_r(4 downto 0) <= "00010"; 
                when  data =>
                   erc_capt_r(4 downto 0) <= "00011"; 
                when  crc =>
                   erc_capt_r(4 downto 0) <= "00100"; 
                when  delim_ack =>
                   erc_capt_r(4 downto 0) <="00101"; 
                when  eof =>
                   erc_capt_r(4 downto 0) <= "00110"; 
                when  interframe =>
                   erc_capt_r(4 downto 0) <= "00111"; 
                when  error =>
                   erc_capt_r(4 downto 0) <= "01000"; 
                when  overload =>
                   erc_capt_r(4 downto 0) <= "01000"; 
                when others =>
                   erc_capt_r(4 downto 0) <= "11111"; 
                end case;
            else
                erc_capt_r(4 downto 0) <= erc_capt_r(4 downto 0);
            end if;
          
        end if;
    end process;


    ----------------------------------------------------------------------------
    -- Counting 128 ocurrences of 11 consecutive RECESSIVE bits. Generating
    -- error counter erase command upon completion!
    ----------------------------------------------------------------------------
    err_ctr_erase_proc : process(clk_sys, res_n)
    begin
        if (res_n = ACT_RESET) then
            cons_128_11_progress    <= '0';

            cons_rec_ctr            <= 0;
            cons_128_11_rec_ctr     <= 0;
            reset_err_counters      <= '0';

        elsif (rising_edge(clk_sys)) then

            reset_err_counters <= '0';

            -- Setting / Clearing "in progress" flag
            if (drv_clr_err_ctrs = '1') then
                cons_128_11_progress <= '1';
            elsif (reset_err_counters = '1') then
                cons_128_11_progress <= '0';
            end if;

            -- Counting 11 consecutive recessive bits!
            if (cons_128_11_progress = '1') then
                if (rec_trig = '1') then
                    if (data_rx = RECESSIVE) then
                        if (cons_rec_ctr = 10) then
                            cons_rec_ctr <= 0;
                        else
                            cons_rec_ctr <= cons_rec_ctr + 1;
                        end if;
                    else
                        cons_rec_ctr <= 0;
                    end if;
                end if;
            else
                cons_rec_ctr <= 0;
            end if;

            -- Counting 128 ocurrences
            if (cons_128_11_progress = '1') then

                -- 128 ocurrences reached -> Erase error counters command
                if (cons_128_11_rec_ctr = 127) then
                    cons_128_11_rec_ctr <= 0;
                    reset_err_counters <= '1';

                -- Not reached, but 11 consecutive are reached -> add 1!
                elsif (rec_trig = '1' and data_rx = RECESSIVE and
                       cons_rec_ctr = 10) then
                    cons_128_11_rec_ctr <= cons_128_11_rec_ctr + 1;
                end if;
            else
                cons_128_11_rec_ctr <= 0;
            end if;

        end if;
    end process;


  
  -- Internal register to output propagation
  err_capt <= erc_capt_r;
  
end architecture;
