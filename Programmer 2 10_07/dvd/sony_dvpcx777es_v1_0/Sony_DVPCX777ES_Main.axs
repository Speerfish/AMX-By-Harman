PROGRAM_NAME='Sony_DVPCX777ES_Main'
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 10/21/2003 AT: 10:55:37               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 10/29/2003 AT: 16:43:05         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 10/21/2003                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)


DEFINE_DEVICE

    dvDVP      = 5001:1:0
                        (*rate = 9600 bps
                          data bits = 8
                          stop bit  = 1
                          parity    = no parity
                          Handshaking = off
                       RS232 port connections FG10-756-10:
                       AMX                   SRP X700 P
                       1 GND                 5 GND
                       2 RXD                 3 TXD  
                       3 TXD                 2 RXD
                       *)
                       
    dvDVPTP    = 128:1:0

    vdvDVP     = 33001:1:0

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
        9,  // scan back 
       10,  // disc skip up
       11,  // disc skip down
       //
       // these aren't really transport buttons
       // but are used to manipulate the touchpanel 
       // 
       12,  // Info button - to toggle popup for playing information
       13,  // Title or Album Number LABEL
       14   // Chapter or Track LABEL 
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
        28  // folder
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
        80,     // CLEAR button
        81,     // ANGLE button
        82,     // SUBTITLE button
        83      // AUDIO button 
    }
    INTEGER nWriteBtns[] =
    {
        1,       // disc number
        2,      // title or album number
        3,      // chapter or track number
        4,      // disc number for go to 
        5,      // title number for go to
        6,       // chapter number for go to 
        7        // disc type 
    }
    
    INTEGER nGoToDisc[] =
    {
        60,     // Jump
        61,     // Digit 0
        62,     // 1
        63,     // 2
        64,     // 3
        65,     // 4
        66,     // 5
        67,     // 6
        68,     // 7
        69,     // Digit 8
        70,     // digit 9
        71,     // Clear
        72,     // select Disc
        73,     // select Title (album) 
        74      // select Chapter (track) 
    }
DEFINE_COMBINE

DEFINE_TYPE

DEFINE_VARIABLE

     DEV dvTPArray[] = { dvDVPTP }

DEFINE_MODULE 'Sony_DVPCX777ES_Comm' mdlDVP_APP(dvDVP, vdvDVP)

DEFINE_MODULE 'Sony_DVPCX777ES_UI' mdlDVP_APP(vdvDVP, dvTPArray, nTransportBtns, nMenuBtns, 
                                                 nKeypadBtns, nWriteBtns, nGoToDisc, nOtherBtns)

