PROGRAM_NAME='Programmer 2, Exercise 5, AM, Rev 0'
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
dvMaster  		=     	0:1:0		// NI-2000		Processor
dvSwitcher		=		 5001:1:0		// RS232-1		Autopatch	****** 9600,N,8,1
dvTP					=		10001:1:0 	// NXT-CV7
dvClientProj	=				0:3:0
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

integer SRC_BTNS [] =
{
	1, 2, 3, 4, 5
}

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
volatile integer RESP_BTN = 59
volatile integer MAX_OUTS = 8
volatile integer MAX_INPS = 8
volatile integer TCP_PORT = 5000
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
volatile integer nCurInp
volatile integer nStatus[MAX_OUTS]
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
DEFINE_FUNCTION char checkSum ( char sString[] )
{
	stack_var integer i
	stack_var char ckSum
	
	for ( i = 1; i<= length_array(sString); i++ )
	{
		ckSum = ckSum + sString[i]  // ckSum = ckSum + sString[i]
	}
	return ckSum
}
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
		send_command data.device,"'SET BAUD 9600,N,8,1 485 DISABLE'"
		send_command data.device,"'HSOFF'"
	}

string:
	{
		//parse switcher response
		stack_var integer nIn
		stack_var integer nOut
		stack_var char sTemp[64]
		
		if( find_string(data.text,"'CL1I'",1) && find_string(data.text,"'T'",1) )
		{
			remove_string(data.text,"'CL1I'",1)
			
			nIn = atoi( remove_string(data.text,"'O'",1) )
			
			sTemp = "'Input: ',itoa(nIn),'| Output(s): '"
			
			while( find_string(data.text,"' '",1) )
			{
				nOut = atoi( remove_string(data.text,"' '",1) )
				if( nOut >= 1 && nOut <= MAX_OUTS )
				{
					nStatus[nOut] = nIn
					sTemp = "sTemp,itoa(nOut),','"
				}
			}
			
			nOut = atoi( remove_string(data.text,"'T'",1) )
			nStatus[nOut] = nIn
			sTemp = "sTemp,itoa(nOut)"
			
			send_command dvTP,"'^TXT-',itoa(RESP_BTN),',0,',sTemp"
		}
	}
}

BUTTON_EVENT[dvTP,INP_BTNS]
{
	push:
	{
		stack_var integer i
		
		nCurInp = get_last(INP_BTNS)
		
		for( i = 1; i <= MAX_OUTS; i++ )
		{
			[dvTP,OUT_BTNS[i]] = ( nStatus[i] == nCurInp )
		}
	}
}

BUTTON_EVENT[dvTP,OUT_BTNS]
{
	push:
	{
		[button.input] = ![button.input]
	}
}

BUTTON_EVENT[dvTP,TAKE_BTN]
{
	push:
	{
		stack_var char sCmd[32]
		stack_var integer i
		local_var char cChkSum
		
		if( nCurInp )
		{
			for( i = 1; i <= length_array(OUT_BTNS); i++ )
			{
				if( [dvTP,OUT_BTNS[i]] )//if( bOutFeedback[i] )
				{
					sCmd = "sCmd,itoa(i),' '"
				}
			}
			sCmd = left_string(sCmd,length_array(sCmd)-1)
			
			send_string dvSwitcher,"sCmd,checkSum(sCmd)"
			
			to[button.input]
		}
	}
}
BUTTON_EVENT[dvTP,RESP_BTN]
{
	push:
	{
		send_command dvTP,"'^TXT-',itoa(RESP_BTN),',0,'"
		to[button.input]
		
		ip_client_open(dvClientProj.PORT,"'192.168.150.100'",TCP_PORT,IP_TCP)
	}
}
data_event[dvClientProj]
{
	online:
	{
		//connection made
	}
	
	offline:
	{
		//connection terminated
	}
	
	onerror:
	{
		switch(data.number)
		{
			case 2: // general failure
			case 7: // timed out
			case 17: // local port not open
			{}
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
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
[dvTP,INP_BTNS[1]] = ( nCurInp == 1 )
[dvTP,INP_BTNS[2]] = ( nCurInp == 2 )
[dvTP,INP_BTNS[3]] = ( nCurInp == 3 )
[dvTP,INP_BTNS[4]] = ( nCurInp == 4 )
[dvTP,INP_BTNS[5]] = ( nCurInp == 5 )
[dvTP,INP_BTNS[6]] = ( nCurInp == 6 )
[dvTP,INP_BTNS[7]] = ( nCurInp == 7 )
[dvTP,INP_BTNS[8]] = ( nCurInp == 8 )
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

