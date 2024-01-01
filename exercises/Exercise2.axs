PROGRAM_NAME='Exercise2'
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
dvTP						=	10001:1:0	// Ethernet, NXT-CV7 TOUCHPANEL
dvRelays					=	5001:4:0		//	Entire set of relays	
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

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

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
BUTTON_EVENT [dvTP,10]
{
	PUSH:
	{
		ON [dvRelays,1]
	}
}
BUTTON_EVENT [dvTP,11]
{
	PUSH:
	{
		OFF [dvRelays,1]
	}
}
BUTTON_EVENT [dvTP,12]
{
	PUSH:
		{
			TO [dvRelays,2]
		}
}
BUTTON_EVENT [dvTP,13]
{
	PUSH:
	{
		PULSE [dvRelays,3]
	}
}
BUTTON_EVENT [dvTP,14]
{
	PUSH:
	{
		MIN_TO [dvRelays,4]
	}
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
//Button Feedback
[dvTP,10] = [dvRelays,1]
[dvTP,11] = ![dvRelays,1]
[dvTP,12] = [dvRelays,2]
[dvTP,13] = [dvRelays,3]
[dvTP,14] = [dvRelays,4]
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

