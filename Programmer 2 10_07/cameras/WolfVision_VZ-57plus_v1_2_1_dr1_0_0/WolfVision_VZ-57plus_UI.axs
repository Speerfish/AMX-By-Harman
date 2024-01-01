MODULE_NAME='WolfVision_VZ-57plus_UI' (DEV vdvDocCam,
				       INTEGER nBtns[],
				       INTEGER nLvls[],
				       DEV dvTP)

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

INTEGER MIRROR_UP_CH = 300
INTEGER MIRROR_DOWN_CH = 301
INTEGER MENU_CH = 302;
INTEGER MENU_UP_CH = 303;
INTEGER MENU_DOWN_CH = 304;
INTEGER MENU_LEFT_CH = 305;
INTEGER MENU_RIGHT_CH = 306;
INTEGER MENU_HELP_CH = 307;
INTEGER TEXT_ENHANCER_CH = 308;
INTEGER EXTERN_CH = 310;
INTEGER IMAGE_MUTE_CH = 311;
INTEGER IMAGETURN_CH = 312;
INTEGER BLACK_WHITE_CH = 313;
INTEGER SHOWALL_CH = 314;
INTEGER FREEZE_CH = 315;
INTEGER WHITE_BALANCE_CH = 316;
INTEGER LAMP_1_BLOWN_CH = 317;
INTEGER LAMP_2_BLOWN_CH = 318;

INTEGER MIRROR_LVL = 51;

#include 'SNAPI.axi'

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
CHAR sType[20]          // VZ TYPE (E.G. VZ57P)
CHAR sVersion[20]       // VZ FIRMWARE VERSION (E.G. 1.21b)
INTEGER bSBOn		// IS THE SLIDE BOX FIELD ON?
INTEGER bLBPresent	// IS A LIGHT BOX CONNECTED TO THE VISUALIZER?
INTEGER bLamp1Blown     // IS THE LAMP 1 BLOWN?
INTEGER bLamp2Blown     // IS THE LAMP 2 BLOWN?
CHAR sVideo[5]          // VIDEO STANDARD (PAL OR NTSC)
CHAR sResRGB[20]        // RGB RESOLUTION
CHAR sResDVI[20]        // DVI RESOLUTION

INTEGER nZoomPos = 0;   // VALUE OF ZOOM LEVEL
INTEGER nFocusPos = 0;  // VALUE OF FOCUS LEVEL
INTEGER nIrisPos = 0;   // VALUE OF IRIS LEVEL
INTEGER nMirrorPos = 0; // VALUE OF MIRROR LEVEL
INTEGER bBlockLvls = 0; // FLAG: BLOCK LEVEL VALUES

INTEGER nIndex
INTEGER nMemory         // WHICH MEMORY WILL BE STORED IF USER 
                        // HOLDS BUTTON LONG ENOUGH
INTEGER nMemoryStore    // SHOULD THE MEMORY BE STORED OR RECALLED
INTEGER nPreset         // WHICH PRESET WILL BE STORED IF USER
                        // HOLDS BUTTON LONG ENOUGH
INTEGER nPresetStore    // SHOULD THE PRESET BE STORED OR RECALLED

INTEGER nDebug = 1;     // ACTUAL DEBUG STATE (ERROR)

/***************************************************************/
/* Function: UpdateTPLvlFB()                                   */
/* Purpose:  When a panel goes offline then comes back online, */
/*           it's levels are reset to zero. This updates the   */
/*           levels when the panel comes back online.          */
/***************************************************************/
DEFINE_FUNCTION fnUpdateTPLvlFB()
{
    IF (nDebug >= 3)
    {
	SEND_STRING 0, "'fnUpateTPLvlFB()'";
    }

    // Refresh Zoom
    SEND_LEVEL dvTP, nBtns[51], nZoomPos;
    SEND_COMMAND dvTP, "'@TXT', nLvls[1], ITOA(nZoomPos)";

    // Refresh Focus
    SEND_LEVEL dvTP, nBtns[52], nFocusPos;
    SEND_COMMAND dvTP, "'@TXT', nLvls[2], ITOA(nFocusPos)";

    // Refresh Iris
    SEND_LEVEL dvTP, nBtns[53], nIrisPos;
    SEND_COMMAND dvTP, "'@TXT', nLvls[3], ITOA(nIrisPos)";

    // Refresh Mirror
    SEND_LEVEL dvTP, nBtns[54], nMirrorPos;
    SEND_COMMAND dvTP, "'@TXT', nLvls[4], ITOA(nMirrorPos)";
}

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[dvTP]
{
    ONLINE:
    {
	fnUpdateTPLvlFB();		// Update the touch panel levels
	bBlockLvls = 0;			// No longer block levels
	SEND_COMMAND data.device, "'PAGE-VZ57plus'";
    }
    OFFLINE:
    {
	bBlockLvls = 1;
    }
}
  
DATA_EVENT [vdvDoccam]
{
    ONLINE:
    {
	WAIT_UNTIL ([vdvDoccam, DEVICE_COMMUNICATING])
	{
	    SEND_COMMAND vdvDoccam, "'?DEBUG'";
	}
    }
    COMMAND:
    {
	STACK_VAR CHAR sCmd[20];
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'UI received from COMM: ', DATA.TEXT";
	}
	sCmd = REMOVE_STRING(DATA.TEXT, '-', 1);
	SWITCH (sCmd)
	{
	    CASE 'DEBUG-':
	    {
		nDebug = ATOI(DATA.TEXT);
		IF (nDebug >= 3)
		{
		    SEND_STRING 0, "'DEBUG messages turned on, level ', DATA.TEXT";
		}
		ELSE
		{
		    SEND_STRING 0, "'DEBUG messages turned off'";
		}
		BREAK
	    }
	    CASE 'VZTYPE-':
	    {
		sType = DATA.TEXT;
		IF (nDebug >= 3)
		{
		    SEND_STRING 0, "'VZ Type: ', sType";
		}
		BREAK
	    }
	    CASE 'VZVERSION-':
	    {
		sVersion = DATA.TEXT
		IF (nDebug >= 3)
		{
		    SEND_STRING 0, "'VZ Version: ', sVersion";
		}
		BREAK
	    }
	    CASE 'LIGHT-':
	    {
		IF (DATA.TEXT == 'SB_ON')
		{
		    bSBOn = 1
		}
		ELSE IF (DATA.TEXT == 'SB_OFF')
		{
		    bSBOn = 0
		}
		ELSE IF (DATA.TEXT == 'LB_CONNECTED')
		{
		    bLBPresent = 1
		}
		ELSE IF (DATA.TEXT == 'LB_DISCONNECTED')
		{
		    bLBPresent = 0
		}
		IF (nDebug >= 3)
		{
		    SEND_STRING 0, "'Light Feedback: ', DATA.TEXT";
		}
            }
	    CASE 'VIDEO-':
	    {
		sVideo = DATA.TEXT
		IF (nDebug >= 3)
		{
		    SEND_STRING 0, "'Video Format: ', sVideo";
		}
		BREAK
	    }
	    CASE 'RES_RGB-':
	    {
		sResRGB = DATA.TEXT
		IF (nDebug >= 3)
		{
		    SEND_STRING 0, "'RGB Resolution: ', sResRGB";
		}
		BREAK
	    }
	    CASE 'RES_DVI-':
	    {
		sResDVI = DATA.TEXT
		IF (nDebug >= 3)
		{
		    SEND_STRING 0, "'DVI Resolution: ', sResDVI";
		}
		BREAK
	    }
	    CASE 'MACRO-':
	    {
		IF ((DATA.TEXT == '12X') || (DATA.TEXT == '11X'))
		{
		    [dvTP, nBtns[50]] = 1
		}
		ELSE IF (DATA.TEXT == 'OFF')
		{
		    [dvTP, nBtns[50]] = 0
		}
		BREAK
	    }
	    CASE 'NEGATIVE-':
	    {
		IF ((DATA.TEXT == 'BLUE') || (DATA.TEXT == 'ON'))
		{
		    [dvTP, nBtns[44]] = 1
		}
		ELSE IF (DATA.TEXT == 'OFF')
		{
		    [dvTP, nBtns[44]] = 0
		}
		BREAK
	    }
	    CASE 'ARM-':
	    {
		IF ((DATA.TEXT == 'UNDEFINED') || (DATA.TEXT == '12X') || 
		    (DATA.TEXT == '11X') || (DATA.TEXT == 'UP'))
		{
		    [dvTP, nBtns[49]] = 1
		}
		ELSE IF (DATA.TEXT == 'DOWN')
		{
		    [dvTP, nBtns[49]] = 0
		}
		BREAK
	    }
	}
    }
}

BUTTON_EVENT [dvTP, nBtns]
{
    PUSH:
    {
	nIndex = GET_LAST(nBtns)
	SWITCH (nIndex)
	{
	    CASE 1:	(* Power on/off *)
	    {
		PULSE [vdvDoccam, POWER]
		BREAK
	    }
	    CASE 2:	(* Live Image *)
	    {
		TO [BUTTON.INPUT]
		nMemory = 0
		SEND_COMMAND vdvDoccam, "'MEMORY-OFF'"
		    
		IF ([vdvDoccam, IMAGETURN_CH])
		{
		    OFF [vdvDoccam, IMAGETURN_CH]
		}
		IF ([vdvDoccam, EXTERN_CH])
		{
		    OFF [vdvDoccam, EXTERN_CH]
		}
		IF ([vdvDoccam, FREEZE_CH])
		{
		    OFF [vdvDoccam, FREEZE_CH]
		}
		BREAK
	    }
	    CASE 3:	(* Image Turn on/off *)
	    {
		SEND_COMMAND vdvDoccam, "'IMAGETURN-CYCLE'"
		BREAK
	    }
	    CASE 4:	(* Extern on/off *)
	    {
		IF ([vdvDoccam, EXTERN_CH])
		{
		    OFF [vdvDoccam, EXTERN_CH]
		}
		ELSE
		{
		    ON [vdvDoccam, EXTERN_CH]
		}
		BREAK
	    }
	    CASE 5:	(* Store/Recall Preset 1 *)
	    CASE 6:	(* Store/Recall Preset 2 *)
	    CASE 7:	(* Store/Recall Preset 3 *)
	    {
		TO [BUTTON.INPUT]
		nPreset = nIndex - 4
		nPresetStore = 0
		nMemory = 0
		SEND_COMMAND vdvDoccam, "'MEMORY-OFF'"
		BREAK
	    }
	    CASE 8:	(* Zoom Tele Start *)
	    {
		TO [BUTTON.INPUT]
		ON [vdvDoccam, ZOOM_IN]
		BREAK
	    }
	    CASE 9:	(* Zoom Wide Start *)
	    {
		TO [BUTTON.INPUT]
		ON [vdvDoccam, ZOOM_OUT]
		BREAK
	    }
	    CASE 10:	(* Focus Near Start *)
	    {
		TO [BUTTON.INPUT]
		ON [vdvDoccam, FOCUS_NEAR]
		BREAK
	    }
	    CASE 11:	(* Focus Far Start *)
	    {
		TO [BUTTON.INPUT]
		ON [vdvDoccam, FOCUS_FAR]
		BREAK
	    }
	    CASE 12:	(* AF on/off *)
	    {
		TO [BUTTON.INPUT]
		SEND_COMMAND vdvDoccam, "'AF-ONEPUSH'"
		BREAK
	    }
	    CASE 13:	(* Iris Close Start *)
	    {
		TO [BUTTON.INPUT]
		ON [vdvDoccam, IRIS_CLOSE]
		BREAK
	    }
	    CASE 14:	(* Iris Open Start *)
	    {
		TO [BUTTON.INPUT]
		ON [vdvDoccam, IRIS_OPEN]
		BREAK
	    }
	    CASE 15:	(* AI on/off *)
	    {
		PULSE [vdvDoccam, AUTO_IRIS]
		BREAK
	    }
	    CASE 16:	(* Textenhancer on/off *)
	    {
		IF ([vdvDoccam, TEXT_ENHANCER_CH])
		{
		    OFF [vdvDoccam, TEXT_ENHANCER_CH]
		}
		ELSE
		{
		    ON [vdvDoccam, TEXT_ENHANCER_CH]
		}
		BREAK
	    }
	    CASE 17:	(* Store/Recall Memory 1 *)
	    CASE 18:	(* Store/Recall Memory 2 *)
	    CASE 19:	(* Store/Recall Memory 3 *)
	    CASE 20:	(* Store/Recall Memory 4 *)
	    CASE 21:	(* Store/Recall Memory 5 *)
	    CASE 22:	(* Store/Recall Memory 6 *)
	    CASE 23:	(* Store/Recall Memory 7 *)
	    CASE 24:	(* Store/Recall Memory 8 *)
    	    CASE 25:	(* Store/Recall Memory 9 *)
	    {
		TO [BUTTON.INPUT]
		nMemory = nIndex - 16
		nMemoryStore = 0
		BREAK
	    }
	    CASE 26:	(* Show All on/off *)
	    {
		IF ([vdvDoccam, SHOWALL_CH])
		{
		    OFF [vdvDoccam, SHOWALL_CH]
		}
		ELSE
		{
		    ON [vdvDoccam, SHOWALL_CH]
		}
		BREAK
	    }
	    CASE 27:	(* Light on/off *)
	    {
		IF ([vdvDoccam, POWER_FB])
		{
		    IF ([vdvDoccam, DOCCAM_UPPER_LIGHT_FB])
		    {
			OFF [vdvDoccam, DOCCAM_UPPER_LIGHT_ON]
		    }
		    ELSE
		    {
			ON [vdvDoccam, DOCCAM_UPPER_LIGHT_ON]
		    }
		}
		BREAK
	    }
	    CASE 28:	(* LightBox on/off *)
	    {
		IF ([vdvDoccam, POWER_FB])
		{
		    IF ([vdvDoccam, DOCCAM_LOWER_LIGHT_FB])
		    {
			OFF [vdvDoccam, DOCCAM_LOWER_LIGHT_ON]
		    }
		    ELSE
		    {
			ON [vdvDoccam, DOCCAM_LOWER_LIGHT_ON]
		    }
		}
		BREAK
	    }
	    CASE 29:	(* All Lights off *)
	    {
		TO [BUTTON.INPUT]
		IF ([vdvDoccam, DOCCAM_UPPER_LIGHT_FB])
		{
		    OFF [vdvDoccam, DOCCAM_UPPER_LIGHT_ON] 
		}
		ELSE IF ([vdvDoccam, DOCCAM_LOWER_LIGHT_FB])
		{
		    OFF [vdvDoccam, DOCCAM_LOWER_LIGHT_ON]
		}
		BREAK
	    }
	    CASE 30:	(* Menu on/off *)
	    {
		TO [BUTTON.INPUT]
		IF ([vdvDoccam, POWER_FB])
		{
		    SEND_COMMAND vdvDoccam, "'MENU-TOGGLE'"
		}
		BREAK
	    }
	    CASE 31:	(* Menu Up *)
	    {
		IF ([vdvDoccam, MENU_CH])
		{
		    PULSE [vdvDoccam, MENU_UP_CH]
		}
		BREAK
	    }
	    CASE 32:	(* Menu Down *)
	    {
		IF ([vdvDoccam, MENU_CH])
		{
		    PULSE [vdvDoccam, MENU_DOWN_CH]
		}
		BREAK
	    }
	    CASE 33:	(* Menu Left *)
	    {
		IF ([vdvDoccam, MENU_CH])
		{
		    PULSE [vdvDoccam, MENU_LEFT_CH]
		}
		BREAK
	    }
	    CASE 34:	(* Menu Right *)
	    {
		IF ([vdvDoccam, MENU_CH])
		{
		    PULSE [vdvDoccam, MENU_RIGHT_CH]
		}
		BREAK
	    }
	    CASE 35:	(* Help on/off *)
	    {
		IF ([vdvDoccam, MENU_CH])
		{
		    IF ([vdvDoccam, MENU_HELP_CH])
		    {
			OFF [vdvDoccam, MENU_HELP_CH]
		    }
		    ELSE
		    {
			ON [vdvDoccam, MENU_HELP_CH]
		    }
		}
		BREAK
	    }
	    CASE 36:	(* Recall Preset A4 *)
	    {
		SEND_COMMAND vdvDoccam, "'PRESET-A4'"
		BREAK
	    }
	    CASE 37:	(* Recall Preset A5 *)
	    {
		SEND_COMMAND vdvDoccam, "'PRESET-A5'"
		BREAK
	    }
	    CASE 38:	(* Recall Preset A6 *)
	    {
		SEND_COMMAND vdvDoccam, "'PRESET-A6'"
		BREAK
	    }
	    CASE 39:	(* Recall Preset A7 *)
	    {
		SEND_COMMAND vdvDoccam, "'PRESET-A7'"
		BREAK
	    }
	    CASE 40:	(* Recall Preset A8 *)
	    {
		SEND_COMMAND vdvDoccam, "'PRESET-A8'"
		BREAK
	    }
	    CASE 41:	(* Recall Preset Slide *)
	    {
		SEND_COMMAND vdvDoccam, "'PRESET-SLIDE'"
		BREAK
	    }
	    CASE 42:	(* Black/White on/off *)
	    {
		IF ([vdvDoccam, BLACK_WHITE_CH])
		{
		    OFF [vdvDoccam, BLACK_WHITE_CH]
		}
		ELSE
		{
		    ON [vdvDoccam, BLACK_WHITE_CH]
		}
		BREAK
	    }
	    CASE 43:	(* Freeze on/off *)
	    {
		IF ([vdvDoccam, FREEZE_CH])
		{
		    OFF [vdvDoccam, FREEZE_CH]
		}
		ELSE
		{
		    ON [vdvDoccam, FREEZE_CH]
		}
		BREAK
	    }
	    CASE 44:	(* Pos/Neg on/off *)
	    {
		SEND_COMMAND vdvDoccam, "'NEGATIVE-TOGGLE'"
		BREAK
	    }
	    CASE 45:	(* White Balance *)
	    {
		TO [BUTTON.INPUT]
		PULSE [vdvDoccam, WHITE_BALANCE_CH]
		BREAK
	    }
	    CASE 46:	(* Image Mute on/off *)
	    {
		IF ([vdvDoccam, IMAGE_MUTE_CH])
		{
		    OFF [vdvDoccam, IMAGE_MUTE_CH]
		}
		ELSE
		{
		    ON [vdvDoccam, IMAGE_MUTE_CH]
		}
		BREAK
	    }
	    CASE 47:	(* Mirror Up *)
	    {
		TO [BUTTON.INPUT]
		ON [vdvDoccam, MIRROR_UP_CH]
		BREAK
	    }
	    CASE 48:	(* Mirror Down *)
	    {
		TO [BUTTON.INPUT]
		ON [vdvDoccam, MIRROR_DOWN_CH]
		BREAK
	    }
	    CASE 49:	(* Arm *)
	    {
		SEND_COMMAND vdvDoccam, "'ARM-TOGGLE'"
		BREAK
	    }
	    CASE 50:	(* Macro *)
	    {
		SEND_COMMAND vdvDoccam, "'MACRO-TOGGLE'"
		BREAK
	    }
	}
    }
    HOLD [20]:
    {
	SWITCH (nIndex)
	{
	    CASE 5:	(* Store Preset 1 *)
	    CASE 6:	(* Store Preset 2 *)
	    CASE 7:	(* Store Preset 3 *)
	    {
		nPresetStore = 1
		SEND_COMMAND vdvDoccam, "'PRESET_STORE-', ITOA(nPreset)"
		SEND_COMMAND BUTTON.INPUT.DEVICE, "'ADBEEP'"
		BREAK
	    }
	    CASE 17:	(* Store Memory 1 *)
	    CASE 18:	(* Store Memory 2 *)
	    CASE 19:	(* Store Memory 3 *)
	    CASE 20:	(* Store Memory 4 *)
	    CASE 21:	(* Store Memory 5 *)
	    CASE 22:	(* Store Memory 6 *)
	    CASE 23:	(* Store Memory 7 *)
	    CASE 24:	(* Store Memory 8 *)
	    CASE 25:	(* Store Memory 9 *)
	    {
		nMemoryStore = 1
		SEND_COMMAND vdvDoccam, "'MEMORY_STORE-', ITOA(nMemory)"
		SEND_COMMAND BUTTON.INPUT.DEVICE, "'ADBEEP'"
		BREAK
	    }
	}
    }
    RELEASE:
    {
    	SWITCH (nIndex)
	{
	    CASE 5:	(* Recall Preset 1 if not previously stored *)
	    CASE 6:	(* Recall Preset 2 if not previously stored *)
	    CASE 7:	(* Recall Preset 3 if not previously stored *)
	    {
		IF (!nPresetStore)
		{
		    SEND_COMMAND vdvDoccam, "'PRESET-', ITOA(nPreset)"
		}
		BREAK
	    }
	    CASE 8:	(* Zoom Tele Stop *)
	    {
		OFF [vdvDoccam, ZOOM_IN]
		BREAK
	    }
	    CASE 9:	(* Zoom Wide Stop *)
	    {
		OFF [vdvDoccam, ZOOM_OUT]
		BREAK
	    }
	    CASE 10:	(* Focus Near Stop *)
	    {
		OFF [vdvDoccam, FOCUS_NEAR]
		BREAK
	    }
	    CASE 11:	(* Focus Far Stop *)
	    {
		OFF [vdvDoccam, FOCUS_FAR]
		BREAK
	    }
	    CASE 13:	(* Iris Close Stop *)
	    {
		OFF [vdvDoccam, IRIS_CLOSE]
		BREAK
	    }
	    CASE 14:	(* Iris Open Stop *)
	    {
		OFF [vdvDoccam, IRIS_OPEN]
		BREAK
	    }
	    CASE 17:	(* Recall Memory 1 if not previously stored *)
	    CASE 18:	(* Recall Memory 2 if not previously stored *)
	    CASE 19:	(* Recall Memory 3 if not previously stored *)
	    CASE 20:	(* Recall Memory 4 if not previously stored *)
	    CASE 21:	(* Recall Memory 5 if not previously stored *)
	    CASE 22:	(* Recall Memory 6 if not previously stored *)
	    CASE 23:	(* Recall Memory 7 if not previously stored *)
	    CASE 24:	(* Recall Memory 8 if not previously stored *)
	    CASE 25:	(* Recall Memory 9 if not previously stored *)
	    {
		IF (!nMemoryStore)
		{
		    SEND_COMMAND vdvDoccam, "'MEMORY-', ITOA(nMemory)"
		}
		BREAK
	    }
	    CASE 47:	(* Mirror Up *)
	    {
		OFF [vdvDoccam, MIRROR_UP_CH]
		BREAK
	    }
	    CASE 48:	(* Mirror Down *)
	    {
		OFF [vdvDoccam, MIRROR_DOWN_CH]
		BREAK
	    }
	} 
    }
}

(***********************************************************)
(*              CHANNEL HANDLING GOES BELOW                *)
(***********************************************************)

CHANNEL_EVENT [vdvDoccam, MIRROR_UP_CH]	// Mirror Up
{
    ON:
    {
	ON [dvTP, nBtns[47]]
    }
    OFF:
    {
	OFF [dvTP, nBtns[47]]
    }
}

CHANNEL_EVENT [vdvDoccam, MIRROR_DOWN_CH]	// Mirror Down
{
    ON:
    {
	ON [dvTP, nBtns[48]]
    }
    OFF:
    {
	OFF [dvTP, nBtns[48]]
    }
}

CHANNEL_EVENT [vdvDoccam, MENU_CH]	// Menu on/off
{
    ON:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Menu-on detected'";
	}
	SEND_COMMAND dvTP,"'PPON-Menu_Navi_VZ57plus;VZ57plus'"
    }
    OFF:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Menu-off detected'";
	}
	SEND_COMMAND dvTP,"'PPOF-Menu_Navi_VZ57plus;VZ57plus'"
    }
}

CHANNEL_EVENT [vdvDoccam, MENU_UP_CH]	// Menu up on/off
{
    ON:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Menu_up-on detected'";
	}
	[dvTP, nBtns[31]] = 1;
    }
    OFF:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Menu_up-off detected'";
	}
	[dvTP, nBtns[31]] = 0;
    }
}

CHANNEL_EVENT [vdvDoccam, MENU_DOWN_CH]	// Menu down on/off
{
    ON:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Menu_down-on detected'";
	}
	[dvTP, nBtns[32]] = 1;
    }
    OFF:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Menu_down-off detected'";
	}
	[dvTP, nBtns[32]] = 0;
    }
}

CHANNEL_EVENT [vdvDoccam, MENU_LEFT_CH]	// Menu left on/off
{
    ON:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Menu_left-on detected'";
	}
	[dvTP, nBtns[33]] = 1;
    }
    OFF:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Menu_left-off detected'";
	}
	[dvTP, nBtns[33]] = 0;
    }
}

CHANNEL_EVENT [vdvDoccam, MENU_RIGHT_CH]// Menu right on/off
{
    ON:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Menu_right-on detected'";
	}
	[dvTP, nBtns[34]] = 1;
    }
    OFF:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Menu_right-off detected'";
	}
	[dvTP, nBtns[34]] = 0;
    }
}

CHANNEL_EVENT [vdvDoccam, MENU_HELP_CH]	// Menu help on/off
{
    ON:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Menu_help-on detected'";
	}
	[dvTP, nBtns[35]] = 1;
    }
    OFF:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Menu_help-off detected'";
	}
	[dvTP, nBtns[35]] = 0;
    }
}

CHANNEL_EVENT [vdvDoccam, TEXT_ENHANCER_CH]	// Text enhancer on/off
{
    ON:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Textenhancer-on detected'";
	}
	ON [dvTP, nBtns[16]]
    }
    OFF:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Textenhancer-off detected'";
	}
	OFF [dvTP, nBtns[16]]
    }
}

CHANNEL_EVENT [vdvDoccam, EXTERN_CH]	// External/internal on/off
{
    ON:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Extern-on detected'";
	}
	ON [dvTP, nBtns[4]]
    }
    OFF:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Extern-off detected'";
	}
	OFF [dvTP, nBtns[4]]
    }
}

CHANNEL_EVENT [vdvDoccam, IMAGE_MUTE_CH]	// Image Mute on/off
{
    ON:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Image_mute-on detected'";
	}
	ON [dvTP, nBtns[46]]
    }
    OFF:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Image_mute-off detected'";
	}
	OFF [dvTP, nBtns[46]]
    }
}

CHANNEL_EVENT [vdvDoccam, IMAGETURN_CH]	// Imageturn on/off
{
    ON:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Imageturn-on detected'";
	}
	ON [dvTP, nBtns[3]]
    }
    OFF:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Imageturn-off detected'";
	}
	OFF [dvTP, nBtns[3]]
    }
}

CHANNEL_EVENT [vdvDoccam, SHOWALL_CH]	// Show all on/off
{
    ON:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Showall-on detected'";
	}
	ON [dvTP, nBtns[26]]
    }
    OFF:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Showall-off detected'";
	}
	OFF [dvTP, nBtns[26]]
    }
}

CHANNEL_EVENT [vdvDoccam, BLACK_WHITE_CH]// Black/White on/off
{
    ON:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'BlackWhite-on detected'";
	}
	ON [dvTP, nBtns[42]]
    }
    OFF:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'BlackWhite-off detected'";
	}
	OFF [dvTP, nBtns[42]]
    }
}

CHANNEL_EVENT [vdvDoccam, FREEZE_CH]	// Freeze on/off
{
    ON:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Freeze-on detected'";
	}
	ON [dvTP, nBtns[43]]
    }
    OFF:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Freeze-off detected'";
	}
	OFF [dvTP, nBtns[43]]
    }
}

CHANNEL_EVENT [vdvDoccam, LAMP_1_BLOWN_CH]// Lamp 1 blown?
{
    ON:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Lamp1Blown-on detected'";
	}
	bLamp1Blown = 1;
    }
    OFF:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Lamp1Blown-off detected'";
	}
	bLamp1Blown = 0;
    }
}

CHANNEL_EVENT [vdvDoccam, LAMP_2_BLOWN_CH]// Lamp 2 blown?
{
    ON:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Lamp2Blown-on detected'";
	}
	bLamp2Blown = 1;
    }
    OFF:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Lamp2Blown-off detected'";
	}
	bLamp2Blown = 0;
    }
}

(***********************************************************)
(*                LEVEL HANDLING GOES BELOW                *)
(***********************************************************)

// Zoom level from the module
LEVEL_EVENT[vdvDoccam, ZOOM_LVL]
{
    STACK_VAR INTEGER n;
    IF (nDebug >= 3)
    {
	SEND_STRING 0, "'Zoom level event on vdvDoccam'";
	SEND_STRING 0, "'    send_level dvTP, ', ITOA(nBtns[51]), ', ', ITOA(level.value)";
    }
    
    IF ((level.value >= 0) && (level.value <= 255))
    {
	// Store the level value
	nZoomPos = level.value;
	// Send the level to the zoom bar graph on the touch panel
	SEND_LEVEL dvTP, nBtns[51], level.value;
	// Send the level value to the zoom variable text
	SEND_COMMAND dvTP, "'@TXT', nLvls[1], ITOA(level.value)";
    }
}

// Zoom button release
BUTTON_EVENT[dvTP, nBtns[51]]
{
    RELEASE:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Zoom level (button) event on dvTP'";
	    SEND_STRING 0, "'    send_level vdvDoccam, ZOOM_LVL, ', ITOA(nZoomPos)";
	}
	// Send the zoom level value to the module
	SEND_LEVEL vdvDocCam, ZOOM_LVL, nZoomPos;
    }
}

// Zoom level on the touch panel
LEVEL_EVENT[dvTP, nBtns[51]]
{
    IF (nDebug >= 3)
    {
	SEND_STRING 0, "'Zoom level event on dvTP, ', ITOA(level.value)";
    }
    // Store the level value
    nZoomPos = level.value;
}

// Focus level from the module
LEVEL_EVENT[vdvDoccam, FOCUS_LVL]
{
    STACK_VAR INTEGER n;
    IF (nDebug >= 3)
    {
	SEND_STRING 0, "'Focus level event on vdvDoccam'";
	SEND_STRING 0, "'    send_level dvTP, ', ITOA(nBtns[52]), ', ', ITOA(level.value)";
    }
    
    IF ((level.value >= 0) && (level.value <= 255))
    {
	// Store the level value
	nFocusPos = level.value;
	// Send the level to the focus bar graph on the touch panel
	SEND_LEVEL dvTP, nBtns[52], level.value;
	// Send the level value to the focus variable text
	SEND_COMMAND dvTP, "'@TXT', nLvls[2], ITOA(level.value)";
    }
}

// Focus button release
BUTTON_EVENT[dvTP, nBtns[52]]
{
    RELEASE:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Focus level (button) event on dvTP'";
	    SEND_STRING 0, "'    send_level vdvDoccam, FOCUS_LVL, ', ITOA(nFocusPos)";
	}
	// Send the focus level value to the module
	SEND_LEVEL vdvDocCam, FOCUS_LVL, nFocusPos;
    }
}

// Focus level on the touch panel
LEVEL_EVENT[dvTP, nBtns[52]]
{
    IF (nDebug >= 3)
    {
	SEND_STRING 0, 'Focus level event on dvTP';
    }
    // Store the level value
    nFocusPos = level.value;
}

// Iris level from the module
LEVEL_EVENT[vdvDoccam, IRIS_LVL]
{
    STACK_VAR INTEGER n;
    IF (nDebug >= 3)
    {
	SEND_STRING 0, "'Iris level event on vdvDoccam'";
	SEND_STRING 0, "'    send_level dvTP, ', ITOA(nBtns[53]), ', ', ITOA(level.value)";
    }
    
    IF ((level.value >= 0) && (level.value <= 255))
    {
	// Store the level value
	nIrisPos = level.value;
	// Send the level to the iris bar graph on the touch panel
	SEND_LEVEL dvTP, nBtns[53], level.value;
	// Send the level value to the iris variable text
	SEND_COMMAND dvTP, "'@TXT', nLvls[3], ITOA(level.value)";
    }
}

// Iris button release
BUTTON_EVENT[dvTP, nBtns[53]]
{
    RELEASE:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Iris level (button) event on dvTP'";
	    SEND_STRING 0, "'    send_level vdvDoccam, IRIS_LVL, ', ITOA(nIrisPos)";
	}
	// Send the iris level value to the module
	SEND_LEVEL vdvDocCam, IRIS_LVL, nIrisPos;
    }
}

// Iris level on the touch panel
LEVEL_EVENT[dvTP, nBtns[53]]
{
    IF (nDebug >= 3)
    {
	SEND_STRING 0, 'Iris level event on dvTP';
    }
    // Store the level value
    nIrisPos = level.value;
}

// Mirror level from the module
LEVEL_EVENT[vdvDoccam, MIRROR_LVL]
{
    STACK_VAR INTEGER n;
    IF (nDebug >= 3)
    {
	SEND_STRING 0, "'Mirror level event on vdvDoccam'";
	SEND_STRING 0, "'    send_level dvTP, ', ITOA(nBtns[54]), ', ', ITOA(level.value)";
    }
    
    IF ((level.value >= 0) && (level.value <= 255))
    {
	// Store the level value
	nMirrorPos = level.value;
	// Send the level to the mirror bar graph on the touch panel
	SEND_LEVEL dvTP, nBtns[54], level.value;
	// Send the level value to the mirror variable text
	SEND_COMMAND dvTP, "'@TXT', nLvls[4], ITOA(level.value)";
    }
}

// Mirror button release
BUTTON_EVENT[dvTP, nBtns[54]]
{
    RELEASE:
    {
	IF (nDebug >= 3)
	{
	    SEND_STRING 0, "'Mirror level (button) event on dvTP'";
	    SEND_STRING 0, "'    send_level vdvDoccam, MIRROR_LVL, ', ITOA(nMirrorPos)";
	}
	// Send the mirror level value to the module
	SEND_LEVEL vdvDocCam, MIRROR_LVL, nMirrorPos;
    }
}

// Mirror level on the touch panel
LEVEL_EVENT[dvTP, nBtns[54]]
{
    IF (nDebug >= 3)
    {
	SEND_STRING 0, 'Mirror level event on dvTP';
    }
    // Store the level value
    nMirrorPos = level.value;
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
[dvTP, nBtns[1]]  = [vdvDoccam, POWER_FB]
[dvTP, nBtns[15]] = [vdvDoccam, AUTO_IRIS_FB]
[dvTP, nBtns[27]] = [vdvDoccam, DOCCAM_UPPER_LIGHT_FB]
[dvTP, nBtns[28]] = [vdvDoccam, DOCCAM_LOWER_LIGHT_FB]
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
