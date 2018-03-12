/*******************************************************************************
 * 
 * CAN with Flexible Data-Rate IP Core 
 * 
 * Copyright (C) 2017 Ondrej Ille <ondrej.ille@gmail.com>
 * 
 * Project advisor: Jiri Novak <jnovak@fel.cvut.cz>
 * Department of Measurement         (http://meas.fel.cvut.cz/)
 * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
 * Czech Technical University        (http://www.cvut.cz/)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy 
 * of this VHDL component and associated documentation files (the "Component"), 
 * to deal in the Component without restriction, including without limitation 
 * the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 * and/or sell copies of the Component, and to permit persons to whom the 
 * Component is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in 
 * all copies or substantial portions of the Component.
 * 
 * THE COMPONENT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
 * AUTHORS OR COPYRIGHTHOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE COMPONENT OR THE USE OR OTHER DEALINGS 
 * IN THE COMPONENT.
 * 
 * The CAN protocol is developed by Robert Bosch GmbH and protected by patents. 
 * Anybody who wants to implement this IP core on silicon has to obtain a CAN 
 * protocol license from Bosch.
 * 
*******************************************************************************/

/* This file is autogenerated, DO NOT EDIT! */

#ifndef __CTU_CAN_FD__
#define __CTU_CAN_FD__

/* Regs memory map */
enum regs {
	DEVICE_ID              = 0x0,
	VERSION                = 0x2,
	MODE                   = 0x4,
	COMMAND                = 0x5,
	STATUS                 = 0x6,
	SETTINGS               = 0x7,
	INT_STAT               = 0x8,
	INT_ENA_SET            = 0xc,
	INT_ENA_CLR           = 0x10,
	INT_MASK_SET          = 0x14,
	INT_MASK_CLR          = 0x18,
	BTR                   = 0x1c,
	BTR_FD                = 0x1e,
	ALC                   = 0x20,
	SJW                   = 0x21,
	BRP                   = 0x22,
	BRP_FD                = 0x23,
	EWL                   = 0x24,
	ERP                   = 0x25,
	FAULT_STATE           = 0x26,
	RXC                   = 0x28,
	TXC                   = 0x2a,
	ERR_NORM              = 0x2c,
	ERR_FD                = 0x2e,
	CTR_PRES              = 0x30,
	FILTER_A_MASK         = 0x34,
	FILTER_A_VAL          = 0x38,
	FILTER_B_MASK         = 0x3c,
	FILTER_B_VAL          = 0x40,
	FILTER_C_MASK         = 0x44,
	FILTER_C_VAL          = 0x48,
	FILTER_RAN_LOW        = 0x4c,
	FILTER_RAN_HIGH       = 0x50,
	FILTER_CONTROL        = 0x54,
	FILTER_STATUS         = 0x56,
	RX_MEM_INFO           = 0x58,
	RX_POINTERS           = 0x5c,
	RX_STATUS             = 0x60,
	RX_SETTINGS           = 0x62,
	RX_DATA               = 0x64,
	TX_STATUS             = 0x68,
	TX_COMMAND            = 0x6c,
	TX_PRIORITY           = 0x70,
	ERR_CAPT              = 0x74,
	TRV_DELAY             = 0x78,
	RX_COUNTER            = 0x7c,
	TX_COUNTER            = 0x80,
	DEBUG_REGISTER        = 0x84,
	YOLO_REG              = 0x88,
	TXTB1_DATA_1         = 0x100,
	TXTB1_DATA_2         = 0x104,
	TXTB1_DATA_20        = 0x14c,
	TXTB2_DATA_1         = 0x200,
	TXTB2_DATA_2         = 0x204,
	TXTB2_DATA_20        = 0x24c,
	TXTB3_DATA_1         = 0x300,
	TXTB3_DATA_2         = 0x304,
	TXTB3_DATA_20        = 0x34c,
	TXTB4_DATA_1         = 0x400,
	TXTB4_DATA_2         = 0x404,
	TXTB4_DATA_20        = 0x44c,
	LOG_TRIG_CONFIG      = 0x500,
	LOG_CAPT_CONFIG      = 0x504,
	LOG_STATUS           = 0x508,
	LOG_POINTERS         = 0x50a,
	LOG_COMMAND          = 0x50c,
	LOG_CAPT_EVENT_1     = 0x510,
	LOG_CAPT_EVENT_2     = 0x514,
};


/* Register descriptions: */
union device_id_version {
	uint32_t u32;
	struct device_id_version_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* DEVICE_ID */
		uint32_t device_id              : 16;
  /* VERSION */
		uint32_t ver_minor               : 8;
		uint32_t ver_major               : 8;
#else
		uint32_t ver_major               : 8;
		uint32_t ver_minor               : 8;
		uint32_t device_id              : 16;
#endif
	} s;
};

union mode_command_status_settings {
	uint32_t u32;
	struct mode_command_status_settings_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* MODE */
		uint32_t rst                     : 1;
		uint32_t lom                     : 1;
		uint32_t stm                     : 1;
		uint32_t afm                     : 1;
		uint32_t fde                     : 1;
		uint32_t rtr_pref                : 1;
		uint32_t tsm                     : 1;
		uint32_t acf                     : 1;
		uint32_t reserved_8              : 1;
  /* COMMAND */
		uint32_t at                      : 1;
		uint32_t rrb                     : 1;
		uint32_t cdo                     : 1;
		uint32_t reserved_15_12          : 4;
  /* STATUS */
		uint32_t rbs                     : 1;
		uint32_t dos                     : 1;
		uint32_t tbs                     : 1;
		uint32_t et                      : 1;
		uint32_t rs                      : 1;
		uint32_t ts                      : 1;
		uint32_t es                      : 1;
		uint32_t bs                      : 1;
  /* SETTINGS */
		uint32_t rtrle                   : 1;
		uint32_t rtr_th                  : 4;
		uint32_t int_loop                : 1;
		uint32_t ena                     : 1;
		uint32_t fd_type                 : 1;
#else
		uint32_t fd_type                 : 1;
		uint32_t ena                     : 1;
		uint32_t int_loop                : 1;
		uint32_t rtr_th                  : 4;
		uint32_t rtrle                   : 1;
		uint32_t bs                      : 1;
		uint32_t es                      : 1;
		uint32_t ts                      : 1;
		uint32_t rs                      : 1;
		uint32_t et                      : 1;
		uint32_t tbs                     : 1;
		uint32_t dos                     : 1;
		uint32_t rbs                     : 1;
		uint32_t reserved_15_12          : 4;
		uint32_t cdo                     : 1;
		uint32_t rrb                     : 1;
		uint32_t at                      : 1;
		uint32_t reserved_8              : 1;
		uint32_t acf                     : 1;
		uint32_t tsm                     : 1;
		uint32_t rtr_pref                : 1;
		uint32_t fde                     : 1;
		uint32_t afm                     : 1;
		uint32_t stm                     : 1;
		uint32_t lom                     : 1;
		uint32_t rst                     : 1;
#endif
	} s;
};

union int_stat {
	uint32_t u32;
	struct int_stat_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* INT_STAT */
		uint32_t ri                      : 1;
		uint32_t ti                      : 1;
		uint32_t ei                      : 1;
		uint32_t doi                     : 1;
		uint32_t epi                     : 1;
		uint32_t ali                     : 1;
		uint32_t bei                     : 1;
		uint32_t lfi                     : 1;
		uint32_t rfi                     : 1;
		uint32_t bsi                     : 1;
		uint32_t rbnei                   : 1;
		uint32_t txbhci                  : 1;
		uint32_t reserved_31_12         : 20;
#else
		uint32_t reserved_31_12         : 20;
		uint32_t txbhci                  : 1;
		uint32_t rbnei                   : 1;
		uint32_t bsi                     : 1;
		uint32_t rfi                     : 1;
		uint32_t lfi                     : 1;
		uint32_t bei                     : 1;
		uint32_t ali                     : 1;
		uint32_t epi                     : 1;
		uint32_t doi                     : 1;
		uint32_t ei                      : 1;
		uint32_t ti                      : 1;
		uint32_t ri                      : 1;
#endif
	} s;
};

union int_ena_set {
	uint32_t u32;
	struct int_ena_set_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* INT_ENA_SET */
		uint32_t int_ena_set            : 12;
		uint32_t reserved_31_12         : 20;
#else
		uint32_t reserved_31_12         : 20;
		uint32_t int_ena_set            : 12;
#endif
	} s;
};

union int_ena_clr {
	uint32_t u32;
	struct int_ena_clr_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* INT_ENA_CLR */
		uint32_t int_ena_clr            : 12;
		uint32_t reserved_31_12         : 20;
#else
		uint32_t reserved_31_12         : 20;
		uint32_t int_ena_clr            : 12;
#endif
	} s;
};

union int_mask_set {
	uint32_t u32;
	struct int_mask_set_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* INT_MASK_SET */
		uint32_t int_mask_set           : 12;
		uint32_t reserved_31_12         : 20;
#else
		uint32_t reserved_31_12         : 20;
		uint32_t int_mask_set           : 12;
#endif
	} s;
};

union int_mask_clr {
	uint32_t u32;
	struct int_mask_clr_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* INT_MASK_CLR */
		uint32_t int_mask_clr           : 12;
		uint32_t reserved_31_12         : 20;
#else
		uint32_t reserved_31_12         : 20;
		uint32_t int_mask_clr           : 12;
#endif
	} s;
};

union btr_btr_fd {
	uint32_t u32;
	struct btr_btr_fd_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* BTR */
		uint32_t prop                    : 6;
		uint32_t ph1                     : 5;
		uint32_t ph2                     : 5;
  /* BTR_FD */
		uint32_t prop_fd                 : 6;
		uint32_t ph1_fd                  : 4;
		uint32_t reserved_26             : 1;
		uint32_t ph2_fd                  : 4;
		uint32_t reserved_31             : 1;
#else
		uint32_t reserved_31             : 1;
		uint32_t ph2_fd                  : 4;
		uint32_t reserved_26             : 1;
		uint32_t ph1_fd                  : 4;
		uint32_t prop_fd                 : 6;
		uint32_t ph2                     : 5;
		uint32_t ph1                     : 5;
		uint32_t prop                    : 6;
#endif
	} s;
};

union alc_sjw_brp_brp_fd {
	uint32_t u32;
	struct alc_sjw_brp_brp_fd_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* ALC */
		uint32_t alc_val                 : 5;
		uint32_t reserved_7_5            : 3;
  /* SJW */
		uint32_t sjw                     : 4;
		uint32_t sjw_fd                  : 4;
  /* BRP */
		uint32_t brp                     : 6;
		uint32_t reserved_23_22          : 2;
  /* BRP_FD */
		uint32_t brp_fd                  : 6;
		uint32_t reserved_31_30          : 2;
#else
		uint32_t reserved_31_30          : 2;
		uint32_t brp_fd                  : 6;
		uint32_t reserved_23_22          : 2;
		uint32_t brp                     : 6;
		uint32_t sjw_fd                  : 4;
		uint32_t sjw                     : 4;
		uint32_t reserved_7_5            : 3;
		uint32_t alc_val                 : 5;
#endif
	} s;
};

union ewl_erp_fault_state {
	uint32_t u32;
	struct ewl_erp_fault_state_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* EWL */
		uint32_t ewl_limit               : 8;
  /* ERP */
		uint32_t erp_limit               : 8;
  /* FAULT_STATE */
		uint32_t era                     : 1;
		uint32_t erp                     : 1;
		uint32_t bof                     : 1;
		uint32_t reserved_31_19         : 13;
#else
		uint32_t reserved_31_19         : 13;
		uint32_t bof                     : 1;
		uint32_t erp                     : 1;
		uint32_t era                     : 1;
		uint32_t erp_limit               : 8;
		uint32_t ewl_limit               : 8;
#endif
	} s;
};

union rxc_txc {
	uint32_t u32;
	struct rxc_txc_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* RXC */
		uint32_t rxc_val                : 16;
  /* TXC */
		uint32_t txc_val                : 16;
#else
		uint32_t txc_val                : 16;
		uint32_t rxc_val                : 16;
#endif
	} s;
};

union err_norm_err_fd {
	uint32_t u32;
	struct err_norm_err_fd_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* ERR_NORM */
		uint32_t err_norm_val           : 16;
  /* ERR_FD */
		uint32_t err_fd_val             : 16;
#else
		uint32_t err_fd_val             : 16;
		uint32_t err_norm_val           : 16;
#endif
	} s;
};

union ctr_pres {
	uint32_t u32;
	struct ctr_pres_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* CTR_PRES */
		uint32_t ctpv                    : 9;
		uint32_t ptx                     : 1;
		uint32_t prx                     : 1;
		uint32_t enorm                   : 1;
		uint32_t efd                     : 1;
		uint32_t reserved_31_13         : 19;
#else
		uint32_t reserved_31_13         : 19;
		uint32_t efd                     : 1;
		uint32_t enorm                   : 1;
		uint32_t prx                     : 1;
		uint32_t ptx                     : 1;
		uint32_t ctpv                    : 9;
#endif
	} s;
};

union filter_a_mask {
	uint32_t u32;
	struct filter_a_mask_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* FILTER_A_MASK */
		uint32_t bit_mask_a_val         : 29;
		uint32_t reserved_31_29          : 3;
#else
		uint32_t reserved_31_29          : 3;
		uint32_t bit_mask_a_val         : 29;
#endif
	} s;
};

union filter_a_val {
	uint32_t u32;
	struct filter_a_val_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* FILTER_A_VAL */
		uint32_t bit_val_a_val          : 29;
		uint32_t reserved_31_29          : 3;
#else
		uint32_t reserved_31_29          : 3;
		uint32_t bit_val_a_val          : 29;
#endif
	} s;
};

union filter_b_mask {
	uint32_t u32;
	struct filter_b_mask_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* FILTER_B_MASK */
		uint32_t bit_mask_b_val         : 29;
		uint32_t reserved_31_29          : 3;
#else
		uint32_t reserved_31_29          : 3;
		uint32_t bit_mask_b_val         : 29;
#endif
	} s;
};

union filter_b_val {
	uint32_t u32;
	struct filter_b_val_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* FILTER_B_VAL */
		uint32_t bit_val_b_val          : 29;
		uint32_t reserved_31_29          : 3;
#else
		uint32_t reserved_31_29          : 3;
		uint32_t bit_val_b_val          : 29;
#endif
	} s;
};

union filter_c_mask {
	uint32_t u32;
	struct filter_c_mask_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* FILTER_C_MASK */
		uint32_t bit_mask_c_val         : 29;
		uint32_t reserved_31_29          : 3;
#else
		uint32_t reserved_31_29          : 3;
		uint32_t bit_mask_c_val         : 29;
#endif
	} s;
};

union filter_c_val {
	uint32_t u32;
	struct filter_c_val_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* FILTER_C_VAL */
		uint32_t bit_val_c_val          : 29;
		uint32_t reserved_31_29          : 3;
#else
		uint32_t reserved_31_29          : 3;
		uint32_t bit_val_c_val          : 29;
#endif
	} s;
};

union filter_ran_low {
	uint32_t u32;
	struct filter_ran_low_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* FILTER_RAN_LOW */
		uint32_t bit_ran_low_val        : 29;
		uint32_t reserved_31_29          : 3;
#else
		uint32_t reserved_31_29          : 3;
		uint32_t bit_ran_low_val        : 29;
#endif
	} s;
};

union filter_ran_high {
	uint32_t u32;
	struct filter_ran_high_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* FILTER_RAN_HIGH */
		uint32_t bit_ran_high_val       : 29;
		uint32_t reserved_31_29          : 3;
#else
		uint32_t reserved_31_29          : 3;
		uint32_t bit_ran_high_val       : 29;
#endif
	} s;
};

union filter_control_filter_status {
	uint32_t u32;
	struct filter_control_filter_status_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* FILTER_CONTROL */
		uint32_t fanb                    : 1;
		uint32_t fane                    : 1;
		uint32_t fafb                    : 1;
		uint32_t fafe                    : 1;
		uint32_t fbnb                    : 1;
		uint32_t fbne                    : 1;
		uint32_t fbfb                    : 1;
		uint32_t fbfe                    : 1;
		uint32_t fcnb                    : 1;
		uint32_t fcne                    : 1;
		uint32_t fcfb                    : 1;
		uint32_t fcfe                    : 1;
		uint32_t frnb                    : 1;
		uint32_t frne                    : 1;
		uint32_t frfb                    : 1;
		uint32_t frfe                    : 1;
  /* FILTER_STATUS */
		uint32_t sfa                     : 1;
		uint32_t sfb                     : 1;
		uint32_t sfc                     : 1;
		uint32_t sfr                     : 1;
		uint32_t reserved_31_20         : 12;
#else
		uint32_t reserved_31_20         : 12;
		uint32_t sfr                     : 1;
		uint32_t sfc                     : 1;
		uint32_t sfb                     : 1;
		uint32_t sfa                     : 1;
		uint32_t frfe                    : 1;
		uint32_t frfb                    : 1;
		uint32_t frne                    : 1;
		uint32_t frnb                    : 1;
		uint32_t fcfe                    : 1;
		uint32_t fcfb                    : 1;
		uint32_t fcne                    : 1;
		uint32_t fcnb                    : 1;
		uint32_t fbfe                    : 1;
		uint32_t fbfb                    : 1;
		uint32_t fbne                    : 1;
		uint32_t fbnb                    : 1;
		uint32_t fafe                    : 1;
		uint32_t fafb                    : 1;
		uint32_t fane                    : 1;
		uint32_t fanb                    : 1;
#endif
	} s;
};

union rx_mem_info {
	uint32_t u32;
	struct rx_mem_info_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* RX_MEM_INFO */
		uint32_t rx_buff_size           : 13;
		uint32_t reserved_15_13          : 3;
		uint32_t rx_mem_free            : 13;
		uint32_t reserved_31_29          : 3;
#else
		uint32_t reserved_31_29          : 3;
		uint32_t rx_mem_free            : 13;
		uint32_t reserved_15_13          : 3;
		uint32_t rx_buff_size           : 13;
#endif
	} s;
};

union rx_pointers {
	uint32_t u32;
	struct rx_pointers_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* RX_POINTERS */
		uint32_t rx_wpp                 : 12;
		uint32_t reserved_15_12          : 4;
		uint32_t rx_rpp                 : 12;
		uint32_t reserved_31_28          : 4;
#else
		uint32_t reserved_31_28          : 4;
		uint32_t rx_rpp                 : 12;
		uint32_t reserved_15_12          : 4;
		uint32_t rx_wpp                 : 12;
#endif
	} s;
};

union rx_status_rx_settings {
	uint32_t u32;
	struct rx_status_rx_settings_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* RX_STATUS */
		uint32_t rx_empty                : 1;
		uint32_t rx_full                 : 1;
		uint32_t reserved_3_2            : 2;
		uint32_t rx_frc                 : 11;
		uint32_t reserved_15             : 1;
  /* RX_SETTINGS */
		uint32_t rtsop                   : 1;
		uint32_t reserved_31_17         : 15;
#else
		uint32_t reserved_31_17         : 15;
		uint32_t rtsop                   : 1;
		uint32_t reserved_15             : 1;
		uint32_t rx_frc                 : 11;
		uint32_t reserved_3_2            : 2;
		uint32_t rx_full                 : 1;
		uint32_t rx_empty                : 1;
#endif
	} s;
};

union rx_data {
	uint32_t u32;
	struct rx_data_s {
  /* RX_DATA */
		uint32_t rx_data                : 32;
	} s;
};

union tx_status {
	uint32_t u32;
	struct tx_status_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* TX_STATUS */
		uint32_t tx1s                    : 4;
		uint32_t tx2s                    : 4;
		uint32_t tx3s                    : 4;
		uint32_t tx4s                    : 4;
		uint32_t reserved_31_16         : 16;
#else
		uint32_t reserved_31_16         : 16;
		uint32_t tx4s                    : 4;
		uint32_t tx3s                    : 4;
		uint32_t tx2s                    : 4;
		uint32_t tx1s                    : 4;
#endif
	} s;
};

union tx_command {
	uint32_t u32;
	struct tx_command_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* TX_COMMAND */
		uint32_t txce                    : 1;
		uint32_t txcr                    : 1;
		uint32_t txca                    : 1;
		uint32_t reserved_7_3            : 5;
		uint32_t txi1                    : 1;
		uint32_t txi2                    : 1;
		uint32_t txi3                    : 1;
		uint32_t txi4                    : 1;
		uint32_t reserved_31_12         : 20;
#else
		uint32_t reserved_31_12         : 20;
		uint32_t txi4                    : 1;
		uint32_t txi3                    : 1;
		uint32_t txi2                    : 1;
		uint32_t txi1                    : 1;
		uint32_t reserved_7_3            : 5;
		uint32_t txca                    : 1;
		uint32_t txcr                    : 1;
		uint32_t txce                    : 1;
#endif
	} s;
};

union tx_priority {
	uint32_t u32;
	struct tx_priority_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* TX_PRIORITY */
		uint32_t txt1p                   : 3;
		uint32_t reserved_3              : 1;
		uint32_t txt2p                   : 3;
		uint32_t reserved_7              : 1;
		uint32_t txt3p                   : 3;
		uint32_t reserved_11             : 1;
		uint32_t txt4p                   : 3;
		uint32_t reserved_31_15         : 17;
#else
		uint32_t reserved_31_15         : 17;
		uint32_t txt4p                   : 3;
		uint32_t reserved_11             : 1;
		uint32_t txt3p                   : 3;
		uint32_t reserved_7              : 1;
		uint32_t txt2p                   : 3;
		uint32_t reserved_3              : 1;
		uint32_t txt1p                   : 3;
#endif
	} s;
};

union err_capt {
	uint32_t u32;
	struct err_capt_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* ERR_CAPT */
		uint32_t err_pos                 : 5;
		uint32_t err_type                : 3;
		uint32_t reserved_31_8          : 24;
#else
		uint32_t reserved_31_8          : 24;
		uint32_t err_type                : 3;
		uint32_t err_pos                 : 5;
#endif
	} s;
};

union trv_delay {
	uint32_t u32;
	struct trv_delay_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* TRV_DELAY */
		uint32_t trv_delay_value        : 16;
		uint32_t reserved_31_16         : 16;
#else
		uint32_t reserved_31_16         : 16;
		uint32_t trv_delay_value        : 16;
#endif
	} s;
};

union rx_counter {
	uint32_t u32;
	struct rx_counter_s {
  /* RX_COUNTER */
		uint32_t rx_counter_val         : 32;
	} s;
};

union tx_counter {
	uint32_t u32;
	struct tx_counter_s {
  /* TX_COUNTER */
		uint32_t tx_counter_val         : 32;
	} s;
};

union debug_register {
	uint32_t u32;
	struct debug_register_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* DEBUG_REGISTER */
		uint32_t stuff_count             : 3;
		uint32_t destuff_count           : 3;
		uint32_t pc_arb                  : 1;
		uint32_t pc_con                  : 1;
		uint32_t pc_dat                  : 1;
		uint32_t pc_crc                  : 1;
		uint32_t pc_eof                  : 1;
		uint32_t pc_ovr                  : 1;
		uint32_t pc_int                  : 1;
		uint32_t reserved_31_13         : 19;
#else
		uint32_t reserved_31_13         : 19;
		uint32_t pc_int                  : 1;
		uint32_t pc_ovr                  : 1;
		uint32_t pc_eof                  : 1;
		uint32_t pc_crc                  : 1;
		uint32_t pc_dat                  : 1;
		uint32_t pc_con                  : 1;
		uint32_t pc_arb                  : 1;
		uint32_t destuff_count           : 3;
		uint32_t stuff_count             : 3;
#endif
	} s;
};

union yolo_reg {
	uint32_t u32;
	struct yolo_reg_s {
  /* YOLO_REG */
		uint32_t yolo_val               : 32;
	} s;
};

union txtb1_data_1 {
	uint32_t u32;
	struct txtb1_data_1_s {
  /* TXTB1_DATA_1 */
		uint32_t txtb1_data_1           : 32;
	} s;
};

union txtb1_data_2 {
	uint32_t u32;
	struct txtb1_data_2_s {
  /* TXTB1_DATA_2 */
		uint32_t txtb1_data_2           : 32;
	} s;
};

union txtb1_data_20 {
	uint32_t u32;
	struct txtb1_data_20_s {
  /* TXTB1_DATA_20 */
		uint32_t txtb1_data_20          : 32;
	} s;
};

union txtb2_data_1 {
	uint32_t u32;
	struct txtb2_data_1_s {
  /* TXTB2_DATA_1 */
		uint32_t txtb2_data_1           : 32;
	} s;
};

union txtb2_data_2 {
	uint32_t u32;
	struct txtb2_data_2_s {
  /* TXTB2_DATA_2 */
		uint32_t txtb2_data_2           : 32;
	} s;
};

union txtb2_data_20 {
	uint32_t u32;
	struct txtb2_data_20_s {
  /* TXTB2_DATA_20 */
		uint32_t txtb2_data_20          : 32;
	} s;
};

union txtb3_data_1 {
	uint32_t u32;
	struct txtb3_data_1_s {
  /* TXTB3_DATA_1 */
		uint32_t txtb3_data_1           : 32;
	} s;
};

union txtb3_data_2 {
	uint32_t u32;
	struct txtb3_data_2_s {
  /* TXTB3_DATA_2 */
		uint32_t txtb3_data_2           : 32;
	} s;
};

union txtb3_data_20 {
	uint32_t u32;
	struct txtb3_data_20_s {
  /* TXTB3_DATA_20 */
		uint32_t txtb3_data_20          : 32;
	} s;
};

union txtb4_data_1 {
	uint32_t u32;
	struct txtb4_data_1_s {
  /* TXTB4_DATA_1 */
		uint32_t txtb4_data_1           : 32;
	} s;
};

union txtb4_data_2 {
	uint32_t u32;
	struct txtb4_data_2_s {
  /* TXTB4_DATA_2 */
		uint32_t txtb4_data_2           : 32;
	} s;
};

union txtb4_data_20 {
	uint32_t u32;
	struct txtb4_data_20_s {
  /* TXTB4_DATA_20 */
		uint32_t txtb4_data_20          : 32;
	} s;
};

union log_trig_config {
	uint32_t u32;
	struct log_trig_config_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* LOG_TRIG_CONFIG */
		uint32_t t_sof                   : 1;
		uint32_t t_arbl                  : 1;
		uint32_t t_rev                   : 1;
		uint32_t t_trv                   : 1;
		uint32_t t_ovl                   : 1;
		uint32_t t_err                   : 1;
		uint32_t t_brs                   : 1;
		uint32_t t_usrw                  : 1;
		uint32_t t_arbs                  : 1;
		uint32_t t_ctrs                  : 1;
		uint32_t t_dats                  : 1;
		uint32_t t_crcs                  : 1;
		uint32_t t_ackr                  : 1;
		uint32_t t_acknr                 : 1;
		uint32_t t_ewlr                  : 1;
		uint32_t t_erpc                  : 1;
		uint32_t t_trs                   : 1;
		uint32_t t_res                   : 1;
		uint32_t reserved_31_18         : 14;
#else
		uint32_t reserved_31_18         : 14;
		uint32_t t_res                   : 1;
		uint32_t t_trs                   : 1;
		uint32_t t_erpc                  : 1;
		uint32_t t_ewlr                  : 1;
		uint32_t t_acknr                 : 1;
		uint32_t t_ackr                  : 1;
		uint32_t t_crcs                  : 1;
		uint32_t t_dats                  : 1;
		uint32_t t_ctrs                  : 1;
		uint32_t t_arbs                  : 1;
		uint32_t t_usrw                  : 1;
		uint32_t t_brs                   : 1;
		uint32_t t_err                   : 1;
		uint32_t t_ovl                   : 1;
		uint32_t t_trv                   : 1;
		uint32_t t_rev                   : 1;
		uint32_t t_arbl                  : 1;
		uint32_t t_sof                   : 1;
#endif
	} s;
};

union log_capt_config {
	uint32_t u32;
	struct log_capt_config_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* LOG_CAPT_CONFIG */
		uint32_t c_sof                   : 1;
		uint32_t c_arbl                  : 1;
		uint32_t c_rev                   : 1;
		uint32_t c_trv                   : 1;
		uint32_t c_ovl                   : 1;
		uint32_t c_err                   : 1;
		uint32_t c_brs                   : 1;
		uint32_t c_arbs                  : 1;
		uint32_t c_ctrs                  : 1;
		uint32_t c_dats                  : 1;
		uint32_t c_crcs                  : 1;
		uint32_t c_ackr                  : 1;
		uint32_t c_acknr                 : 1;
		uint32_t c_ewlr                  : 1;
		uint32_t c_erc                   : 1;
		uint32_t c_trs                   : 1;
		uint32_t c_res                   : 1;
		uint32_t c_syne                  : 1;
		uint32_t c_stuff                 : 1;
		uint32_t c_destuff               : 1;
		uint32_t c_ovr                   : 1;
		uint32_t reserved_31_21         : 11;
#else
		uint32_t reserved_31_21         : 11;
		uint32_t c_ovr                   : 1;
		uint32_t c_destuff               : 1;
		uint32_t c_stuff                 : 1;
		uint32_t c_syne                  : 1;
		uint32_t c_res                   : 1;
		uint32_t c_trs                   : 1;
		uint32_t c_erc                   : 1;
		uint32_t c_ewlr                  : 1;
		uint32_t c_acknr                 : 1;
		uint32_t c_ackr                  : 1;
		uint32_t c_crcs                  : 1;
		uint32_t c_dats                  : 1;
		uint32_t c_ctrs                  : 1;
		uint32_t c_arbs                  : 1;
		uint32_t c_brs                   : 1;
		uint32_t c_err                   : 1;
		uint32_t c_ovl                   : 1;
		uint32_t c_trv                   : 1;
		uint32_t c_rev                   : 1;
		uint32_t c_arbl                  : 1;
		uint32_t c_sof                   : 1;
#endif
	} s;
};

union log_status_log_pointers {
	uint32_t u32;
	struct log_status_log_pointers_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* LOG_STATUS */
		uint32_t log_cfg                 : 1;
		uint32_t log_rdy                 : 1;
		uint32_t log_run                 : 1;
		uint32_t reserved_6_3            : 4;
		uint32_t log_exist               : 1;
		uint32_t log_size                : 8;
  /* LOG_POINTERS */
		uint32_t log_wpp                 : 8;
		uint32_t log_rpp                 : 8;
#else
		uint32_t log_rpp                 : 8;
		uint32_t log_wpp                 : 8;
		uint32_t log_size                : 8;
		uint32_t log_exist               : 1;
		uint32_t reserved_6_3            : 4;
		uint32_t log_run                 : 1;
		uint32_t log_rdy                 : 1;
		uint32_t log_cfg                 : 1;
#endif
	} s;
};

union log_command {
	uint32_t u32;
	struct log_command_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* LOG_COMMAND */
		uint32_t log_str                 : 1;
		uint32_t log_abt                 : 1;
		uint32_t log_up                  : 1;
		uint32_t log_down                : 1;
		uint32_t reserved_31_4          : 28;
#else
		uint32_t reserved_31_4          : 28;
		uint32_t log_down                : 1;
		uint32_t log_up                  : 1;
		uint32_t log_abt                 : 1;
		uint32_t log_str                 : 1;
#endif
	} s;
};

union log_capt_event_1 {
	uint32_t u32;
	struct log_capt_event_1_s {
  /* LOG_CAPT_EVENT_1 */
		uint32_t event_ts_48_16         : 32;
	} s;
};

union log_capt_event_2 {
	uint32_t u32;
	struct log_capt_event_2_s {
#ifdef __BIG_ENDIAN_BITFIELD
  /* LOG_CAPT_EVENT_2 */
		uint32_t evnt_type               : 5;
		uint32_t evnt_den                : 3;
		uint32_t evnt_det                : 5;
		uint32_t evnt_dea                : 3;
		uint32_t event_ts_15_0          : 16;
#else
		uint32_t event_ts_15_0          : 16;
		uint32_t evnt_dea                : 3;
		uint32_t evnt_det                : 5;
		uint32_t evnt_den                : 3;
		uint32_t evnt_type               : 5;
#endif
	} s;
};

#endif
