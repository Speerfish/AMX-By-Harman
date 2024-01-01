PROGRAM_NAME='Kramer_VP-724DS_Main'
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 01/23/2003 AT: 08:33:13               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 12/04/2003 AT: 10:05:54         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 12/01/2003                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
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

dvTP      = 128:1:0             (* AXT-CA10 TOUCH PANEL *)
dvDEVICE  = 5001:6:0            (* KRAMER VP-724DS      *)
vdvDEVICE = 33001:1:0           (* VIRTUAL DEVICE       *)
(* CABLE FOR THE KRAMER VP-724DS IS <ENTER INFO HERE>. SEE DOCUMENTATION FOR WIRING DETAILS. *)
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

INTEGER nCHAN_BTN[] =                   // CHANNEL BUTTONS ON TOUCH PANEL
{
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    
    11, // NORMAL ASPECT RATIO
    12, // WIDE SCREEN ASPECT RATIO
    13,
    14, // 4:3 ASPECT RATIO
    15, // PAN & SCAN ASPECT RATIO
    16,
    17, // BRIGHTNESS TOGGLE
    18, // CONTRAST TOGGLE
    19,
    20,
    
    21, // CURSOR UP
    22, // CURSOR LEFT
    23, // CURSOR DOWN
    24, // CURSOR RIGHT
    25, // ENTER
    26, // MENU TOGGLE
    27,
    28, // NORMAL DISPLAY MODE
    29, // PRESENTATION DISPLAY MODE
    30, // CINEMA DISPLAY MODE
    
    31, // NATURE DISPLAY MODE
    32, // USER 1 DISPLAY MODE
    33, // USER 2 DISPLAY MODE
    34,
    35,
    36, // FREEZE TOGGLE
    37, // KEY LOCK TOGGLE
    38, // MUTE TOGGLE
    39, // FACTORY RESET
    40, // STATUS TOGGLE
    
    41,
    42,
    43, // S-VIDEO 1 INPUT
    44, // DVI INPUT
    45, // COMPOSITE 1 INPUT
    46, // COMPONENT INPUT
    47, // VGA 1 INPUT
    48, // VGA 2 INPUT
    49, // S-VIDEO 2 INPUT
    50, // COMPOSITE 2 INPUT
    
    51,
    52,
    53, // 640x480 OUTPUT RESOLUTION
    54, // 800x600 OUTPUT RESOLUTION
    55, // 1024x768 OUTPUT RESOLUTION
    56, // 1280x1024 OUTPUT RESOLUTION
    57, // 1600x1200 OUTPUT RESOLUTION
    58, // 852x1024i OUTPUT RESOLUTION
    59, // 1024x1024i OUTPUT RESOLUTION
    60, // 1366x768 OUTPUT RESOLUTION
    
    61, // 1366x1024 OUTPUT RESOLUTION
    62, // 1280x720 OUTPUT RESOLUTION
    63, // 720x483 OUTPUT RESOLUTION
    64, // 480P OUTPUT RESOLUTION
    65, // 720P OUTPUT RESOLUTION
    66, // 1080i OUTPUT RESOLUTION
    67,
    68,
    69, // PIP TOGGLE
    70, // 1/25 PIP SIZE
    
    71, // 1/16 PIP SIZE
    72, // 1/9 PIP SIZE
    73, // 1/4 PIP SIZE
    74, // 1/2 PIP SIZE
    75, // PIP SWAP TOGGLE
    76,
    77,
    78, // VOLUME DECREMENT
    79, // VOLUME INCREMENT
    80,
    
    81,
    82, // ZOOM DECREMENT
    83  // ZOOM INCREMENT
}

INTEGER nTXT_BTN[] =                    // TEXT BUTTONS ON TOUCH PANEL
{
    1
}
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

DEFINE_MODULE 'Kramer_VP-724DS_Comm' COMM1(vdvDEVICE, dvDEVICE)
DEFINE_MODULE 'Kramer_VP-724DS_UI'   TP1(vdvDEVICE, dvTP, nCHAN_BTN, nTXT_BTN)
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