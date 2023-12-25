PROGRAM_NAME='M2M Device Control Local Room'
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 06/19/2004  AT: 11:27:41        *)
(***********************************************************)
(***********************************************************)
(* System Type : NetLinx NI-3000                           *)
(***********************************************************)
(* REV HISTORY:                                            *)
(*  This is the main source code file for the AMX Level 3  *)
(*  training class, Master #1, in a 2 system               *)
(*  master-to-master configuration.                        *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvProj              = 5001:1:0      //RS232 Proj 38400,N,8,1
dvSwt               = 5001:2:0      //RS232 A/V Switcher 9600,N,8,1
dvScreen            = 5001:7:0      //Screen Up=Relay #1,Down=2


vdvProj             = 33001:1:0     //Virtual RS232 Proj
vdvSwt              = 33002:1:0     //Virtual RS232 A/V Switcher
vdvScreen           = 33007:1:0     //Virtual Screen
vdvRemRoom          = 33010:1:0     //Virtual device for remote room
                      
dvModero            = 10128:1:0     //Modero

//Remote real device - change system number to match actual remote system number
dvRemProj           = 5001:1:102   //RS232 Proj 38400,N,8,1 on master system #102
dvRemSwt            = 5001:2:102   //RS232 A/V Switcher 9600,N,8,1 on master system #102
dvRemScreen         = 5001:7:102   //Screen Up=Relay #1,Down=2 on master system #102

//Remote virtual devices - change system number to match actual remote system number
vdvRemProj          = 33001:1:102  //RS232 Proj 38400,N,8,1 on master system #102
vdvRemSwt           = 33002:2:102  //RS232 A/V Switcher 9600,N,8,1 on master system #102
vdvRemScreen        = 33007:1:102  //Screen Up=Relay #1,Down=2 on master system #102

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

DEV dvTPs[] = {dvModero}

//Source selections TP btns - position in array
//corresponds to input channel on switcher
VOLATILE INTEGER nSources[] =
{
  131,                   //DVD    (input 1 on switcher)
  132,                   //VCR 1  (input 2 on switcher)
  133,                   //VCR 2  (input 3 on switcher)
  135,                   //DSS    (input 4 on switcher)
  141,                   //Projector page
  142,                   //Screen page
  143,                   //Phone Dir page
  48                     //Remote room external btn
}

VOLATILE INTEGER nCurrentSource

//Destination selections TP buttons - position in array    
//corresponds to output channel on switcher
VOLATILE INTEGER nDestinations[] =
{
  141                    //Projector        (output 1 on switcher)
}

VOLATILE INTEGER nCurrentDestination

//Projector input system var
INTEGER nSelectedInput
//End of system vars

//RS232 Devices - TP buttons arrays
INTEGER nProjBtns[] =
{
  1,                     //Power On
  2,                     //Power Off
  65000,                 //No Video Mute Button
  65000,                 //No Video UnMute Button
  3,                     //Composite Video Input (VCRs)
  4,                     //RGB 1 Input           (DVD)
  65000,                 //No RGB 2 Button
  5                      //S-Video Input         (DSS)
}

//Screen control
INTEGER nScreenBtns[] = {8,9} //Up=8,Down=9

//Remote rooms - master-to-master room control
INTEGER nRemoteRoom = 49    //2nd rm = 49
INTEGER nRemoteRoomFlag     //Set is remote room is being controlled 

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

//Screen relay control - momentary
([dvScreen,1],[dvScreen,2])   //1=up,2=down

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
(*                MODULE DEFINITIONS GO BELOW               *)
(***********************************************************)
DEFINE_MODULE 'AMXProjCommMod' mdlProjCommMod(dvProj,vdvProj,nSelectedInput)
DEFINE_MODULE 'AMXScreenCommMod' mdlScreenCommMod(dvScreen,vdvScreen)
DEFINE_MODULE 'AMXSwtCommMod' mdlSwtCommMod(dvSwt,vdvSwt)

(*************************************************************)
DEFINE_MODULE 'AMXProjUIMod' mdlProjUIMod(dvTPs,vdvProj,nProjBtns,nSelectedInput)
DEFINE_MODULE 'AMXScreenUIMod' mdlScreenUIMod(dvTPs,vdvScreen,nScreenBtns) 
DEFINE_MODULE 'AMXSwtUIMod' mdlSwtUIMod(dvTPs,vdvSwt,nSources,nDestinations,
                                        nCurrentSource,nCurrentDestination,
                                        nRemoteRoomFlag)

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT



(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

//Overflow room feedback
[dvTPs,49] = [vdvRemRoom,250]
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

