PROGRAM_NAME='Programmer 2 9_10_07, Exercise 8, PL, Rev0'
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
dvMASTER	=					0:1:0
dvSERVER	=					0:3:0
dvCLIENT	=					0:4:0

dvTP			=			10001:1:0
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
volatile integer POPUP_BTNS[] =
{
	1, 2, 3, 4, 5
}
TCP_PORT	= 87

TL_ID	= 1
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
volatile integer nCurPopup
char cBuffer[1000]
char sIPAddress[15]

long lTLArray[] = {50, 100, 175, 200, 5000}
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
include 'keyboardParsing.axi'
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
create_buffer dvSERVER, cBuffer
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
DATA_EVENT[dvMASTER]
{
	online:
	{
		ip_server_open(dvSERVER.PORT,TCP_PORT,IP_TCP)
		
		timeline_create(TL_ID,lTLArray,length_array(lTLArray),TIMELINE_ABSOLUTE,TIMELINE_REPEAT)
	}
}
DATA_EVENT[dvSERVER]
{
	online:
	{
		on[dvSERVER,255]
		send_command dvTP,"'ADBEEP'"
		on[dvTP,150]
		
		send_command dvTP,"'^TXT-151,0,',data.sourceip"
	}
	string:
	{
		//local_var char sMsg[128]
		
		//sMsg = "sMsg,data.text"
		
		if( find_string(cBuffer,"':'",1) > 0 )
		{
			cBuffer = left_string(cBuffer,length_array(cBuffer)-1)
			send_command dvTP,"'^TXT-153,0,',cBuffer"	//send_command dvTP,"'^TXT-153,0,',sMsg"
			
			send_command dvTP,"'^TXT-152,0,Your msg was - ',cBuffer"
			send_string dvSERVER,"'Your msg was - ',cBuffer"
			
			clear_buffer cBuffer		// sMsg = "''"
		}
	}
	offline:
	{
		off[dvSERVER,255]
		off[dvTP,150]
		
		send_command dvTP,"'^TXT-151,0,'"
		send_command dvTP,"'^TXT-152,0,'"
		send_command dvTP,"'^TXT-153,0,'"
		
		ip_server_open(dvSERVER.PORT,TCP_PORT,IP_TCP)
	}
}
DATA_EVENT[dvCLIENT]
{
	online:
	{
		on[dvCLIENT,255]
		on[dvTP,152]
	}
	offline:
	{
		off[dvCLIENT,255]
		off[dvTP,152]
		
		send_command dvTP,"'^TXT-155,0,'"
		send_command dvTP,"'^TXT-156,0,'"
	}
	string:
	{
		send_command dvTP,"'^TXT-156,0,',data.text"
	}
}
BUTTON_EVENT[dvTP,POPUP_BTNS]
{
	push:
	{
		stack_var integer i
		
		nCurPopup = get_last(POPUP_BTNS)
		
		switch(nCurPopup)
		{
			case 1:	send_command dvTP,"'@PPN-RELAYS'"
			case 2:	send_command dvTP,"'@PPN-SWITCHER'"
			case 3:	send_command dvTP,"'@PPN-PRESETS'"
			case 4:	send_command dvTP,"'@PPN-TCP'"
			case 5:	send_command dvTP,"'@PPN-TIMELINE'"
		}
		
		for( i = 1; i <= length_array(POPUP_BTNS); i++ )
			[dvTP,i] = ( nCurPopup == i )
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
				sIPAddress = "'192.168.150.',itoa(nTPNumber)"
				send_command dvTP,"'^TXT-154,0,',sIPAddress"
				on[dvTP,151]
			}
			else
			{
				sIPAddress = "''"
				send_command dvTP,"'^TXT-154,0,Invalid # ',itoa(nTPNumber)"
				off[dvTP,151]
			}
		}
	}
}
BUTTON_EVENT[dvTP,152]
{
	push:
	{
		if( [dvTP,151] )
		{
			ip_client_open(dvCLIENT.PORT,sIPAddress,TCP_PORT,IP_TCP)
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
		if( [dvTP,152] )
		{
			send_command dvTP,"'@AKB-;Enter msg'"
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
TIMELINE_EVENT[TL_ID]
{
	if( timeline.sequence == 1 )
	{
		// open projector door
	}
	if( timeline.sequence == 2 )
	{
		// lower projector
	}
	if( timeline.sequence == 3 )
	{
		
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

