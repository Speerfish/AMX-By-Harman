MODULE_NAME='Relay_Sequence_Mod' (DEV dvRelaysDPS, DEV dvTouchPanelDPS,INTEGER nBtnUp,INTEGER nBtnDn)
(***********************************************************)
(*  FILE CREATED ON: 09/28/2004  AT: 17:37:55              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 09/28/2004  AT: 18:55:23        *)
(***********************************************************)
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

  AVAILABLE = 0
  LOCKOUT   = 1

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

  VOLATILE INTEGER nSequence

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

BUTTON_EVENT[dvTouchPanelDPS,nBtnUp]
{
  PUSH:
  {
	WAIT_UNTIL ( nSequence == AVAILABLE )
	{
			    nSequence = LOCKOUT
				PULSE[dvRelaysDPS,1]
	  WAIT  5 { PULSE[dvRelaysDPS,2]  
			  }
	  WAIT 10 { PULSE[dvRelaysDPS,3]  
			  }
	  WAIT 15 { PULSE[dvRelaysDPS,4]
			  }
	  WAIT 20 { nSequence = AVAILABLE 
			  }
	}
  }
}

BUTTON_EVENT[dvTouchPanelDPS,nBtnDn]
{
  PUSH:
  {
	WAIT_UNTIL ( nSequence == AVAILABLE )
	{
			    nSequence = LOCKOUT
				PULSE[dvRelaysDPS,4]
	  WAIT  5 { PULSE[dvRelaysDPS,3]  
			  }
	  WAIT 10 { PULSE[dvRelaysDPS,2]  
			  }
	  WAIT 15 { PULSE[dvRelaysDPS,1]
			  }
	  WAIT 20 {	nSequence = AVAILABLE 
			  }
	}
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
