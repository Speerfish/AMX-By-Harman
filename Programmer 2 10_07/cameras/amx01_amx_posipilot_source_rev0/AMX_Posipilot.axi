PROGRAM_NAME='AMX_Posipilot'
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 02/07/2002 AT: 14:54:55               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/18/2003 AT: 15:11:42         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 04/05/2002                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

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


(*---------------------------------------------------------*)
(*   PILOT LIST #1 (not to exceed 5)                       *)
(*---------------------------------------------------------*)
DEV vdvPILOT_LIST_1[] =
{
  vdvPILOT_1,vdvPILOT_2
}


(*---------------------------------------------------------*)
(*   PILOT's PANEL LIST (not to exceed 5)                  *)
(*---------------------------------------------------------*)
DEV dvPILOT_PNL_LIST_1[] =
{
  dvTP_1,dvTP_2
}


(*---------------------------------------------------------*)
(*   PT LIST (not to exceed 18)                            *)
(*---------------------------------------------------------*)
DEV dvPT_LIST_1[] =
{
  dvCAM1,dvCAM2,dvCAM3,dvCAM4,dvCAM5,dvCAM6
}


(*---------------------------------------------------------*)
(*   STANDARD POSIPILOT TEMPLATE                           *)
(*---------------------------------------------------------*)
INTEGER chALL_PILOT_BTNS_1[] =
{
    9,                        // BTN/VT - PRESET RECALL
   21,                        // BTN/VT - PRESET STORE
    1,                        // BTN/VT - PRESET 1
    2,                        // BTN/VT - PRESET 2
    3,                        // BTN/VT - PRESET 3
    4,                        // BTN/VT - PRESET 4
    5,                        // BTN/VT - PRESET 5
    6,                        // BTN/VT - PRESET 6
   22,                        // BTN/VT - CAM 1
   23,                        // BTN/VT - CAM 2
   24,                        // BTN/VT - CAM 3
   18,                        // BTN/VT - CAM 4
   19,                        // BTN/VT - CAM 5
   20,                        // BTN/VT - CAM 6
   11,                        // BTN/VT - MORE CAMERAS
   10,                        // BTN    - MORE PRESETS
   14,                        // BTN    - IRIS AUTO/MANUAL
   35,                        // BTN    - SETUP - REVERSE PAN
   36,                        // BTN    - SETUP - REVERSE TILT
   37,                        // BTN    - SETUP - REVERSE ZOOM
   38,                        // BTN    - SETUP - REVERSE FOCUS
   39,                        // BTN    - SETUP - REVERSE IRIS
   40,                        // BTN    - SETUP - LENS=SPEED
   41,                        // BTN    - SETUP - LENS=POSITIONAL
   42,                        // BTN    - SETUP - RESET CAMERA
   43,                        // BTN    - SETUP - CALIBRATE
   86,                        // BTN    - SETUP - CLEAR UP
   87,                        // BTN    - SETUP - CLEAR DOWN
   88,                        // BTN    - SETUP - CLEAR LEFT
   89,                        // BTN    - SETUP - CLEAR RIGHT
   81,                        // BTN    - SETUP - SET UP
   82,                        // BTN    - SETUP - SET DOWN
   83,                        // BTN    - SETUP - SET LEFT
   84,                        // BTN    - SETUP - SET RIGHT
   90,                        // BTN    - SETUP - SET/GOTO  HOME
   33,                        // BTN/VT - CONFIG (ENTER SETUP)
   34,                        // BTN    - CONFIG (EXIT  SETUP)
  100                         // BTN    - FB FOR INITIALIZATION
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


(*** THIS POSIPILOT USES THE MEWER "POT" TYPE FOCUS WHEEL   ***)
//SEND_COMMAND vdvPILOT_1,"'FOCUS=POT'"

(*** THIS POSIPILOT USES THE OLDER "MOTOR" TYPE FOCUS WHEEL ***)
SEND_COMMAND vdvPILOT_1,"'FOCUS=POT'"
SEND_COMMAND vdvPILOT_2,"'FOCUS=POT'"

(***********************************************************)
(*                MODULES CODE GOES BELOW                  *)
(***********************************************************)
(*---------------------------------------------------------------------------*)
(* NOTE:                                                                     *)
(*       -The JS module and "pot" or "motor" type focus wheels:              *)
(*          --PosiPilot is defaulted to the older "motor" style for the      *)
(*            focus wheel.  It would still be a good idea to include the     *)
(*            command 'FOCUS=MOTOR' in your startup code, just to be sure.   *)
(*          --Use command 'FOCUS=POT' if you have the newer style focus      *)
(*            wheel.  This should be done in your STARTUP.                   *)
(*          --NOTE: The 'FOCUS=POT' send command will set the AI8 to DELTA   *)
(*                  mode for focus.  There is no way to reset this           *)
(*                  DELTA mode, other than cycling power on the pilot.  So,  *)
(*                  if you "guess" it is the newer style focus wheel (POT),  *)
(*                  and it is wrong, you will need to cycle power on the     *)
(*                  pilot before sending the 'FOCUS=MOTOR' command.          *)
(*                                                                           *)
(*       -Modules default all cameras to:                                    *)
(*          --Positional type lens                                           *)
(*          --Zoom wide  is in the positive direction (+V)                   *)
(*          --Zoom tele  is in the negative direction (-V)                   *)
(*          --Focus far  is in the positive direction (+V)                   *)
(*          --Focus near is in the negative direction (-V)                   *)
(*          --Iris close is in the positive direction (+V)                   *)
(*          --Iris open  is in the negative direction (-V)                   *)
(*                                                                           *)
(*       -Modules default all P/T heads to:                                  *)
(*          --Mounted up-right (sitting on a pedestal as opposed to hanging  *)
(*            from the ceiling)                                              *)
(*                                                                           *)
(*       -When adding multiple PosiPilot modules, it is necessary to group   *)
(*        them by module names.  For example:                                *)
(*        module names.  For example:                                        *)
(*            DEFINE_MODULE 'AMX_PosiPilot_UI' mdl_Pilot_UI_1()              *)
(*            DEFINE_MODULE 'AMX_PosiPilot_UI' mdl_Pilot_UI_2()              *)
(*            DEFINE_MODULE 'AMX_PosiPilot_JS' mdl_Pilot_JS_1()              *)
(*            DEFINE_MODULE 'AMX_PosiPilot_JS' mdl_Pilot_JS_2()              *)
(*            DEFINE_MODULE 'AMX_PT_CONTROL'   mdlCCS_PT_1()                 *)
(*---------------------------------------------------------------------------*)
(*** UI modules here (buttons) ***)
DEFINE_MODULE 'AMX_PosiPilot_UI'  mdlUI_1(vdvPILOT_1, dvTP_1, chALL_PILOT_BTNS_1, dvPT_LIST_1)
DEFINE_MODULE 'AMX_PosiPilot_UI'  mdlUI_2(vdvPILOT_2, dvTP_2, chALL_PILOT_BTNS_1, dvPT_LIST_1)


(*** JS modules here (joystcks) ***)
DEFINE_MODULE 'AMX_PosiPilot_JS'  mdlJS_1(vdvPILOT_1, dvAI8_1)
DEFINE_MODULE 'AMX_PosiPilot_JS'  mdlJS_2(vdvPILOT_2, dvAI8_2)


(*** PT module here (camera control) ***)
DEFINE_MODULE 'AMX_PT_CONTROL'    mdlPT_1(vdvPILOT_LIST_1, dvPT_LIST_1)


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

