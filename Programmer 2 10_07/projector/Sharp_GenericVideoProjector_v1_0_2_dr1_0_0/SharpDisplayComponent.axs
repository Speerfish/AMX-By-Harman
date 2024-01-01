MODULE_NAME='SharpDisplayComponent'(
								dev vdvDev[],
								dev dvTP
							  )
(***********************************************************)
(*  FILE CREATED ON: 12/09/2005  AT: 11:18:15              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/19/2007  AT: 16:52:47        *)
(***********************************************************)

DEFINE_DEVICE

DEFINE_CONSTANT
integer nButtons[] = 
{
	1120,	//  1 - Picture Freeze cycle
	1121,	//  2 - Picture Mute cycle
	1122,	//  3 - PIP cycle
	1123,	//  4 - Set Active Window to Main
	1124,	//  5 - Set Active Window to Left
	1125,	//  6 - Set Active Window to Right
	1126,	//  7 - Set Active Window to Sub
	148,	//  8 - Increment Brightness
	149,	//  9 - Decrement Brightness
	150,	// 10 - Increment Color
	151,	// 11 - Decrement Color
	152,	// 12 - Increment Contrast
	153,	// 13 - Decrement Contrast
	154,	// 14 - Increment Sharpness
	155,	// 15 - Decrement Sharpness
	156,	// 16 - Increment Tint
	157,	// 17 - Decrement Tint
	142,	// 18 - Aspect Ratio Cycle
	191,	// 19 - Cycle PIP Position
	213,	// 20 - Set Picture Freeze
	210,	// 21 - Set Picture Mute
	194,	// 22 - Set PIP
	193,	// 23 - Swap PIP
	3010,	// 24 - Set Brightness (release)
	3011,	// 25 - Set Color (release)
	3012,	// 26 - Set Contrast (release)
	3013,	// 27 - Set Sharpness (release)
	3014,	// 28 - Set Tint (release)
	1149,	// 29 - Query video type
	1139,	// 30 - Query aspect ratio
	1129	// 31 - Query active window
}
integer nVTButtons[] =
{
	27		//  1 - Aspect Ratio
}

integer nTPLevels[] =
{
	10,		//  1 - Brightness
	11,		//  2 - Color
	12,		//  3 - Contrast
	13,		//  4 - Sharpness
	14		//  5 - Tint
}
// Aspect Ratio buttons
integer nAspectRatioBtns[] =
{
	1131,	//  1 - Normal (4x3)
	1133,	//  2 - Invalid (aspect ratio)
	3300,	//  3 - Full
	3301,	//  4 - Dot by Dot
	3302,	//  5 - Stretch
	3303,	//  6 - Smart Stretch
	3304,	//  7 - Border
	3316,	//  8 - Area Zoom
	3317	//	9 - V-Stretch
}

// Video Type buttons
integer nVideoTypeBtns[] =
{
	1140,	//  1 - SECAM
	1141,	//  2 - PAL
	1142,	//  3 - NTSC
	1145,	//  4 - Auto
	3305,	//  5 - NTSC 4.43
	3306,	//  6 - PAL-M
	3307,	//  7 - PAL-N
	3308	//  8 - PAL 60
}
char sAspectRatios[][20] = 
{
	'NORMAL',
	'INVALID',
	'FULL',
	'DOT_BY_DOT',
	'STRETCH',
	'SMART_STRETCH',
	'BORDER',
	'A_ZOOM',
	'V_STRETCH'
}

char sVideoTypes[][20] =
{
	'SECAM',
	'PAL',
	'NTSC',
	'AUTO',
	'NTSC4_43',
	'PAL_M',
	'PAL_N',
	'PAL_60'
}
integer nOutputBtns[] =
{
	301	// Output 1 
}
integer nFBArray[] =
{
	301	// Output 1
}
#include 'SNAPI.axi'

DEFINE_VARIABLE

volatile integer nBrightValue[]   = { 0 }
volatile integer nColorValue[]    = { 0 }
volatile integer nContrastValue[] = { 0 }
volatile integer nSharpValue[]    = { 0 }
volatile integer nTintValue[]     = { 0 }
volatile integer nDbg = 1
volatile integer nAspectRatioCount = 0
volatile integer nVideoTypeCount = 0
volatile integer nOutputCount = 1
volatile integer nCurrOut = 1

volatile char sActiveWindow[10] = ''
char sAspect[][20] = { '' }
char sVideoType[][20] = { '' }

//*******************************************************************
// Function : fPrintf												*
// Purpose  : to print a line to the telnet session					*
// Params   : sTxt - the data to print to the telnet session		*
// Return   : none													*
//*******************************************************************
define_function fPrintf (char sTxt[])
{
	if (nDbg > 2)
	{
		send_string 0, "'** Message from DisplayComponent.axs: ',sTxt"
	}
}

//*******************************************************************
// Function : fnFBLookup											*
// Purpose  : to look up whether this module is controlling 		*
//			  feedback for the button								*
// Params   : nChNo - the channel to test for feedback control		*
// Return   : integer - 1 for do feedback, 0 for do not do feedback	*
//*******************************************************************
define_function integer fnFBLookup (integer nChNo)
{
	stack_var integer z
	stack_var integer nFB
	nFB = 0
	z = 0
	for (z = 1; z <= length_array(nFBArray); z++)
	{
		if (nFBArray[z] == nChNo)
		{
			nFB = z
			break
		}
	}
/*	if (nFB)
	{
		fPrintf("'This component has feedback control over button #',itoa(nChNo)")
	}
	else
	{
		fPrintf("'This component does not have feedback control over button #',itoa(nChNo)")
	}
*/	return nFB
}

//*******************************************************************
// Function : dpstoa												*
// Purpose  : to convert a device's DPS to ascii for displaying		*
// Params   : dvIn - the device to be represented in ascii			*
// Return   : char[20] - the ascii representation of the dvIn's DPS	*
//*******************************************************************
define_function char[20] dpstoa (dev dvIn)
{
	return "itoa(dvIn.number),':',itoa(dvIn.port),':',itoa(dvIn.system)"
}

DEFINE_START

nAspectRatioCount = length_array(nAspectRatioBtns)
nVideoTypeCount = length_array(nVideoTypeBtns)
nOutputCount = length_array(vdvDev)

DEFINE_EVENT

data_event[vdvDev]
{
	command:
	{
		if (find_string(data.text, '-', 1))
		{
			stack_var integer x
			stack_var integer nTempDev
			stack_var char sCmd[20]
			
			for (x = 1; x <= nOutputCount; x++)
			{
				if (vdvDev[x] == data.device)
				{
					nTempDev = x
					break
				}
			}
			
			sCmd = remove_string(data.text, '-', 1)
			
			switch (sCmd)
			{
				case 'ACTIVEWINDOW-' :
				{
					sActiveWindow = data.text
				}
				case 'ASPECT-' :
				{
					sAspect[nTempDev] = data.text
					if (nTempDev = nCurrOut)
					{
						send_command dvTP, "'^TXT-',itoa(nVTButtons[1]),',0,',data.text"
					}
					for (x = 1; x <= nAspectRatioCount; x++)
					{
						[dvTP, nAspectRatioBtns[x]] = (sAspect[nCurrOut] == sAspectRatios[x])
					}
				}
				case 'VIDEOTYPE-' :
				{
					sVideoType[nTempDev] = data.text
					for (x = 1; x <= nVideoTypeCount; x++)
					{
						[dvTP, nVideoTypeBtns[x]] = (sVideoType[nCurrOut] == sVideoTypes[x])
					}
				}
				case 'DEBUG-' :
				{
					nDbg = atoi(data.text)
				}
			}
		}
	}
}

button_event[dvTP, nAspectRatioBtns]
{
	push:
	{
		stack_var integer nBtn
		stack_var integer x
		nBtn = get_last(nAspectRatioBtns)
		
		sAspect[nCurrOut] = sAspectRatios[nBtn]
		send_command vdvDev[nCurrOut], "'ASPECT-',sAspectRatios[nBtn]"
		fPrintf("'send_command ',dpstoa(vdvDev[nCurrOut]),', ',39,'ASPECT-',sAspectRatios[nBtn],39")
//		send_command dvTP, "'^TXT-',itoa(nVTButtons[1]),',0,',sAspect[nCurrOut]"
		
		for (x = 1; x <= nAspectRatioCount; x++)
		{
			[dvTP, nAspectRatioBtns[x]] = (sAspect[nCurrOut] == sAspectRatios[x])
		}
	}
}

button_event[dvTP, nVideoTypeBtns]
{
	push:
	{
		stack_var integer nBtn
		stack_var integer x
		nBtn = get_last(nVideoTypeBtns)
		
		sVideoType[nCurrOut] = sVideoTypes[nBtn]
		send_command vdvDev[nCurrOut], "'VIDEOTYPE-',sVideoTypes[nBtn]"
		fPrintf("'send_command ',dpstoa(vdvDev[nCurrOut]),', ',39,'VIDEOTYPE-',sVideoTypes[nBtn],39")
		
		for (x = 1; x <= nVideoTypeCount; x++)
		{
			[dvTP, nVideoTypeBtns[x]] = (sVideoType[nCurrOut] == sVideoTypes[x])
		}
	}
}

button_event[dvTP, nOutputBtns]
{
	push:
	{
		stack_var integer x
		nCurrOut = get_last(nOutputBtns)
		
		for (x = 1; x <= nOutputCount; x++)
		{
			if (fnFBLookup(nOutputBtns[x]))
			{
				[dvTP, nOutputBtns[x]] = (nCurrOut == x)
			}
		}
		
		for (x = 1; x <= nAspectRatioCount; x++)
		{
			[dvTP, nAspectRatioBtns[x]] = (sAspect[nCurrOut] == sAspectRatios[x])
		}
		
		// update all the levels for the new input
		send_level dvTP, nTPLevels[1], nBrightValue[nCurrOut]
		send_level dvTP, nTPLevels[2], nColorValue[nCurrOut]
		send_level dvTP, nTPLevels[3], nContrastValue[nCurrOut]
		send_level dvTP, nTPLevels[4], nSharpValue[nCurrOut]
		send_level dvTP, nTPLevels[5], nTintValue[nCurrOut]
	}
}

button_event[dvTP, nButtons]
{
	push:
	{
		stack_var integer nBtn
		nBtn = get_last(nButtons)
		
		switch (nBtn)
		{
			case 1 :	// Picture Freeze cycle
			{
				pulse[vdvDev[nCurrOut], PIC_FREEZE]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(PIC_FREEZE),']'")
			}
			case 2 :	// Picture Mute cycle
			{
				pulse[vdvDev[nCurrOut], PIC_MUTE]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(PIC_MUTE),']'")
			}
			case 3 :	// PIP cycle
			{
				pulse[vdvDev[nCurrOut], PIP]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(PIP),']'")
			}
			case 4 :	// Set Active Window to Main
			{
				send_command vdvDev[nCurrOut], "'ACTIVEWINDOW-MAIN'"
				fPrintf("'send_command ',dpstoa(vdvDev[nCurrOut]),', ',39,'ACTIVEWINDOW-MAIN',39")
			}
			case 5 :	// Set Active Window to Left
			{
				send_command vdvDev[nCurrOut], "'ACTIVEWINDOW-LEFT'"
				fPrintf("'send_command ',dpstoa(vdvDev[nCurrOut]),', ',39,'ACTIVEWINDOW-LEFT',39")
			}
			case 6 :	// Set Active Window to Right
			{
				send_command vdvDev[nCurrOut], "'ACTIVEWINDOW-RIGHT'"
				fPrintf("'send_command ',dpstoa(vdvDev[nCurrOut]),', ',39,'ACTIVEWINDOW-RIGHT',39")
			}
			case 7 :	// Set Active Window to Sub
			{
				send_command vdvDev[nCurrOut], "'ACTIVEWINDOW-SUB'"
				fPrintf("'send_command ',dpstoa(vdvDev[nCurrOut]),', ',39,'ACTIVEWINDOW-SUB',39")
			}
			case 8 :	// Increment Brightness
			{
				pulse[vdvDev[nCurrOut], BRIGHT_UP]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(BRIGHT_UP),']'")
			}
			case 9 :	// Decrement Brightness
			{
				pulse[vdvDev[nCurrOut], BRIGHT_DN]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(BRIGHT_DN),']'")
			}
			case 10 :	// Increment Color
			{
				pulse[vdvDev[nCurrOut], COLOR_UP]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(COLOR_UP),']'")
			}
			case 11 :	// Decrement Color
			{
				pulse[vdvDev[nCurrOut], COLOR_DN]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(COLOR_DN),']'")
			}
			case 12 :	// Increment Contrast
			{
				pulse[vdvDev[nCurrOut], CONTRAST_UP]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(CONTRAST_UP),']'")
			}
			case 13 :	// Decrement Contrast
			{
				pulse[vdvDev[nCurrOut], CONTRAST_DN]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(CONTRAST_DN),']'")
			}
			case 14 :	// Increment Sharpness
			{
				pulse[vdvDev[nCurrOut], SHARP_UP]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(SHARP_UP),']'")
			}
			case 15 :	// Decrement Sharpness
			{
				pulse[vdvDev[nCurrOut], SHARP_DN]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(SHARP_DN),']'")
			}
			case 16 :	// Increment Tint
			{
				pulse[vdvDev[nCurrOut], TINT_UP]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(TINT_UP),']'")
			}
			case 17 :	// Decrement Tint
			{
				pulse[vdvDev[nCurrOut], TINT_DN]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(TINT_DN),']'")
			}
			case 18 :	// Aspect Ratio Cycle
			{
				pulse[vdvDev[nCurrOut], ASPECT_RATIO]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(ASPECT_RATIO),']'")
			}
			case 19 :	// Cycle PIP Position
			{
				pulse[vdvDev[nCurrOut], PIP_POS]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(PIP_POS),']'")
			}
			case 20 :	// Set Picture Freeze
			{
				[vdvDev[nCurrOut], PIC_FREEZE_ON] = ![vdvDev[nCurrOut], PIC_FREEZE_ON]
				fPrintf("'[',dpstoa(vdvDev[nCurrOut]),', ',itoa(PIC_FREEZE_ON),'] = ![',dpstoa(vdvDev[nCurrOut]),', ',itoa(PIC_FREEZE_ON),']'")
			}
			case 21 :	// Set Picture Mute
			{
				[vdvDev[nCurrOut], PIC_MUTE_ON] = ![vdvDev[nCurrOut], PIC_MUTE_ON]
				fPrintf("'[',dpstoa(vdvDev[nCurrOut]),', ',itoa(PIC_MUTE_ON),'] = ![',dpstoa(vdvDev[nCurrOut]),', ',itoa(PIC_MUTE_ON),']'")
			}
			case 22 :	// Set PIP
			{
				[vdvDev[nCurrOut], PIP_ON] = ![vdvDev[nCurrOut], PIP_ON]
				fPrintf("'[',dpstoa(vdvDev[nCurrOut]),', ',itoa(PIP_ON),'] = ![',dpstoa(vdvDev[nCurrOut]),', ',itoa(PIP_ON),']'")
			}
			case 23 :	// Swap PIP
			{
				pulse[vdvDev[nCurrOut], PIP_SWAP]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(PIP_SWAP),']'")
			}
			case 29 :	// Query video type
			{
				send_command vdvDev[nCurrOut], "'?VIDEOTYPE'"
				fPrintf("'send_command ',dpstoa(vdvDev[nCurrOut]),', ',39,'?VIDEOTYPE',39")
			}
			case 30 :	// Query aspect ratio
			{
				send_command vdvDev[nCurrOut], "'?ASPECT'"
				fPrintf("'send_command ',dpstoa(vdvDev[nCurrOut]),', ',39,'?ASPECT',39")
			}
			case 31 :	// Query active window
			{
				send_command vdvDev[nCurrOut], "'?ACTIVEWINDOW'"
				fPrintf("'send_command ',dpstoa(vdvDev[nCurrOut]),', ',39,'?ACTIVEWINDOW',39")
			}
		}
	}
	release:
	{
		stack_var integer nBtn
		nBtn = get_last(nButtons)
		
		switch (nBtn)
		{
			case 24 :	// Set Brightness
			{
				send_level vdvDev[nCurrOut], BRIGHT_LVL, nBrightValue[nCurrOut]
				fPrintf("'send_level ',dpstoa(vdvDev[nCurrOut]),', ',itoa(BRIGHT_LVL),', ',itoa(nBrightValue[nCurrOut])")
			}
			case 25 :	// Set Color
			{
				send_level vdvDev[nCurrOut], COLOR_LVL, nColorValue[nCurrOut]
				fPrintf("'send_level ',dpstoa(vdvDev[nCurrOut]),', ',itoa(COLOR_LVL),', ',itoa(nColorValue[nCurrOut])")
			}
			case 26 :	// Set Contrast
			{
				send_level vdvDev[nCurrOut], CONTRAST_LVL, nContrastValue[nCurrOut]
				fPrintf("'send_level ',dpstoa(vdvDev[nCurrOut]),', ',itoa(CONTRAST_LVL),', ',itoa(nContrastValue[nCurrOut])")
			}
			case 27 : 	// Set Sharpness
			{
				send_level vdvDev[nCurrOut], SHARP_LVL, nSharpValue[nCurrOut]
				fPrintf("'send_level ',dpstoa(vdvDev[nCurrOut]),', ',itoa(SHARP_LVL),', ',itoa(nSharpValue[nCurrOut])")
			}
			case 28 :	// Set Tint
			{
				send_level vdvDev[nCurrOut], TINT_LVL, nTintValue[nCurrOut]
				fPrintf("'send_level ',dpstoa(vdvDev[nCurrOut]),', ',itoa(TINT_LVL),', ',itoa(nTintValue[nCurrOut])")
			}
		}
	}
}

level_event[dvTP, nTPLevels[1]]
{
	nBrightValue[nCurrOut] = level.value
}
level_event[vdvDev, BRIGHT_LVL]
{
	integer index
	integer n
	
	for (n = 1; n <= length_array(vdvDev); n++)
	{
		if (vdvDev[n] == level.input.device) { index = n }
	}
	nBrightValue[index] = level.value
	if (index == nCurrOut)
	{
		send_level dvTP, nTPLevels[1], nBrightValue[index]
		fPrintf("'send_level ',dpstoa(dvTP),', ',itoa(nTPLevels[1]),', ',itoa(nBrightValue[index])")
	}
}

level_event[dvTP, nTPLevels[2]]
{
	nColorValue[nCurrOut] = level.value
}
level_event[vdvDev, COLOR_LVL]
{
	integer index
	integer n
	
	for (n = 1; n <= length_array(vdvDev); n++)
	{
		if (vdvDev[n] == level.input.device) { index = n }
	}
	nColorValue[index] = level.value
	if (index == nCurrOut)
	{
		send_level dvTP, nTPLevels[2], nColorValue[index]
		fPrintf("'send_level ',dpstoa(dvTP),', ',itoa(nTPLevels[2]),', ',itoa(nColorValue[index])")
	}
}

level_event[dvTP, nTPLevels[3]]
{
	nContrastValue[nCurrOut] = level.value
}
level_event[vdvDev, CONTRAST_LVL]
{
	integer index
	integer n
	
	for (n = 1; n <= length_array(vdvDev); n++)
	{
		if (vdvDev[n] == level.input.device) { index = n }
	}
	nContrastValue[index] = level.value
	if (index == nCurrOut)
	{
		send_level dvTP, nTPLevels[3], nContrastValue[index]
		fPrintf("'send_level ',dpstoa(dvTP),', ',itoa(nTPLevels[3]),', ',itoa(nContrastValue[index])")
	}
}

level_event[dvTP, nTPLevels[4]]
{
	nSharpValue[nCurrOut] = level.value
}
level_event[vdvDev, SHARP_LVL]
{
	integer index
	integer n
	
	for (n = 1; n <= length_array(vdvDev); n++)
	{
		if (vdvDev[n] == level.input.device) { index = n }
	}
	nSharpValue[index] = level.value
	if (index == nCurrOut)
	{
		send_level dvTP, nTPLevels[4], nSharpValue[index]
		fPrintf("'send_level ',dpstoa(dvTP),', ',itoa(nTPLevels[4]),', ',itoa(nSharpValue[index])")
	}
}

level_event[dvTP, nTPLevels[5]]
{
	nTintValue[nCurrOut] = level.value
}
level_event[vdvDev, TINT_LVL]
{
	integer index
	integer n
	
	for (n = 1; n <= length_array(vdvDev); n++)
	{
		if (vdvDev[n] == level.input.device) { index = n }
	}
	nTintValue[index] = level.value
	if (index == nCurrOut)
	{
		send_level dvTP, nTPLevels[5], nTintValue[index]
		fPrintf("'send_level ',dpstoa(dvTP),', ',itoa(nTPLevels[5]),', ',itoa(nTintValue[index])")
	}
}

DEFINE_PROGRAM
[dvTP, nButtons[4]] = (sActiveWindow = 'MAIN')
[dvTP, nButtons[5]] = (sActiveWindow = 'LEFT')
[dvTP, nButtons[6]] = (sActiveWindow = 'RIGHT')
[dvTP, nButtons[7]] = (sActiveWindow = 'SUB')
[dvTP, nButtons[20]] = [vdvDev[nCurrOut], PIC_FREEZE_FB]
[dvTP, nButtons[21]] = [vdvDev[nCurrOut], PIC_MUTE_FB]
[dvTP, nButtons[22]] = [vdvDev[nCurrOut], PIP_FB]
