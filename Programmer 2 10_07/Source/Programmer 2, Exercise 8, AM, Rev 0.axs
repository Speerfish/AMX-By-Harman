PROGRAM_NAME='Programmer 2, Exercise 8, AM, Rev 0'
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
dvMASTER			=				0:1:0
dvSERVER			=				0:3:0
dvCLIENT			=				0:4:0
dvTP					=		10001:1:0 	// NXT-CV7
dvProj				=		 5001:1:0
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
integer TCP_PORT = 87
integer TL_CMD	 = 1
integer TL_Proj	 = 2
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
char cBuffer[128]
char cClientBuffer[128]
char sIPAddy[15]
VOLATILE LONG lTimeCmd[] = { 300 }  // time in milliseconds
volatile long lTimeProj[] = {50, 100, 150, 200}
volatile integer nProjSequence
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
include 'popup.axi'
include 'KeyboardParsing.axi'
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
create_buffer dvSERVER, cBuffer
create_buffer dvCLIENT, cClientBuffer
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
DATA_EVENT[dvMASTER]
{
	online:
	{
		ip_server_open( dvSERVER.PORT, TCP_PORT, IP_TCP)
		timeline_create( tl_cmd, lTimeCmd, length_array(lTimeCmd), timeline_relative, timeline_repeat)
	}
}
timeline_event[tl_cmd]
{
	//check my command buffer for commands
	//remove one command from buffer
	//send a command to the device
	
	if( length_array(cBuffer) )
	{
		send_string dvCLIENT, remove_string(cBuffer,"':'",1)
	}
}
DATA_EVENT[dvSERVER]
{
	online:
	{
		on[data.device,255]
		send_command dvTP,"'ADBEEP'"
		
		send_command dvTP,"'^TXT-151,0,',data.sourceip"
	}
	
	offline:
	{
		off[data.device,255]
		
		send_command dvTP,"'^TXT-151,0,'"
		send_command dvTP,"'^TXT-152,0,'"
		send_command dvTP,"'^TXT-153,0,'"
		
		ip_server_open( dvSERVER.PORT, TCP_PORT, IP_TCP )
	}
	
	string:
	{
		if( find_string(cBuffer,"':'",1) > 0 )
		{
			cBuffer = left_string(cBuffer,length_array(cBuffer)-1)
			send_command dvTP,"'^TXT-153,0,',cBuffer"
			
			send_command dvTP,"'^TXT-152,0,Your msg was: ',cBuffer"
			send_string dvSERVER,"'Your msg was: ',cBuffer"
			
			clear_buffer cBuffer
		}
	}
}

DATA_EVENT[dvCLIENT]
{
	online:
	{
		on[dvCLIENT,255]
	}
	offline:
	{
		off[dvCLIENT,255]
		
		send_command dvTP,"'^TXT-155,0,'"
		send_command dvTP,"'^TXT-156,0,'"
	}
	string:
	{
		if( find_string(cClientBuffer,"':'",1) )
		{
			cClientBuffer = left_string(cClientBuffer, length_array(cClientBuffer)-1)
			send_command dvTP,"'^TXT-156,0,',data.text"
			clear_buffer cClientBuffer
		}
	}
}

BUTTON_EVENT[dvTP,150]
{
	push:
	{
		if( [dvSERVER,255] )
		{
			ip_server_close(dvSERVER.PORT)
		}
	}
}
BUTTON_EVENT[dvTP,151]
{
	push:
	{
		if( ![dvCLIENT,255] )
		{
			send_command dvTP,"'@AKP-;Enter node'"
		}
	}
	release:
	{
		wait_until (bTPDone) 'TP'
		{
			if( nTPNumber > 0 && nTPNumber < 255 )
			{
				sIPAddy = "'192.168.150.',itoa(nTPNumber)"
				send_command dvTP,"'^TXT-154,0,',sIPAddy"
				on[dvTP,151]
			}
			else
			{
				sIPAddy = "''"
				send_command dvTP,"'^TXT-154,0,Incorrect #',itoa(nTPNumber)"
				off[dvTP,151]
			}
		}
	}
}

BUTTON_EVENT[dvTP,152]
{
	push:
	{
		if( [dvTP,151] && ![dvTP,152] )
		{
			ip_client_open( dvCLIENT.PORT, sIPAddy, TCP_PORT, IP_TCP )
		}
		if( [dvTP,152] )
		{
			ip_client_close(dvCLIENT.PORT)
		}
	}
}
BUTTON_EVENT[dvTP,153]
{
	push:
	{
		if( [dvCLIENT,255] )
		{
			send_command dvTP,"'@AKB-;Enter Message'"
		}
	}
	release:
	{
		wait_until (bTPDone) 'TP'
		{
			send_string dvCLIENT,"sTPData,':'"
			send_command dvTP,"'^TXT-155,0,',sTPData"
		}
	}
}
button_event[dvTP,154] // Proj Status popup
{
	push:
	{
		timeline_create( TL_Proj, lTimeProj, length_array(lTimeProj), timeline_absolute, timeline_repeat)
	}
}
button_event[dvTP,155]
{
	push:
	{
		timeline_kill(TL_Proj)
	}
}
timeline_event[TL_Proj]
{
	nProjSequence = timeline.sequence
	switch(nProjSequence)
	{
		case 1: // ask for power status
		{}
		case 2: // ask for lamp hours
		{}
		case 3: // ask for input status
		{}
	}
}
data_event[dvProj]
{
	string:
		{
			switch(nProjSequence)
			{
				case 1: // response to power status
				case 2: // response to lamp hours
				case 3:	// response to input status
				{}
			}
		}
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
[dvTP,150] = [dvSERVER,255]
[dvTP,152] = [dvSERVER,255]
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

