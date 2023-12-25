PROGRAM_NAME='MainAsyncModTest'
(***********************************************************)
(*  FILE CREATED ON: 03/25/2004  AT: 23:12:08              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/05/2004  AT: 14:02:31        *)
(***********************************************************)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvG3TP             = 128:1:0      //G3 touch panel
dvModero           = 10128:1:0    //G4 touch panel

vdvTestAsyncMod    = 33001:1:0    //Virtual device

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

DEV dvTPs[] = {dvG3TP,dvModero}

(***********************************************************)
(*                MODULE DEFINITIONS GO BELOW               *)
(***********************************************************)
DEFINE_MODULE 'AsyncMod1Test' mdlAsyncMod1(dvTPs,vdvTestAsyncMod)
DEFINE_MODULE 'AsyncMod2Test' mdlAsyncMod2(dvTPs,vdvTestAsyncMod)

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

