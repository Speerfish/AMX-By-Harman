MODULE_NAME='AMXProjUIMod'(DEV dvTP[],DEV vdvProjector,INTEGER nProjBtns[],
                           INTEGER nInputFlag)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 06/16/2004  AT: 22:18:58        *)
(***********************************************************)
                           
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(* This projector responds to valid commands by echoing    *)
(* the command back to the master.                         *)
(* Module parameters:                                      *)
(*  dvTP - An array containing touch panel device address  *)
(*  vdvProjector - The D:P:S of the virtual projector      *)
(*  nProjBtns - an array containing the touch panel button *)
(*  channel numbers associated with the projector commands *)
(*  nInputFlag - a flag that tracks the input currently    *)
(*  selected on the projector.                             *)
(*      1=Vid1, 2=RGB1, 3=RGB2, 4=S-Video                  *)
(*                                                         *)
(*  The module also uses the following virtual channels    *)
(*  to provide projector feedback:                         *)
(*    [dvRS232Proj,255] tracks power, on = proj ON         *)
(*    [dvRS232Proj,254] tracks picture mute, on = muted    *)    
(***********************************************************)

//Projector RS-232 commands - for reference only
//sProjCmds[1] = "$02,'PON',$03"      //Power ON command
//sProjCmds[2] = "$02,'POF',$03"      //Power OFF command
//sProjCmds[3] = "$02,'MUTE',$03"     //Video mute
//sProjCmds[4] = "$02,'UNMUTE',$03"   //Video unmute
//sProjCmds[5] = "$02,'VID1',$03"     //Vid1 input
//sProjCmds[6] = "$02,'RGB1',$03"     //RGB1 input
//sProjCmds[7] = "$02,'RGB2',$03"     //RGB2 input
//sProjCmds[8] = "$02,'SVID',$03"     //S-Vid input

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

#include 'StdProjAPI.axi'  //Standard API definitions for the Comm module

INTEGER nFBLoop            //Feedback loop counter

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

BUTTON_EVENT[dvTP,nProjBtns]
{
  PUSH:
  {
    PULSE [vdvProjector,nStdProjAPI[GET_LAST(nProjBtns)]]  //Call routines in comm module
  }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

//Power feedback
[dvTP,nProjBtns[1]] = [vdvProjector,255]     //Power ON
[dvTP,nProjBtns[2]] = ![vdvProjector,255]    //Power OFF


//Selected input feedback
[dvTP,nProjBtns[5]] = (nInputFlag == 1)
[dvTP,nProjBtns[6]] = (nInputFlag == 2)
[dvTP,nProjBtns[8]] = (nInputFlag == 4)

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
