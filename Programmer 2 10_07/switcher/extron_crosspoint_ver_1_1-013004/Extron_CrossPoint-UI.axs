MODULE_NAME='Extron_CrossPoint-UI' (DEV vdvDEVICE, DEV dvTPArray[], 
                                 INTEGER nSwitcherBtns[], INTEGER nWriteBtns[])
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 12/13/2002 AT: 14:17:53               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 01/07/2004 AT: 09:06:12         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 12/13/2002                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)

(***********************************************************)
(* System Type : Netlinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

    // level to switch 
    INTEGER ALL= 0 
    INTEGER VIDEO = 1
    INTEGER AUDIO = 2
    
    // boolean constants 
    INTEGER FALSE     =   0
    INTEGER TRUE      =   1
    
    // power states
    INTEGER POWER_ON    = 1
    INTEGER POWER_OFF   = 0 
    INTEGER POWER_UNKNOWN = 2
    
    // for variable nKeypadCommand 
    INTEGER INPUT_KEYPAD = 1
    INTEGER OUTPUT_KEYPAD = 2
    INTEGER PRESET_KEYPAD = 3
    INTEGER GAIN_KEYPAD = 4
    
    // constants representing button positions in the array
    INTEGER INPUT_BTN = 1
    INTEGER OUTPUT_BTN = 2
    INTEGER PRESET_BTN = 3
    INTEGER SET_GAIN_BTN = 4
    INTEGER BOTH_BTN = 5
    INTEGER AUDIO_BTN = 6
    INTEGER VIDEO_BTN = 7
    INTEGER CONNECT_BTN = 8 
    INTEGER STATUS_BTN = 9
    INTEGER RECALL_BTN = 10
    INTEGER SAVE_BTN = 11
    INTEGER GET_GAIN_BTN = 12
    INTEGER POS_NEG_BTN = 13
    INTEGER DEVICE_SCALE_BTN = 14 
    INTEGER POWER_OFF_BTN = 15
    INTEGER POWER_ON_BTN = 16
    
    // constants for default values
    INTEGER DEFAULT_INPUT = 1
    INTEGER DEFAULT_OUTPUT = 1
    INTEGER DEFAULT_PRESET = 1
    INTEGER DEFAULT_GAIN = 50 
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

    VOLATILE INTEGER bDebug = FALSE 
    VOLATILE INTEGER nPower = POWER_UNKNOWN 
    VOLATILE INTEGER bDeviceScale
    VOLATILE INTEGER bNegative = FALSE                      // indicate whether a negative
                                                            // gain value is being entered
    VOLATILE INTEGER nKeypadCommand                         // tracks why keypad is up
    // DEFAULT VALUES
    
    VOLATILE INTEGER nSelectedLevel = ALL                   // ALL, VIDEO, AUDIO
    VOLATILE INTEGER nSelectedInput = DEFAULT_INPUT         // 0 to Max inputs
    VOLATILE INTEGER nSelectedOutput = DEFAULT_OUTPUT       // 1 to max outputs
    VOLATILE INTEGER nSelectedPreset = DEFAULT_PRESET       // 1 to max presets
    VOLATILE INTEGER nSelectedGain = DEFAULT_GAIN           // should range from 0 to 100 
          
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

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                THE EVENTS GOES BELOW                    *)
(***********************************************************)
DEFINE_EVENT


BUTTON_EVENT[dvTPArray, nSwitcherBtns]
{
    PUSH:
    {
        STACK_VAR INTEGER nBtnIndex                           
        nBtnIndex = GET_LAST(nSwitcherBtns)
        PULSE [dvTPArray,nSwitcherBtns[nBtnIndex]]
        SWITCH (nBtnIndex)
        {
            CASE    INPUT_BTN:         // specify input value
            CASE    OUTPUT_BTN:        // specify output
            CASE    PRESET_BTN:        // specify preset
            CASE    SET_GAIN_BTN:      // set gain 
            {
                // shortcut = button indexes are defined the same as 
                // the keypad command values 
                nKeypadCommand = nBtnIndex 
                SEND_COMMAND dvTPArray,"'AKEYP'" // POPUP THE KEYPAD
            }
            CASE    BOTH_BTN:      // level = both
            { 
                nSelectedLevel = ALL
            }
            CASE   VIDEO_BTN:      // level = video
            { 
                nSelectedLevel = VIDEO
            }
            CASE    AUDIO_BTN:      // level = audio
            {
                nSelectedLevel = AUDIO 
            } 
            CASE   CONNECT_BTN:      // connect 
            {
                SEND_COMMAND vdvDEVICE,"'SWITCH=',ITOA(nSelectedLevel),':',ITOA(nSelectedInput),':',ITOA(nSelectedOutput)"
            }
            CASE   STATUS_BTN:      // status   OUTPUT only
            {
                SEND_COMMAND vdvDEVICE,"'SWITCH?O:',ITOA(nSelectedOutput)"
            }
            CASE   RECALL_BTN:      // recall 
            {
                SEND_COMMAND vdvDEVICE,"'RECALL=',ITOA(nSelectedPreset)"
            }
            CASE   SAVE_BTN:      // save
            {
                SEND_COMMAND vdvDEVICE,"'SAVE=',ITOA(nSelectedPreset)"
            } 
            CASE   GET_GAIN_BTN:      // get gain INPUT only       
            {
                SEND_COMMAND vdvDEVICE,"'GAIN?I',ITOA(nSelectedInput)"
            }
            CASE   POS_NEG_BTN:
            {
                bNegative = !bNegative 
            }
            CASE DEVICE_SCALE_BTN:
            {
                bDeviceScale = !bDeviceScale 
                SEND_COMMAND vdvDEVICE,"'DEVICESCALE=',ITOA(bDeviceScale)"
            }
            CASE POWER_OFF_BTN:
            {
                SEND_COMMAND vdvDEVICE,"'POWER=0'"
            }
            CASE POWER_ON_BTN:
            {
                SEND_COMMAND vdvDEVICE,"'POWER=1'"
            }
        }   // END OF - switch on button index
    }
}   // END OF - button event 
      

DATA_EVENT[dvTPArray]
{
    STRING:
    {
        STACK_VAR INTEGER nKeypadValue
        
        IF (FIND_STRING(DATA.TEXT,'KEYP',1))   
        {
           SEND_COMMAND dvTPArray,"'AKEYR'" // Remove the keypad 
           SEND_STRING 0,"'received keypad string ',DATA.TEXT"
           REMOVE_STRING(DATA.TEXT,'-',1)
           nKeypadValue = ATOI(DATA.TEXT)
           SWITCH (nKeypadCommand)
           {
                CASE INPUT_KEYPAD:
                {
                    nSelectedInput = nKeypadValue
                }
                CASE OUTPUT_KEYPAD:
                {
                    nSelectedOutput = nKeypadValue
                }
                CASE PRESET_KEYPAD:
                {
                    nSelectedPreset = nKeypadValue
                }
                CASE GAIN_KEYPAD:
                {
                    nSelectedGain = nKeypadValue
                    //
                    //  There's no 'execute' button when setting button, so 
                    //  send the command directly when the value is received
                    //
                    IF (bNegative)                      // append a negative sign
                        SEND_COMMAND vdvDEVICE,"'GAIN=I',ITOA(nSelectedInput),':-',ITOA(nSelectedGain)" 
                    ELSE      
                        SEND_COMMAND vdvDEVICE,"'GAIN=I',ITOA(nSelectedInput),':',ITOA(nSelectedGain)" 
                }
           }
           SEND_COMMAND dvTPArray,"'!T',nWriteBtns[nKeypadCommand],ITOA(nKeypadValue)"
           
        }
    }
}


DATA_EVENT[vdvDEVICE]
{
    ONLINE:
    {
        SEND_COMMAND dvTPArray,"'!T',nWriteBtns[1],itoa(nSelectedInput) "
        SEND_COMMAND dvTPArray,"'!T',nWriteBtns[2],itoa(nSelectedOutput)"
        SEND_COMMAND dvTPArray,"'!T',nWriteBtns[3],itoa(nSelectedPreset)"
        SEND_COMMAND dvTPArray,"'!T',nWriteBtns[4],itoa(nSelectedGain)"
    }
    STRING:
    {

        STACK_VAR CHAR cCMD[20], cVALUE
        STACK_VAR INTEGER nDEVICE, nVALUE
            
        IF (bDebug)
            SEND_STRING 0, "'UI RECEIVED ',DATA.TEXT" 
           
        IF(FIND_STRING(DATA.TEXT, '=', 1))
        {
            cCMD = REMOVE_STRING(DATA.TEXT, '=', 1)
        }
        ELSE
        {
            cCMD = DATA.TEXT
        }
        SWITCH(cCMD)
        {
            CASE 'DEBUG=':
            {
                bDebug = ATOI(DATA.TEXT)
            }
            CASE 'DEVICESCALE=':
            {
                bDeviceScale = ATOI(DATA.TEXT) 
            }
            CASE 'GAIN=':
            {
                SEND_COMMAND dvTPArray,"'!T',nWriteBtns[5],'GAIN=',DATA.TEXT"
            }
            CASE 'POWER=':
            {
                nPower = ATOI(DATA.TEXT)
            }
            CASE 'RECALL=':
            {
                SEND_COMMAND dvTPArray,"'!T',nWriteBtns[5],'RECALL=',DATA.TEXT"
            }
            CASE 'RECONFIG':
            {
                SEND_COMMAND dvTPArray,"'!T',nWriteBtns[5],'RECONFIG'"
            }
            CASE 'SAVE=':
            {
                SEND_COMMAND dvTPArray,"'!T',nWriteBtns[5],'SAVE=',DATA.TEXT"
            }
            CASE 'SWITCH=':
            {
                SEND_COMMAND dvTPArray,"'!T',nWriteBtns[5],'SWITCH=',DATA.TEXT"
            }
            CASE 'VERSION=':
            {
                SEND_COMMAND dvTPArray,"'!T',nWriteBtns[5],'VERSION=',DATA.TEXT"
            }
            DEFAULT:
            {
                SEND_COMMAND dvTPArray,"'!T',nWriteBtns[5],'Unexpected response received: ',cCMD,DATA.TEXT"
            } 
        }//END SWITCH(cCMD)
    }//END STRING
}//END DATA_EVENT[vdvDEVICE]
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
[dvTPArray,nSwitcherBtns[BOTH_BTN]] = (nSelectedLevel = ALL) 
[dvTPArray,nSwitcherBtns[VIDEO_BTN]] = (nSelectedLevel = VIDEO) 
[dvTPArray,nSwitcherBtns[AUDIO_BTN]] = (nSelectedLevel = AUDIO) 
[dvTPArray,nSwitcherBtns[POS_NEG_BTN]] = (bNegative) 
[dvTPArray,nSwitcherBtns[DEVICE_SCALE_BTN]] = (bDeviceScale) 
[dvTpArray,nSwitcherBtns[POWER_OFF_BTN]] = (nPower = POWER_OFF) 
[dvTpArray,nSwitcherBtns[POWER_ON_BTN]] = (nPower = POWER_ON) 

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

