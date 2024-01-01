PROGRAM_NAME='Programmer 2 Exercise 2, AM, Rev 0'
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
dvTP			=	10001:1:0 // NXT-CV7
rdvRelays	=	5001:4:0  // NI-2000 RELAYS
dvMaster	=		 0:1:0
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
integer SRC_BTNS [] =
{
	1, 2, 3, 4, 5
}

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
INTEGER nsrc

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
//BUTTON_EVENT[dvTP,1]
//BUTTON_EVENT[dvTP,2]
//BUTTON_EVENT[dvTP,3]
//BUTTON_EVENT[dvTP,4]
BUTTON_EVENT[dvTP,SRC_BTNS]
{
	PUSH:
	{
		LOCAL_VAR INTEGER I
		SWITCH(BUTTON.INPUT.CHANNEL)
		{
			case 1: send_command dvTP,"'@PPN-RELAYS'"	
			case 2: send_command dvTP,"'@PPN-SWITCHER'"
			case 3: send_command dvTP,"'@PPN-PRESETS'"
			case 4: send_command dvTP,"'@PPN-TCP'"
			case 5: send_command dvTP,"'@PPN-TIMELINE'"
		}
		//ON[BUTTON.INPUT]
		//nsrc = button.input.channel
		FOR( I = 1; I <= LENGTH_ARRAY(SRC_BTNS); I++ )
		{
			[DVTP,I] = (BUTTON.INPUT.CHANNEL == I )
//			IF( BUTTON.INPUT.CHANNEL == I )
//			{
//			ON[dvTP,I]
//			}
//			ELSE
//			{
//			 OFF[dvTP,I]
//			}
		}
	}
}	
BUTTON_EVENT [dvTP,11]
BUTTON_EVENT [dvTP,12]
{
	PUSH:
	{
		PULSE[rdvRelays,BUTTON.INPUT.CHANNEL-10] // PULSE [DVRELAYS,1] OR [dvRelays,2]
		PULSE[BUTTON.INPUT]											// PULSE [dvTP,11] OR [dvTP,12]
	}
}
BUTTON_EVENT [dvTP,13]
{
	PUSH:
	{
		TO[dvTP,13]						// STAYS ON WHILE INPUT SIGNAL IS ON
	}
	RELEASE:
	{
		PULSE[rdvRelays,3]
		PULSE[dvTP,13] 				// PULSE WHILE [dvRelays,3] IS PULSED
	}
}

BUTTON_EVENT[dvTP,14]
{
	PUSH:
	{
//		IF( [dvRelays,4] == FALSE)
//			{
//				ON[dvRelays,4]
//			}
//		ELSE
//		{
//			OFF[dvRelays,4]
//		}
			[rdvRelays,4] = ![rdvRelays,4]
			TO[dvTP,14]
	}
}

BUTTON_EVENT[dvTP,15]  // RELAY MACRO
{
	PUSH:
	{
		PULSE[rdvRelays,1]
	}
	RELEASE:
	{
		PULSE[rdvRelays,4]
	}
	HOLD[5,REPEAT]:
	{
		LOCAL_VAR INTEGER Rmac
		
		IF(Rmac < 4)
		{
		Rmac = Rmac+1
		}
		ELSE
		{
		Rmac = 1		
		}
		PULSE[rdvRelays,Rmac]
	}
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
//[dvTP,1] = (nsrc == 1)
//[dvTP,2] = (nsrc == 2)
//[dvTP,3] = (nsrc == 3)
//[dvTP,4] = (nsrc == 4)
//[dvTP,5] = (nsrc == 5)


//[dev,channel] = <condition> for direct feedback
[dvTP,101] = ([rdvRelays,1] == true)
[dvTP,102] = [rdvRelays,2]
[dvTP,103] = [rdvRelays,3]
[dvTP,104] = [rdvRelays,4]
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

