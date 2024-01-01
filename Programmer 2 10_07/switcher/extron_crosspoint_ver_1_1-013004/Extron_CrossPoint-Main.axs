PROGRAM_NAME='Extron_CrossPoint-Main'
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 12/13/2002 AT: 14:11:58               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 01/07/2004 AT: 09:06:03         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 12/13/2002                              *)
(*                                                         *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)

(***********************************************************)
(* System Type : Netlinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

    dvDEVICE  = 5001:1:0             // PHYSICAL SWITCHER DEVICE
                                (*rate = 9600 bps
                                  data bits = 8
                                  stop bit  = 1
                                  parity    = no parity
                                  Handshaking = off
                                RS232 port connections FG10-752-10:
                                AMX                   Switcher
                                1 GND                 5 GND
                                2 RXD                 2 TXD  
                                3 TXD                 3 RXD
                                *)
    vdvDEVICE = 33001:1:0            // VIRTUAL DEVICE
    dvSwitcherTP = 128:1:0
    vdvSwitcherTP = 33002:1:0
   
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
    INTEGER nSwitcherBtns [] =
    {
        1,      // Input selection button
        2,      // Output selection button
        8,      // preset selection button
        11,     // set gain for the specified input
        3,      // Level = both
        4,      // level = audio    
        5,      // level = video 
        6,      // connect (switch) 
        7,      // query connection for specified output
        9,      // recall specified preset
        10,     // save current settings as specified preset
        12,     // query the gain for the specified input 
        13,     // positive/negative flag
        14,     // device_scale flag 
        15,     // power off 
        16      // power on  
    }
    INTEGER nWriteBtns [] =
    {
        1,      // specified input 
        2,      // specified output
        3,      // specified preset
        4,      // gain value
        5       // displays feedback from device 
    }
    
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
    DEV dvTPArray[] = { vdvSwitcherTP, dvSwitcherTP }
(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING
(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE
(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

DEFINE_MODULE 'Extron_CrossPoint-COMM' COMM1(vdvDEVICE, dvDEVICE)
DEFINE_MODULE 'Extron_CrossPoint-UI' TP1(vdvDEVICE, dvTPArray, nSwitcherBtns, nWriteBtns)
(***********************************************************)
(*                THE EVENTS GOES BELOW                    *)
(***********************************************************)
DEFINE_EVENT
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)