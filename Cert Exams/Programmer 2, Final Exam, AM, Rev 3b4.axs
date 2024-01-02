PROGRAM_NAME='Programmer 2, Final Exam, AM, Rev 3b3'
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
DV_MASTER			=	   0:1:0
DV_IP_SERVER			=	   0:3:0
DV_TP				=	8001:1:0
DV_SWITCHER			=	8002:1:0
DV_PROJECTOR			=	8003:1:0
DV_DVD_PLAYER			= 	8004:1:0
DV_CAMERA			=	8005:1:0
DV_CAMERA_102			=	8100:1:100
DV_RELAYS			=	8006:1:0		// 1-3 PROJ SCREEN, 4-5 SYSTEM POWER
DV_DISPLAY_1			=	8007:1:0	 	// DISPLAY MONITOR 1
DV_DISPLAY_2			=	8008:1:0		// DISPLAY MONITOR 2
DV_VCR				=	8009:10:0		// VCR
DV_CD_CHANGER			=	8010:11:0		// CD PLAYER


(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
integer TCP_PORT =   87
INTEGER MAX_CDS	 =    5
nDVD = 1
nCD  = 2
INTEGER PROJ_ON = 1
LONG 	PROJ_FLASH [] = {500,500}
INTEGER CAMERA_COMM = 1
LONG 	CAMERA_PULSE [] = {50}
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE
STRUCTURE _sSongs
{
	CHAR sTITLE[25]
	INTEGER nMINUTE
	INTEGER nSECOND
}
STRUCTURE _sCDInfo
{
	CHAR sARTIST[30]
	CHAR sCD_TITLE[30]
	_sSongs nTRACKS[5]
	
}
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE INTEGER nInput
VOLATILE INTEGER nOutput
VOLATILE CHAR sBuffer[13]

VOLATILE CHAR sDiscType[9]

VOLATILE DEV cameras
VOLATILE CHAR nCameraCommand[4]
VOLATILE INTEGER nProjPower   
VOLATILE INTEGER nLampStatus

VOLATILE INTEGER nInputStatus

VOLATILE INTEGER nPower

volatile   char cBuffer[500]
PERSISTENT _sCDInfo uCDList[MAX_CDS]
PERSISTENT INTEGER bLOADED

volatile INTEGER nDiscType = nDVD
volatile INTEGER nValid
volatile integer nIndexDVD
volatile integer nIndexCD


CHAR chrCmds_CDMenu[][]=
    {
    {$20,$20,$0D},	// STOP
    {$20,$21,$0D},	// PLAY
    {$20,$22,$0D},	// PAUSE
    {$20,$31,$0D},	// SEARCH REV
    {$20,$32,$0D},	// SEARCH FWD
    {$20,$33,$0D},	// SKIP REV
    {$20,$34,$0D}	// SKIP FWD
    }


CHAR chrCmds_DVDMenu[][]=
    {
    {$20,$20,$0D},	// STOP
    {$20,$21,$0D},	// PLAY
    {$20,$22,$0D},	// PAUSE
    {$20,$31,$0D},	// SEARCH REV
    {$20,$32,$0D},	// SEARCH FWD
    {$20,$33,$0D},	// SKIP REV
    {$20,$34,$0D},	// SKIP FWD
    {$24,$2A,$0D},	// MENU
    {$24,$2B,$0D},	// SELECT
    {$24,$2C,$0D},	// ARROW UP
    {$24,$2D,$0D},	// ARROW DOWN
    {$24,$2E,$0D},	// ARROW RIGHT
    {$24,$2F,$0D}	// ARROW LEFT
    }


volatile integer PROJECTOR_BTNS[] =
{
	1, 2, 3, 4
}

volatile integer DISPLAY_MONITOR_BTNS[] =
{
	5, 6, 7, 8
}

volatile integer SWITCHER_BTNS[] =
{
	11, 12, 13, 14,
	21, 22, 23, 24,
	31, 32, 33, 34,
	41, 42, 43, 44
}

volatile integer CD_BTNS[] =
{
	51, 52, 53, 54,
	55, 56, 57
}

volatile integer DVD_BTNS[] =
{
	51, 52, 53, 54,
	55, 56, 57, 61, 
	62, 63, 64, 65, 
	66
}

volatile integer CAMERA_BTNS[] =
{
	71, 72, 73, 74,
	75, 76, 77, 78,
	79
}

volatile integer CD_CHANGER_BTNS[] =
{
	90, 91, 92, 93, 94,
	95, 96, 97, 98, 99
}

volatile integer SCREEN_BTNS[] =
{
	101, 102, 103
}

volatile integer POWER_BTN[] =
{
	104
}
(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE
([dv_Relays,1]..[dv_Relays,3])
([DV_TP,101]..[DV_TP,103])
(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
		        uCDList[1].sArtist ='SNOOP DOGGY DOGG'
		        uCDList[2].sArtist ='LUDACRIS'
			uCDList[3].sArtist ='DEEP DISH'
			uCDList[4].sArtist ='DIESELBOY'
			uCDList[5].sArtist ='APHRODITE'
			
			uCDList[1].sCD_TITLE ='DOGGYSTYLE'
			uCDList[2].sCD_TITLE ='WORD OF MOUF'
			uCDList[3].sCD_TITLE ='GLOBAL UNDERGROUND'
			uCDList[4].sCD_TITLE ='PROJECT HUMAN'
			uCDList[5].sCD_TITLE ='URBAN TAKEOVER'

			uCDList[1].nTRACKS[1].sTITLE='DISC 1 TRACK 1'
			uCDList[1].nTRACKS[1].nMINUTE = 8
			uCDList[1].nTRACKS[1].nSECOND = 48
			uCDList[1].nTRACKS[2].sTITLE='DISC 1 TRACK 2'
			uCDList[1].nTRACKS[2].nMINUTE = 6
			uCDList[1].nTRACKS[2].nSECOND = 11
			uCDList[1].nTRACKS[3].sTITLE='DISC 1 TRACK 3'
			uCDList[1].nTRACKS[3].nMINUTE = 5
			uCDList[1].nTRACKS[3].nSECOND = 26
			uCDList[1].nTRACKS[4].sTITLE='DISC 1 TRACK 4'
			uCDList[1].nTRACKS[4].nMINUTE = 4
			uCDList[1].nTRACKS[4].nSECOND = 36
			uCDList[1].nTRACKS[5].sTITLE='DISC 1 TRACK 5'
			uCDList[1].nTRACKS[5].nMINUTE = 3
			uCDList[1].nTRACKS[5].nSECOND = 58
			
			uCDList[2].nTRACKS[1].sTITLE='DISC 2 TRACK 1'
			uCDList[2].nTRACKS[1].nMINUTE = 8
			uCDList[2].nTRACKS[1].nSECOND = 48
			uCDList[2].nTRACKS[2].sTITLE='DISC 2 TRACK 2'
			uCDList[2].nTRACKS[2].nMINUTE = 6
			uCDList[2].nTRACKS[2].nSECOND = 11
			uCDList[2].nTRACKS[3].sTITLE='DISC 2 TRACK 3'
			uCDList[2].nTRACKS[3].nMINUTE = 5
			uCDList[2].nTRACKS[3].nSECOND = 26
			uCDList[2].nTRACKS[4].sTITLE='DISC 2 TRACK 4'
			uCDList[2].nTRACKS[4].nMINUTE = 4
			uCDList[2].nTRACKS[4].nSECOND = 36
			uCDList[2].nTRACKS[5].sTITLE='DISC 2 TRACK 5'
			uCDList[2].nTRACKS[5].nMINUTE = 3
			uCDList[2].nTRACKS[5].nSECOND = 58
			
			uCDList[3].nTRACKS[1].sTITLE='DISC 3 TRACK 1'
			uCDList[3].nTRACKS[1].nMINUTE = 8
			uCDList[3].nTRACKS[1].nSECOND = 48
			uCDList[3].nTRACKS[2].sTITLE='DISC 3 TRACK 2'
			uCDList[3].nTRACKS[2].nMINUTE = 6
			uCDList[3].nTRACKS[2].nSECOND = 11
			uCDList[3].nTRACKS[3].sTITLE='DISC 3 TRACK 3'
			uCDList[3].nTRACKS[3].nMINUTE = 5
			uCDList[3].nTRACKS[3].nSECOND = 26
			uCDList[3].nTRACKS[4].sTITLE='DISC 3 TRACK 4'
			uCDList[3].nTRACKS[4].nMINUTE = 4
			uCDList[3].nTRACKS[4].nSECOND = 36
			uCDList[3].nTRACKS[5].sTITLE='DISC 3 TRACK 5'
			uCDList[3].nTRACKS[5].nMINUTE = 3
			uCDList[3].nTRACKS[5].nSECOND = 58
			
			uCDList[4].nTRACKS[1].sTITLE='DISC 4 TRACK 1'
			uCDList[4].nTRACKS[1].nMINUTE = 8
			uCDList[4].nTRACKS[1].nSECOND = 48
			uCDList[4].nTRACKS[2].sTITLE='DISC 4 TRACK 2'
			uCDList[4].nTRACKS[2].nMINUTE = 6
			uCDList[4].nTRACKS[2].nSECOND = 11
			uCDList[4].nTRACKS[3].sTITLE='DISC 4 TRACK 3'
			uCDList[4].nTRACKS[3].nMINUTE = 5
			uCDList[4].nTRACKS[3].nSECOND = 26
			uCDList[4].nTRACKS[4].sTITLE='DISC 4 TRACK 4'
			uCDList[4].nTRACKS[4].nMINUTE = 4
			uCDList[4].nTRACKS[4].nSECOND = 36
			uCDList[4].nTRACKS[5].sTITLE='DISC 4 TRACK 5'
			uCDList[4].nTRACKS[5].nMINUTE = 3
			uCDList[4].nTRACKS[5].nSECOND = 58
			
			uCDList[5].nTRACKS[1].sTITLE='DISC 5 TRACK 1'
			uCDList[5].nTRACKS[1].nMINUTE = 8
			uCDList[5].nTRACKS[1].nSECOND = 48
			uCDList[5].nTRACKS[2].sTITLE='DISC 5 TRACK 2'
			uCDList[5].nTRACKS[2].nMINUTE = 6
			uCDList[5].nTRACKS[2].nSECOND = 11
			uCDList[5].nTRACKS[3].sTITLE='DISC 5 TRACK 3'
			uCDList[5].nTRACKS[3].nMINUTE = 5
			uCDList[5].nTRACKS[3].nSECOND = 26
			uCDList[5].nTRACKS[4].sTITLE='DISC 5 TRACK 4'
			uCDList[5].nTRACKS[4].nMINUTE = 4
			uCDList[5].nTRACKS[4].nSECOND = 36
			uCDList[5].nTRACKS[5].sTITLE='DISC 5 TRACK 5'
			uCDList[5].nTRACKS[5].nMINUTE = 3
			uCDList[5].nTRACKS[5].nSECOND = 58
create_buffer DV_IP_SERVER, cBuffer
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
DATA_EVENT[DV_MASTER]
{
	online:
	{
	    IP_SERVER_OPEN(DV_IP_SERVER.PORT,TCP_PORT,IP_TCP)
	}
}

DATA_EVENT[DV_IP_SERVER]
{
	online:
	{
		send_command DV_TP,"'ADBEEP'"	
		
		SEND_STRING DV_IP_SERVER,"'Welcome to the NetLinx system programmed by Armin Mitchell with AVI-SPL',13,10,
		'I attended the NetLinx Programmer course in Costa Mesa that began on October 1, 2007.',13,10"			
	}
	string:
	{
		send_command DV_TP,"'^TXT-254,0,',cBuffer"
		clear_buffer cBuffer
	}
	offline:
	{
		IP_SERVER_OPEN(DV_IP_SERVER.PORT,TCP_PORT,IP_TCP)
	}
}

DATA_EVENT[DV_SWITCHER]		// 5001:1:101 SWITCHER 38400,N,8,1
{
	online:
	{	//SERIAL CONFIG
		send_command data.device,"'SET BAUD 38400,N,8,1 485 DISABLE'"
		send_command data.device,"'HSOFF'"
	}
	STRING:
	{
	    SEND_COMMAND dv_TP,"'TEXT70-',  data.text"
	    SEND_COMMAND dv_TP,"'TEXT71-',  'Input: ', nInput, ' to Output: ', nOutput"

	    REMOVE_STRING(data.text,'IN',1)
		{
		// SET A VARIABLE TO = NEXT CHARACTER
		nInput = ATOI(data.text)
		}
	    REMOVE_STRING(data.text,'OUT',1)
		{
		// SET A VARIABLE TO = NEXT CHARACTER
		nOutput = ATOI(data.text)
		}

	    
	}
}
BUTTON_EVENT[DV_TP,11]		// (nInput == 1) and (nOutput == 1)
{
		PUSH:
		{
		    SEND_STRING dv_Switcher,"$02,'IN1OUT1',$03"
		}
}
BUTTON_EVENT[DV_TP,12]		// (nInput == 1) and (nOutput == 2)
{
		PUSH:
		{
		    SEND_STRING dv_Switcher,"$02,'IN1OUT2',$03"
		}
}
BUTTON_EVENT[DV_TP,13]		// (nInput == 1) and (nOutput == 3)
{
		PUSH:
		{
		    SEND_STRING dv_Switcher,"$02,'IN1OUT3',$03"
		}
}
BUTTON_EVENT[DV_TP,14]		// (nInput == 1) and (nOutput == 4)
{
		PUSH:
		{
		    SEND_STRING dv_Switcher,"$02,'IN1OUT4',$03"
		}
}

BUTTON_EVENT[DV_TP,21]		// (nInput == 2) and (nOutput == 1)
{
		PUSH:
		{
		    SEND_STRING dv_Switcher,"$02,'IN2OUT1',$03"
		}
}
BUTTON_EVENT[DV_TP,22]		// (nInput == 2) and (nOutput == 2)
{
		PUSH:
		{
		    SEND_STRING dv_Switcher,"$02,'IN2OUT2',$03"
		}
}
BUTTON_EVENT[DV_TP,23]		// (nInput == 2) and (nOutput == 3)
{
		PUSH:
		{
		    SEND_STRING dv_Switcher,"$02,'IN2OUT3',$03"
		}
}
BUTTON_EVENT[DV_TP,24]		// (nInput == 2) and (nOutput == 4)
{
		PUSH:
		{
		    SEND_STRING dv_Switcher,"$02,'IN2OUT4',$03"
		}
}
BUTTON_EVENT[DV_TP,31]		// (nInput == 3) and (nOutput == 1)
{
		PUSH:
		{
		    SEND_STRING dv_Switcher,"$02,'IN3OUT1',$03"
		}
}
BUTTON_EVENT[DV_TP,32]		// (nInput == 3) and (nOutput == 2)
{
		PUSH:
		{
		    SEND_STRING dv_Switcher,"$02,'IN3OUT2',$03"
		}
}
BUTTON_EVENT[DV_TP,33]		// (nInput == 3) and (nOutput == 3)
{
		PUSH:
		{
		    SEND_STRING dv_Switcher,"$02,'IN3OUT3',$03"
		}
}
BUTTON_EVENT[DV_TP,34]		// (nInput == 3) and (nOutput == 4)
{
		PUSH:
		{
		    SEND_STRING dv_Switcher,"$02,'IN3OUT4',$03"
		}
}
BUTTON_EVENT[DV_TP,41]		// (nInput == 4) and (nOutput == 1)
{
		PUSH:
		{
		    SEND_STRING dv_Switcher,"$02,'IN4OUT1',$03"
		}
}
BUTTON_EVENT[DV_TP,42]		// (nInput == 4) and (nOutput == 2)
{
		PUSH:
		{
		    SEND_STRING dv_Switcher,"$02,'IN4OUT2',$03"
		}
}
BUTTON_EVENT[DV_TP,43]		// (nInput == 4) and (nOutput == 3)
{
		PUSH:
		{
		    SEND_STRING dv_Switcher,"$02,'IN4OUT3',$03"
		}
}
BUTTON_EVENT[DV_TP,44]		// (nInput == 4) and (nOutput == 4)
{
		PUSH:
		{
		    SEND_STRING dv_Switcher,"$02,'IN4OUT4',$03"
		}
}
DATA_EVENT[DV_PROJECTOR]	// 5001:2:101 PROJECTOR 38400,N,8,1
{
	online:
	{	//SERIAL CONFIG
		send_command data.device,"'SET BAUD 38400,N,8,1 485 DISABLE'"
		send_command data.device,"'HSOFF'"
		send_string dv_projector,"'>>STS'"
	}
	STRING: // PROJECTOR STATUS QUERY
	{
	    STACK_VAR CHAR cCMD[25]
	    
	    IF(FIND_STRING(DATA.TEXT, '<<', 1)) 
	    {
		REMOVE_STRING(DATA.TEXT, '<<', 1) 
	    }        
	    SELECT
	    {
		// SET UP ACTIVE HANDLERS FOR EACH PROJ RESPONSE.
		ACTIVE(DATA.TEXT='PON'):
		    {
			ON[DV_TP,1]
			nProjPower = 1 
		    }
		ACTIVE(DATA.TEXT='POF'):
		    {
			nProjPower = 0
			nInputStatus = 0
		    }
		ACTIVE(DATA.TEXT='LON'):
		    {
			ON[DV_TP,2]
			nProjPower = 1
			nLampStatus = 1
		    }
		ACTIVE(DATA.TEXT='LOF'):
		    {
			IF(!TIMELINE_ACTIVE(PROJ_ON))
			{
			TIMELINE_CREATE(PROJ_ON,PROJ_FLASH,2,TIMELINE_RELATIVE,TIMELINE_REPEAT)
			}
			nProjPower = 1
			nLampStatus = 0
		    }
		ACTIVE(DATA.TEXT='LFF'):
		    {
			TIMELINE_KILL(PROJ_ON)
			nProjPower = 0
			nLampStatus = 0
			nInputStatus = 0
		    }
		ACTIVE(DATA.TEXT='VID'):
		    {
			nInputStatus = 1
		    }
		ACTIVE(DATA.TEXT='RGB'):
		    {
			nInputStatus = 2
		    }
		
	    }
	}
}
TIMELINE_EVENT[PROJ_ON]
	{			
	    SWITCH(TIMELINE.SEQUENCE)
	    {
		    CASE 1:
		    {
			ON[DV_TP,2]
		    }

		    CASE 2:
		    {
			OFF[DV_TP,2]
		    }

	    }
	}
BUTTON_EVENT[DV_TP,1]		// PROJECTOR OFF / ON 
{
    PUSH:
    {
	SELECT
        {
          ACTIVE(nProjPower):
            { 
		SEND_STRING DV_PROJECTOR,"'>>POF'"
	    }
          ACTIVE(!nProjPower):
            {
		SEND_STRING DV_PROJECTOR,"'>>PON'"
	    }
        }
    }
}

BUTTON_EVENT[DV_TP,2]		// LAMP OFF / ON
{
    PUSH:
    {
	SELECT
        {
          ACTIVE(nLampStatus):
           { 
	    SEND_STRING DV_PROJECTOR,"'>>LOF'"
           }
          ACTIVE(!nLampStatus):
           {
	    SEND_STRING DV_PROJECTOR,"'>>LON'"
           }
          
        }
    }
}
BUTTON_EVENT[DV_TP,3]		// VIDEO INPUT SELECT
{
	PUSH:
	{
	    SEND_STRING DV_PROJECTOR,"'>>VID'"
	}
}
BUTTON_EVENT[DV_TP,4]		// DATA INPUT SELECT
{
	PUSH:
	{
	    SEND_STRING DV_PROJECTOR,"'>>RGB'"
	}
}

DATA_EVENT[DV_DVD_PLAYER]	// 5001:3:101 DVD PLAYER 9600,N,8,1
{
	online:
	{	//SERIAL CONFIG
		send_command data.device,"'SET BAUD 9600,N,8,1 485 DISABLE'"
		send_command data.device,"'HSOFF'"
		SEND_STRING DV_DVD_PLAYER,"$21,$11,$0D"
	}
	STRING:
	{
		if( find_string(data.text,"$11",1) && find_string(data.text,"$0D",1) )
		{
			remove_string(data.text,"$11",1)
			nDiscType = data.text[1] // specify byte
		}
		if( find_string(data.text,"$06",1) && find_string(data.text,"$0D",1) )
		{
			nValid = data.text[1]
		}
	SELECT
	{
	    ACTIVE(nDiscType == "$01" && nValid == "$06"):
	    {
		ON[DV_TP,DVD_BTNS[nIndexDVD]]
	    } 
	    ACTIVE(nDiscType == "$02" && nValid == "$06"):
	    {
		ON[DV_TP,CD_BTNS[nIndexCD]]
	    }
	}
	
    }
}
button_event[DV_TP,DVD_BTNS]	// DVD BUTTONS
    {
    push:
	{
	nIndexDVD=get_last(DVD_BTNS)
	
	if(nDiscType=nDVD)
	    {
	    send_string dv_dvd_player, "chrCmds_DvdMenu[nIndexDVD]"
	    }
	}
    }
button_event[DV_TP,CD_BTNS]	// CD BUTTONS
    {
    push:
	{
	nIndexCD=get_last(CD_BTNS)
	
	if(nDiscType=nCD)
	    {
	    send_string dv_dvd_player, "chrCmds_CDMenu[nIndexCD]"
	    }
	}
    }
DATA_EVENT[DV_CAMERA]		// 5001:4:101 CAMERA 38400,N,8,1
{
	online:
	{	//SERIAL CONFIG
		send_command data.device,"'SET BAUD 38400,N,8,1 485 DISABLE'"
		send_command data.device,"'HSOFF'"
		cameras = dv_camera
	}
}

TIMELINE_EVENT[CAMERA_COMM]
	{			
	    SEND_STRING cameras, nCameraCommand   
	}
BUTTON_EVENT[DV_TP,71]		// PAN RIGHT
{
	PUSH:
	{
	    TIMELINE_CREATE(CAMERA_COMM,CAMERA_PULSE,1,TIMELINE_RELATIVE,TIMELINE_ONCE)
	    nCameraCommand = 'PR'
	}
	HOLD[2]:		// CLOSE TO .25 SEC
	{
	    TIMELINE_CREATE(CAMERA_COMM,CAMERA_PULSE,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
	    nCameraCommand = 'PR'
	}
	RELEASE:
	{
	    TIMELINE_KILL(CAMERA_COMM)
	}
}
BUTTON_EVENT[DV_TP,72]		// PAN LEFT
{
	PUSH:
	{
	    TIMELINE_CREATE(CAMERA_COMM,CAMERA_PULSE,1,TIMELINE_RELATIVE,TIMELINE_ONCE)
	    nCameraCommand = 'PL'
	}
	HOLD[2]:		// CLOSE TO .25 SEC
	{
	    TIMELINE_CREATE(CAMERA_COMM,CAMERA_PULSE,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
	    nCameraCommand = 'PL'
	}
	RELEASE:
	{
	    TIMELINE_KILL(CAMERA_COMM)
	}
}
BUTTON_EVENT[DV_TP,73]		// TILT UP
{
	PUSH:
	{
	    TIMELINE_CREATE(CAMERA_COMM,CAMERA_PULSE,1,TIMELINE_RELATIVE,TIMELINE_ONCE)
	    nCameraCommand = 'TU'
	}
	HOLD[2]:		// CLOSE TO .25 SEC
	{
	    TIMELINE_CREATE(CAMERA_COMM,CAMERA_PULSE,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
	    nCameraCommand = 'TU'
	}
	RELEASE:
	{
	    TIMELINE_KILL(CAMERA_COMM)
	}
}
BUTTON_EVENT[DV_TP,74]		// TILT DOWN
{
	PUSH:
	{
	    TIMELINE_CREATE(CAMERA_COMM,CAMERA_PULSE,1,TIMELINE_RELATIVE,TIMELINE_ONCE)
	    nCameraCommand = 'TD'
	}
	HOLD[2]:		// CLOSE TO .25 SEC
	{
	    TIMELINE_CREATE(CAMERA_COMM,CAMERA_PULSE,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
	    nCameraCommand = 'TD'
	}
	RELEASE:
	{
	    TIMELINE_KILL(CAMERA_COMM)
	}
}
BUTTON_EVENT[DV_TP,75]		// ZOOM IN
{
	PUSH:
	{
	    TIMELINE_CREATE(CAMERA_COMM,CAMERA_PULSE,1,TIMELINE_RELATIVE,TIMELINE_ONCE)
	    nCameraCommand = 'Z+'
	}
	HOLD[2]:		// CLOSE TO .25 SEC
	{
	    TIMELINE_CREATE(CAMERA_COMM,CAMERA_PULSE,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
	    nCameraCommand = 'Z+'
	}
	RELEASE:
	{
	    TIMELINE_KILL(CAMERA_COMM)
	}
}
BUTTON_EVENT[DV_TP,76]		// ZOOM OUT
{
	PUSH:
	{
	    TIMELINE_CREATE(CAMERA_COMM,CAMERA_PULSE,1,TIMELINE_RELATIVE,TIMELINE_ONCE)
	    nCameraCommand = 'Z-'
	}
	HOLD[2]:		// CLOSE TO .25 SEC
	{
	    TIMELINE_CREATE(CAMERA_COMM,CAMERA_PULSE,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
	    nCameraCommand = 'Z-'
	}
	RELEASE:
	{
	    TIMELINE_KILL(CAMERA_COMM)
	}
}
BUTTON_EVENT[DV_TP,77]		// FOCUS IN
{
	PUSH:
	{
	    nCameraCommand = 'F+'
	    TIMELINE_CREATE(CAMERA_COMM,CAMERA_PULSE,1,TIMELINE_RELATIVE,TIMELINE_ONCE)
	}
	HOLD[2]:		// CLOSE TO .25 SEC
	{
	    nCameraCommand = 'F+'
	    TIMELINE_CREATE(CAMERA_COMM,CAMERA_PULSE,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
	}
	RELEASE:
	{
	    TIMELINE_KILL(CAMERA_COMM)
	}
}
BUTTON_EVENT[DV_TP,78]		// FOCUS OUT
{
	PUSH:
	{
	    TIMELINE_CREATE(CAMERA_COMM,CAMERA_PULSE,1,TIMELINE_RELATIVE,TIMELINE_ONCE)
	    nCameraCommand = 'F-'
	}
	HOLD[2]:		// CLOSE TO .25 SEC
	{
	    TIMELINE_CREATE(CAMERA_COMM,CAMERA_PULSE,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
	    nCameraCommand = 'F-'
	}
	RELEASE:
	{
	    TIMELINE_KILL(CAMERA_COMM)
	}
}
BUTTON_EVENT[DV_TP,79]		// TOGGLE TO CAMERA 2
{
	PUSH:
	{
	    PULSE[DV_TP,BUTTON.INPUT.CHANNEL]
	    SWITCH(cameras)
	    {
		CASE dv_camera:
		{
		    cameras = dv_camera_102
		}
		CASE dv_camera_102:
		{
		    cameras = dv_camera
		}
	    }
	}
}

DATA_EVENT[DV_DISPLAY_1]	// 5001:8:101 MONITOR1 IR MODE, CARRIER ON
{
	online:
	{	// IR CONFIG
		SEND_COMMAND DATA.DEVICE,"'SET MODE IR'"
		SEND_COMMAND DATA.DEVICE,"'CARON'"		
	}
}
BUTTON_EVENT[DV_TP,5]		// MONITOR1 RGB1
{
    PUSH:
     {
      PULSE[DV_DISPLAY_1,BUTTON.INPUT.CHANNEL+78]
      PULSE[DV_TP,BUTTON.INPUT.CHANNEL]
     }
}
BUTTON_EVENT[DV_TP,6]		// MONITOR1 VIDEO1
{
    PUSH:
     {
      PULSE[DV_DISPLAY_1,BUTTON.INPUT.CHANNEL+79]
      PULSE[DV_TP,BUTTON.INPUT.CHANNEL]
     }
}

DATA_EVENT[DV_DISPLAY_2]	// 5001:9:101 MONITOR2 IR MODE, CARRIER ON
{
	online:
	{	// IR CONFIG
		SEND_COMMAND DATA.DEVICE,"'SET MODE IR'"
		SEND_COMMAND DATA.DEVICE,"'CARON'"		
	}
}
BUTTON_EVENT[DV_TP,7]		// MONITOR2 RGB1
{
    PUSH:
     {
      PULSE[DV_DISPLAY_2,BUTTON.INPUT.CHANNEL+76]
      PULSE[DV_TP,BUTTON.INPUT.CHANNEL]
     }
}
BUTTON_EVENT[DV_TP,8]		// MONITOR2 VIDEO1
{
    PUSH:
     {
      PULSE[DV_DISPLAY_2,BUTTON.INPUT.CHANNEL+77]
      PULSE[DV_TP,BUTTON.INPUT.CHANNEL]
     }
}


DATA_EVENT[DV_VCR]		// 5001:10:101 VCR SERIAL MODE, CARRIER OFF
{
	online:
	{	// IR CONFIG
		SEND_COMMAND DATA.DEVICE,"'SET MODE SERIAL'"
		SEND_COMMAND DATA.DEVICE,"'CAROFF'"		
	}
}

DATA_EVENT[DV_CD_CHANGER]	// 5001:11:101 CD CHANGER IR MODE, CARRIER ON

{
	online:
	{	// IR CONFIG
		SEND_COMMAND DATA.DEVICE,"'SET MODE IR'"
		SEND_COMMAND DATA.DEVICE,"'CARON'"
	}
}

BUTTON_EVENT[DV_TP,90]		// DISC 1
{
    PUSH:
		{
			PULSE[DV_CD_CHANGER,BUTTON.INPUT.CHANNEL-31]
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(90),',0,',(uCDList[1].sARTIST)"
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(91),',0,',(uCDList[1].sCD_TITLE)"
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(92),',0,',(uCDList[1].nTRACKS[1])"
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(93),',0,',(uCDList[1].nTRACKS[1].nMINUTE),':',(uCDList[1].nTRACKS[1].nSECOND)"
		}
}
BUTTON_EVENT[DV_TP,91]		// DISC 2
{
    PUSH:
		{
			PULSE[DV_CD_CHANGER,BUTTON.INPUT.CHANNEL-31]
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(90),',0,',(uCDList[2].sARTIST)"
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(91),',0,',(uCDList[2].sCD_TITLE)"
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(92),',0,',(uCDList[2].nTRACKS[1])"
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(93),',0,',(uCDList[2].nTRACKS[1].nMINUTE),':',(uCDList[2].nTRACKS[1].nSECOND)"
		}
}
BUTTON_EVENT[DV_TP,92]		// DISC 3
{
    PUSH:
		{
			PULSE[DV_CD_CHANGER,BUTTON.INPUT.CHANNEL-31]
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(90),',0,',(uCDList[3].sARTIST)"
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(91),',0,',(uCDList[3].sCD_TITLE)"
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(92),',0,',(uCDList[3].nTRACKS[1])"
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(93),',0,',(uCDList[3].nTRACKS[1].nMINUTE),':',(uCDList[3].nTRACKS[1].nSECOND)"
		}
}
BUTTON_EVENT[DV_TP,93]		// DISC 4
{
    PUSH:
		{
			PULSE[DV_CD_CHANGER,BUTTON.INPUT.CHANNEL-31]
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(90),',0,',(uCDList[4].sARTIST)"
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(91),',0,',(uCDList[4].sCD_TITLE)"
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(92),',0,',(uCDList[4].nTRACKS[1])"
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(93),',0,',(uCDList[4].nTRACKS[1].nMINUTE),':',(uCDList[4].nTRACKS[1].nSECOND)"
		}
}
BUTTON_EVENT[DV_TP,94]		// DISC 5
{
    PUSH:
		{
			PULSE[DV_CD_CHANGER,BUTTON.INPUT.CHANNEL-31]
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(90),',0,',(uCDList[5].sARTIST)"
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(91),',0,',(uCDList[5].sCD_TITLE)"
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(92),',0,',(uCDList[5].nTRACKS[1])"
			SEND_COMMAND DV_TP, "'^TXT-',ITOA(93),',0,',(uCDList[5].nTRACKS[1].nMINUTE),':',(uCDList[5].nTRACKS[1].nSECOND)"			
		}
}
BUTTON_EVENT[DV_TP,95]		// PLAY
BUTTON_EVENT[DV_TP,96]		// STOP
BUTTON_EVENT[DV_TP,97]		// PAUSE
BUTTON_EVENT[DV_TP,98]		// SKIP FWD
BUTTON_EVENT[DV_TP,99]		// SKIP REV
{
    PUSH:
     {
      PULSE[DV_CD_CHANGER,BUTTON.INPUT.CHANNEL-94]
     }
}

BUTTON_EVENT[DV_TP,101]		// SCREEN UP
{
	PUSH:
	{
		ON[DV_RELAYS,1]
		WAIT 25
		{ 
		OFF[DV_RELAYS,1]		
		}
	}
}
BUTTON_EVENT[DV_TP,102]		// SCREEN DOWN
{
	PUSH:
	{
		ON[DV_RELAYS,2]
		WAIT 25
		{ 
		OFF[DV_RELAYS,2]		
		}
	}
}

BUTTON_EVENT[DV_TP,103]		// SCREEN STOP
{
	PUSH:
	{
		PULSE[DV_RELAYS,BUTTON.INPUT.CHANNEL-100]
	}
}

BUTTON_EVENT[DV_TP,104]		// SYSTEM POWER
{
    PUSH:
    {
	SELECT
        {
          ACTIVE(!nPower):
           {
              ON[DV_RELAYS,4]
		WAIT 10
		{
		ON[DV_RELAYS,5]
		}
	    nPower = 1 
           }
          ACTIVE(nPower):
           { 
		OFF[DV_RELAYS,5]
	    WAIT 10
		{
		OFF[DV_RELAYS,4]
		}
	    nPower = 0 
           }
        }
      }
}


(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
[dv_TP,3] = (nInputStatus = 1)
[dv_TP,4] = (nInputStatus = 2)
[dv_TP,101] = [dv_Relays,1]
[dv_TP,102] = [dv_Relays,2]
[dv_TP,103] = [dv_Relays,3]
[dv_TP,104] = [DV_RELAYS,4] AND [DV_RELAYS,5]
[dv_TP,11]  = (nInput == 1) and (nOutput == 1)
[dv_TP,12]  = (nInput == 1) and (nOutput == 2)
[dv_TP,13]  = (nInput == 1) and (nOutput == 3)
[dv_TP,14]  = (nInput == 1) and (nOutput == 4)
[dv_TP,21]  = (nInput == 2) and (nOutput == 1)       
[dv_TP,22]  = (nInput == 2) and (nOutput == 2)
[dv_TP,23]  = (nInput == 2) and (nOutput == 3)
[dv_TP,24]  = (nInput == 2) and (nOutput == 4)
[dv_TP,31]  = (nInput == 3) and (nOutput == 1)
[dv_TP,32]  = (nInput == 3) and (nOutput == 2)
[dv_TP,33]  = (nInput == 3) and (nOutput == 3)
[dv_TP,34]  = (nInput == 3) and (nOutput == 4)
[dv_TP,41]  = (nInput == 4) and (nOutput == 1)
[dv_TP,42]  = (nInput == 4) and (nOutput == 2)
[dv_TP,43]  = (nInput == 4) and (nOutput == 3)
[dv_TP,44]  = (nInput == 4) and (nOutput == 4)
[DV_TP,71]  = (nCameraCommand == 'PR')
[DV_TP,72]  = (nCameraCommand == 'PL')			 
[DV_TP,73]  = (nCameraCommand == 'TU')
[DV_TP,74]  = (nCameraCommand == 'TD')
[DV_TP,75]  = (nCameraCommand == 'Z+')
[DV_TP,76]  = (nCameraCommand == 'Z-')
[DV_TP,77]  = (nCameraCommand == 'F+')		    
[DV_TP,78]  = (nCameraCommand == 'F-')	    

SYSTEM_CALL [1] 'VCR1' (DV_VCR,DV_TP,81,82,83,84,85,86,87,88,0)
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

