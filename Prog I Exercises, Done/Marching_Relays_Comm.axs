MODULE_NAME='Marching_Relays_Comm' (DEV vdvCommDPS, DEV dvRelaysDPS)
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

  stateAvailable  = 0
  stateMarchingUp = 1
	stateMarchingDn = 2
	stateOn         = 3



(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

  VOLATILE INTEGER nState

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

DEFINE_CALL 'All Relays' ( CHAR sFlip[1] )
{
	CANCEL_WAIT_UNTIL 'Command Buffer'
	CANCEL_WAIT 'Relay 1'
	CANCEL_WAIT 'Relay 2'
	CANCEL_WAIT 'Relay 3'
	CANCEL_WAIT 'Relay 4'
	
	IF ( nState == stateMarchingDn OR nState == stateMarchingUp )
	{
		SEND_STRING vdvCommDPS,'MARCH=0'
		nState = stateAvailable
	}
	
	SWITCH ( sFlip )
	{
		CASE '1': { nState = stateOn
          		  ON[dvRelaysDPS,1]
		            ON[dvRelaysDPS,2]
								ON[dvRelaysDPS,3]
								ON[dvRelaysDPS,4]
								SEND_STRING vdvCommDPS,'ALL=1'
							}
		CASE '0': { OFF[dvRelaysDPS,1]
		            OFF[dvRelaysDPS,2]
								OFF[dvRelaysDPS,3]
								OFF[dvRelaysDPS,4]
								nState = stateAvailable
								SEND_STRING vdvCommDPS,'ALL=0'
		          }
	}
}

DEFINE_CALL 'March Relays' ( CHAR sDirection[1] )
{
	SWITCH(sDirection)
	{
		CASE '+':
		{
			WAIT_UNTIL ( nState == stateAvailable ) 'Command Buffer'
			{
				                    nState = stateMarchingUp
									          SEND_STRING vdvCommDPS,'MARCH=+'
									          PULSE[dvRelaysDPS,1]
				WAIT  5 'Relay 1' { PULSE[dvRelaysDPS,2] }
				WAIT 10 'Relay 2' { PULSE[dvRelaysDPS,3] }
				WAIT 15 'Relay 3' { PULSE[dvRelaysDPS,4] }
				WAIT 20 'Relay 4' { nState = stateAvailable 
													  SEND_STRING vdvCommDPS,'MARCH=0'
													}
			}
		}
		CASE '-':
		{
			WAIT_UNTIL ( nState == stateAvailable ) 'Command Buffer'
			{
				                    nState = stateMarchingDn
			                      SEND_STRING vdvCommDPS,'MARCH=-'
						                PULSE[dvRelaysDPS,4]
				WAIT  5 'Relay 1' { PULSE[dvRelaysDPS,3] }
				WAIT 10 'Relay 2' { PULSE[dvRelaysDPS,2] }
				WAIT 15 'Relay 3' { PULSE[dvRelaysDPS,1] }
				WAIT 20 'Relay 4' { nState = stateAvailable 
				                    SEND_STRING vdvCommDPS,'MARCH=0'
								          }
			}
		}
	}
}


(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[vdvCommDPS]
{
	COMMAND:
	{
		STACK_VAR sCommand[6]
		
		// remove everything up to the equal sign
		sCommand = REMOVE_STRING(DATA.TEXT,'=',1)
		
		SWITCH (sCommand)
		{
			CASE 'ALL=':
			{
				
				CALL 'All Relays' ( DATA.TEXT )
			}
			CASE 'MARCH=':
			{
				CALL 'March Relays' ( DATA.TEXT )
			}
		}
	}
}

CHANNEL_EVENT[dvRelaysDPS,1]
CHANNEL_EVENT[dvRelaysDPS,2]
CHANNEL_EVENT[dvRelaysDPS,3]
CHANNEL_EVENT[dvRelaysDPS,4]
{
	ON:
	{
		SEND_STRING vdvCommDPS,"'RELAY=1:',ITOA(CHANNEL.CHANNEL)"
	}
	OFF:
	{
		SEND_STRING vdvCommDPS,"'RELAY=0:',ITOA(CHANNEL.CHANNEL)"
	}
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
