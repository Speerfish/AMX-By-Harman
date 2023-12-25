MODULE_NAME='AMXScreenCommMod'(DEV dvScr,DEV vdvScr)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/10/2004  AT: 16:53:22        *)
(***********************************************************)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(* Module parameters:                                      *)
(*  dvScr - The D:P:S of the real screen                   *)
(*  vdvScr - The D:P:S of the virtual screen               *)
(*                                                         *)
(***********************************************************)
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

#include 'StdScreenAPI.axi'

(***********************************************************)
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

CHANNEL_EVENT[vdvScr,nStdScreenAPI]    //1=up,2=down,3=stop
{
  ON:
  {
    PULSE [dvScr,CHANNEL.CHANNEL]    //Make sure relays are defined 
  }                                  //as mutually exclusive in Main
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
