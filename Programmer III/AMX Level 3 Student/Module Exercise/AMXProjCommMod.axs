MODULE_NAME='AMXProjCommMod'(DEV dvRS232Proj,DEV vdvRS232Proj, INTEGER nInput)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 06/17/2004  AT: 22:14:39        *)
(***********************************************************)
                             
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* This projector responds to valid commands by echoing    *)
(* the command back to the master.                         *)
(* Module parameters:                                      *)
(*  dvRS232Proj - The D:P:S of the real projector          *)
(*  vdvRS232Proj - The D:P:S of the virtual projector      *)
(*  nInput - a flag that tracks the input currently        *)
(*  selected on the projector.                             *)
(*      1=Vid1, 2=RGB1, 3=RGB2, 4=S-Video                  *)
(*                                                         *)
(*  The module also uses the following virtual channels    *)
(*  to track projector states:                             *)
(*    [dvRS232Proj,255] tracks power, on = proj ON         *)
(*    [dvRS232Proj,254] tracks picture mute, on = muted    *)    
(***********************************************************)

(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

#include 'StdProjAPI.axi'  //Standard API for this device

//AMX Projector Commands
CHAR sProjCmds[10][15]  //Allow for 10 commands, up to 15 bytes each

//Response buffer
CHAR sProjResponse[50]

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

//Associate buffer with RS232 device
CREATE_BUFFER dvRS232Proj,sProjResponse

//Projector RS-232 commands
sProjCmds[1] = "$02,'PON',$03"      //Power ON command
sProjCmds[2] = "$02,'POF',$03"      //Power OFF command
sProjCmds[3] = "$02,'MUTE',$03"     //Video mute
sProjCmds[4] = "$02,'UNMUTE',$03"   //Video unmute
sProjCmds[5] = "$02,'VID1',$03"     //Vid1 input
sProjCmds[6] = "$02,'RGB1',$03"     //RGB1 input
sProjCmds[7] = "$02,'RGB2',$03"     //RGB2 input
sProjCmds[8] = "$02,'SVID',$03"     //S-Vid input

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[dvRS232Proj]           //Initialize RS232 port
{
  ONLINE:
  {
    SEND_COMMAND dvRS232Proj,'SET BAUD 38400,N,8,1 485 DISABLE'
  }
  
  STRING:                         //Device response routine
  {
    IF (FIND_STRING(sProjResponse,"$03",1)) //If command terminator is in buffer
    {
      GET_BUFFER_CHAR(sProjResponse)  //Get rid of the $02 STX
      //Get rid of the $03 ETX - what's left in buffer is the command
      SET_LENGTH_ARRAY(sProjResponse,LENGTH_ARRAY(sProjResponse)-1)
      SWITCH (sProjResponse)
      {
        CASE 'PON':               //Power is ON
        {
          ON [vdvRS232Proj,255]   //Set power channel
        }
        CASE 'POF':               //Power is OFF
        {
          OFF [vdvRS232Proj,255]  //Reset power channel
        }
        CASE 'VID1':              //Video 1 input selected
        {
          nInput = 1              //Flag set to Video 1
        }
        CASE 'RGB1':              //RGB 1 input selected
        {
          nInput = 2              //Flag set RGB 1
        }
        CASE 'RGB2':              //RGB 2 input selected
        {
          nInput = 3              //Flag set RGB 2
        }
        CASE 'SVID':              //S-Video input selected
        {
          nInput = 4              //Flag set S-Video
        }                        
        CASE 'MUTE':              //Picture is muted
        {
          ON [vdvRS232Proj,254]   //Set mute channel
        }
        CASE 'UNMUTE':            //Picture is not muted
        {
          OFF [vdvRS232Proj,254]  //Reset mute channel
        }
      }
      CLEAR_BUFFER sProjResponse
    }
  }
}

CHANNEL_EVENT[vdvRS232Proj,nStdProjAPI]
{
  ON:
  {
    IF ((![vdvRS232Proj,255]) AND (CHANNEL.CHANNEL != 2))   //If power is off, turn it on
    {
      SEND_STRING dvRS232Proj,sProjCmds[1]
    }
    SEND_STRING dvRS232Proj,sProjCmds[CHANNEL.CHANNEL]
  }
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
