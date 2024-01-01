PROGRAM_NAME='MainInclude'
(***********************************************************)
(*  FILE CREATED ON: 02/15/2007  AT: 12:48:05              *)
(***********************************************************)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(* Description:                                            *)
(* This file was created to help track the active state of *)
(* a component's page                                      *)
(***********************************************************)

#IF_NOT_DEFINED __MAIN_INCLUDE__
#DEFINE __MAIN_INCLUDE__

//DEFINE_DEVICE
//dvTPMain = 10001:1:0 // PRE DEFINED VALUE
//
//DEFINE_VARIABLE
//INTEGER nDevice = 1 // PRE DEFINED VALUE
//INTEGER nPages[] = { 3 } // PRE DEFINED VALUE

DEFINE_VARIABLE
volatile integer nDbg = 1 				// The current debug level

VOLATILE CHAR bActiveComponent = FALSE 	// Used to determine if the current component is active or not
VOLATILE INTEGER bNoLevelReset = FALSE

VOLATILE INTEGER nActiveDevice = 0 		// The currently active device number
VOLATILE INTEGER nActiveDeviceID = 0 	// The currently active device button ID

VOLATILE INTEGER nActivePage = 0 		// The currently active page number
VOLATILE INTEGER nActivePageID = 0 		// The currently active page button ID
VOLATILE INTEGER nPageLoop = 0 			// Page feedback loop

VOLATILE INTEGER nCurrentZone = 1 		// The currently active zone
VOLATILE INTEGER nActiveZoneID = 0 		// The currently active zone button ID
VOLATILE INTEGER nZoneLoop = 0 			// Zone feedback loop

VOLATILE char strCompName[30] = ''

DEFINE_CONSTANT
INTEGER MAX_ZONE = 20

// List of device navigation buttons
integer nNavigationBtns[] =
{
    500, // Device 1
    501, // Device 2
    502, // Device 3
    503, // Device 4
    504, // Device 5
    505, // Device 6
    506, // Device 7
    507, // Device 8
    508, // Device 9
    509, // Device 10
    510, // Device 11
    511, // Device 12
    512, // Device 13
    513, // Device 14
    514, // Device 15
    515, // Device 16
    516, // Device 17
    517, // Device 18
    518, // Device 19
    519  // Device 20
}

// List of page sub navigation buttons
integer nSubNavBtns[] =
{
    520, // Page 1
    521, // Page 2
    522, // Page 3
    523, // Page 4
    524, // Page 5
    525, // Page 6
    526, // Page 7
    527, // Page 8
    528, // Page 9
    529, // Page 10
    530, // Page 11
    531, // Page 12
    532, // Page 13
    533, // Page 14
    534, // Page 15
    535, // Page 16
    536, // Page 17
    537, // Page 18
    538, // Page 19
    539  // Page 20
}

integer nZoneBtns[] =
{
    901, // Zone 1
    902, // Zone 2
    903, // Zone 3
    904, // Zone 4
    905, // Zone 5
    906, // Zone 6
    907, // Zone 7
    908, // Zone 8
    909, // Zone 9
    910, // Zone 10
    911, // Zone 11
    912, // Zone 12
    913, // Zone 13
    914, // Zone 14
    915, // Zone 15
    916, // Zone 16
    917, // Zone 17
    918, // Zone 18
    919, // Zone 19
    920  // Zone 20
}   

DEFINE_MUTUALLY_EXCLUSIVE
([dvTPMain,nSubNavBtns[1]]..[dvTPMain,nSubNavBtns[length_array(nSubNavBtns)]])
([dvTPMain,nZoneBtns[1]]..[dvTPMain,nZoneBtns[MAX_ZONE]])

DEFINE_START

nActiveDevice = 1
nActiveDeviceID = nNavigationBtns[1]
nCurrentZone = 1
nActiveZoneID = nZoneBtns[1]

DEFINE_EVENT

// Reset the panel
data_event[dvTPMain]
{
    ONLINE:
    {
		// This is a hack to clear all component popup pages
		send_command dvTPMain, "'@PPF-Popup Page;'" 
    }
}

// Get the currently active device
button_event[dvTPMain, nNavigationBtns]
{
    PUSH:
    {
		STACK_VAR INTEGER btn
		
		btn = get_last(nNavigationBtns)
		
		bActiveComponent = FALSE
		nActiveDevice = btn;
		nActiveDeviceID = nNavigationBtns[btn]
		
		nActivePage = 0
		nActivePageID = 0
		
		// Notify the module that a device selection has occurred
		OnDeviceChanged()
		
		// This is a hack to clear all component popup pages
		send_command dvTPMain, "'@PPF-Popup Page;'" 
    }
}

// Get the currently active page
button_event[dvTPMain, nSubNavBtns]
{
    PUSH:
    {
		STACK_VAR INTEGER btn
		
		btn = get_last(nSubNavBtns)
		
		bActiveComponent = FALSE
		nActivePage = btn;
		nActivePageID = nSubNavBtns[btn]
		
		// If this is from the device we were expecting
		if (nActiveDevice == nDevice)
		{
			integer i
			
			ON[dvTPMain, nSubNavBtns[nActivePage]]
			for (i = 1; i <= LENGTH_ARRAY(nPages); i++)
			{
				if (nActivePage == nPages[i])
				{
					bActiveComponent = TRUE
					
					// Notify the module that a page flip has occurred
					OnPageChanged()
					break;
				}
			}
		}
    }
}

// Get the current zone
button_event[dvTPMain, nZoneBtns]
{
    PUSH:
    {
		STACK_VAR INTEGER btn
		
		// If this zone was changed from the expected device
		if (nActiveDevice == nDevice)
		{
			btn = get_last(nZoneBtns)
			if (btn <= LENGTH_ARRAY(vdvDev))
			{
				nCurrentZone = btn
				nActiveZoneID = nZoneBtns[nCurrentZone]
				
				ON[dvTPMain, nZoneBtns[nCurrentZone]]
				
				// Notify the module that the zone has changed
				OnZoneChange()
			}
		}
    }
}

//*******************************************************************
// Function : println						    					*
// Purpose  : to print a line to the telnet session		    		*
// Params   : sName - name of the file to print			    		*
// Params   : sTxt - the data to print to the telnet session	    *
// Return   : none						    						*
//*******************************************************************
define_function println (char sTxt[])
{
    if (nDbg > 2)
    {
		if (LENGTH_STRING(strCompName) > 0)
			send_string 0, "'** Message from ', strCompName, ': ',sTxt"
		else
			send_string 0, "'** Message: ',sTxt"
    }
}

//*******************************************************************
// Function : dpstoa						    					*
// Purpose  : to convert a device's DPS to ascii for displaying	    *
// Params   : dvIn - the device to be represented in ascii	    	*
// Return   : char[20] - the ascii representation of the dvIn's DPS *
//*******************************************************************
define_function char[20] dpstoa (dev dvIn)
{
    return "itoa(dvIn.number),':',itoa(dvIn.port),':',itoa(dvIn.system)"
}

//*******************************************************************
// Function : getFeedbackZone					    				*
// Purpose  : Get the zone which matches the responding device	    *
// Params   : dvIn - the responding device			    			*
// Return   : integer - the zone which the dvIn's DPS is at	    	*
//*******************************************************************
define_function integer getFeedbackZone(dev dvIn)
{
    stack_var integer zone
    for (zone = 1; zone <= LENGTH_ARRAY(vdvDev); zone++)
    {
		if (vdvDev[zone] == dvIn)
		{
			RETURN zone;
			break;
		}
    }
    
    RETURN 0;
}

DEFINE_PROGRAM
for (nZoneLoop = 1; nZoneLoop <= MAX_ZONE; nZoneLoop++)
    [dvTPMain, nZoneBtns[nZoneLoop]] = (nZoneLoop == nCurrentZone)

for (nPageLoop = 1; nPageLoop <= LENGTH_ARRAY(nSubNavBtns); nPageLoop++)
    [dvTPMain, nSubNavBtns[nPageLoop]] = (nPageLoop == nActivePage)

#END_IF // __MAIN_INCLUDE__