MODULE_NAME='AMXScreenUIMod'(DEV dvTP[], DEV vdvScr,INTEGER nScrBtns[]) 
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/10/2004  AT: 16:50:54        *)
(***********************************************************)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(* Module parameters:                                      *)
(*  dvTP - An array containing touch panel device address  *)
(*  vdvScr - The D:P:S of the virtual screen               *)
(*  nScrBtns - an array containing the touch panel button  *)
(*  channel numbers associated with the screen commands    *)
(*                                                         *)
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

#include 'StdScreenAPI.axi'

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

BUTTON_EVENT[dvTP,nScrBtns]
{
  PUSH:
  {
    PULSE [vdvScr,nStdScreenAPI[GET_LAST(nScrBtns)]] //Call routine in screen comm module  
  }
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
