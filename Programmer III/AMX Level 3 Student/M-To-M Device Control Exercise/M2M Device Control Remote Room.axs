PROGRAM_NAME='M2M Device Control Remote Room'
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 06/17/2004  AT: 21:53:10        *)
(***********************************************************)
(***********************************************************)
(* System Type : NetLinx NI-2000                           *)
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
dvScreen            = 5001:7:0      //Screen Up=Relay #1,Down=2,Stop=3


vdvProj             = 33001:1:0     //Virtual RS232 Proj
vdvSwt              = 33002:1:0     //Virtual RS232 A/V Switcher
vdvScreen           = 33007:1:0     //Virtual Screen
                      
dvModero8400        = 10128:1:0     //Modero MVP-8400

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

DEV dvTPs[] = {dvModero8400}

//Local and Remote devices
//DEV dvProjs[] = {dvProj,dvRemProj}
//DEV dvSwitchers[] = {dvSwt,dvRemSwt}
//dev dvScreens[] = {dvScreen,dvRemScreen}

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

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

//Screen relay control - momentary
([dvScreen,1],[dvScreen,2])   //1=up,2=down

(***********************************************************)
(*                MODULE DEFINITIONS GO BELOW               *)
(***********************************************************)
DEFINE_MODULE 'AMXProjCommMod' mdlProjCommMod(dvProj,vdvProj,nSelectedInput)
DEFINE_MODULE 'AMXScreenCommMod' mdlScreenCommMod(dvScreen,vdvScreen)
DEFINE_MODULE 'AMXSwtCommMod' mdlSwtCommMod(dvSwt,vdvSwt)

(*************************************************************)
DEFINE_MODULE 'AMXProjUIMod' mdlProjUIMod(dvTPs,vdvProj,nProjBtns,nSelectedInput)
DEFINE_MODULE 'AMXScreenUIMod' mdlScreenUIMod(dvTPs,vdvScreen,nScreenBtns) 
DEFINE_MODULE 'AMXRemoteSwtUIMod' mdlSwtUIMod(dvTPs,vdvSwt,nSources,nDestinations,
                                        nCurrentSource,nCurrentDestination)

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

