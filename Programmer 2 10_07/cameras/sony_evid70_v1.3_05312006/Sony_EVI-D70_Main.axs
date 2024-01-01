PROGRAM_NAME='Sony_EVI-D70_Main'
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 01/23/2003 AT: 08:33:13               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/31/2006  AT: 10:18:36        *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 08/25/2003                              *)
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
dvDEV_IN  = 5001:5:0            (* SONY EVI-D70 CAMERA  *)
dvDEV_OUT = 5001:6:0            (* SONY EVI-D70 CAMERA  *)
vdvDEV    = 33001:1:0           (* VIRTUAL DEVICE       *)
(* CABLE FOR THE SONY EVI-D70 IS FG#10-1784-10. SEE AMX WEBSITE FOR WIRING DETAILS. *)
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

// THIS MODULE IS DESIGNED TO SUPPORT DAISY-CHAINING OF DEVICES WHERE dvDEV_OUT IS THE PORT CONNECTED TO THE VISCA IN PORT
// ON THE FIRST CAMERA AND dvDEV_IN IS THE PORT CONNECTED TO THE VISCA OUT PORT ON THE LAST CAMERA. HOWEVER, THIS MODULE 
// WAS NOT TESTED WITH MULTIPLE CAMERAS.
DEFINE_MODULE 'Sony_EVI-D70_Comm' COMM1(vdvDEV,dvDEV_IN, dvDEV_OUT)
DEFINE_MODULE 'Sony_EVI-D70_UI'   TP1(vdvDEV, dvTP)
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