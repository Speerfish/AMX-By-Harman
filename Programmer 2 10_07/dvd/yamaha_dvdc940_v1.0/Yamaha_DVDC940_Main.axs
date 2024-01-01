PROGRAM_NAME='Yamaha_DVDC940_Main'
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 06/02/2004 AT: 10:05:24               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 06/02/2004 AT: 10:05:24         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)


DEFINE_DEVICE

    dvDEVICE      = 5001:1:0
                        (*    cable = FG10-843-04 (NI) / FG10-843-10 (NXI) 
                          rate = 9600 bps
                          data bits = 8
                          stop bit  = 1
                          parity    = no parity
                          Handshaking = on
                       *)
                       
    dvDEVICETP    = 10001:1:0
    vdvDEVICE     = 33001:1:0

DEFINE_CONSTANT

    INTEGER nTransportBtns[] = 

    {
        1,  // power on  
        2,  // power off
        3,  // play
        4,  // stop
        5,  // pause 
        6,  // skip next
        7,  // skip previous
        8,  // scan forward
        9  // scan back 
    }

    INTEGER nMenuBtns[] =
    {
        20, // menu
        21, // top menu
        22, // return
        23, // menu select 'enter'
        24, // cursor up
        25, // cursor down
        26, // cursor left
        27, // cursor right
        28  // clear 
    }
    
    INTEGER nKeyPadBtns[] =
    {
        40, // digit 0         
        41,
        42,
        43,
        44,
        45,
        46,
        47,
        48,
        49  // digit 9 
    }

    INTEGER nOtherBtns [] =
    {
        80,     // DISPLAY button
        81,     // ANGLE button
        82,     // SUBTITLE button
        83,     // AUDIO button
        84,     // REPEAT AB 
        86,      // DISC = 1   
        87,      // DISC = 2  
        88,      // DISC = 3
        89,      // DISC = 4 
        90       // DISC = 5
    }
DEFINE_COMBINE

DEFINE_TYPE

DEFINE_VARIABLE

     DEV dvTPArray[] = { dvDEVICETP }

DEFINE_MODULE 'Yamaha_DVDC940_Comm' mdlDVP_APP(vdvDEVICE, dvDEVICE)

DEFINE_MODULE 'Yamaha_DVDC940_UI' mdlDVP_APP(vdvDEVICE, dvTPArray, nTransportBtns, nMenuBtns, 
                                                 nKeypadBtns ,nOtherBtns)

