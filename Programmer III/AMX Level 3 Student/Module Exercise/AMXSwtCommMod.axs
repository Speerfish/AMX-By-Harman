MODULE_NAME='AMXSwtCommMod'(DEV dvAMXSwt, DEV vdvAMXSwt)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 06/15/2004  AT: 20:53:20        *)
(***********************************************************)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* This module controls a switcher based on the Extron     *)
(* SIS protocol.  Other switcher protocols could be        *)
(* implemented using different modules based on the same   *)
(* common virtual device interface protocol:               *)
(*    'x,y,z' where x=input channel,y=outputs,z=level      *)
(*                                                         *)
(* Module parameters:                                      *)
(*  dvAMXSwt - The D:P:S of the real switcher              *)
(*  vdvAMXSwt - The D:P:S of the virtual switcher          *)
(***********************************************************)

(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

CHAR sBuffer[10]  //Buffer used with DATA.TEXT

CHAR sInput[4]    //Can hold input channel up to 999 plus the terminator - ','
CHAR sOutputs[4]  //Can hold output channel up to 999 plus the terminator - ','

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[dvAMXSwt]         //Initialize RS-232 port
{
  ONLINE:
  {
    SEND_COMMAND dvAMXSwt,'SET BAUD 9600,N,8,1 485 DISABLE'
    SEND_COMMAND dvAMXSwt,'RXON'   //Make sure receive is turned on when
  }                                //not using CREATE_BUFFER
}

DATA_EVENT[vdvAMXSwt]
{
  STRING:
  {
    sBuffer = "sBuffer,DATA.TEXT"      //Append incoming data into buffer
    
    IF (FIND_STRING(sBuffer,"$03",1))  //If terminator character ETX ($03) is in buffer
    {
      SET_LENGTH_ARRAY(sBuffer,LENGTH_ARRAY(sBuffer)-1)   //Get rid of the terminator - $03
      sInput = REMOVE_STRING(sBuffer,',',1)               //Get the input channel
      SET_LENGTH_ARRAY(sInput,LENGTH_ARRAY(sInput)-1)     //Get rid of the comma ','
      sOutputs = REMOVE_STRING(sBuffer,',',1)             //Get the output channel(s)
      SET_LENGTH_ARRAY(sOutputs,LENGTH_ARRAY(sOutputs)-1) //Get rid of the comma ','
      //Whats left in sBuffer is the level - 1=both Audio and Video,2=Audio only,3=Video only,4=RGB only
      SWITCH (sBuffer)
      {
        CASE '1':                      //Switch audio and video together
        {
          SEND_STRING dvAMXSwt,"sInput,'*',sOutputs,'!'"   //Make the switch
        }
        CASE '2':                      //Switch audio only
        {
          SEND_STRING dvAMXSwt,"sInput,'*',sOutputs,'$'"   //Make the switch
        }
        CASE '3':                      //Switch composite video only
        {
          SEND_STRING dvAMXSwt,"sInput,'*',sOutputs,'%'"   //Make the switch
        }
        CASE '4':                      //Switch RGBHV video only
        {
          SEND_STRING dvAMXSwt,"sInput,'*',sOutputs,'&'"   //Make the switch
        }
      }
      CLEAR_BUFFER sBuffer             //Clean up for next switch
      CLEAR_BUFFER sInput              //Clean up for next switch
      CLEAR_BUFFER sOutputs            //Clean up for next switch
    }
    
    IF (LENGTH_ARRAY(sBuffer) == MAX_LENGTH_ARRAY(sBuffer)) //Error condition
    {
      CLEAR_BUFFER sBuffer  
      CLEAR_BUFFER sInput             
      CLEAR_BUFFER sOutputs           
    }
  }
}

//In a real project you would add a DATA_EVENT here to parse
//the response from the switcher to make sure the switch
//was executed and set feedback accordingly.
//This is not required for this exercise due to time constraints
//and the fact that this should have been taught in Level II
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
