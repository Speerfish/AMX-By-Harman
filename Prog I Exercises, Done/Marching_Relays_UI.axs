MODULE_NAME='Marching_Relays_UI' ( DEV vdvCommDPS, DEV dvTPDPS, INTEGER nBtns[3], INTEGER nRelayLEDs[4] )
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

	stateAllOff     = 0
	stateMarchingUp = 1
	stateMarchingDn = 2
	stateAllOn      = 3

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

	VOLATILE INTEGER nState
	VOLATILE INTEGER nStateRelays[4]

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

BUTTON_EVENT[dvTPDPS,nBtns]
{
	PUSH:
	{
		SWITCH( GET_LAST(nBtns) )
		{
			CASE 1: { SEND_COMMAND vdvCommDPS,'ALL=1'   }
			CASE 2: { SEND_COMMAND vdvCommDPS,'MARCH=-' }
			CASE 3: { SEND_COMMAND vdvCommDPS,'MARCH=+' }
		}
	}
	RELEASE:
	{
		IF ( BUTTON.INPUT.CHANNEL == nBtns[1] )
		{
			SEND_COMMAND vdvCommDPS,'ALL=0'
		}
	}
}

DATA_EVENT[vdvCommDPS]
{
	STRING:
	{
		STACK_VAR CHAR sCommand[6]
		
		sCommand = REMOVE_STRING(DATA.TEXT,'=',1)
		
		SWITCH(sCommand)
		{
			CASE 'ALL=' : 
			{ 
				SWITCH(DATA.TEXT)
				{
					CASE '0': { nState = stateAllOff }
					CASE '1': { nState = stateAllOn  }
				}
			}
			CASE 'MARCH=':
			{
				SWITCH(DATA.TEXT)
				{
					CASE '+': { nState = stateMarchingUp }
					CASE '-': { nState = stateMarchingDn }
					CASE '0': { nstate = stateAllOff     }
				}
			}
			CASE 'RELAY=':
			{
				nStateRelays[ATOI(RIGHT_STRING(DATA.TEXT,1))] = ATOI(LEFT_STRING(DATA.TEXT,1))
			}
		}
	}
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

[dvTPDPS,nBtns[1]] = ( nState == stateAllOn      )
[dvTPDPS,nBtns[2]] = ( nState == stateMarchingDn )
[dvTPDPS,nBtns[3]] = ( nState == stateMarchingUp )

[dvTPDPS,nRelayLEDs[1]] = nStateRelays[1]
[dvTPDPS,nRelayLEDs[2]] = nStateRelays[2]
[dvTPDPS,nRelayLEDs[3]] = nStateRelays[3]
[dvTPDPS,nRelayLEDs[4]] = nStateRelays[4]

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
