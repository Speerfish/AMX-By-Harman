PROGRAM_NAME='Exercise 3.2'
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
dvVideoProjector 			=  	5001:8:0		// IR port 4, Video Projector - Sony VPLV800Q
dvAVSwitcher			=	5001:1:0		// Serial Port 1, A/V swithcer - Extron MAV62	
dvRelays				=	5001:4:0		// Entire set of relays

dvTP					=	10001:1:0		// Ethernet, NXT-CV7 TOUCHPANEL
dvTP_VCR				=	10001:2:0		// VCR TP Controls

dvLightingSys			=	96:1:103		//AXLink Lighting SYSTEM_CALL

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
PLAY = 1
STOP = 2
PAUSE = 3
FFWD = 4
REWIND = 5
EJECT = 80
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
INTEGER nTransportStatus
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
BUTTON_EVENT[dvTP,36]
{
	PUSH:
	{
		IF(![dvRelays,1])
		{
		    ON[dvRelays,1]
		    CANCEL_WAIT 'UP'
		    OFF[dvRelays,2]
		    WAIT 70 'DOWN'
		{
			OFF[dvRelays,1]
		}
	    }
	}
}
BUTTON_EVENT[dvTP,37]
{
	PUSH:
	{
		IF (![dvRelays,2])
		{
		    ON[dvRelays,2]
		    CANCEL_WAIT 'DOWN'
		    OFF[dvRelays,1]
		    WAIT 70 'UP'
		{
			OFF[dvRelays,2]
		}
	    }
	}
}
BUTTON_EVENT[dvTP_VCR,31]
{
	PUSH:
		{
			TO [dvVCR,1]
			nTransportStatus = PLAY
		}
}
BUTTON_EVENT[dvTP_VCR,32]
{
	PUSH:
		{
			TO [dvVCR,2]
			nTransportStatus = STOP
		}
}
BUTTON_EVENT[dvTP_VCR,33]
{
	PUSH:
		{
			TO [dvVCR,3]
			nTransportStatus = PAUSE
		}
}
BUTTON_EVENT[dvTP_VCR,34]
{
	PUSH:
		{
			MIN_TO [dvVCR,4]
			nTransportStatus = FFWD
		}
}

BUTTON_EVENT[dvTP_VCR,35]
{
	PUSH:
		{
			MIN_TO [dvVCR,5]
			nTransportStatus = REWIND
		}
}
BUTTON_EVENT[dvTP_VCR,36]
{
	PUSH:
		{
			TO [dvVCR,80]
			nTransportStatus = EJECT
		}
}
 (***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)


(***********************************************************)
DEFINE_PROGRAM
[dvTP,36] = [dvRelays,1]
[dvTP,37] = [dvRelays,2]
[dvTP_VCR,31] = ( nTransportStatus == 1 )   	// VCR Play Status
[dvTP_VCR,32] = ( nTransportStatus == 2)   	// VCR Stop Status
[dvTP_VCR,33] = ( nTransportStatus == 3 )   	// VCR Pause Status
[dvTP_VCR,34] = ( nTransportStatus == 4 )  	// VCR FFWD Status
[dvTP_VCR,35] = ( nTransportStatus == 5 )   	// VCR REW Status
[dvTP_VCR,36] = ( nTransportStatus == 80 )    // VCR Eject Status
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

