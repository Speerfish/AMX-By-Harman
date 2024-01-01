PROGRAM_NAME='Programmer 2, Exercise 5, PL, Rev 0'
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
dvMaster		=			0:1:0		// NI-2000
dvSwitcher	=	 5001:1:0		// RS232-1		Autopatch		Switcher

dvTP				=	10001:1:0		// NXT-CV15
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
volatile integer INP_BTNS[] =
{
	41, 42, 43, 44,
	45, 46, 47, 48
}
volatile integer OUT_BTNS[] =
{
	51, 52, 53, 54,
	55, 56, 57, 58
}
volatile integer TAKE_BTN = 49
volatile integer RESPONSE_BTN = 59
volatile integer MAX_OUTPUTS = 8
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
volatile integer nInp
volatile integer nOutput[MAX_OUTPUTS]
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
#include 'popup.axi'
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
DATA_EVENT[dvSwitcher]
{
	online:
	{
		// SEND_COMMAND RS232_1,"'SET BAUD 115200,N,8,1 485 ENABLE'"
		send_command data.device,"'SET BAUD 9600,N,8,1 485 DISABLE'"
		send_command data.device,"'HSOFF'" // hardware handshaking/flow control
	}
	string:
	{
		stack_var integer i
		stack_var integer nInp
		stack_var integer nOut
		stack_var char sText[64]
		
		if( find_string(data.text,"'CL1I'",1) && find_string(data.text,"'T'",1) )
		{
			remove_string(data.text,"'CL1I'",1)
			
			nInp = atoi( remove_string(data.text,"'O'",1) )
			
			sText = "'Input: ',itoa(nInp),'| Output(s): '"
			
			for( i = 1; i <= length_array(data.text); i++ )
			{
				nOut = atoi( remove_string(data.text,"' '",1) )
				if( nOut >= 1 && nOut <= MAX_OUTPUTS )
				{
					nOutput[nOut] = nInp
					sText = "sText,itoa(nOut),','"
				}
			}
			nOut = atoi( remove_string(data.text,"'T'",1) )
			if( nOut >= 1 && nOut <= MAX_OUTPUTS )
			{
				nOutput[nOut] = nInp
				sText = "sText,itoa(nOut)"
			}
			send_command dvTP,"'^TXT-',itoa(RESPONSE_BTN),',0,',sText"
		}
	}
}
BUTTON_EVENT[dvTP,INP_BTNS]
{
	push:
	{
		stack_var integer i
		
		if( nInp && nInp <> get_last(INP_BTNS) )	// turn off previous inp button
			off[dvTP,INP_BTNS[nInp]]						// instead of MUTUALLY_EXCLUSIVE_GROUP
			
		nInp = get_last(INP_BTNS)		// track input number
		
		on[dvTP,INP_BTNS[nInp]]		// feedback for the current input
		
		// feedback for the output buttons to follow...
		for( i = 1; i <= MAX_OUTPUTS; i++ )
			[dvTP,OUT_BTNS[i]] = ( nOutput[i] == nInp )
	}
}
BUTTON_EVENT[dvTP,OUT_BTNS]
{
	push:
	{
		[button.input] = ![button.input]	// toggle output buttons
	}
}
BUTTON_EVENT[dvTP,TAKE_BTN]
{
	push:
	{
		stack_var char sCmd[32]
		stack_var integer i
		
		if( nInp && nInp <= MAX_OUTPUTS )	// check for a valid input
		{
			sCmd = "'CL1I',itoa(nInp),'O'"
			
			for( i = 1; i <= MAX_OUTPUTS; i++ )
			{
				if( [dvTP,OUT_BTNS[i]] == true )
					sCmd = "sCmd,itoa(i),' '"
			}
			// grab everything except for 1 last character & append T
			sCmd = "left_string(sCmd,length_array(sCmd)-1),'T'"
			
			send_string dvSwitcher,sCmd
			
			to[button.input]	// momentary feedback
		}
	}
}
BUTTON_EVENT[dvTP,RESPONSE_BTN]
{
	push:
	{
		send_command dvTP,"'^TXT-',itoa(RESPONSE_BTN),',0,'"
		to[button.input]
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

