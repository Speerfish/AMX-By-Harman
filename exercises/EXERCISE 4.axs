PROGRAM_NAME='EXERCISE 4'
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
dvVCR	=	5001:5:0 // VCR, SONY SVO1620
dvSAT	=	5001:6:0 // SATELLITE DISH, RCA SD4430RW
dvTV	=	5001:7:0 // TV, JVC AV2760
dvPROJ	=	5001:8:0 // PROJECTOR, SONY VPLV800Q
dvSWITCH = 	5001:1:0 // EXTRON MAV62
dvTP	=	10001:1:0 // NXT-CV15
dvREL	=	5001:4:0 // RELAYS

dvRADIA	=	96:1:103 // RADIA LIGHTING SYSTEM 
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
PROJ_ON = 27
PROJ_OFF = 28
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
([dvREL,1],[dvREL,2]) // FOR PROJECTOR LIFT
([dvREL,3],[dvREL,4]) // FOR SCREEN
([dvPROJ,27],[dvPROJ,28]) // FOR PROJECTOR

DEFINE_CALL 'SYSTEM ON' // CALL FOR SYSTEM POWER ON
{

    CALL 'LIFT DOWN'
    WAIT 20
    {
	CALL 'PROJECTOR ON'
    }
    WAIT 50
    {
	CALL 'SCREEN DOWN'
    }
}

DEFINE_CALL 'LIFT DOWN'
{
    SET_PULSE_TIME(10) // NEEDS 1 SECOND OF CLOSURE TO ENGAGE
    PULSE[dvREL,2] // PULSES FOR 1 SECOND
    SET_PULSE_TIME(5) // SETS PULSE TIME BACK TO DEFAULT (1/2 SEC)
}

DEFINE_CALL 'PROJECTOR ON'
{
	IF(![dvPROJ,27]) // IF NOT ALREADY ON
	{
	    ON[dvPROJ,27] // TURN ON
	}
}

DEFINE_CALL 'SCREEN DOWN'
{
    PULSE[dvREL,4] // PULSES SCREEN TO LOWER 
}

DEFINE_CALL 'SYSTEM OFF'
{

    CALL 'PROJECTOR OFF'
    WAIT 10
    {
	CALL 'SCREEN UP'
    }
    
    WAIT 50
    {
	CALL 'LIFT UP'
    }
}

DEFINE_CALL 'PROJECTOR OFF'
{
    IF (![dvPROJ,28])
    {
	PULSE[dvPROJ,28] // PULSE PROJECTOR OFFLINE
    }
}

DEFINE_CALL 'SCREEN UP'
{
    PULSE[dvREL,3] // RAISE SCREEN
}

DEFINE_CALL 'LIFT UP'
{
    SET_PULSE_TIME(10) // NEEDS 1 SECOND OF CLOSURE TO ENGAGE
    PULSE[dvREL,1] // PULSES FOR 1 SECOND
    SET_PULSE_TIME(5) // SETS PULSE TIME BACK TO DEFAULT (1/2 SEC)
}
//DEFINE_CALL 'CLICKY MAGOO'
//{
//    WAIT 5
//    {
//	PULSE[dvREL,1]
//    }
//    WAIT 8
//    {
//	PULSE[dvREL,2]
//	WAIT 15
//	{
//	    PULSE[dvREL,3]
//	}
//    }
//    WAIT 9
//    {
//	PULSE[dvREL,4]
//    }
//}


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

BUTTON_EVENT[dvTP,41]
BUTTON_EVENT[dvTP,42]
BUTTON_EVENT[dvTP,43]
BUTTON_EVENT[dvTP,44]
BUTTON_EVENT[dvTP,45]
BUTTON_EVENT[dvTP,46]
BUTTON_EVENT[dvTP,47]
BUTTON_EVENT[dvTP,48]
{                
    PUSH:
    {
	SWITCH(BUTTON.INPUT.CHANNEL)
	{
	    CASE 41:
	    {
		CALL 'SYSTEM ON'
	    }
	    CASE 42:
	    {
		CALL 'SYSTEM OFF'
	    }
	    CASE 43:
	    {
		CALL 'SCREEN UP'
	    }
	    CASE 44:
	    {
		CALL 'SCREEN DOWN'
	    }
	    CASE 45:
	    {
		CALL 'LIFT UP'
	    }
	    CASE 46:
	    {
		CALL 'LIFT DOWN'
	    }
	    CASE 47:
	    {
		CALL 'PROJECTOR ON'
	    }
	    CASE 48:
	    {
		CALL 'SYSTEM OFF'
	    }
	}
    }
}

//BUTTON_EVENT[dvTP,41]
//{
//    PUSH:
//    {
//	CALL 'CLICKY MAGOO'
//    }
//}
//
//BUTTON_EVENT[dvTP,42]
//{
//    RELEASE:
//    {
//	CALL 'CLICKY MAGOO'
//    }
//}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
	    // LIFT DOWN AND LOWER SCREEN AND PROJECTOR ON
[dvTP,41] = ([dvREL,2] AND [dvREL,4] AND [dvPROJ,27])
	    // PROJECTOR OFF AND RAISE SCREEN AND RAISE LIFT
[dvTP,42] = ([dvPROJ,28] AND [dvREL,3] AND [dvREL,1])

[dvTP,43] = [dvREL,3] // SCREEN UP
[dvTP,44] = [dvREL,4] // SCREEN DOWN
[dvTP,45] = [dvREL,1] // LIFT UP
[dvTP,46] = [dvREL,2] // LIFT DOWN
[dvTP,47] = [dvPROJ,27] // PROJECTOR ON
[dvTP,48] = [dvPROJ,28] // PROJECTOR OFF 


(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

