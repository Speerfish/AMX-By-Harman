PROGRAM_NAME='Programmer 2 9_10_07, Exercise 9, PL, Rev0'
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
dvIO		=		 5001:9:0

dvTP		=		10001:1:0
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
volatile integer POPUP_BTNS[] =
{
	1, 2, 3, 4, 5
}
TL_REL	= 1
TL_ABS	= 2
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
volatile integer nCurPopup

long lTimes1[] = {125, 250, 500, 1000}
long lTimes2[] = {125, 250, 500, 1000}
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
BUTTON_EVENT[dvTP,190]		// absolute timeline
{
	push:
	{
		if( timeline_active(TL_REL) )
		{
			timeline_kill(TL_REL)
			off[dvTP,192]
		}
		
		timeline_create
			(TL_ABS,lTimes1,length_array(lTimes1),TIMELINE_ABSOLUTE,TIMELINE_REPEAT)
	}
}
BUTTON_EVENT[dvTP,191]		// relative timeline
{
	push:
	{
		if( timeline_active(TL_ABS) )
		{
			timeline_kill(TL_ABS)
			off[dvTP,192]
		}
		
		timeline_create
			(TL_REL,lTimes2,length_array(lTimes2),TIMELINE_RELATIVE,TIMELINE_REPEAT)
	}
}
TIMELINE_EVENT[TL_ABS]
TIMELINE_EVENT[TL_REL]
{
	[dvIO,1] = (timeline.sequence == 1)
	[dvIO,2] = (timeline.sequence == 2)
	[dvIO,3] = (timeline.sequence == 3)
	[dvIO,4] = (timeline.sequence == 4)
	
	send_command dvTP,"'^TXT-200,0,',itoa(timeline.repetition)"
}
BUTTON_EVENT[dvTP,192]	// pause
{
	push:
	{
		[button.input] = ![button.input]
		
		if( [button.input] )		// pause
		{
			if( timeline_active(TL_ABS) )
				timeline_pause(TL_ABS)
			
			if( timeline_active(TL_REL) )
				timeline_pause(TL_REL)
		}
		else	// restart
		{
			if( timeline_active(TL_ABS) )
				timeline_restart(TL_ABS)
			
			if( timeline_active(TL_REL) )
				timeline_restart(TL_REL)
		}
	}
}
BUTTON_EVENT[dvTP,193]	// reload
{
	push:
	{
		local_var integer nLen
		
		if( nLen == 4 )
			nLen = 2
		else
			nLen = 4
			
		if( timeline_active(TL_ABS) )
			timeline_reload(TL_ABS,lTimes1,nLen)
		
		if( timeline_active(TL_REL) )
			timeline_reload(TL_REL,lTimes2,nLen)
		
		to[button.input]
	}
}
BUTTON_EVENT[dvTP,194]	// stop
{
	push:
	{
		timeline_kill(TL_ABS)
		timeline_kill(TL_REL)
	}
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
[dvTP,190] = timeline_active(TL_ABS)
[dvTP,191] = timeline_active(TL_REL)

[dvTP,194] = ( !timeline_active(TL_ABS) && !timeline_active(TL_REL) )

[dvTP,201] = [dvIO,1]
[dvTP,202] = [dvIO,2]
[dvTP,203] = [dvIO,3]
[dvTP,204] = [dvIO,4]
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

