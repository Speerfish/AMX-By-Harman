MODULE_NAME='AMXSwtUIMod'(DEV dvTPs[],DEV vdvSwt,INTEGER nSources[],
                          INTEGER nDestinations[],INTEGER nCurrentSource,
                          INTEGER nCurrentDestination)
(***********************************************************)
(*  FILE CREATED ON: 04/10/2004  AT: 21:49:39              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 06/17/2004  AT: 22:14:39        *)
(***********************************************************)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* Module parameters:                                      *)
(*  dvTPs[] - An array of touch panels                     *)
(*  vdvSwt - The D:P:S of the virtual switcher             *)
(*  nSources[] - an array of channel codes for the source  *)
(*  selections                                             *)
(*  nDestinations[] - an array of channel codes for the    *)
(*  display/destination device selections                  *)
(*  nCurrentSource - the current source device selected    *)
(*  nCurrentDestination - the current display/destination  *)
(*  device selected                                        *)
(*                                                         *)
(* This API is implemented using the following common      *)
(* virtual device interface protocol:                      *)
(*    'x,y,z' where x=input channel,y=outputs,z=level      *)
(* followed by a hex $03 as a string terminator            *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE INTEGER nFBLoop //Loop counter used for feedback loop

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

//Source selection
BUTTON_EVENT[dvTPs,nSources]
{
  PUSH:
  {
    nCurrentSource = GET_LAST(nSources)
    SEND_STRING vdvSwt,"ITOA(nCurrentSource),',1,1',$03"
    //Check for power state of sources in each source module
    //Switch projector to correct input in Proj UI mod
  }
}

//Destination selection
//BUTTON_EVENT[dvTPs,nDestinations]
//{
//  PUSH:
//  {
//    nCurrentDestination = GET_LAST(nDestinations)
//    //Switch both audio and video to selected channel
//    SEND_STRING vdvSwt,"ITOA(nCurrentSource),',',ITOA(nCurrentDestination),',1'"
//    //Could check for power state of displays here
//  }
//}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

//Source selection feedback
FOR (nFBLoop=1;nFBLoop<=LENGTH_ARRAY(nSources);nFBLoop++)
{
  [dvTPs,nSources[nFBLoop]] = (nCurrentSource == nFBLoop)
}
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
