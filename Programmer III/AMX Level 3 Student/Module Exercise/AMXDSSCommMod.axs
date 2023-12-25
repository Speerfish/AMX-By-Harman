MODULE_NAME='AMXDSSCommMod'(DEV dvAMXDSS, DEV vdvAMXDSS,DEV vdvDSSFavs,INTEGER nDSSFavChans[])
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 06/15/2004  AT: 23:02:18        *)
(***********************************************************)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* Module parameters:                                      *)
(*  dvAMXDSS - The D:P:S of the real DSS                   *)
(*  vdvAMXDSS - The D:P:S of the virtual DSS               *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

#include 'StdDSSAPI.axi'  //Standard API channels for Comm module

VOLATILE INTEGER nSelctedFn  //The function the user selected
VOLATILE INTEGER nNumOfFavs[] = {1,2,3,4,5} //Limit favorite channels to 5
VOLATILE INTEGER nLoop

(***********************************************************)
(*          STARTUP CODE GOES BELOW             *)
(***********************************************************)
DEFINE_START

//FOR (nLoop=1;nLoop<=LENGTH_ARRAY(nDSSFavChans);nLoop++)
//{
//  nNumOfFavs[nLoop] = nLoop
//}

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[dvAMXDSS]
{
  ONLINE:                      //Initialize IR port
  {
    SEND_COMMAND DATA.DEVICE,'SET MODE IR'
    SEND_COMMAND DATA.DEVICE,'CARON'
    SEND_COMMAND DATA.DEVICE,'XCHM-0'

  }
}

CHANNEL_EVENT[vdvAMXDSS,nStdDSSAPI]
{
  ON:
  {
    SEND_COMMAND dvAMXDSS,"'SP',CHANNEL.CHANNEL"
  }
}

CHANNEL_EVENT[vdvDSSFavs,nNumOfFavs]
{
  ON:
  {
    SEND_COMMAND dvAMXDSS,"'XCH ',ITOA(nDSSFavChans[CHANNEL.CHANNEL])"
  }
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
