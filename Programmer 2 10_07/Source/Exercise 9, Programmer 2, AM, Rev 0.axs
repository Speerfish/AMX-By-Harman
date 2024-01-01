PROGRAM_NAME='Exercise 9, Programmer 2, AM, Rev 0'
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
dvTP					=		10001:1:0 	// NXT-CV7
dvIO					=		 5001:9:0
//rdvIO					=		 5001:9:206
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
volatile integer	TL_REL	= 1
volatile integer	TL_ABS	= 2
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
long lTimes1[] = {125, 250, 500, 1000}
long lTimes2[] = {125, 250, 500, 1000}
long lTimes3[] = {100, 200, 300, 400}

integer nCurTLid
volatile integer bReloaded
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
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
timeline_event[tl_abs]
timeline_event[tl_rel]
{
	if(timeline.sequence == 1 )
		send_command dvTP,"'^TXT-200,0,',itoa(timeline.repetition)"	
	
	[dvIO,1] = (timeline.sequence == 1)
	[dvIO,2] = (timeline.sequence == 2)
	[dvIO,3] = (timeline.sequence == 3)
	[dvIO,4] = (timeline.sequence == 4)
}

button_event[dvTP,190]		// absolute timeline
{
	push:
	{
		if( timeline_active(tl_rel) )
		{
			timeline_kill(tl_rel)
			off[dvtp,192]		//pause timeline
			off[bReloaded]
		}
		
		timeline_create(tl_abs, lTimes1, length_array(lTimes1), timeline_absolute, timeline_repeat)
		nCurTLid = tl_abs
	}
}

button_event[dvTP,191]		// relative timeline
{
	push:
	{
		if( timeline_active(tl_abs) )
		{
			timeline_kill(tl_abs)
			off[dvtp,192]		//pause timeline
			off[bReloaded]
		}
		
		timeline_create(tl_rel, lTimes2, length_array(lTimes2), timeline_absolute, timeline_repeat)
		nCurTLid = tl_rel
	}
}

BUTTON_EVENT[dvTP,192]	// pause button
{
	push:
	{
		[button.input] = ![button.input]
		
		if( [button.input] )
				{
					timeline_pause(nCurTLid)
				}
		else	// restart
		{
				timeline_restart(nCurTLid)
		}
	}
}
button_event[dvtp,193]
{
	push:
	{
		bReloaded = !bReloaded
		
		if(bReloaded)
		{
			timeline_reload(nCurTLid, lTimes3, length_array(lTimes3) )
		}
		else
		{
			if( nCurTLid == tl_abs )
				timeline_reload(tl_abs, lTimes1, length_array(lTimes1) )
			else
				timeline_reload(tl_rel, lTimes2, length_array(lTimes2) )
		}
		
		to[button.input]
	}
}
BUTTON_EVENT[dvTP,194]	// stop button
{
	push:
	{
		timeline_kill(tl_abs)
		timeline_kill(tl_rel)
		
		send_command dvTP,"'^TXT-200,0,'"
	}
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
[dvTP,190] = timeline_active(tl_abs)
[dvTP,191] = timeline_active(tl_rel)

[dvTP,194] = !timeline_active(tl_abs) && !timeline_active(tl_rel)

[dvTP,201] = [dvIO,1]
[dvTP,202] = [dvIO,2]
[dvTP,203] = [dvIO,3]
[dvTP,204] = [dvIO,4]
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

