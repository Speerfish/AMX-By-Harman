PROGRAM_NAME='Epson_PowerLite_811p_Main'
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 01/23/2003 AT: 08:33:13               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 08/12/2003 AT: 07:42:24         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 08/01/2003                              *)
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
dvDEV     = 5001:5:0            (* EPSON POWERLITE 811p *)
vdvDEV    = 33001:1:0           (* VIRTUAL DEVICE       *)
(* CABLE FOR THE 811p IS FG#10-756. SEE DOCUMENTATION FOR WIRING DETAILS. *)
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

INTEGER nCHAN_BTN[] =           // CHANNEL BUTTONS ON TOUCH PANEL
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
    
    11,    // RGB Analog Input 1 on Main page
    12,    // RGB Digital Input 1 on Main page
    13,    // RGB Analog Input 2 on Main page
    14,    // RGB Video Input 1 on Main page
    15,    // Component (YCbCr) Input on Main page
    16,    // Component (YPbPr) Input on Main page
    17,
    18,    // S-Video Input on Main page
    19,    // Video (RCA) Input on Main page
    20,    // RGB-Video RGsB Input on Main page
    
    21,    // Temperature Color Color Control button on Color Settings popup
    22,    // RGB Color Color Control button on Color Settings popup
    23,    // sRGB Color Mode button on Color Settings popup
    24,    // Normal Color Mode button on Color Settings popup
    25,    // Meeting Color Mode button on Color Settings popup
    26,    // Presentation Color Mode button on Color Settings popup
    27,    // Theater Color Mode button on Color Settings popup
    28,    // Amusement Color Mode button on Color Settings popup
    29,    // Power Off button on Main page
    30,    // Power On button on Main page
    
    31,
    32,    // Volume decrement button on Main page
    33,    // Volume increment button on Main page
    34,
    35,    // Aspect Ratio toggle button on Misc popup
    36,
    37,    // Cursor Left button on Main page
    38,    // Cursor Right button on Main page
    39,    // Cursor Up button on Main page
    40,    // Cursor Down button on Main page
    
    41,    // Enter button on Main page
    42,    // Menu toggle button on Main page
    43,    // Help toggle button on Main page
    44,    // Back button on Main page
    45,
    46,
    47,
    48,
    49,
    50,
    
    51,    // Blank Screen Mute button on Misc popup
    52,    // Blue Screen Mute button on Misc popup
    53,    // Logo Mute button on Misc popup
    54,    // Ceiling projection toggle button on Misc popup
    55,    // Rear projection toggle button on Misc popup
    56,
    57,
    58,    // Noise toggle button on Misc popup
    59,
    60,
    
    61,    // Exit Zoom button on Misc popup
    62,    // Zoom out button on Misc popup
    63,    // Zoom in button on Misc popup
    64,    // Detail menu button on Main page
    65,
    66,
    67,
    68,
    69,    // Mute On button on Main page
    70,    // Mute Off button on Main page
    
    71,    // 10% Volume button on Main page
    72,    // 20% Volume button on Main page
    73,    // 30% Volume button on Main page
    74,    // 40% Volume button on Main page
    75,    // 50% Volume button on Main page
    76,    // 60% Volume button on Main page
    77,    // 70% Volume button on Main page
    78,    // 80% Volume button on Main page
    79,    // 90% Volume button on Main page
    80    // 100% Volume button on Main page
}

INTEGER nTXT_BTN[] =            // TEXT BUTTONS ON TOUCH PANEL
{
    1,    // Lamp hours text field on Misc popup page
    2,    // Text field on Time Out popup page
    3,    // Brightnes text field on Adjustment popup page
    4,    // Contrast text field on Adjustment popup page
    5,    // Sharpness text field on Adjustment popup page
    6,    // Tint text field on Adjustment popup page
    7    // Color text field on Adjustment popup page
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

DEFINE_MODULE 'Epson_PowerLite_811p_Comm' COMM1(vdvDEV, dvDEV)
DEFINE_MODULE 'Epson_PowerLite_811p_UI'   TP1(vdvDEV, dvTP, nCHAN_BTN, nTXT_BTN)
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