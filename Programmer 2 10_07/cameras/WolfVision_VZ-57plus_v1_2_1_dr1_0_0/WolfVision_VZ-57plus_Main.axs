PROGRAM_NAME='WolfVision_vz-57plus_Main'
(***********************************************************)
(* FILE CREATED ON: 2005/12/14 (HGaechter)                 *)
(***********************************************************)
(* FILE LAST MODIFIED ON: 2005/12/20 (HGaechter)           *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
dvDocCam  =  5001:02:0
vdvDocCam = 41001:01:0
dvTP      = 10001:01:0

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
INTEGER nBtns[]= 
{   31, //  1 POWER ON/OFF
    32, //  2 LIVE IMAGE
    33, //  3 IMAGE TURN
    34, //  4 EXT. INPUT
    35, //  5 PRESET 1
    36, //  6 PRESET 2
    37, //  7 PRESET 3
    38, //  8 ZOOM TELE
    39, //  9 ZOOM WIDE 
    40, // 10 FOCUS NEAR
    41, // 11 FOCUS FAR
    42, // 12 ONE PUSH AUTO FOCUS
    43, // 13 IRIS CLOSE
    44, // 14 IRIS OPEN
    45, // 15 AUTO IRIS 
    46, // 16 TEXT MODE
    47, // 17 MEMORY 1  
    48, // 18 MEMORY 2  
    49, // 19 MEMORY 3  
    50, // 20 MEMORY 4  
    51, // 21 MEMORY 5  
    52, // 22 MEMORY 6  
    53, // 23 MEMORY 7  
    54, // 24 MEMORY 8  
    55, // 25 MEMORY 9  
    56, // 26 SHOW ALL
    57, // 27 LIGHT
    58, // 28 LIGHT BOX 
    59, // 29 ALL LIGHTS OFF 
    60, // 30 MENU
    61, // 31 MENU UP
    62, // 32 MENU DOWN
    63, // 33 MENU LEFT
    64, // 34 MENU RIGHT
    65, // 35 HELP
    66, // 36 PRESET A4
    67, // 37 PRESET A5
    68, // 38 PRESET A6
    69, // 39 PRESET A7
    70, // 40 PRESET A8
    71, // 41 PRESET DIA
    72, // 42 BLACK/WHITE
    73, // 43 FREEZE
    74, // 44 POS/NEG
    75, // 45 WHITE BALANCE
    76, // 46 IMAGE MUTE
    78, // 47 MIRROR UP
    79, // 48 MIRROR DOWN
    80, // 49 ARM
    81, // 50 MACRO
    91, // 51 ZOOM LEVEL BAR
    92, // 52 FOCUS LEVEL BAR
    93, // 53 IRIS LEVEL BAR
    94  // 54 MIRROR LEVEL BAR
}

INTEGER nLvls[] =
{
    101, // 1 ZOOM LEVEL TEXT
    102, // 2 FOCUS LEVEL TEXT
    103, // 3 IRIS LEVEL TEXT
    104  // 4 MIRROR LEVEL TEXT
}

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

DEFINE_MODULE 'WolfVision_VZ-57plus_UI' ui(vdvDocCam, nBtns, nLvls, dvTP)

(***********************************************************)
(* This command is used for static device binding with no  *)
(* dynamic device discovery (DDD)                          *)
(***********************************************************)
DEFINE_MODULE 'WolfVision_VZ_Comm_dr1_0_0' comm(vdvDocCam, dvDocCam)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
(***********************************************************)
(* This command is used for DDD combined with fixed        *)
(* device/virtual device binding                           *)
(***********************************************************)
//STATIC_PORT_BINDING (vdvDocCam, dvDocCam, DUET_DEV_TYPE_DOCUMENT_CAMERA, 'VZ-57plus', DUET_DEV_POLLED)

(***********************************************************)
(* These two commands are used for DDD with no predefined  *)
(* binding                                                 *)
(***********************************************************)
//DYNAMIC_APPLICATION_DEVICE(vdvDocCam, DUET_DEV_TYPE_DOCUMENT_CAMERA, 'WolfVision VZ')
//DYNAMIC_POLLED_PORT(dvDocCam)

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

