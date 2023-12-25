MODULE_NAME='AMXDSSUIMod'(DEV dvTP[], DEV vdvAMXDSS,DEV vdvDSSFavs,
                          INTEGER nAMXDSSBtns[],INTEGER nDSSFavBtns[])
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 06/15/2004  AT: 23:02:18        *)
(***********************************************************)
                          
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* Module parameters:                                      *)
(*  dvTP - An array with the D:P:S of real touch panels    *)
(*  vdvAMXDSS - The D:P:S of the virtual DSS               *)
(*  nAMXDSSBtns - an array containing the touch panel      *)
(*  button channel numbers associated with the DSS         *)
(*  commands                                               *)
(*  nKPadBtns - an array containing the touch panel        *)
(*  button channel numbers associated with the DSS         *)
(*  keypad.                                                *)
(***********************************************************)
//For reference only
//INTEGER StdDSSAPI[] =
//{
//  9,                      //Power  
//  22                      //Channel Up  
//  23                      //Channel Down  
//  44                      //Select  
//  45,                     //Cursor Up  
//  46,                     //Cursor Down  
//  47,                     //Cursor Left  
//  48,                     //Cursor Right  
//  54,                     //Favorite  
//  55,                     //Previous Channel  
//  86                      //Menu  
//}
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

#include 'StdDSSAPI.axi'  //Standard API channels for Comm module

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

BUTTON_EVENT[dvTP,nAMXDSSBtns]
{
  PUSH:
  {
    PULSE [vdvAMXDSS,nStdDSSAPI[GET_LAST(nAMXDSSBtns)]]
  }
}

BUTTON_EVENT[dvTP,nDSSFavBtns]
{
  PUSH:
  {
    PULSE [vdvDSSFavs,GET_LAST(nDSSFavBtns)]
  }
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
