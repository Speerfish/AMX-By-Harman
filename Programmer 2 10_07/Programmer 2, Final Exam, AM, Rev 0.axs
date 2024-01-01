PROGRAM_NAME='Programmer 2, Final Exam, AM, Rev 0'
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
DV_MASTER					=		 0:1:0
DV_IP_SERVER			=		 0:3:0
DV_TP							=	 128:1:0
DV_SWITCHER				=	5001:1:0
DV_PROJECTOR			=	5001:2:0
DV_DVD_PLAYER			= 5001:3:0
DV_CAMERA					=	5001:4:0
DV_CAMERA_102			=	5001:4:100
DV_RELAYS					=	5001:7:0		// 1-3 PROJ SCREEN, 4-5 SYSTEM POWER
DV_DISPLAY_1			=	5001:8:0	 	// DISPLAY MONITOR 1
DV_DISPLAY_2			=	5001:9:0		// DISPLAY MONITOR 2
DV_VCR						=	5001:10:0		// VCR
DV_CD_CHANGER			=	5001:11:0		// CD PLAYER


(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

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
	61, 62, 63, 64,
	65, 66
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
integer TCP_PORT =   87
INTEGER MAX_CDS	 = 		5
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE
STRUCTURE _sSongs
{
	INTEGER	nTRACKS
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

VOLATILE INTEGER nProjPower 
VOLATILE INTEGER nProjWarm  
VOLATILE INTEGER nProjCool

VOLATILE INTEGER nLampPower 
VOLATILE INTEGER nLampWarm  
VOLATILE INTEGER nLampCool

VOLATILE INTEGER nPower

volatile		char cBuffer[500]
PERSISTENT _sCDInfo uCDList[MAX_CDS]
PERSISTENT INTEGER bLOADED
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
DEFINE_CALL 'PROJ ON'
{ 
 IF(!nProjPower)
  {
   SEND_STRING DV_PROJECTOR,"'PON'"
   nProjPower = 1 
   nProjWarm = 1    
   WAIT 300 nProjWarm = 0
  }
}  
   
DEFINE_CALL 'PROJ OFF'
  {
   SEND_STRING DV_PROJECTOR,"'POF'"
   nProjPower = 0
   nProjCool = 1 
   WAIT 900 nProjCool = 0
  }
  
DEFINE_CALL 'LAMP ON'
{ 
 IF(!nLampPower)
  {
   SEND_STRING DV_PROJECTOR,"'LON'"
   nLampPower = 1 
   nLampWarm = 1    
   WAIT 300 nLampWarm = 0
  }
}  
   
DEFINE_CALL 'LAMP OFF'
  {
   SEND_STRING DV_PROJECTOR,"'LOF'"
   nLampPower = 0
   nLampCool = 1 
   WAIT 900 nLampCool = 0
  }
 
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
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
		

		IF( bLOADED == FALSE)
		{
			uCDList[1].sArtist = 'SNOOP DOGGY DOGG'
			uCDList[2].sArtist = 'LUDACRIS'
			uCDList[3].sArtist = 'DEEP DISH'
			uCDList[4].sArtist = 'DIESELBOY'
			uCDList[5].sArtist = 'APHRODITE'
			
			uCDList[1].sCD_TITLE = 'DOGGYSTYLE'
			uCDList[2].sCD_TITLE = 'WORD OF MOUF'
			uCDList[3].sCD_TITLE = 'GLOBAL UNDERGROUND'
			uCDList[4].sCD_TITLE = 'PROJECT HUMAN'
			uCDList[5].sCD_TITLE = 'URBAN TAKEOVER'
	
			uCDList[1].nTRACKS[1].nMINUTE = 8
			uCDList[1].nTRACKS[1].nSECOND = 48
			uCDList[1].nTRACKS[2].nMINUTE = 6
			uCDList[1].nTRACKS[2].nSECOND = 11
			uCDList[1].nTRACKS[3].nMINUTE = 5
			uCDList[1].nTRACKS[3].nSECOND = 26
			uCDList[1].nTRACKS[4].nMINUTE = 4
			uCDList[1].nTRACKS[4].nSECOND = 36
			uCDList[1].nTRACKS[5].nMINUTE = 3
			uCDList[1].nTRACKS[5].nSECOND = 58
			
			uCDList[2].nTRACKS[1].nMINUTE = 8
			uCDList[2].nTRACKS[1].nSECOND = 48
			uCDList[2].nTRACKS[2].nMINUTE = 6
			uCDList[2].nTRACKS[2].nSECOND = 11
			uCDList[2].nTRACKS[3].nMINUTE = 5
			uCDList[2].nTRACKS[3].nSECOND = 26
			uCDList[2].nTRACKS[4].nMINUTE = 4
			uCDList[2].nTRACKS[4].nSECOND = 36
			uCDList[2].nTRACKS[5].nMINUTE = 3
			uCDList[2].nTRACKS[5].nSECOND = 58
			
			uCDList[3].nTRACKS[1].nMINUTE = 8
			uCDList[3].nTRACKS[1].nSECOND = 48
			uCDList[3].nTRACKS[2].nMINUTE = 6
			uCDList[3].nTRACKS[2].nSECOND = 11
			uCDList[3].nTRACKS[3].nMINUTE = 5
			uCDList[3].nTRACKS[3].nSECOND = 26
			uCDList[3].nTRACKS[4].nMINUTE = 4
			uCDList[3].nTRACKS[4].nSECOND = 36
			uCDList[3].nTRACKS[5].nMINUTE = 3
			uCDList[3].nTRACKS[5].nSECOND = 58
			
			uCDList[4].nTRACKS[1].nMINUTE = 8
			uCDList[4].nTRACKS[1].nSECOND = 48
			uCDList[4].nTRACKS[2].nMINUTE = 6
			uCDList[4].nTRACKS[2].nSECOND = 11
			uCDList[4].nTRACKS[3].nMINUTE = 5
			uCDList[4].nTRACKS[3].nSECOND = 26
			uCDList[4].nTRACKS[4].nMINUTE = 4
			uCDList[4].nTRACKS[4].nSECOND = 36
			uCDList[4].nTRACKS[5].nMINUTE = 3
			uCDList[4].nTRACKS[5].nSECOND = 58
			
			uCDList[5].nTRACKS[1].nMINUTE = 8
			uCDList[5].nTRACKS[1].nSECOND = 48
			uCDList[5].nTRACKS[2].nMINUTE = 6
			uCDList[5].nTRACKS[2].nSECOND = 11
			uCDList[5].nTRACKS[3].nMINUTE = 5
			uCDList[5].nTRACKS[3].nSECOND = 26
			uCDList[5].nTRACKS[4].nMINUTE = 4
			uCDList[5].nTRACKS[4].nSECOND = 36
			uCDList[5].nTRACKS[5].nMINUTE = 3
			uCDList[5].nTRACKS[5].nSECOND = 58
			
			bLOADED = TRUE		// ON[bLOADED] OR bLOADED = 1
		}
	}
}

DATA_EVENT[DV_TP]
{
	ONLINE:
		{  
		LOCAL_VAR INTEGER I
			FOR(I = 1; I<= MAX_CDS; I++)
			{
				SEND_COMMAND DATA.DEVICE, "'^TXT-',ITOA(89+I),',0,',uCDList[I].sARTIST"
				SEND_COMMAND DATA.DEVICE, "'^TXT-',ITOA(89+I),',0,',uCDList[I].sCD_TITLE"
				SEND_COMMAND DATA.DEVICE, "'^TXT-',ITOA(89+I),',0,',ITOA(uCDList[I].nTRACKS)"
				SEND_COMMAND DATA.DEVICE, "'^TXT-',ITOA(89+I),',0,',ITOA(uCDList[I].nTRACKS.nMINUTE)"
				SEND_COMMAND DATA.DEVICE, "'^TXT-',ITOA(88+I),',0,',ITOA(uCDList[I].nTRACKS.nSECOND)"
			}
		}
}


DATA_EVENT[DV_IP_SERVER]
{
	online:
	{
		send_command DV_TP,"'ADBEEP'"		
	}
	string:
	
	if( find_string(cBuffer,"'ping'",1) > 0 )
		{
			cBuffer = left_string(cBuffer,length_array(cBuffer)-1)
			send_command DV_TP,"'^TXT-254,0,',cBuffer"
			SEND_STRING DV_IP_SERVER,"'Welcome to the NetLinx system programmed by Armin Mitchell with Audio Visual Innovations, Inc.',13,10,'I attended the NetLinx Programmer course in Costa Mesa that began on October 1, 2007.',13,10"			
			
			clear_buffer cBuffer
		}
}

DATA_EVENT[DV_SWITCHER]			//5001:1:101 SWITCHER 38400,N,8,1
{
	online:
	{	//SERIAL CONFIG
		send_command data.device,"'SET BAUD 38400,N,8,1 485 DISABLE'"
		send_command data.device,"'HSOFF'"
	}
	STRING:
    {
    SEND_COMMAND dv_TP,"'TEXT70-',  sBuffer"
    SEND_COMMAND dv_TP,"'TEXT71-',  'Input: ', MID_STRING(sBuffer,5,1), ' to Output: ', MID_STRING(sBuffer,9,1)"
    }
}
BUTTON_EVENT[DV_TP,11]		// (nInput == 1) and (nOutput == 1)
{
		PUSH:
		{
			nInput = BUTTON.INPUT.CHANNEL-10
			nOutput = BUTTON.INPUT.CHANNEL-10
			SEND_STRING dv_Switcher,"'$02IN',ITOA(nInput),'OUT',ITOA(nOutput),'$03'"
		}
}
BUTTON_EVENT[DV_TP,12]		// (nInput == 1) and (nOutput == 2)
{
		PUSH:
		{
			nInput = BUTTON.INPUT.CHANNEL-11
			nOutput = BUTTON.INPUT.CHANNEL-10
			SEND_STRING dv_Switcher,"'$02IN',ITOA(nInput),'OUT',ITOA(nOutput),'$03'"
		}
}
BUTTON_EVENT[DV_TP,13]		// (nInput == 1) and (nOutput == 3)
{
		PUSH:
		{
			nInput = BUTTON.INPUT.CHANNEL-12
			nOutput = BUTTON.INPUT.CHANNEL-10
			SEND_STRING dv_Switcher,"'$02IN',ITOA(nInput),'OUT',ITOA(nOutput),'$03'"
		}
}
BUTTON_EVENT[DV_TP,14]		// (nInput == 1) and (nOutput == 4)
{
		PUSH:
		{
			nInput = BUTTON.INPUT.CHANNEL-13
			nOutput = BUTTON.INPUT.CHANNEL-10
			SEND_STRING dv_Switcher,"'$02IN',ITOA(nInput),'OUT',ITOA(nOutput),'$03'"
		}
}

BUTTON_EVENT[DV_TP,21]		// (nInput == 2) and (nOutput == 1)
{
		PUSH:
		{
			nInput = BUTTON.INPUT.CHANNEL-19
			nOutput = BUTTON.INPUT.CHANNEL-20
			SEND_STRING dv_Switcher,"'$02IN',ITOA(nInput),'OUT',ITOA(nOutput),'$03'"
		}
}
BUTTON_EVENT[DV_TP,22]		// (nInput == 2) and (nOutput == 2)
{
		PUSH:
		{
			nInput = BUTTON.INPUT.CHANNEL-20
			nOutput = BUTTON.INPUT.CHANNEL-20
			SEND_STRING dv_Switcher,"'$02IN',ITOA(nInput),'OUT',ITOA(nOutput),'$03'"
		}
}
BUTTON_EVENT[DV_TP,23]		//(nInput == 2) and (nOutput == 3)
{
		PUSH:
		{
			nInput = BUTTON.INPUT.CHANNEL-21
			nOutput = BUTTON.INPUT.CHANNEL-20
			SEND_STRING dv_Switcher,"'$02IN',ITOA(nInput),'OUT',ITOA(nOutput),'$03'"
		}
}
BUTTON_EVENT[DV_TP,24]		// (nInput == 2) and (nOutput == 4)
{
		PUSH:
		{
			nInput = BUTTON.INPUT.CHANNEL-22
			nOutput = BUTTON.INPUT.CHANNEL-20
			SEND_STRING dv_Switcher,"'$02IN',ITOA(nInput),'OUT',ITOA(nOutput),'$03'"
		}
}
BUTTON_EVENT[DV_TP,31]		//(nInput == 3) and (nOutput == 1)
{
		PUSH:
		{
			nInput = BUTTON.INPUT.CHANNEL-28
			nOutput = BUTTON.INPUT.CHANNEL-30
			SEND_STRING dv_Switcher,"'$02IN',ITOA(nInput),'OUT',ITOA(nOutput),'$03'"
		}
}
BUTTON_EVENT[DV_TP,32]		//  (nInput == 3) and (nOutput == 2)
{
		PUSH:
		{
			nInput = BUTTON.INPUT.CHANNEL-29
			nOutput = BUTTON.INPUT.CHANNEL-30
			SEND_STRING dv_Switcher,"'$02IN',ITOA(nInput),'OUT',ITOA(nOutput),'$03'"
		}
}
BUTTON_EVENT[DV_TP,33]		// (nInput == 3) and (nOutput == 3)
{
		PUSH:
		{
			nInput = BUTTON.INPUT.CHANNEL-30
			nOutput = BUTTON.INPUT.CHANNEL-30
			SEND_STRING dv_Switcher,"'$02IN',ITOA(nInput),'OUT',ITOA(nOutput),'$03'"
		}
}
BUTTON_EVENT[DV_TP,34]		// (nInput == 3) and (nOutput == 4)
{
		PUSH:
		{
			nInput = BUTTON.INPUT.CHANNEL-31
			nOutput = BUTTON.INPUT.CHANNEL-30
			SEND_STRING dv_Switcher,"'$02IN',ITOA(nInput),'OUT',ITOA(nOutput),'$03'"
		}
}
BUTTON_EVENT[DV_TP,41]		// (nInput == 4) and (nOutput == 1)
{
		PUSH:
		{
			nInput = BUTTON.INPUT.CHANNEL-37
			nOutput = BUTTON.INPUT.CHANNEL-40
			SEND_STRING dv_Switcher,"'$02IN',ITOA(nInput),'OUT',ITOA(nOutput),'$03'"
		}
}
BUTTON_EVENT[DV_TP,42]		// (nInput == 4) and (nOutput == 2)
{
		PUSH:
		{
			nInput = BUTTON.INPUT.CHANNEL-38
			nOutput = BUTTON.INPUT.CHANNEL-40
			SEND_STRING dv_Switcher,"'$02IN',ITOA(nInput),'OUT',ITOA(nOutput),'$03'"
		}
}
BUTTON_EVENT[DV_TP,43]		// (nInput == 4) and (nOutput == 3)
{
		PUSH:
		{
			nInput = BUTTON.INPUT.CHANNEL-39
			nOutput = BUTTON.INPUT.CHANNEL-40
			SEND_STRING dv_Switcher,"'$02IN',ITOA(nInput),'OUT',ITOA(nOutput),'$03'"
		}
}
BUTTON_EVENT[DV_TP,44]		// (nInput == 4) and (nOutput == 4)
{
		PUSH:
		{
			nInput = BUTTON.INPUT.CHANNEL-40
			nOutput = BUTTON.INPUT.CHANNEL-40
			SEND_STRING dv_Switcher,"'$02IN',ITOA(nInput),'OUT',ITOA(nOutput),'$03'"
		}
}
DATA_EVENT[DV_PROJECTOR]		//5001:2:101 PROJECTOR 38400,N,8,1
{
	online:
	{	//SERIAL CONFIG
		send_command data.device,"'SET BAUD 38400,N,8,1 485 DISABLE'"
		send_command data.device,"'HSOFF'"
	}
}

BUTTON_EVENT[DV_TP,1]		// PROJECTOR OFF / ON 
{
		PUSH:
		{
			SELECT
        {
          ACTIVE(!nProjPower):
           {
            WAIT 600
             {
              CALL 'PROJ ON' 
             }
           }
          ACTIVE(nProjPower):
           { 
							CALL	'PROJ OFF' 
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
          ACTIVE(!nLampPower):
           {
            WAIT 600
             {
              CALL	'LAMP ON'
             }
           }
          ACTIVE(nLampPower):
           { 
              CALL  'LAMP OFF' 
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

DATA_EVENT[DV_DVD_PLAYER]		//5001:3:101 DVD PLAYER 9600,N,8,1
{
	online:
	{	//SERIAL CONFIG
		send_command data.device,"'SET BAUD 9600,N,8,1 485 DISABLE'"
		send_command data.device,"'HSOFF'"
		SEND_STRING DV_DVD_PLAYER,"$21,$11,$13"
	}
	STRING:
	{
		stack_var integer nDiscType
		stack_var char sTemp[15]
		
		if( find_string(data.text,"'$11,$0'",1) && find_string(data.text,"'$13'",1) )
		{
			remove_string(data.text,"'$11,$0'",1)
			
			nDiscType = atoi( remove_string(data.text,"'$'",1) )
			sTemp = "itoa(nDiscType)"
		}
	}
}
//SELECT:
//{
//	ACTIVE(sTemp == 1):
//	{
		BUTTON_EVENT[DV_TP,51]		// STOP
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$20,$20,$13"
			}
		}
		BUTTON_EVENT[DV_TP,52]		// PLAY
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$20,$21,$13"
			}
		}
		BUTTON_EVENT[DV_TP,53]		// PAUSE
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$20,$22,$13"
			}
		}
		BUTTON_EVENT[DV_TP,54]		// SEARCH REV
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$20,$31,$13"
			}
		}
		BUTTON_EVENT[DV_TP,55]		// SEARCH FWD
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$20,$32,$13"
			}
		}
		BUTTON_EVENT[DV_TP,56]		// SKIP REV
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$20,$33,$13"
			}
		}
		BUTTON_EVENT[DV_TP,57]		// SKIP FWD
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$20,$34,$13"
			}
		}
		BUTTON_EVENT[DV_TP,61]		// DVD MENU (DVD ONLY)
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$24,$2A,$13"
			}
		}
		BUTTON_EVENT[DV_TP,62]		// DVD SELECT (DVD ONLY)
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$24,$2B,$13"
			}
		}
		BUTTON_EVENT[DV_TP,63]		// DVD ARROW UP (DVD ONLY)
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$24,$2C,$13"
			}
		}
		BUTTON_EVENT[DV_TP,64]		// DVD ARROW DOWN (DVD ONLY)
		{
		PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$24,$2D,$13"
			}
		}
		BUTTON_EVENT[DV_TP,65]		// DVD ARROW RIGHT (DVD ONLY)
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$24,$2E,$13"
			}
		}
		BUTTON_EVENT[DV_TP,66]		// DVD ARROW LEFT (DVD ONLY)
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$24,$2F,$13"
			}
		}
//	}           }
//	ACTIVE(sTemp == 2):
//	{ 
		BUTTON_EVENT[DV_TP,51]		// STOP
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$20,$20,$13"
			}
		}
		BUTTON_EVENT[DV_TP,52]		// PLAY
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$20,$21,$13"
			}
		}
		BUTTON_EVENT[DV_TP,53]		// PAUSE
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$20,$22,$13"
			}
		}
		BUTTON_EVENT[DV_TP,54]		// SEARCH REV
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$20,$31,$13"
			}
		}
		BUTTON_EVENT[DV_TP,55]		// SEARCH FWD
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$20,$32,$13"
			}
		}
		BUTTON_EVENT[DV_TP,56]		// SKIP REV
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$20,$33,$13"
			}
		}
		BUTTON_EVENT[DV_TP,57]		// SKIP FWD
		{
			PUSH:
			{
				SEND_STRING DV_DVD_PLAYER,"$20,$34,$13"
			}
		}
//	}
//}
DATA_EVENT[DV_CAMERA]				//5001:4:101 CAMERA 38400,N,8,1
{
	online:
	{	//SERIAL CONFIG
		send_command data.device,"'SET BAUD 38400,N,8,1 485 DISABLE'"
		send_command data.device,"'HSOFF'"
	}
}
BUTTON_EVENT[DV_TP,71]		// PAN RIGHT
{
	PUSH:
		{
			SEND_STRING DV_CAMERA, "'PR'"
		}
}
BUTTON_EVENT[DV_TP,72]		// PAN LEFT
{
	PUSH:
		{
			SEND_STRING DV_CAMERA, "'PL'"
		}
}
BUTTON_EVENT[DV_TP,73]		// TILT UP
{
	PUSH:
		{
			SEND_STRING DV_CAMERA, "'TU'"
		}
}
BUTTON_EVENT[DV_TP,74]		// TILT DOWN
{
	PUSH:
		{
			SEND_STRING DV_CAMERA, "'TD'"
		}
}
BUTTON_EVENT[DV_TP,75]		// ZOOM IN
{
	PUSH:
		{
			SEND_STRING DV_CAMERA, "'Z+'"
		}
}
BUTTON_EVENT[DV_TP,76]		// ZOOM OUT
{
	PUSH:
		{
			SEND_STRING DV_CAMERA, "'Z-'"
		}
}
BUTTON_EVENT[DV_TP,77]		// FOCUS IN
{
	PUSH:
		{
			SEND_STRING DV_CAMERA, "'F+'"
		}
}
BUTTON_EVENT[DV_TP,78]		// FOCUS OUT
{
	PUSH:
		{
			SEND_STRING DV_CAMERA, "'F-'"
		}
}
BUTTON_EVENT[DV_TP,79]		// TOGGLE TO CAMERA 2
{
	PUSH:
		{
			SEND_STRING DV_CAMERA_102, "''"
		}
}

DATA_EVENT[DV_DISPLAY_1]		//5001:8:101 MONITOR1 IR MODE, CARRIER ON
{
	online:
	{	// IR CONFIG
		SEND_COMMAND DATA.DEVICE,"'SET MODE IR'"
		SEND_COMMAND DATA.DEVICE,"'CARON'"		
	}
}
BUTTON_EVENT[DV_TP,5]		//MONITOR1 RGB1
{
	 PUSH:
     {
      PULSE[DV_DISPLAY_1,PUSH_CHANNEL+78]
     }
}
BUTTON_EVENT[DV_TP,6]		//MONITOR1 VIDEO1
{
	PUSH:
     {
      PULSE[DV_DISPLAY_1,PUSH_CHANNEL+79]
     }
}

DATA_EVENT[DV_DISPLAY_2]		//5001:9:101 MONITOR2 IR MODE, CARRIER ON
{
	online:
	{	// IR CONFIG
		SEND_COMMAND DATA.DEVICE,"'SET MODE IR'"
		SEND_COMMAND DATA.DEVICE,"'CARON'"		
	}
}
BUTTON_EVENT[DV_TP,7]		//MONITOR2 RGB1
{
	 PUSH:
     {
      PULSE[DV_DISPLAY_2,PUSH_CHANNEL+76]
     }
}
BUTTON_EVENT[DV_TP,8]		//MONITOR2 VIDEO1
{
	 PUSH:
     {
      PULSE[DV_DISPLAY_2,PUSH_CHANNEL+77]
     }
}


DATA_EVENT[DV_VCR]					//5001:10:101 VCR SERIAL MODE, CARRIER OFF
{
	online:
	{	// IR CONFIG
		SEND_COMMAND DATA.DEVICE,"'SET MODE IR'"
		SEND_COMMAND DATA.DEVICE,"'CAROFF'"		
	}
}

DATA_EVENT[DV_CD_CHANGER]		//5001:11:101 CD CHANGER IR MODE, CARRIER ON
{
	online:
	{	// IR CONFIG
		SEND_COMMAND DATA.DEVICE,"'SET MODE IR'"
		SEND_COMMAND DATA.DEVICE,"'CARON'"	
	}
}
BUTTON_EVENT[DV_TP,90]		//DISC 1
BUTTON_EVENT[DV_TP,91]		//DISC 2
BUTTON_EVENT[DV_TP,92]		//DISC 3
BUTTON_EVENT[DV_TP,93]		//DISC 4
BUTTON_EVENT[DV_TP,94]		//DISC 5
{
	 PUSH:
     {
      PULSE[DV_CD_CHANGER,PUSH_CHANNEL-31]
     }
}
BUTTON_EVENT[DV_TP,95]		//PLAY
BUTTON_EVENT[DV_TP,96]		//STOP
BUTTON_EVENT[DV_TP,97]		//PAUSE
BUTTON_EVENT[DV_TP,98]		//SKIP FWD
BUTTON_EVENT[DV_TP,99]		//SKIP REV
{
	 PUSH:
     {
      PULSE[DV_CD_CHANGER,PUSH_CHANNEL-94]
     }
}

BUTTON_EVENT[DV_TP,101]	//SCREEN UP
BUTTON_EVENT[DV_TP,102]	//SCREEN DOWN
{
	PUSH:
	{
		ON[DV_RELAYS,BUTTON.INPUT.CHANNEL-100]
		WAIT 25
		{ 
		TOTAL_OFF[DV_RELAYS,BUTTON.INPUT.CHANNEL-100]		
		{
	}
}

BUTTON_EVENT[DV_TP,103]		//SCREEN STOP
{
	PUSH:
	{
		PULSE[DV_RELAYS,BUTTON.INPUT.CHANNEL-100]
	}
}

BUTTON_EVENT[DV_TP,104]		//SYSTEM POWER
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
							TOTAL_OFF[DV_RELAYS,5]
							WAIT 10
							{
								TOTAL_OFF[DV_RELAYS,4]
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

[dv_TP,101] = [dv_Relays,1]
[dv_TP,102] = [dv_Relays,2]
[dv_TP,103] = [dv_Relays,3]
[DV_TP,104] = [DV_RELAYS,4] AND [DV_RELAYS,5]
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
              
SYSTEM_CALL [DV_VCR] 'VCR1' (DV_VCR,DV_TP,81,82,83,84,85,86,87,88,0)
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

