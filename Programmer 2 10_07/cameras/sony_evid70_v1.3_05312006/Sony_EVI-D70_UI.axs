MODULE_NAME='Sony_EVI-D70_UI' (DEV vdvDEV, DEV dvTP)
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 01/30/2003 AT: 08:51:36               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 09/02/2003 AT: 13:33:38         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 08/25/2003                              *)
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
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE CHAR sVERSION[5]        // STORES NETLINX COMM MODULE VERSION NUMBER
VOLATILE CHAR cEXPOSURE = '0'    // STORES THE CURRENT EXPOSURE SETTING FOR THE ACTIVE CAMERA
VOLATILE CHAR cFOCUS = '0'       // STORES THE CURRENT FOCUS SETTING FOR THE ACTIVE CAMERA
VOLATILE CHAR cWHITEBAL = '0'    // STORES THE CURRENT WHITE BALANCE SETTING FOR THE ACTIVE CAMERA
VOLATILE CHAR cIRIS = '0'        // STORES THE CURRENT IRIS SETTING FOR THE ACTIVE CAMERA
VOLATILE INTEGER nDEBUG = 0      // TRACKS THE ON/OFF STATE OF DEBUG MSGS SENT TO THE TELNET SESSION
VOLATILE INTEGER nDEVICE_SCALE=0 // TRACKS WHICH SCALING RANGE WE ARE USING
VOLATILE INTEGER nCURRENT_CAM=0  // TRACKS THE CURRENTLY SELECTED CAMERA
VOLATILE INTEGER nINIT_FLAG = 0  // TRACKS WHEN WE NEED TO QUERY FOR CAMERA INFORMATION
VOLATILE INTEGER nGAIN = 0       // STORES THE GAIN VALUE FOR THE CURRENTLY ACTIVE CAMERA
VOLATILE INTEGER nIRIS = 0       // STORES THE IRIS VALUE FOR THE CURRENTLY ACTIVE CAMERA
VOLATILE INTEGER nSHUTTER = 0    // STORES THE SHUTTER POSITION VALUE FOR THE CURRENTLY ACTIVE CAMERA
VOLATILE SLONG slPAN = 0         // STORES THE PAN POSITION VALUE FOR THE CURRENTLY ACTIVE CAMERA
VOLATILE SLONG slTILT = 0        // STORES THE TILT POSITION VALUE FOR THE CURRENTLY ACTIVE CAMERA
VOLATILE LONG lFOCUS = 0         // STORES THE FOCUS VALUE FOR THE CURRENTLY ACTIVE CAMERA
VOLATILE LONG lZOOM = 0          // STORES THE ZOOM POSITION VALUE FOR THE CURRENTLY ACTIVE CAMERA
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

DATA_EVENT[vdvDEV]
{
    STRING:
    {
        STACK_VAR CHAR cCMD[35]
        
        IF(nDEBUG) { SEND_STRING 0, "'UI RECEIVED FROM COMM: ',DATA.TEXT" }
        IF(FIND_STRING(DATA.TEXT, '=', 1)) { cCMD = REMOVE_STRING(DATA.TEXT, '=', 1) }        
        ELSE { cCMD = DATA.TEXT }
        SWITCH(cCMD)
        {
            // FIND MATCHING STRING AND PARSE REST OF MESSAGE. PROVIDE FEEDBACK TO THE 
            // TOUCH PANEL.
            CASE 'BACKLIGHT=':
            {
                STACK_VAR INTEGER nCAM, nLIGHT
                
                nCAM = ATOI(DATA.TEXT)
                REMOVE_STRING(DATA.TEXT, ':', 1)
                nLIGHT = ATOI(DATA.TEXT)
                IF (nCAM == nCURRENT_CAM) { [dvTP, 54] = nLIGHT }
            }
            CASE 'DEBUG=': { nDEBUG = ATOI(DATA.TEXT) }
            CASE 'DEVICE_SCALE=': { nDEVICE_SCALE = ATOI(DATA.TEXT) }
            CASE 'ERRORM=': { SEND_STRING 0, "'ERROR=',DATA.TEXT" }
            CASE 'EXPOSURE=':
            {
                STACK_VAR INTEGER nCAM
                
                nCAM = ATOI(DATA.TEXT)
                IF (nCAM == nCURRENT_CAM)
                {
                    REMOVE_STRING(DATA.TEXT, ':', 1)
                    cEXPOSURE = DATA.TEXT[1]
                }
            }
            CASE 'FOCUS=':
            {
                STACK_VAR INTEGER nCAM
                
                nCAM = ATOI(DATA.TEXT)
                IF (nCAM == nCURRENT_CAM)
                {
                    REMOVE_STRING(DATA.TEXT, ':', 1)
                    SWITCH(DATA.TEXT)
                    {
                        CASE 'AUTO': { cFOCUS = 'A' }
                        CASE 'MAN': { cFOCUS = 'M' }
                        DEFAULT : { lFOCUS = ATOI(DATA.TEXT) }
                    }
                }
            }
            CASE 'GAIN=':
            {
                STACK_VAR INTEGER nCAM
                
                nCAM = ATOI(DATA.TEXT)
                IF (nCAM == nCURRENT_CAM)
                {
                    REMOVE_STRING(DATA.TEXT, ':', 1)
                    nGAIN = ATOI(DATA.TEXT)
                }
            }
            CASE 'IRIS=':
            {
                STACK_VAR INTEGER nCAM
                
                nCAM = ATOI(DATA.TEXT)
                IF (nCAM == nCURRENT_CAM)
                {
                    REMOVE_STRING(DATA.TEXT, ':', 1)
                    SWITCH(DATA.TEXT)
                    {
                        CASE 'AUTO': { cIRIS = 'A' }
                        CASE 'MAN': { cIRIS = 'M' }
                        DEFAULT : { nIRIS = ATOI(DATA.TEXT) }
                    }
                }
            }
            CASE 'OSD=':
            {
                STACK_VAR INTEGER nCAM, nOSD
                
                nCAM = ATOI(DATA.TEXT)
                REMOVE_STRING(DATA.TEXT, ':', 1)
                nOSD = ATOI(DATA.TEXT)
                IF (nCAM == nCURRENT_CAM) { [dvTP, 55] = nOSD }
            }
            CASE 'PAN=':
            {
                STACK_VAR INTEGER nCAM
                
                nCAM = ATOI(DATA.TEXT)
                IF (nCAM == nCURRENT_CAM)
                {
                    REMOVE_STRING(DATA.TEXT, ':', 1)
                    slPAN = ATOI(DATA.TEXT)
                }
            }
            CASE 'POWER=':
            {
                STACK_VAR INTEGER nCAM
                
                nCAM = ATOI(DATA.TEXT)
                REMOVE_STRING(DATA.TEXT, ':', 1)
                IF (nCAM == nCURRENT_CAM AND DATA.TEXT == '1')
                {
                    ON[dvTP, 5]
                    IF (nINIT_FLAG)
                    {
                        WAIT 90         // IF CAMERA NEEDS TO INITIALIZE, THEN NO COMMANDS ACCEPTED UNTIL INIT FINISHED
                        {
                            SEND_COMMAND vdvDEV,"'BACKLIGHT?',ITOA(nCURRENT_CAM)"
                            SEND_COMMAND vdvDEV,"'EXPOSURE?',ITOA(nCURRENT_CAM)"
                            SEND_COMMAND vdvDEV,"'FOCUS?',ITOA(nCURRENT_CAM)"
                            SEND_COMMAND vdvDEV,"'IRIS?',ITOA(nCURRENT_CAM)"
                            SEND_COMMAND vdvDEV,"'OSD?',ITOA(nCURRENT_CAM)"
                            SEND_COMMAND vdvDEV,"'WHITEBAL?',ITOA(nCURRENT_CAM)"
                            OFF[nINIT_FLAG]
                        }
                    }
                }
                ELSE IF (nCAM == nCURRENT_CAM AND DATA.TEXT == '0') { OFF[dvTP, 5] }
            }
            CASE 'SHUTTER=':
            {
                STACK_VAR INTEGER nCAM
                
                nCAM = ATOI(DATA.TEXT)
                IF (nCAM == nCURRENT_CAM)
                {
                    REMOVE_STRING(DATA.TEXT, ':', 1)
                    nSHUTTER = ATOI(DATA.TEXT)
                }
            }
            CASE 'TILT=':
            {
                STACK_VAR INTEGER nCAM
                
                nCAM = ATOI(DATA.TEXT)
                IF (nCAM == nCURRENT_CAM)
                {
                    REMOVE_STRING(DATA.TEXT, ':', 1)
                    slTILT = ATOI(DATA.TEXT)
                }
            }
            CASE 'VERSION=': { sVERSION = DATA.TEXT }
            CASE 'WHITEBAL=':
            {
                STACK_VAR INTEGER nCAM
                
                nCAM = ATOI(DATA.TEXT)
                IF (nCAM == nCURRENT_CAM)
                {
                    REMOVE_STRING(DATA.TEXT, ':', 1)
                    cWHITEBAL = DATA.TEXT[1]
                }
            }
            CASE 'ZOOM=':
            {
                STACK_VAR INTEGER nCAM
                
                nCAM = ATOI(DATA.TEXT)
                IF (nCAM == nCURRENT_CAM)
                {
                    REMOVE_STRING(DATA.TEXT, ':', 1)
                    lZOOM = ATOI(DATA.TEXT)
                }
            }
        }// END SWITCH(cCMD)
    }// END STRING
}// END DATA_EVENT[vdvDEV]

DATA_EVENT[dvTP]
{
    ONLINE:
    {
        SEND_COMMAND dvTP, "'@PPX'"
        SEND_COMMAND dvTP, "'@TXT', 1, ''"
    }
}

// TO INCREASE THE NUMBER OF CAMERAS SUPPORTED, ADD MORE BUTTONS HERE
// CODE TO SWITCH BETWEEN CAMERA VIEW SCREENS IS NOT INCLUDED
BUTTON_EVENT[dvTP, 1]       // CAMERA 1 BUTTON
BUTTON_EVENT[dvTP, 2]       // CAMERA 2 BUTTON
BUTTON_EVENT[dvTP, 3]       // CAMERA 3 BUTTON
BUTTON_EVENT[dvTP, 4]       // CAMERA 4 BUTTON
{
    PUSH:
    {
        STACK_VAR INTEGER N
        
        FOR(N = 1; N < 6; N++) { OFF[dvTP, N] }             // TURN OFF POWER BUTTON TOO
        nCURRENT_CAM = BUTTON.INPUT.CHANNEL
        SEND_COMMAND dvTP, "'@TXT', 1, ITOA(nCURRENT_CAM)"
        ON[nINIT_FLAG]
        SEND_COMMAND vdvDEV, "'POWER?',ITOA(nCURRENT_CAM)"
    }
}
BUTTON_EVENT[dvTP, 5]       // POWER BUTTON
{
    PUSH:
    {
        IF ([BUTTON.INPUT]) { SEND_COMMAND vdvDEV, "'POWER=',ITOA(nCURRENT_CAM),':0'" }
        ELSE { SEND_COMMAND vdvDEV, "'POWER=',ITOA(nCURRENT_CAM),':1'" }
    }
}
BUTTON_EVENT[dvTP, 6]       // PAN LEFT BUTTON
BUTTON_EVENT[dvTP, 7]       // PAN RIGHT BUTTON
{
    PUSH:
    {
        TO[BUTTON.INPUT]
        SWITCH(BUTTON.INPUT.CHANNEL)
        {
            CASE 6: { SEND_COMMAND vdvDEV, "'PANTILT=',ITOA(nCURRENT_CAM),':7'" }
            CASE 7: { SEND_COMMAND vdvDEV, "'PANTILT=',ITOA(nCURRENT_CAM),':3'" }
        }
    }
    RELEASE: { SEND_COMMAND vdvDEV, "'PANTILT=',ITOA(nCURRENT_CAM),':S'" }
}
BUTTON_EVENT[dvTP, 9]       // TILT DOWN BUTTON
BUTTON_EVENT[dvTP, 10]      // TILT UP BUTTON
{
    PUSH:
    {
        TO[BUTTON.INPUT]
        SWITCH(BUTTON.INPUT.CHANNEL)
        {
            CASE 9: { SEND_COMMAND vdvDEV, "'PANTILT=',ITOA(nCURRENT_CAM),':1'" }
            CASE 10:{ SEND_COMMAND vdvDEV, "'PANTILT=',ITOA(nCURRENT_CAM),':5'" }
        }
    }
    RELEASE: { SEND_COMMAND vdvDEV, "'PANTILT=',ITOA(nCURRENT_CAM),':S'" }
}
BUTTON_EVENT[dvTP, 12]      // WIDE ZOOM BUTTON
BUTTON_EVENT[dvTP, 13]      // TELE ZOOM BUTTON
{
    PUSH:
    {
        TO[BUTTON.INPUT]
        SWITCH(BUTTON.INPUT.CHANNEL)
        {
            CASE 12: { SEND_COMMAND vdvDEV, "'ZOOM=',ITOA(nCURRENT_CAM),':-'" }
            CASE 13: { SEND_COMMAND vdvDEV, "'ZOOM=',ITOA(nCURRENT_CAM),':+'" }
        }
    }
    RELEASE: { SEND_COMMAND vdvDEV, "'ZOOM=',ITOA(nCURRENT_CAM),':S'" }
}
BUTTON_EVENT[dvTP, 15]      // AUTO EXPOSURE BUTTON
BUTTON_EVENT[dvTP, 16]      // MANUAL EXPOSURE BUTTON
BUTTON_EVENT[dvTP, 17]      // SHUTTER PRIORITY BUTTON
BUTTON_EVENT[dvTP, 18]      // IRIS PRIORITY BUTTON
BUTTON_EVENT[dvTP, 19]      // BRIGHT MODE BUTTON
{
    PUSH:
    {
        PULSE[BUTTON.INPUT]
        SWITCH(BUTTON.INPUT.CHANNEL)
        {
            CASE 15: { SEND_COMMAND vdvDEV, "'EXPOSURE=',ITOA(nCURRENT_CAM),':A'" }
            CASE 16: { SEND_COMMAND vdvDEV, "'EXPOSURE=',ITOA(nCURRENT_CAM),':M'" }
            CASE 17: { SEND_COMMAND vdvDEV, "'EXPOSURE=',ITOA(nCURRENT_CAM),':S'" }
            CASE 18: { SEND_COMMAND vdvDEV, "'EXPOSURE=',ITOA(nCURRENT_CAM),':I'" }
            CASE 19: { SEND_COMMAND vdvDEV, "'EXPOSURE=',ITOA(nCURRENT_CAM),':B'" }
        }
    }
}
BUTTON_EVENT[dvTP, 20]      // BRIGHT MODE DOWN BUTTON
BUTTON_EVENT[dvTP, 21]      // BRIGHT MODE UP BUTTON
{
    PUSH:
    {
        IF ([dvTP, 19])     // BRIGHT MODE MUST BE ENABLED FIRST
        {
            TO[BUTTON.INPUT]
            SWITCH(BUTTON.INPUT.CHANNEL)
            {
                CASE 20: { SEND_COMMAND vdvDEV, "'EXPOSURE=',ITOA(nCURRENT_CAM),':B:-'" }
                CASE 21: { SEND_COMMAND vdvDEV, "'EXPOSURE=',ITOA(nCURRENT_CAM),':B:+'" }
            }
        }
        ELSE { SEND_COMMAND dvTP, "'ABEEP'" }
    }
    HOLD[5, REPEAT]:
    {
        IF ([dvTP, 19])     // BRIGHT MODE MUST BE ENABLED FIRST
        {
            SWITCH(BUTTON.INPUT.CHANNEL)
            {
                CASE 20: { SEND_COMMAND vdvDEV, "'EXPOSURE=',ITOA(nCURRENT_CAM),':B:-'" }
                CASE 21: { SEND_COMMAND vdvDEV, "'EXPOSURE=',ITOA(nCURRENT_CAM),':B:+'" }
            }
        }
    }
}
BUTTON_EVENT[dvTP, 22]      // BRIGHT MODE STOP BUTTON
{
    PUSH:
    {
        IF ([dvTP, 19])
        {
            PULSE[BUTTON.INPUT]
            SEND_COMMAND vdvDEV, "'EXPOSURE=',ITOA(nCURRENT_CAM),':B:R'"
        }
        ELSE { SEND_COMMAND dvTP, "'ABEEP'" }
    }
}

BUTTON_EVENT[dvTP, 24]      // AUTO FOCUS BUTTON
BUTTON_EVENT[dvTP, 25]      // MANUAL FOCUS BUTTON
{
    PUSH:
    {
        PULSE[BUTTON.INPUT]
        IF (BUTTON.INPUT.CHANNEL == 24) { SEND_COMMAND vdvDEV, "'FOCUS=',ITOA(nCURRENT_CAM),':AUTO'" }
        ELSE { SEND_COMMAND vdvDEV, "'FOCUS=',ITOA(nCURRENT_CAM),':MAN'" }
    }
}
BUTTON_EVENT[dvTP, 26]      // FOCUS DECREMENT BUTTON
BUTTON_EVENT[dvTP, 27]      // FOCUS INCREMENT BUTTON
{
    PUSH:
    {
        IF ([dvTP, 25])
        {
            TO[BUTTON.INPUT]
            SWITCH(BUTTON.INPUT.CHANNEL)
            {
                CASE 26: { SEND_COMMAND vdvDEV, "'FOCUS=',ITOA(nCURRENT_CAM),':-'" }
                CASE 27: { SEND_COMMAND vdvDEV, "'FOCUS=',ITOA(nCURRENT_CAM),':+'" }
            }
        }
        ELSE { SEND_COMMAND dvTP, "'ABEEP'" }
    }
    RELEASE:
    {
        IF ([dvTP, 25]) { SEND_COMMAND vdvDEV, "'FOCUS=',ITOA(nCURRENT_CAM),':S'" }
    }
}
BUTTON_EVENT[dvTP, 29]      // GAIN DECREMENT BUTTON
BUTTON_EVENT[dvTP, 30]      // GAIN INCREMENT BUTTON
{
    PUSH:
    {
        IF ([dvTP, 16])     // ONLY VALID WHEN EXPOSURE IS SET TO MANUAL
        {
            TO[BUTTON.INPUT]
            SWITCH(BUTTON.INPUT.CHANNEL)
            {
                CASE 29: { SEND_COMMAND vdvDEV, "'GAIN=',ITOA(nCURRENT_CAM),':-'" }
                CASE 30: { SEND_COMMAND vdvDEV, "'GAIN=',ITOA(nCURRENT_CAM),':+'" }
            }
        }
        ELSE { SEND_COMMAND dvTP, "'ABEEP'" }
    }
    HOLD[5, REPEAT]:
    {
        IF ([dvTP, 16])     // ONLY VALID WHEN EXPOSURE IS SET TO MANUAL
        {
            SWITCH(BUTTON.INPUT.CHANNEL)
            {
                CASE 29: { SEND_COMMAND vdvDEV, "'GAIN=',ITOA(nCURRENT_CAM),':-'" }
                CASE 30: { SEND_COMMAND vdvDEV, "'GAIN=',ITOA(nCURRENT_CAM),':+'" }
            }
        }
    }
}
BUTTON_EVENT[dvTP, 31]      // GAIN RESET BUTTON
{
    PUSH:
    {
        IF ([dvTP, 16])     // ONLY VALID WHEN EXPOSURE IS SET TO MANUAL
        {
            PULSE[BUTTON.INPUT]
            SEND_COMMAND vdvDEV, "'GAIN=',ITOA(nCURRENT_CAM),':R'"
        }
        ELSE { SEND_COMMAND dvTP, "'ABEEP'" }
    }
}

BUTTON_EVENT[dvTP, 32]      // IRIS AUTO BUTTON
BUTTON_EVENT[dvTP, 33]      // IRIS MANUAL BUTTON
BUTTON_EVENT[dvTP, 34]      // IRIS RESET BUTTON
{
    PUSH:
    {
        IF ([dvTP, 16] OR [dvTP, 18])       // ONLY VALID WHEN EXPOSURE IS SET TO MANUAL OR IRIS PRIORITY
        {
            PULSE[BUTTON.INPUT]
            SWITCH(BUTTON.INPUT.CHANNEL)
            {
                CASE 32: { SEND_COMMAND vdvDEV, "'IRIS=',ITOA(nCURRENT_CAM),':AUTO'" }
                CASE 33: { SEND_COMMAND vdvDEV, "'IRIS=',ITOA(nCURRENT_CAM),':MAN'" }
                CASE 34: { SEND_COMMAND vdvDEV, "'IRIS=',ITOA(nCURRENT_CAM),':RESET'" }
            }
        }
        ELSE { SEND_COMMAND dvTP, "'ABEEP'" }
    }
}
BUTTON_EVENT[dvTP, 35]      // IRIS DECREMENT BUTTON
BUTTON_EVENT[dvTP, 36]      // IRIS INCREMENT BUTTON
{
    PUSH:
    {
        IF ([dvTP, 16] OR [dvTP, 18])       // ONLY VALID WHEN EXPOSURE IS SET TO MANUAL OR IRIS PRIORITY
        {
            TO[BUTTON.INPUT]
            SWITCH(BUTTON.INPUT.CHANNEL)
            {
                CASE 35: { SEND_COMMAND vdvDEV, "'IRIS=',ITOA(nCURRENT_CAM),':-'" }
                CASE 36: { SEND_COMMAND vdvDEV, "'IRIS=',ITOA(nCURRENT_CAM),':+'" }
            }
        }
        ELSE { SEND_COMMAND dvTP, "'ABEEP'" }
    }
}
BUTTON_EVENT[dvTP, 37]      // SHUTTER DECREMENT BUTTON
BUTTON_EVENT[dvTP, 38]      // SHUTTER INCREMENT BUTTON
{
    PUSH:
    {
        IF([dvTP, 16] OR [dvTP, 17])        // ONLY VALID WHEN EXPOSURE IS SET TO MANUAL OR SHUTTER PRIORITY
        {
            TO[BUTTON.INPUT]
            SWITCH(BUTTON.INPUT.CHANNEL)
            {
                CASE 37: { SEND_COMMAND vdvDEV, "'SHUTTER=',ITOA(nCURRENT_CAM),':-'" }
                CASE 38: { SEND_COMMAND vdvDEV, "'SHUTTER=',ITOA(nCURRENT_CAM),':+'" }
            }
        }
        ELSE { SEND_COMMAND dvTP, "'ABEEP'" }
    }
    HOLD[5, REPEAT]:
    {
        IF ([dvTP, 16] OR [dvTP, 17])       // ONLY VALID WHEN EXPOSURE IS SET TO MANUAL OR SHUTTER PRIORITY
        {
            SWITCH(BUTTON.INPUT.CHANNEL)
            {
                CASE 37: { SEND_COMMAND vdvDEV, "'SHUTTER=',ITOA(nCURRENT_CAM),':-'" }
                CASE 38: { SEND_COMMAND vdvDEV, "'SHUTTER=',ITOA(nCURRENT_CAM),':+'" }
            }
        }
        ELSE { SEND_COMMAND dvTP, "'ABEEP'" }
    }
}
BUTTON_EVENT[dvTP, 39]      // SHUTTER RESET BUTTON
{
    PUSH:
    {
        IF ([dvTP, 16] OR [dvTP, 17])       // ONLY VALID WHEN EXPOSURE IS SET TO MANUAL OR SHUTTER PRIORITY
        {
            PULSE[BUTTON.INPUT]
            SEND_COMMAND vdvDEV, "'SHUTTER=',ITOA(nCURRENT_CAM),':R'"
        }
        ELSE { SEND_COMMAND dvTP, "'ABEEP'" }
    }
}

BUTTON_EVENT[dvTP, 51]      // WHITE BALANCE AUTO BUTTON
BUTTON_EVENT[dvTP, 52]      // WHITE BALANCE INDOOR BUTTON
BUTTON_EVENT[dvTP, 53]      // WHITE BALANCE OUTDOOR BUTTON
{
    PUSH:
    {
        PULSE[BUTTON.INPUT]
        SWITCH(BUTTON.INPUT.CHANNEL)
        {
            CASE 51: { SEND_COMMAND vdvDEV, "'WHITEBAL=',ITOA(nCURRENT_CAM),':AUTO'" }
            CASE 52: { SEND_COMMAND vdvDEV, "'WHITEBAL=',ITOA(nCURRENT_CAM),':IN'" }
            CASE 53: { SEND_COMMAND vdvDEV, "'WHITEBAL=',ITOA(nCURRENT_CAM),':OUT'" }
        }
    }
}
BUTTON_EVENT[dvTP, 54]      // BACKLIGHT TOGGLE BUTTON
{
    PUSH:
    {
        IF ([BUTTON.INPUT]) { SEND_COMMAND vdvDEV, "'BACKLIGHT=',ITOA(nCURRENT_CAM),':0'" }
        ELSE { SEND_COMMAND vdvDEV, "'BACKLIGHT=',ITOA(nCURRENT_CAM),':1'" }
    }
}
BUTTON_EVENT[dvTP, 55]      // OSD TOGGLE BUTTON
{
    PUSH:
    {
        IF ([BUTTON.INPUT]) { SEND_COMMAND vdvDEV, "'OSD=',ITOA(nCURRENT_CAM),':0'" }
        ELSE { SEND_COMMAND vdvDEV, "'OSD=',ITOA(nCURRENT_CAM),':1'" }
    }
}
BUTTON_EVENT[dvTP, 56]      // REMOTE TOGGLE BUTTON
{
    PUSH:
    {
        PULSE[BUTTON.INPUT]
        IF ([BUTTON.INPUT]) { SEND_COMMAND vdvDEV, "'REMOTE=',ITOA(nCURRENT_CAM),':0'" }
        ELSE { SEND_COMMAND vdvDEV, "'REMOTE=',ITOA(nCURRENT_CAM),':1'" }
    }
}
BUTTON_EVENT[dvTP, 59]      // SET PRESET BUTTON
BUTTON_EVENT[dvTP, 60]      // RECALL PRESET BUTTON
{
    PUSH:
    {
        OFF[dvTP, 59]
        OFF[dvTP, 60]
        ON[BUTTON.INPUT]
    }
}
BUTTON_EVENT[dvTP, 61]      // PRESET 1 BUTTON
BUTTON_EVENT[dvTP, 62]      // PRESET 2 BUTTON
BUTTON_EVENT[dvTP, 63]      // PRESET 3 BUTTON
BUTTON_EVENT[dvTP, 64]      // PRESET 4 BUTTON
BUTTON_EVENT[dvTP, 65]      // PRESET 5 BUTTON
BUTTON_EVENT[dvTP, 66]      // PRESET 6 BUTTON
{
    PUSH:
    {
        STACK_VAR INTEGER N
        
        FOR(N = 61; N < 67; N++) { OFF[dvTP, N] }
        PULSE[BUTTON.INPUT]
        IF ([dvTP, 59]) { SEND_COMMAND vdvDEV, "'SAVE=',ITOA(nCURRENT_CAM),':',ITOA(BUTTON.INPUT.CHANNEL - 60)" }
        ELSE IF ([dvTP, 60]) { SEND_COMMAND vdvDEV, "'RECALL=',ITOA(nCURRENT_CAM),':',ITOA(BUTTON.INPUT.CHANNEL - 60)" }
        FOR(N = 59; N < 67; N++) { OFF[dvTP, N] }
    }
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

[dvTP, 1] = (nCURRENT_CAM == 1)         // CAMERA 1 ACTIVE
[dvTP, 2] = (nCURRENT_CAM == 2)         // CAMERA 2 ACTIVE
[dvTP, 3] = (nCURRENT_CAM == 3)         // CAMERA 3 ACTIVE
[dvTP, 4] = (nCURRENT_CAM == 4)         // CAMERA 4 ACTIVE

[dvTP, 15] = (cEXPOSURE == 'A')         // AUTO EXPOSURE
[dvTP, 16] = (cEXPOSURE == 'M')         // MANUAL EXPOSURE
[dvTP, 17] = (cEXPOSURE == 'S')         // SHUTTER PRIORITY
[dvTP, 18] = (cEXPOSURE == 'I')         // IRIS PRIORITY
[dvTP, 19] = (cEXPOSURE == 'B')         // BRIGHT MODE

[dvTP, 24] = (cFOCUS == 'A')            // AUTO FOCUS
[dvTP, 25] = (cFOCUS == 'M')            // MANUAL FOCUS

[dvTP, 32] = (cIRIS == 'A')             // AUTO IRIS
[dvTP, 33] = (cIRIS == 'M')             // MANUAL IRIS

[dvTP, 51] = (cWHITEBAL == 'A')         // AUTO WHITE BALANCE
[dvTP, 52] = (cWHITEBAL == 'I')         // INDOOR WHITE BALANCE
[dvTP, 53] = (cWHITEBAL == 'O')         // OUTDOOR WHITE BALANCE
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)