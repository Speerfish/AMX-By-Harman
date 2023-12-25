MODULE_NAME='StdKeyPad'(DEV dvTPs[], DEV dvDevices[], INTEGER nKPBtns[],
                        INTEGER nSource)
(***********************************************************)
(*  FILE CREATED ON: 04/27/2004  AT: 06:10:24              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/27/2004  AT: 06:37:51        *)
(***********************************************************)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE INTEGER nKeyPadIRCodes[]=
{
  10,                //0
  11,                //1
  12,                //2
  13,                //3
  14,                //4
  15,                //5
  16,                //6
  17,                //7
  18,                //8
  19                 //9
}

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

BUTTON_EVENT[dvTPs,nKPBtns]
{
  PUSH:
  {
    SEND_COMMAND dvDevices[nSource],"'SP',nKeyPadIRCodes[GET_LAST(nKPBtns)]"  
  }
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
