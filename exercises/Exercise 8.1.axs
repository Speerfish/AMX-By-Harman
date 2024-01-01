PROGRAM_NAME='Exercise 8.1'
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/05/2006  AT: 09:00:25        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
dvTP					=	10001:1:0
dvSWITCH				=	5001:1:0
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
INTEGER nInputSelected
INTEGER nOutputSelected
(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE
([dvTP,61]..[dvTP,64])
([dvTP,65]..[dvTP,68])
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
BUTTON_EVENT[dvTP,61]
BUTTON_EVENT[dvTP,62]
BUTTON_EVENT[dvTP,63]
BUTTON_EVENT[dvTP,64]
BUTTON_EVENT[dvTP,65]
BUTTON_EVENT[dvTP,66]
BUTTON_EVENT[dvTP,67]
BUTTON_EVENT[dvTP,68]
{
    PUSH:
    {
	SWITCH(BUTTON.INPUT.CHANNEL-60)
	{
	    CASE 1:
	    {
		nInputSelected = 1
		ON[dvTP,61]
	    }
	    CASE 2:
	    {
		nInputSelected = 2
		ON[dvTP,62]
	    }
	    CASE 3:
	    {
		nInputSelected = 3
		ON[dvTP,63]
	    }
	    CASE 4:
	    {
		nInputSelected = 4
		ON[dvTP,64]
	    }
	    CASE 5:
	    {
		nOutputSelected = 1
		ON[dvTP,65]
	    }
	    CASE 6:
	    {
		nOutputSelected = 2
		ON[dvTP,66]
	    }
	    CASE 7:
	    {
		nOutputSelected = 3
		ON[dvTP,67]
	    }
	    CASE 8:
	    {
		nOutputSelected = 4
		ON[dvTP,68]
	    }
	}
    }
}    
BUTTON_EVENT[dvTP,69]
{
    PUSH:
    {
    SEND_STRING dvSWITCH, "'*i', ITOA(nInputSelected), 'o', ITOA(nOutputSelected), '!' "
	TO[dvTP,69]
    }
} 
DATA_EVENT [dvSWITCH]
{
    ONLINE:
    {
	
    }
    
    STRING:
    {
    SEND_COMMAND dvTP,"'TEXT70-',  DATA.TEXT"
    }
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
[dvTP,61] = (nInputSelected == 1)
[dvTP,62] = (nInputSelected == 2)
[dvTP,63] = (nInputSelected == 3)
[dvTP,64] = (nInputSelected == 4)
[dvTP,65] = (nOutputSelected == 1)
[dvTP,66] = (nOutputSelected == 2)
[dvTP,67] = (nOutputSelected == 3)
[dvTP,68] = (nOutputSelected == 4)
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

