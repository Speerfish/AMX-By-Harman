PROGRAM_NAME='Programmer 2, Exercise 3, AM, Rev0'
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
dvTP		=	10001:1:0 // NXT-CV7
dvRelays	=	 5001:4:0 // NI-2000 RELAYS
dvTuner		=	 5001:5:0 // IR-1 Sony TU1041
dvMaster  	=	     0:1:0	// Processor
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
integer SRC_BTNS [] =
{
	1, 2, 3, 4, 5
}
INTEGER MAX_PRESETS = 5

INTEGER EDIT_BTNS[] =
{
	63,64
}

INTEGER PRESET_BTNS[] =
{
	65, 66, 67, 68, 69
}

INTEGER SCROLL_BTNS[] =
{
	61, 62
}

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
// 3.1.) CREATE A STRUCTURE TO STORE PRESETS
DEFINE_TYPE
STRUCTURE _sPresets
{
char sChannelName[20]
integer nChannel
}
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
// 3.2.) CREATE A VARIABLE TO USE THE STRUCTURE
PERSISTENT _sPresets uListings[MAX_PRESETS]
INTEGER nCURPRESETS						// 1-5
INTEGER nEDITMODE						// 0 = NORMAL, 1 = EDIT NUMBER, 2 = EDIT NAME
PERSISTENT INTEGER bLOADED 		//
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
#INCLUDE	'KeyboardParsing.axi'
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
DATA_EVENT[dvMaster]
{
	online:
	{ //3.3.) load the variable with data
		IF( bLOADED == FALSE)
		{
			uListings[1].sChannelName = 'ESPN'
			uListings[2].sChannelName = 'ESPN 2'
			uListings[3].sChannelName = 'ESPN NEWS'
			uListings[4].sChannelName = 'FOX'
			uListings[5].sChannelName = 'FOX SPORTS'
	
			uListings[1].nChannel = 34
			uListings[2].nChannel = 35
			uListings[3].nChannel = 405
			uListings[4].nChannel = 13
			uListings[5].nChannel = 26
			
			bLOADED = TRUE		// ON[bLOADED] OR bLOADED = 1
		}
	}
}

DATA_EVENT[dvTuner]
{
	online:
	{	// 4.1.) IR CONFIG
		SEND_COMMAND DATA.DEVICE,"'SET MODE IR'"
		SEND_COMMAND DATA.DEVICE,"'CARON'"		//may or may not be necessary
		
		// 4.2.) SEND CURRENT PRESET
		IF( (nCURPRESETS > 0) && (nCURPRESETS <= MAX_PRESETS) )
		{
			SEND_COMMAND dvTuner,"'XCH ',ITOA(uListings[nCURPRESETS].nChannel)"
		}
	}
}

DATA_EVENT[dvTP]
{
	ONLINE:
		{  // 5.) DISPLAY CHANNEL NAMES WHEN TP COMES ONLINE
		LOCAL_VAR INTEGER I
			FOR(I = 1; I<= MAX_PRESETS; I++)
			{
				SEND_COMMAND DATA.DEVICE, "'^TXT-',ITOA(61+I),',0,',uListings[I].sChannelName"
				SEND_COMMAND DATA.DEVICE, "'^TXT-',ITOA(67+I),',0,',ITOA(uListings[I].nCHANNEL)"
			}
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
		FOR( I = 1; I <= LENGTH_ARRAY(SRC_BTNS); I++ )
		{
			[DVTP,I] = (BUTTON.INPUT.CHANNEL == I )
		}
	}
}


// 6.) SET UP EDIT NAME AND EDIT NUMBER
BUTTON_EVENT[dvTP,EDIT_BTNS]
{
	PUSH:
		{
			IF (!nEDITMODE || nEDITMODE <> GET_LAST(EDIT_BTNS) )
			{	// IF nEDITMODE MODE == 0 OR nEDITMODE MODE IS DIFFERENT THAN LAST STATE || = OR, <> = NOT EQUAL
				nEDITMODE = GET_LAST(EDIT_BTNS)
			}
			ELSE
			{	// nEDITMODE IS EQUAL TO PREVIOUS MODE
			nEDITMODE = 0
			}
				//FB BASE ON nEDITMODE
			[dvTP,EDIT_BTNS[1]] = (nEDITMODE == 1)
			[dvTP,EDIT_BTNS[2]] = (nEDITMODE == 2)
			
		}
}

// 7a.-7c.) Preset buttons 1-5
BUTTON_EVENT[dvTP,PRESET_BTNS]
{
	PUSH:
	{
		nCURPRESETS = get_last(PRESET_BTNS)
		SWITCH(nEDITMODE)
		{				// no edit mode
			CASE 0: 
			{
				send_command button.input.device,"'^TXT-61,0,',uListings[nCURPRESETS].sChannelName"
				send_command button.input.device,"'^TXT-67,0,',itoa(uListings[nCURPRESETS].nChannel)"
				send_command dvTuner,"'XCH ',itoa(uListings[nCURPRESETS].nChannel)"
			}  
			CASE 1: 
			{				// Edit number
				send_command button.input.device, 
				"'@AKP-',itoa(uListings[nCURPRESETS].nChannel),';Enter number'"
			}
			CASE 2: 
			{				// Edit Name
				send_command button.input.device,
				"'@AKB-',uListings[nCURPRESETS].sChannelName,';Enter name'"
			}
		}
	}
	RELEASE:
	{	// ASSIGN HERE
		WAIT_UNTIL (bTPDONE) 'TP'
		{
			IF ( nEDITMODE == 1 )
			{	//NUMBER MODE
				uListings[nCURPRESETS].nCHANNEL = nTPNUMBER
			}
			ELSE
			{	// NAME MODE
				uListings[nCURPRESETS].sCHANNELNAME = sTPDATA
			}
			
			SEND_COMMAND dvTP,
				"'^TXT-',ITOA(61+nCURPRESETS),',0,',uListings[nCURPRESETS].sCHANNELNAME"
			SEND_COMMAND dvTP,
				"'^TXT-',ITOA(67+nCURPRESETS),',0,',ITOA(uListings[nCURPRESETS].nCHANNEL)"
			
		}
	}
}
// 8.) SCROLL_BTNS to scroll through channel preset info
BUTTON_EVENT[dvTP,SCROLL_BTNS]
{
	push:
	{
		cancel_wait 'SCROLL'
		
		if( get_last(SCROLL_BTNS) == 1)
		{		// '-' btn
			nCURPRESETS--
			if( nCURPRESETS <= 0 )
				nCURPRESETS = MAX_PRESETS
		}
		else
		{		// '+' btn
			nCURPRESETS++
			if( nCURPRESETS > MAX_PRESETS )
				nCURPRESETS = 1
		}
		
		// update current channel info
		send_command dvTP,"'^TXT-61,0,',uListings[nCURPRESETS].sChannelName"
		send_command dvTP,"'^TXT-67,0,',itoa(uListings[nCURPRESETS].nChannel)"
		
		to[button.input]			// momentary fb
	}
	release:
	{
		wait 3 'SCROLL'
		{
			send_command dvTUNER,"'XCH ',itoa(uListings[nCURPRESETS].nChannel)"
		}
	}
	hold[5,repeat]:
	{
		if( get_last(SCROLL_BTNS) == 1)
		{
			nCURPRESETS--
			if( nCURPRESETS <= 0 )
				nCURPRESETS = MAX_PRESETS
		}
		else
		{
			nCURPRESETS++
			if( nCURPRESETS > MAX_PRESETS )
				nCURPRESETS = 1
		}
		// update current channel info
		send_command dvTP,"'^TXT-61,0,',uListings[nCURPRESETS].sChannelName"
		send_command dvTP,"'^TXT-67,0,',itoa(uListings[nCURPRESETS].nChannel)"
	}
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
[dvTP,PRESET_BTNS[1]] = ( nCURPRESETS == 1 )
[dvTP,PRESET_BTNS[2]] = ( nCURPRESETS == 2 )
[dvTP,PRESET_BTNS[3]] = ( nCURPRESETS == 3 )
[dvTP,PRESET_BTNS[4]] = ( nCURPRESETS == 4 )
[dvTP,PRESET_BTNS[5]] = ( nCURPRESETS == 5 )
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

