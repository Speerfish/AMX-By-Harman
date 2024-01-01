PROGRAM_NAME='exercise 7.2'
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
dvVOL 					= 	305:2:113
dvTP					=	10001:1:0
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
INTEGER nBarGraph
INTEGER PRESET1
INTEGER PRESET2
INTEGER VOL_LEVEL
INTEGER VOL_LEVEL2
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
LEVEL_EVENT [dvVOL,1]
{
    SEND_LEVEL dvTP,  1, LEVEL.VALUE 
    nBarGraph = LEVEL.VALUE
    VOL_LEVEL = LEVEL.VALUE
    SEND_COMMAND dvTP, "'TEXT57-', ITOA((nBarGraph*100) / 255),'%' "
}
LEVEL_EVENT [dvVOL,2]
{
    SEND_LEVEL dvTP,  2, LEVEL.VALUE 
    nBarGraph = LEVEL.VALUE
    VOL_LEVEL2 = LEVEL.VALUE
    SEND_COMMAND dvTP, "'TEXT58-', ITOA((nBarGraph*100) / 255),'%' "
}
BUTTON_EVENT  [dvTP,53]
{
RELEASE:
{
    SEND_COMMAND dvVOL,"'P1L' ,  ITOA(PRESET1)"
}
HOLD[20]:
    {
    PRESET1 = VOL_LEVEL
    SEND_COMMAND  dvTP, " 'ABEEP' "
    }
}
BUTTON_EVENT  [dvTP,55]
{
RELEASE:
{
    SEND_COMMAND dvVOL," ' P2L' ,  ITOA(PRESET2)"
}
HOLD[20]:
    {
    PRESET2 = VOL_LEVEL2
    SEND_COMMAND  dvTP, " 'ABEEP' "
    }
}
BUTTON_EVENT  [dvTP,51]
BUTTON_EVENT  [dvTP,52]
BUTTON_EVENT  [dvTP,54]
BUTTON_EVENT  [dvTP,56]
{
    PUSH:
    {
	SWITCH(BUTTON.INPUT.CHANNEL)
	{
	    CASE 51:
	    {
		OFF [dvVOL,6]
		TO[dvVOL,4]
	    }
	    CASE 52:
	    {
		OFF[dvVOL,9]
		TO[dvVOL,5]
	    }
	    CASE 54:
	    {
		[dvVOL,6] = ![dvVOL,6]
	    }
	    CASE 56:
	    {
		[dvVOL,9] = ![dvVOL,9]
	    }
	}
    }
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
[dvTP,51] = [dvVOL,4]
[dvTP,52] = [dvVOL,5]
[dvTP,53] = (PRESET1 == VOL_LEVEL)
[dvTP,54] = [dvVOL,6]
[dvTP,55] = (PRESET2 == VOL_LEVEL2)
[dvTP,56] = [dvVOL,9]
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

