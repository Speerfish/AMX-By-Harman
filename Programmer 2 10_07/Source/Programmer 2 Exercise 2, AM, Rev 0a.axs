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
dvRelays	=	5001:4:0  // NI-2000 RELAYS
dvMaster  =    0:1:0	// Processor
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
STRUCTURE _sSongs
{
char sTitle [25]
integer nMin
integer nSec
}

structure _sCDInfo
{
char sCDTitle[30]
_sSongs uTrack [15]
integer nYear
char sGenre [20]
}
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
INTEGER nsrc
char sString[10] = {'Paul'} 			 // student's name
integer nTestScores[10]						 // 10 test scores
char sClassNames[20][10]					// 20 students
integer nClassScores[20][10]			// 10 test scores per student for 20 students


_sSongs uTrack5
_sSongs uButSeriously[12]
_sCDInfo uCDList[300]

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE
//([dvTP,1]..[dvTP,5])
(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
uTrack5.sTitle  ='Colours'
uTrack5.nMin  = 8
uTrack5.nSec  = 51

uButSeriously[5].sTitle = 'Colours'
uButSeriously[5].nMin = 8
uButSeriously[5].nSec = 51

uButSeriously[1].sTitle = 'Hang in Long Enough'
uButSeriously[2].sTitle = 'Thats just the way it is'

uCDList[1].sCDTitle = 'But Seroiusly'
uCDList[1].uTrack[1].nMin
uCDList[1].uTrack[1].nSec
uCDList[1].uTrack[1].sTitle = 'Hang in Long Enough'

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
data_event[dvMaster]
{
	online:
	{
	//similar to define start
	}
}
//BUTTON_EVENT[dvTP,1]
//BUTTON_EVENT[dvTP,2]
//BUTTON_EVENT[dvTP,3]
//BUTTON_EVENT[dvTP,4]
DATA_EVENT[dvIRDEVICE]
{
	ONLINE:
	{
		SEND_COMMAND dvIRDEVICE,"'CONFIG COMMAND HERE'"
	}
}
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
		// example of assinging values to different array types
		// sString = 'Paul'
		// sString = 'Ken'
		// sString[2] = 'A'
		
		// nTestScores[1] = 100
		// nTestScores[2] = 90
		// nTestScores[3] = 75
		// ..
		// nTestScores[10] = 15
		
		
		// sClassNames[1]  = 'Ken'
		// sClassNames[2]  = 'Paul'
		// sClassNames[3]  = 'Nick'
		// sClassNames[4]  = 'Willy'
		
		
		//send_command dvTP,"'^TXT-60,0,',sClassNames[1]"   write Paul to addy 60
		
		//nClassScores[1][1] = 100
		//nClassScores[1][2] = 99
		//nClassScores[1][3] = 100
		
		//nClassScores[2][1] = 100
		//nClassScores[2][2] = 0
		//nClassScores[2][3] = 55
		//nClassScores[2][4] = 100
		//nClassScores[2][5] = 90
		
		//send_command dvTP,"'^TXT-60,0,',itoa(nClassScores[1][2])" write 99 to addy 60
		
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
		PULSE[dvRelays,BUTTON.INPUT.CHANNEL-10] // PULSE [DVRELAYS,1] OR [dvRelays,2]
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
		PULSE[dvRelays,3]
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
			[dvRelays,4] = ![dvRelays,4]
			TO[dvTP,14]
	}
}

BUTTON_EVENT[dvTP,15]  // RELAY MACRO
{
	PUSH:
	{
		PULSE[dvRelays,1]
	}
	RELEASE:
	{
		PULSE[dvRelays,4]
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
		PULSE[dvRelays,Rmac]
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
[dvTP,101] = ([dvRelays,1] == true)
[dvTP,102] = [dvRelays,2]
[dvTP,103] = [dvRelays,3]
[dvTP,104] = [dvRelays,4]
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

