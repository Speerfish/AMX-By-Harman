MODULE_NAME='SharpLampComponent'(
								dev vdvDev[],
								dev dvTP
						   )
(***********************************************************)
(*  FILE CREATED ON: 12/21/2005  AT: 16:41:27              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/12/2007  AT: 08:15:40        *)
(***********************************************************)

DEFINE_DEVICE

DEFINE_CONSTANT
integer nButtons[] =
{
	9,		//  1 - Power
	27,		//  2 - Power On
	28,		//  3 - Power Off
	255,	//  4 - Power Cycle
	1510,	//  5 - query cooldown time
	1511,	//  6 - query lamp time
	1512,	//  7 - query warmup time
	1514,	//  8 - set cooldown time
	1516,	//  9 - set lamp time
	1515,	// 10 - set warmup time
	1513,	// 11 - set counter notify state
	2140,	// 12 - 0
	2141,	// 13 - 1
	2142,	// 14 - 2
	2143,	// 15 - 3
	2144,	// 16 - 4
	2145,	// 17 - 5
	2146,	// 18 - 6
	2147,	// 19 - 7
	2148,	// 20 - 8
	2149,	// 21 - 9
	2150,	// 22 - Accept
	2151,	// 23 - Cancel
	2152,	// 24 - Clear
	1518,	// 25 - Warming
	1517	// 26 - Cooling
}

integer nVTButtons[] =
{
	13,		//  1 - warmup time (countdown)
	12,		//  2 - cooldown time (countdown)
	14,		//  3 - lamp time
	2140,	//  4 - set display
	1510,	//  5 - cooldown time
	1511	//  6 - warmup time
}

integer nOutputBtns[] =
{
	301,	// Output 1
	302		// Output 2
}

integer nFBArray[] =
{
	301,	// Output 1
	302		// Output 2
}
#include 'SNAPI.axi'

DEFINE_VARIABLE

volatile integer nAdjustType = 0
volatile integer nNotifyState = 0
volatile char sNumber[4] = ''

volatile integer nCurrZone = 1
volatile integer nDbg = 1
volatile integer nOutputCount = 1

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
		send_string 0, "'** Message from LampComponent.axs: ',sTxt"
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

DEFINE_EVENT

data_event[vdvDev]
{
	command:
	{
		if (find_string(data.text, '-', 1))
		{
			stack_var char sCmd[20]
			stack_var integer x
			stack_var integer nTempZone
			sCmd = remove_string(data.text, '-', 1)
			
			nTempZone = 0
			for (x = 1; x <= nOutputCount; x++)
			{
				if (data.device == vdvDev[x])
				{
					nTempZone = x
					break
				}
			}
			
			switch (sCmd)
			{
				case 'LAMPTIME-' :
				{
					if (nTempZone == nCurrZone)
					{
						send_command dvTP, "'^TXT-',itoa(nVTButtons[3]),',0,',data.text"
					}
				}// End case 'LAMPTIME-' :
				case 'COOLDOWN-' :
				{
					if (nTempZone == nCurrZone)
					{
						send_command dvTP, "'^TXT-',itoa(nVTButtons[5]),',0,',data.text"
					}
				}
				case 'COOLING-' :
				{
					if (nTempZone == nCurrZone)
					{
						send_command dvTP, "'^TXT-',itoa(nVTButtons[2]),',0,',data.text"
					}
				}// End case 'COOLING-' :
				case 'WARMING-' :
				{
					if (nTempZone == nCurrZone)
					{
						send_command dvTP, "'^TXT-',itoa(nVTButtons[1]),',0,',data.text"
					}
				}// End case 'WARMING-' :
				case 'WARMUP-' :
				{
					if (nTempZone == nCurrZone)
					{
						send_command dvTP, "'^TXT-',itoa(nVTButtons[6]),',0,',data.text"
					}
				}
				case 'DEBUG-' :
				{
					nDbg = atoi(data.text)
				}// End case 'DEBUG-' :
			}// End switch (sCmd)
		}// End if (find_string(data.text, '-', 1))
	}// End command:
}// End data_event[vdvDev]

button_event[dvTP, nOutputBtns]
{
	push:
	{
		stack_var integer x
		nCurrZone = get_last(nOutputBtns)
		
		for (x = 1; x <= nOutputCount; x++)
		{
			if (fnFBLookup(nOutputBtns[x]))
			{
				[dvTP, nOutputBtns[x]] = (nCurrZone == x)
			}
		}
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
			case 1 :	// Set Lamp Power
			{
				[vdvDev[nCurrZone], POWER_ON] = ![vdvDev[nCurrZone], POWER_ON]
				fPrintf("'[',dpstoa(vdvDev[nCurrZone]),', ',itoa(POWER_ON),'] = ![',dpstoa(vdvDev[nCurrZone]),', ',itoa(POWER_ON),']'")
			}
			case 2 :	// Set Lamp Power On
			{
				pulse[vdvDev[nCurrZone], PWR_ON]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrZone]),', ',itoa(PWR_ON),']'")
			}
			case 3 :	// Set Lamp Power Off
			{
				pulse[vdvDev[nCurrZone], PWR_OFF]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrZone]),', ',itoa(PWR_OFF),']'")
			}
			case 4 :	// Cycle Lamp Power
			{
				pulse[vdvDev[nCurrZone], POWER]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrZone]),', ',itoa(POWER),']'")
			}
			case 5 :	// query cooldown time
			{
				send_command vdvDev[nCurrZone], "'?COOLDOWN'"
				fPrintf("'send_command ',dpstoa(vdvDev[nCurrZone]),', ',39,'?COOLDOWN',39")
			}
			case 6 :	// query lamp time
			{
				send_command vdvDev[nCurrZone], "'?LAMPTIME'"
				fPrintf("'send_command ',dpstoa(vdvDev[nCurrZone]),', ',39,'?LAMPTIME',39")
			}
			case 7 :	// query warmup time
			{
				send_command vdvDev[nCurrZone], "'?WARMUP'"
				fPrintf("'send_command ',dpstoa(vdvDev[nCurrZone]),', ',39,'?WARMUP',39")
			}
			case 8 :	// set cooldown time
			case 9 :	// set lamp time
			case 10 :	// set warmup time
			{
				nAdjustType = nBtn
				send_command dvTP, "'@PPN-Lamp Numeric'"
				send_command dvTP, "'^TXT-',itoa(nVTButtons[4]),',0,',sNumber"
			}
			case 11 :	// set counter notify state
			{
				nNotifyState = !(nNotifyState)
				send_command vdvDev[nCurrZone], "'COUNTERNOTIFY-',itoa(nNotifyState)"
				fPrintf("'send_command ',dpstoa(vdvDev[nCurrZone]),', ',39,'COUNTERNOTIFY-',itoa(nNotifyState),39")
			}
			case 12 :	// 0
			case 13 :	// 1
			case 14 :	// 2
			case 15 :	// 3
			case 16 :	// 4
			case 17 :	// 5
			case 18 :	// 6
			case 19 :	// 7
			case 20 :	// 8
			case 21 :	// 9
			{
				if (length_string(sNumber) >= 4)
				{
					get_buffer_char(sNumber)
				}
				sNumber = "sNumber, itoa(nBtn - 12)"
				send_command dvTP, "'^TXT-',itoa(nVTButtons[4]),',0,',sNumber"
			}
			case 22 :	// Accept
			{
				switch (nAdjustType)
				{
					case 8 :
					{
						send_command vdvDev[nCurrZone], "'COOLDOWN-',sNumber"
						fPrintf("'send_command ',dpstoa(vdvDev[nCurrZone]),', ',39,'COOLDOWN-',sNumber,39")
					}
					case 9 :
					{
						send_command vdvDev[nCurrZone], "'LAMPTIME-',sNumber"
						fPrintf("'send_command ',dpstoa(vdvDev[nCurrZone]),', ',39,'LAMPTIME-',sNumber,39")
					}
					case 10 :
					{
						send_command vdvDev[nCurrZone], "'WARMUP-',sNumber"
						fPrintf("'send_command ',dpstoa(vdvDev[nCurrZone]),', ',39,'WARMUP-',sNumber,39")
					}
				}
				set_length_string(sNumber, 0)
				nAdjustType = 0
				send_command dvTP, "'^TXT-',itoa(nVTButtons[4]),',0,',sNumber"
				send_command dvTP, "'@PPK-Lamp Numeric'"
			}
			case 23 :	// Cancel
			{
				set_length_string(sNumber, 0)
				nAdjustType = 0
				send_command dvTP, "'^TXT-',itoa(nVTButtons[4]),',0,',sNumber"
				send_command dvTP, "'@PPK-Lamp Numeric'"
			}
			case 24 :	// Clear
			{
				set_length_string(sNumber, 0)
				send_command dvTP, "'^TXT-',itoa(nVTButtons[4]),',0,',sNumber"
			}
		}
	}
}

DEFINE_PROGRAM
[dvTP, nButtons[1]] = ( [vdvDev[nCurrZone], POWER_FB] && ![vdvDev[nCurrZone], LAMP_WARMING_FB] && ![vdvDev[nCurrZone], LAMP_COOLING_FB])
[dvTP, nButtons[2]] = ( [vdvDev[nCurrZone], POWER_FB] && ![vdvDev[nCurrZone], LAMP_WARMING_FB] && ![vdvDev[nCurrZone], LAMP_COOLING_FB])
[dvTP, nButtons[3]] = (![vdvDev[nCurrZone], POWER_FB] && ![vdvDev[nCurrZone], LAMP_WARMING_FB] && ![vdvDev[nCurrZone], LAMP_COOLING_FB])
[dvTP, nButtons[11]] = nNotifyState
[dvTP, nButtons[25]] = ([vdvDev[nCurrZone], POWER_FB] && [vdvDev[nCurrZone], LAMP_WARMING_FB] && ![vdvDev[nCurrZone], LAMP_COOLING_FB])
[dvTP, nButtons[26]] = ([vdvDev[nCurrZone], POWER_FB] && [vdvDev[nCurrZone], LAMP_COOLING_FB] && ![vdvDev[nCurrZone], LAMP_WARMING_FB])

