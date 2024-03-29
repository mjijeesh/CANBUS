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
--  Package with Constants for Driving Bus and Status Bus.
--------------------------------------------------------------------------------
-- Revision History:
--    28.12.2018  Created file, separated from "can_constants".
--------------------------------------------------------------------------------

Library ieee;
use ieee.std_logic_1164.all;

package drv_stat_pkg is

    ----------------------------------------------------------------------------
    -- Driving bus signal ranges
    ----------------------------------------------------------------------------
    --Prescaler
    constant DRV_TQ_NBT_LOW  : natural := 0;
    constant DRV_TQ_NBT_HIGH : natural := 7;

    constant DRV_TQ_DBT_LOW  : natural := 8;
    constant DRV_TQ_DBT_HIGH : natural := 15;

    constant DRV_PRS_NBT_LOW  : natural := 16;
    constant DRV_PRS_NBT_HIGH : natural := 22;

    constant DRV_PH1_NBT_LOW  : natural := 23;
    constant DRV_PH1_NBT_HIGH : natural := 28;

    constant DRV_PH2_NBT_LOW  : natural := 29;
    constant DRV_PH2_NBT_HIGH : natural := 34;

    constant DRV_PRS_DBT_LOW  : natural := 35;
    constant DRV_PRS_DBT_HIGH : natural := 40;

    constant DRV_PH1_DBT_LOW  : natural := 41;
    constant DRV_PH1_DBT_HIGH : natural := 45;

    constant DRV_PH2_DBT_LOW  : natural := 46;
    constant DRV_PH2_DBT_HIGH : natural := 50;

    constant DRV_SJW_LOW  : natural := 51;
    constant DRV_SJW_HIGH : natural := 55;

    constant DRV_SJW_DBT_LOW  : natural := 56;
    constant DRV_SJW_DBT_HIGH : natural := 60;

    -- TimeStampGen
    constant DRV_TS_1_SRC_LOW  : natural := 61;
    constant DRV_TS_1_SRC_HIGH : natural := 63;

    constant DRV_TS_1_RST_INDEX : natural := 64;

    constant DRV_TS_1_MAKE_LOW  : natural := 65;
    constant DRV_TS_1_MAKE_HIGH : natural := 68;

    constant DRV_TS_2_SRC_LOW  : natural := 69;
    constant DRV_TS_2_SRC_HIGH : natural := 71;

    constant DRV_TS_2_RST_INDEX : natural := 72;

    constant DRV_TS_2_MAKE_LOW  : natural := 73;
    constant DRV_TS_2_MAKE_HIGH : natural := 76;

    -- Message Filter
    constant DRV_FILTER_A_MASK_LOW  : natural := 81;
    constant DRV_FILTER_A_MASK_HIGH : natural := 109;

    constant DRV_FILTER_A_CTRL_LOW  : natural := 110;
    constant DRV_FILTER_A_CTRL_HIGH : natural := 113;

    constant DRV_FILTER_A_BITS_LOW  : natural := 114;
    constant DRV_FILTER_A_BITS_HIGH : natural := 142;

    constant DRV_FILTER_B_MASK_LOW  : natural := 143;
    constant DRV_FILTER_B_MASK_HIGH : natural := 171;

    constant DRV_FILTER_B_CTRL_LOW  : natural := 172;
    constant DRV_FILTER_B_CTRL_HIGH : natural := 175;

    constant DRV_FILTER_B_BITS_LOW  : natural := 176;
    constant DRV_FILTER_B_BITS_HIGH : natural := 204;

    constant DRV_FILTER_C_MASK_LOW  : natural := 205;
    constant DRV_FILTER_C_MASK_HIGH : natural := 233;

    constant DRV_FILTER_C_CTRL_LOW  : natural := 234;
    constant DRV_FILTER_C_CTRL_HIGH : natural := 237;

    constant DRV_FILTER_C_BITS_LOW  : natural := 238;
    constant DRV_FILTER_C_BITS_HIGH : natural := 266;

    constant DRV_FILTER_RAN_CTRL_LOW  : natural := 267;
    constant DRV_FILTER_RAN_CTRL_HIGH : natural := 270;

    constant DRV_FILTER_RAN_LO_TH_LOW  : natural := 271;
    constant DRV_FILTER_RAN_LO_TH_HIGH : natural := 299;

    constant DRV_FILTER_RAN_HI_TH_LOW  : natural := 300;
    constant DRV_FILTER_RAN_HI_TH_HIGH : natural := 328;

    constant DRV_FILTERS_ENA_INDEX : natural := 329;

    -- RX Buffer
    constant DRV_ERASE_RX_INDEX   : natural := 350;
    constant DRV_RTSOPT_INDEX     : natural := 351;
    constant DRV_READ_START_INDEX : natural := 352;
    constant DRV_CLR_OVR_INDEX    : natural := 353;

    -- TXT Buffer
    constant DRV_ERASE_TXT2_INDEX : natural := 356;
    constant DRV_TXT1_WR          : natural := 357;

    -- TX Buffer
    constant DRV_ERASE_TXT1_INDEX : natural := 366;
    constant DRV_TXT2_WR          : natural := 367;


    -- Interrupt manager indices 
    constant DRV_INT_CLR_HIGH   : natural := 747;
    constant DRV_INT_CLR_LOW    : natural := 736;

    constant DRV_INT_ENA_SET_HIGH     : natural := 779;
    constant DRV_INT_ENA_SET_LOW      : natural := 768;

    constant DRV_INT_ENA_CLR_HIGH   : natural := 811;
    constant DRV_INT_ENA_CLR_LOW    : natural := 800;

    constant DRV_INT_MASK_SET_HIGH   : natural := 843;
    constant DRV_INT_MASK_SET_LOW    : natural := 832;

    constant DRV_INT_MASK_CLR_HIGH   : natural := 875;
    constant DRV_INT_MASK_CLR_LOW    : natural := 864;

    -- Bus sampling indices
    constant DRV_SAM_INDEX : natural := 372;

    constant DRV_SSP_DELAY_SELECT_HIGH : natural := 374;
    constant DRV_SSP_DELAY_SELECT_LOW : natural := 373;

    constant DRV_SSP_OFFSET_HIGH : natural := 381;
    constant DRV_SSP_OFFSET_LOW : natural := 375;
  
    ----------------------------------------------------------------------------
    -- CAN Core
    ----------------------------------------------------------------------------

    -- Fault Confinement
    constant DRV_EWL_LOW  : natural := 400;
    constant DRV_EWL_HIGH : natural := 407;

    constant DRV_ERP_LOW  : natural := 408;
    constant DRV_ERP_HIGH : natural := 415;

    constant DRV_CTR_VAL_LOW  : natural := 416;
    constant DRV_CTR_VAL_HIGH : natural := 424;

    constant DRV_CTR_SEL_LOW  : natural := 425;
    constant DRV_CTR_SEL_HIGH : natural := 428;

    constant DRV_ERR_CTR_CLR  : natural := 429;

    constant DRV_RXFCRST_INDEX : natural := 430;
    constant DRV_TXFCRST_INDEX : natural := 431;

    -- Operation control FSM
    constant DRV_CAN_FD_ENA_INDEX    : natural := 460;
    constant DRV_RTR_PREF_INDEX      : natural := 461;
    constant DRV_BUS_MON_ENA_INDEX   : natural := 470;
    constant DRV_SELF_TEST_ENA_INDEX : natural := 471;

    constant DRV_RETR_LIM_ENA_INDEX : natural := 465;

    constant DRV_RETR_TH_LOW  : natural := 466;
    constant DRV_RETR_TH_HIGH : natural := 469;

    constant DRV_ABORT_TRAN_INDEX : natural := 472;

    constant DRV_CLR_RX_CTR_INDEX : natural := 473;
    constant DRV_CLR_TX_CTR_INDEX : natural := 474;

    constant DRV_ACK_FORB_INDEX        : natural := 507;
    constant DRV_INT_LOOBACK_ENA_INDEX : natural := 508;

    constant DRV_ENA_INDEX     : natural := 509;
    constant DRV_FD_TYPE_INDEX : natural := 510;

    ----------------------------------------------------------------------------
    -- Event logger
    ----------------------------------------------------------------------------
    constant DRV_TRIG_CONFIG_DATA_HIGH : natural := 551;
    constant DRV_TRIG_CONFIG_DATA_LOW  : natural := 520;

    constant DRV_TRIG_SOF_INDEX         : natural := 552;
    constant DRV_TRIG_ARB_LOST_INDEX    : natural := 553;
    constant DRV_TRIG_REC_VALID_INDEX   : natural := 554;
    constant DRV_TRIG_TRAN_VALID_INDEX  : natural := 555;
    constant DRV_TRIG_OVL_INDEX         : natural := 556;
    constant DRV_TRIG_ERROR_INDEX       : natural := 557;
    constant DRV_TRIG_BRS_INDEX         : natural := 558;
    constant DRV_TRIG_USER_WRITE_INDEX  : natural := 559;
    constant DRV_TRIG_ARB_START_INDEX   : natural := 560;
    constant DRV_TRIG_CONTR_START_INDEX : natural := 561;
    constant DRV_TRIG_DATA_START_INDEX  : natural := 562;
    constant DRV_TRIG_CRC_START_INDEX   : natural := 563;
    constant DRV_TRIG_ACK_REC_INDEX     : natural := 564;
    constant DRV_TRIG_ACK_N_REC_INDEX   : natural := 565;
    constant DRV_TRIG_EWL_REACHED_INDEX : natural := 566;
    constant DRV_TRIG_ERP_CHANGED_INDEX : natural := 567;
    constant DRV_TRIG_TRAN_START_INDEX  : natural := 568;
    constant DRV_TRIG_REC_START_INDEX   : natural := 569;

    constant DRV_CAP_SOF_INDEX         : natural := 580;
    constant DRV_CAP_ARB_LOST_INDEX    : natural := 581;
    constant DRV_CAP_REC_VALID_INDEX   : natural := 582;
    constant DRV_CAP_TRAN_VALID_INDEX  : natural := 583;
    constant DRV_CAP_OVL_INDEX         : natural := 584;
    constant DRV_CAP_ERROR_INDEX       : natural := 585;
    constant DRV_CAP_BRS_INDEX         : natural := 586;
    constant DRV_CAP_ARB_START_INDEX   : natural := 587;
    constant DRV_CAP_CONTR_START_INDEX : natural := 588;
    constant DRV_CAP_DATA_START_INDEX  : natural := 589;
    constant DRV_CAP_CRC_START_INDEX   : natural := 590;
    constant DRV_CAP_ACK_REC_INDEX     : natural := 591;
    constant DRV_CAP_ACK_N_REC_INDEX   : natural := 592;
    constant DRC_CAP_EWL_REACHED_INDEX : natural := 593;
    constant DRV_CAP_ERP_CHANGED_INDEX : natural := 594;
    constant DRV_CAP_TRAN_START_INDEX  : natural := 595;
    constant DRV_CAP_REC_START_INDEX   : natural := 596;
    constant DRV_CAP_SYNC_EDGE_INDEX   : natural := 597;
    constant DRV_CAP_STUFFED_INDEX     : natural := 598;
    constant DRV_CAP_DESTUFFED_INDEX   : natural := 599;
    constant DRV_CAP_OVR_INDEX         : natural := 600;

    constant DRV_LOG_CMD_STR_INDEX  : natural := 610;
    constant DRV_LOG_CMD_ABT_INDEX  : natural := 611;
    constant DRV_LOG_CMD_UP_INDEX   : natural := 612;
    constant DRV_LOG_CMD_DOWN_INDEX : natural := 613;


    ----------------------------------------------------------------------------
    -- RX, TX and TXT Buffer frame format signal indexes
    ----------------------------------------------------------------------------
    --Tx Message format (Format A)
    constant TX_FFW_HIGH : natural := 639;
    constant TX_FFW_LOW  : natural := 608;

    constant TX_IDW_HIGH : natural := 607;
    constant TX_IDW_LOW  : natural := 576;

    --16 Data words for up to 64 bytes of data
    constant TX_DATAW_HIGH : natural := 575;
    constant TX_DATA1W_LOW : natural := 544;
    constant TX_DATAW_LOW  : natural := 64;

    --Txt message format (Format B)
    constant TXT_FFW_HIGH : natural := 639;
    constant TXT_FFW_LOW  : natural := 608;

    constant TXT_IDW_HIGH : natural := 607;
    constant TXT_IDW_LOW  : natural := 576;

    constant TXT_TSLOW_HIGH : natural := 575;
    constant TXT_TSLOW_LOW  : natural := 544;

    constant TXT_TSUPP_HIGH : natural := 543;
    constant TXT_TSUPP_LOW  : natural := 512;

    constant TXT_DATAW_HIGH : natural := 511;
    constant TXT_DATAW_LOW  : natural := 0;


    ----------------------------------------------------------------------------
    -- Status bus Indices
    ----------------------------------------------------------------------------
    constant STAT_OP_STATE_LOW  : natural := 0;
    constant STAT_OP_STATE_HIGH : natural := 1;

    constant STAT_PC_STATE_LOW  : natural := 2;
    constant STAT_PC_STATE_HIGH : natural := 5;

    constant STAT_ARB_LOST_INDEX : natural := 6;

    constant STAT_SET_TRANSC_INDEX : natural := 7;
    constant STAT_SET_REC_INDEX    : natural := 8;
    constant STAT_IS_IDLE_INDEX    : natural := 9;

    constant STAT_SP_CONTROL_HIGH : natural := 11;
    constant STAT_SP_CONTROL_LOW  : natural := 10;

    constant STAT_SSP_RESET_INDEX       : natural := 12;
    constant STAT_TRV_DELAY_CALIB_INDEX : natural := 13;
    constant STAT_SYNC_CONTROL_HIGH     : natural := 15;
    constant STAT_SYNC_CONTROL_LOW      : natural := 14;

    constant STAT_DATA_TX_INDEX     : natural := 16;
    constant STAT_DATA_RX_INDEX     : natural := 17;
    constant STAT_BS_ENABLE_INDEX   : natural := 18;
    constant STAT_FIXED_STUFF_INDEX : natural := 19;
    constant STAT_DATA_HALT_INDEX   : natural := 20;
    constant STAT_BS_LENGTH_HIGH    : natural := 23;
    constant STAT_BS_LENGTH_LOW     : natural := 21;

    -- Error indices
    constant STAT_STUFF_ERROR_INDEX      : natural := 24;
    constant STAT_DESTUFFED_INDEX        : natural := 25;
    constant STAT_BDS_ENA_INDEX          : natural := 26;
    constant STAT_STUFF_ERRROR_ENA_INDEX : natural := 27;
    constant STAT_FIXED_DESTUFF_INDEX    : natural := 28;
    constant STAT_BDS_LENGTH_HIGH        : natural := 31;
    constant STAT_BDS_LENGTH_LOW         : natural := 29;

    -- Transcieve data
    constant STAT_TRAN_IDENT_HIGH : natural := 60;
    constant STAT_TRAN_IDENT_LOW  : natural := 32;

    constant STAT_TRAN_DLC_HIGH : natural := 64;
    constant STAT_TRAN_DLC_LOW  : natural := 61;

    constant STAT_TRAN_IS_RTR_INDEX     : natural := 65;
    constant STAT_TRAN_IDENT_TYPE_INDEX : natural := 66;
    constant STAT_TRAN_FRAME_TYPE_INDEX : natural := 67;
    constant STAT_TRAN_DATA_ACK_INDEX   : natural := 68;
    constant STAT_TRAN_BRS_INDEX        : natural := 69;
    constant STAT_FRAME_STORE_INDEX     : natural := 70;

    -- Error counters and error state
    constant STAT_TX_COUNTER_HIGH         : natural := 79;
    constant STAT_TX_COUNTER_LOW          : natural := 71;
    constant STAT_RX_COUNTER_HIGH         : natural := 89;
    constant STAT_RX_COUNTER_LOW          : natural := 81;
    constant STAT_ERROR_COUNTER_NORM_HIGH : natural := 272;
    constant STAT_ERROR_COUNTER_NORM_LOW  : natural := 257;
    constant STAT_ERROR_COUNTER_FD_HIGH   : natural := 288;
    constant STAT_ERROR_COUNTER_FD_LOW    : natural := 273;

    constant STAT_BR_SHIFTED              : natural := 80;

    constant STAT_ERC_ERR_POS_LOW         : natural := 100;
    constant STAT_ERC_ERR_POS_HIGH        : natural := 104;

    constant STAT_ERC_ERR_TYPE_LOW        : natural := 105;
    constant STAT_ERC_ERR_TYPE_HIGH       : natural := 107;

    constant STAT_ERROR_STATE_HIGH : natural := 109;
    constant STAT_ERROR_STATE_LOW  : natural := 108;

    -- Error signals
    constant STAT_FORM_ERROR_INDEX          : natural := 110;
    constant STAT_CRC_ERROR_INDEX           : natural := 111;
    constant STAT_ACK_ERROR_INDEX           : natural := 112;
    constant STAT_UNKNOWN_STATE_ERROR_INDEX : natural := 113;
    constant STAT_BIT_STUFF_ERROR_INDEX     : natural := 114;
    constant STAT_FIRST_BIT_AFTER_INDEX     : natural := 115;
    constant STAT_REC_VALID_INDEX           : natural := 116;
    constant STAT_TRAN_VALID_INDEX          : natural := 117;
    constant STAT_CONST7_INDEX              : natural := 118;
    constant STAT_CONST14_INDEX             : natural := 119;
    constant STAT_TRANSM_ERROR_INDEX        : natural := 120;

    -- Recieved data interface
    constant STAT_REC_IDENT_HIGH       : natural := 149;
    constant STAT_REC_IDENT_LOW        : natural := 121;
    constant STAT_REC_DLC_HIGH         : natural := 153;
    constant STAT_REC_DLC_LOW          : natural := 150;
    constant STAT_REC_IS_RTR_INDEX     : natural := 154;
    constant STAT_REC_IDENT_TYPE_INDEX : natural := 155;
    constant STAT_REC_FRAME_TYPE_INDEX : natural := 156;
    constant STAT_REC_BRS_INDEX        : natural := 157;
    constant STAT_REC_CRC_HIGH         : natural := 178;
    constant STAT_REC_CRC_LOW          : natural := 158;
    constant STAT_REC_ESI_INDEX        : natural := 179;
    constant STAT_CRC_ENA_INDEX        : natural := 180;
    constant STAT_TRAN_TRIG            : natural := 181;
    constant STAT_REC_TRIG             : natural := 182;
    constant STAT_SAMPLE_NBT_DEL_1     : natural := 183;
    constant STAT_SAMPLE_DBT_DEL_1     : natural := 184;
    constant STAT_SAMPLE_SEC_DEL_1     : natural := 185;

    -- Arbitration lost capture
    constant STAT_ALC_ID_FIELD_HIGH  : natural := 296;
    constant STAT_ALC_ID_FIELD_LOW   : natural := 294;

    constant STAT_ALC_BIT_HIGH  : natural := 293;
    constant STAT_ALC_BIT_LOW  : natural := 289;

    -- Bus traffic registers
    constant STAT_RX_CTR_HIGH : natural := 219;
    constant STAT_RX_CTR_LOW  : natural := 188;

    constant STAT_TX_CTR_HIGH : natural := 251;
    constant STAT_TX_CTR_LOW  : natural := 220;

    constant STAT_ERP_CHANGED_INDEX : natural := 252;
    constant STAT_EWL_REACHED_INDEX : natural := 253;
    constant STAT_ERROR_VALID_INDEX : natural := 254;

    constant STAT_ACK_RECIEVED_OUT_INDEX : natural := 255;

    constant STAT_BIT_ERROR_VALID_INDEX : natural := 256;

    constant STAT_BS_CTR_HIGH : natural := 302;
    constant STAT_BS_CTR_LOW  : natural := 300;

    constant STAT_BD_CTR_HIGH : natural := 305;
    constant STAT_BD_CTR_LOW  : natural := 303;

    constant STAT_TS_HIGH : natural := 369;
    constant STAT_TS_LOW  : natural := 306;

end package;
