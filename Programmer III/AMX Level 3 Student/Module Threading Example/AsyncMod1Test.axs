MODULE_NAME='AsyncMod1Test'(DEV dvTP[], DEV vdvTestAsync)
(***********************************************************)
(*  FILE CREATED ON: 03/25/2004  AT: 22:49:50              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/05/2004  AT: 14:01:30        *)
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

LONG lDelay[]={1000,2000,3000,4000,5000,6000,7000,8000,9000,
               10000,11000,12000,13000,14000,15000}
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

BUTTON_EVENT[dvTP,1]
{
  PUSH:
  {
    SEND_STRING 0,'STARTING 15 SECOND DELAY IN MODULE 1'
    TIMELINE_CREATE(1,lDelay,15,TIMELINE_ABSOLUTE,TIMELINE_ONCE)  
  }
}

TIMELINE_EVENT[1]
{
  IF (TIMELINE.SEQUENCE == 5)  //Start count in module 2 after 5 seconds
  {
    PULSE [vdvTestAsync,1]
  }
  SEND_STRING 0,"ITOA(TIMELINE.SEQUENCE),' SECOND(S) HAS/HAVE PASSED IN MODULE 1'"  
}

BUTTON_EVENT[dvTP,2]
{
  PUSH:
  {
    STACK_VAR DOUBLE X;
    
    SEND_STRING 0,'STARTING FOR LOOP DELAY IN MODULE 1'
    FOR (X=1;X<10000;X++)
    {
      IF (X = 2000)
      {
        SEND_STRING 0,'PULSING CHANNEL 2 IN MOD 2'
        PULSE [vdvTestAsync,2]
      }
    }  
    SEND_STRING 0,'ENDING FOR LOOP DELAY IN MODULE 1'
  }
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
