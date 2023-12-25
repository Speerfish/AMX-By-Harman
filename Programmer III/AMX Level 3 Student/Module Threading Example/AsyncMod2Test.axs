MODULE_NAME='AsyncMod2Test'(DEV dvTP[], DEV vdvTestAsync)
(***********************************************************)
(*  FILE CREATED ON: 03/25/2004  AT: 23:02:42              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/05/2004  AT: 14:01:43        *)
(***********************************************************)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

DEFINE_VARIABLE

LONG lDelay[]={1000,2000,3000,4000,5000,6000,7000,8000,9000,
               10000,11000,12000,13000,14000,15000}

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

CHANNEL_EVENT[vdvTestAsync,1]         //Called from Mod 1
{
  ON:
  {
    SEND_STRING 0,'STARTING 15 SECOND DELAY IN MODULE 2'
    SEND_STRING 0,'THIS SHOULD START AFTER 5 SECONDS IN MOD 1'
    SEND_STRING 0,'BECAUSE TIMELINES RUN IN SEPERATE THREADS'
    TIMELINE_CREATE(1,lDelay,15,TIMELINE_ABSOLUTE,TIMELINE_ONCE)  
  }
}

TIMELINE_EVENT[1]
{
  SEND_STRING 0,"ITOA(TIMELINE.SEQUENCE),' SECOND(S) HAS/HAVE PASSED IN MODULE 2'"  
}

CHANNEL_EVENT[vdvTestAsync,2]
{
  ON:
  {
    SEND_STRING 0,'IN MODULE 2 CHANNEL EVENT FOR CHANNEL 2'
    SEND_STRING 0,'SHOULD RUN BEFORE LOOP ENDS IN MOD 1 BUT DOES NOT'
    SEND_STRING 0,'BECAUSE THIS MOD IS RUNNING IN SAME THREAD AS MOD 1'
  }
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
