PROGRAM_NAME='Exercise 6.1'
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
dvTP_Proj	=1001:3:0  // Port for projector functions

dvProj 		= 5001:2:0  // insert HP projector here
vdvProj		=33001:1:0 // unused virtual device addy

DEFINE_MODULE 'HP_XP8010_Comm' COMM1(dvProj, vdvProj)

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
PROJ_OFF = 0
PROJ_ON = 1
PROJ_COOLING = 2
PROJ_WARMING = 3
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
INTEGER nHPProjPower		//power status
INTEGER nHPProjInput			// input number
INTEGER nHPProjLamptime		// lamp time used
VOLATILE INTEGER FLASH		
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
BUTTON_EVENT[dvTP_Proj,1]   /// input 1
BUTTON_EVENT[dvTP_Proj,2]   /// input 2
BUTTON_EVENT[dvTP_Proj,3]   /// input 3
BUTTON_EVENT[dvTP_Proj,4]   /// input 4
BUTTON_EVENT[dvTP_Proj,5]   /// input 5
BUTTON_EVENT[dvTP_Proj,6]   /// input 6
BUTTON_EVENT[dvTP_Proj,7]   /// input 7
BUTTON_EVENT[dvTP_Proj,8]   /// input 8
BUTTON_EVENT[dvTP_Proj,9]   /// input 9
{
    PUSH:
    {
    SEND_COMMAND vdvProj, " 'INPUT=', ITOA(BUTTON.INPUT.CHANNEL)"
    }
}

BUTTON_EVENT[dvTP_Proj,10] ///  POWER ON
{
    PUSH:
    {
    SEND_COMMAND vdvProj, "'POWER=1'"
    }
}
BUTTON_EVENT[dvTP_Proj,11] ///  POWER OFF
{
    PUSH:
    {
    SEND_COMMAND vdvProj, "'POWER=0'"
    }
}

DATA_EVENT[vdvProj]  /// listen to module
{
    STRING:
    {
	SELECT
	{
	ACTIVE( FIND_STRING(DATA.TEXT, 'POWER=',1) ):
	{	
	    nHPProjPower = ATOI(DATA.TEXT)
	}
	ACTIVE( FIND_STRING(DATA.TEXT, 'INPUT=',1) ):
	{
	    nHPProjInput = ATOI(DATA.TEXT)
	}
	ACTIVE( FIND_STRING(DATA.TEXT, 'LAMPTIME=',1) ):
	{
	    nHPProjLamptime = ATOI(DATA.TEXT)
	}
    }
  }
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
WAIT 5
{
    FLASH = NOT FLASH
}

[dvTP_Proj,10] =  (nHPProjPower = PROJ_ON) OR
			    ((nHPProjPower = PROJ_WARMING) AND FLASH)

[dvTP_Proj,11] =  (nHPProjPower = PROJ_OFF) OR
			    ((nHPProjPower = PROJ_COOLING) AND FLASH)

[dvTP_Proj,1] = (nHPProjInput = 1) AND FLASH
[dvTP_Proj,2] = nHPProjInput = 2
[dvTP_Proj,3] = nHPProjInput = 3
[dvTP_Proj,4] = nHPProjInput = 4
[dvTP_Proj,5] = nHPProjInput = 5
[dvTP_Proj,6] = nHPProjInput = 6
[dvTP_Proj,7] = nHPProjInput = 7
[dvTP_Proj,8] = nHPProjInput = 8
[dvTP_Proj,9] = nHPProjInput = 9
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)