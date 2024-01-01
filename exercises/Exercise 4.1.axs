PROGRAM_NAME='Exercise 4.1'
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
dvVCR 					=	5001:5:0		// IR port 1, VCR - Sony SVO1620
dvSatRcvr				=	5001:6:0		// IR port 2, Satellite Reciever - RCA DS4430RW
dvTV					=	5001:7:0		// IR port 3, TV - JVC AV2760
dvProj		 			=  	5001:8:0		// IR port 4, Video Projector - Sony VPLV800Q
dvAVSwitcher			=	5001:1:0		// Serial Port 1, A/V swithcer - Extron MAV62	
dvRelays				=	5001:4:0		// Entire set of relays

dvTP					=	10001:1:0		// Ethernet, NXT-CV7 TOUCHPANEL
dvTP_VCR				=	10001:2:0		// VCR TP Controls

dvLightingSys			=	96:1:103		//AXLink Lighting SYSTEM_CALL
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
([dvRelays,1],[dvRelays,2]) // FOR PROJECTOR LIFT
([dvRelays,3],[dvRelays,4]) // FOR SCREEN
([dvPROJ,27],[dvPROJ,28]) // FOR PROJECTOR
(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_CALL 'System Power Up'
{
    CALL 'Lift Down'
    WAIT 20
    {
	CALL 'Projector On'
    }
    WAIT 50
    {
	CALL 'Screen Down'
    }
}
DEFINE_CALL 'System Power Down'
{
    CALL 'Projector Off'
    WAIT 10
    {
	CALL 'Screen Up'
    }
    
    WAIT 50
    {
	CALL 'Lift Up'
    }
}

DEFINE_CALL 'Lift Down'
{
	SET_PULSE_TIME(10)
	PULSE[dvRelays,2]
	SET_PULSE_TIME(5)
}
DEFINE_CALL 'Lift Up'
{
    	SET_PULSE_TIME(10)
	PULSE[dvRelays,1]
	SET_PULSE_TIME(5)
}

DEFINE_CALL 'Projector Off'
{
    IF (![dvPROJ,PROJ_OFF])
    {
	PULSE[dvPROJ,PROJ_OFF] // PULSE PROJECTOR OFFLINE
    }
}

DEFINE_CALL 'Projector On'
{
	IF(![dvPROJ,PROJ_ON]) // IF NOT ALREADY ON
	{
	    ON[dvPROJ,PROJ_ON] // TURN ON
	}
}

DEFINE_CALL 'Screen Down'
{
    PULSE[dvRelays,4] // PULSES SCREEN TO LOWER 
}
DEFINE_CALL 'Screen Up'
{
    PULSE[dvRelays,3] // RAISE SCREEN
}
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
		CALL 'System Power Up'
	    }
	    CASE 42:
	    {
		CALL 'System Power Down'
	    }
	    CASE 43:
	    {
		CALL 'Screen Up'
	    }
	    CASE 44:
	    {
		CALL 'Screen Down'
	    }
	    CASE 45:
	    {
		CALL 'Lift Up'
	    }
	    CASE 46:
	    {
		CALL 'Lift Down'
	    }
	    CASE 47:
	    {
		CALL 'Projector On'
	    }
	    CASE 48:
	    {
		CALL 'System Power Down'
	    }
	}
    }
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
[dvTP,41] = ([dvRelays,2] AND [dvRelays,4] AND [dvProj,27])
[dvTP,42] = ([dvProj,28] AND [dvRelays,3] AND [dvRelays,1])
[dvTP,43] = [dvRelays,3]
[dvTP,44] = [dvRelays,4]
[dvTP,45] = [dvRelays,1]
[dvTP,46] = [dvRelays,2]
[dvTP,47] = [dvProj,27]
[dvTP,48] = [dvProj,28]

IF ((TIME='22:00:00' ) AND [dvProj,PROJ_ON])
    {
    CALL 'System Power Down'
    }
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

