MODULE_NAME='Kramer_VP-724DS_UI' (DEV vdvDEV, DEV dvTP, INTEGER nCHAN_BTN[], INTEGER nTXT_BTN[])
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 01/30/2003 AT: 08:51:36               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 12/08/2003 AT: 14:52:29         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 12/01/2003                              *)
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

VOLATILE CHAR sVERSION[5] = ''   // STORES NETLINX COMM MODULE VERSION NUMBER
VOLATILE CHAR cSIZE[4] = ''      // TRACKS THE CURRENTLY SELECTED PIP SIZE
VOLATILE INTEGER nDEBUG = 0      // TRACKS THE ON/OFF STATE OF DEBUG MSGS SENT TO THE TELNET SESSION
VOLATILE INTEGER nASPECT = 0     // STORES THE LAST SELECTED ASPECT RATIO
VOLATILE INTEGER nDISPLAY = 0    // STORES THE LAST SELECTED DISPLAY MODE
VOLATILE INTEGER nINPUT = 0      // TRACKS THE CURRENTLY SELECTED INPUT SOURCE
VOLATILE INTEGER nRESOLUTION = 0 // TRACKS THE CURRENTLY SELECTED OUTPUT RESOLUTION
VOLATILE INTEGER nVGA_RES = 0    // TRACKS THE CURRENTLY SELECTED VGA/DVI RESOLUTION
VOLATILE INTEGER nMODE = 0       // TRACKS THE CURRENT VIDEO MODE
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
            CASE 'ASPECT=': { nASPECT = ATOI(DATA.TEXT) }
            CASE 'DEBUG=': { nDEBUG = ATOI(DATA.TEXT) }
            CASE 'DISPLAY_MODE=': { nDISPLAY = ATOI(DATA.TEXT) }
            CASE 'ERRORM=': { SEND_STRING 0, "'ERROR-',DATA.TEXT" }
            CASE 'FREEZE=': { [dvTP, nCHAN_BTN[36]] = ATOI(DATA.TEXT) }
            CASE 'INPUT=': { nINPUT = ATOI(DATA.TEXT) }
            CASE 'KEY_LOCK=': { [dvTP, nCHAN_BTN[37]] = ATOI(DATA.TEXT) }
            CASE 'MUTE=': { [dvTP, nCHAN_BTN[38]] = ATOI(DATA.TEXT) }
            CASE 'OUTPUT_RES=': { nRESOLUTION = ATOI(DATA.TEXT) }
            CASE 'PIP=': { [dvTP, nCHAN_BTN[69]] = ATOI(DATA.TEXT) }
            CASE 'PIP_SIZE=': { cSIZE = DATA.TEXT }
            CASE 'VERSION=': { sVERSION = DATA.TEXT }
            CASE 'VGA_RES=': { nVGA_RES = ATOI(DATA.TEXT) }
            CASE 'VIDEOMODE=': { nMODE = ATOI(DATA.TEXT) }
        }// END SWITCH(cCMD)
    }// END STRING
}// END DATA_EVENT[vdvDEV]

DATA_EVENT[dvTP]
{
    ONLINE: 
    {
        SEND_COMMAND dvTP, "'@PPX'"
    }
}// END DATA_EVENT[dvTP]

BUTTON_EVENT[dvTP, nCHAN_BTN]
{
    PUSH:
    {
        STACK_VAR INTEGER nBTN
        
        nBTN = GET_LAST(nCHAN_BTN)
        SELECT
        {
            ACTIVE(nBTN >= 11 AND nBTN <= 15):
            {
                SEND_COMMAND vdvDEV, "'ASPECT=',ITOA(nBTN-10)"
                PULSE[BUTTON.INPUT]
            }
            ACTIVE(nBTN == 17 OR nBTN == 18):
            {
                PULSE[BUTTON.INPUT]
                IF (nBTN == 17) { SEND_COMMAND vdvDEV, 'BRIGHTNESS=T' }
                ELSE { SEND_COMMAND vdvDEV, 'CONTRAST=T' }
            }
            ACTIVE(nBTN >= 21 AND nBTN <= 26):
            {
                PULSE[BUTTON.INPUT]
                SWITCH(nBTN)
                {
                    CASE 21: { SEND_COMMAND vdvDEV, 'CURSOR=+' }
                    CASE 22: { SEND_COMMAND vdvDEV, 'CURSOR=<' }
                    CASE 23: { SEND_COMMAND vdvDEV, 'CURSOR=-' }
                    CASE 24: { SEND_COMMAND vdvDEV, 'CURSOR=>' }
                    CASE 25: { SEND_COMMAND vdvDEV, 'MENUSELECT' }
                    CASE 26: { SEND_COMMAND vdvDEV, 'MENU' }
                }
            }
            ACTIVE(nBTN >= 28 AND nBTN <= 33):
            {
                PULSE[BUTTON.INPUT]
                SEND_COMMAND vdvDEV, "'DISPLAY_MODE=',ITOA(nBTN - 27)"
            }
            ACTIVE(nBTN == 36): { SEND_COMMAND vdvDEV, 'FREEZE=T' }
            ACTIVE(nBTN == 37): { SEND_COMMAND vdvDEV, 'KEY_LOCK=T' }
            ACTIVE(nBTN == 38): { SEND_COMMAND vdvDEV, 'MUTE=T' }
            ACTIVE(nBTN == 39):
            {
                PULSE[BUTTON.INPUT]
                SEND_COMMAND vdvDEV, 'RESET'
            }
            ACTIVE(nBTN == 40):
            {
                PULSE[BUTTON.INPUT]
                SEND_COMMAND vdvDEV, 'STATUS=T'
            }
            ACTIVE(nBTN >= 43 AND nBTN <= 50):
            {
                PULSE[BUTTON.INPUT]
                SEND_COMMAND vdvDEV, "'INPUT=',ITOA(nBTN - 41)"
            }
            ACTIVE(nBTN >= 53 AND nBTN <= 65):
            {
                PULSE[BUTTON.INPUT]
                SEND_COMMAND vdvDEV, "'OUTPUT_RES=',ITOA(nBTN - 52)"
            }
            ACTIVE(nBTN == 66):
            {
                PULSE[BUTTON.INPUT]
                SEND_COMMAND vdvDEV, "'OUTPUT_RES=17'"
            }
            ACTIVE(nBTN == 69): { SEND_COMMAND vdvDEV,'PIP=T' }
            ACTIVE(nBTN >= 70 AND nBTN <= 74):
            {
                PULSE[BUTTON.INPUT]
                SWITCH(nBTN)
                {
                    CASE 70: { SEND_COMMAND vdvDEV, 'PIP_SIZE=1/25' }
                    CASE 71: { SEND_COMMAND vdvDEV, 'PIP_SIZE=1/16' }
                    CASE 72: { SEND_COMMAND vdvDEV, 'PIP_SIZE=1/9' }
                    CASE 73: { SEND_COMMAND vdvDEV, 'PIP_SIZE=1/4' }
                    CASE 74: { SEND_COMMAND vdvDEV, 'PIP_SIZE=1/2' }
                }
            }
            ACTIVE(nBTN == 75): { SEND_COMMAND vdvDEV, 'SWAP' }
            ACTIVE(nBTN == 78): { SEND_COMMAND vdvDEV, 'VOLUME=-' }
            ACTIVE(nBTN == 79): { SEND_COMMAND vdvDEV, 'VOLUME=+' }
            ACTIVE(nBTN == 82): { SEND_COMMAND vdvDEV, 'ZOOM=-' }
            ACTIVE(nBTN == 83): { SEND_COMMAND vdvDEV, 'ZOOM=+' }
        }// END SWITCH(nBTN)
    }// END PUSH
}// END BUTTON_EVENT[dvTP, nCHAN_BTN]
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

[dvTP, nCHAN_BTN[11]] = (nASPECT == 1)         // NORMAL ASPECT RATIO
[dvTP, nCHAN_BTN[12]] = (nASPECT == 2)         // WIDE SCREEN ASPECT RATIO
[dvTP, nCHAN_BTN[14]] = (nASPECT == 4)         // 4:3 ASPECT RATIO
[dvTP, nCHAN_BTN[15]] = (nASPECT == 5)         // PAN & SCAN ASPECT RATIO

[dvTP, nCHAN_BTN[28]] = (nDISPLAY == 1)         // NORMAL DISPLAY MODE
[dvTP, nCHAN_BTN[29]] = (nDISPLAY == 2)         // PRESENTATION DISPLAY MODE
[dvTP, nCHAN_BTN[30]] = (nDISPLAY == 3)         // CINEMA DISPLAY MODE
[dvTP, nCHAN_BTN[31]] = (nDISPLAY == 4)         // NATURE DISPLAY MODE
[dvTP, nCHAN_BTN[32]] = (nDISPLAY == 5)         // USER 1 DISPLAY MODE
[dvTP, nCHAN_BTN[33]] = (nDISPLAY == 6)         // USER 2 DISPLAY MODE

[dvTP, nCHAN_BTN[43]] = (nINPUT == 2)           // S-VIDEO 1 INPUT
[dvTP, nCHAN_BTN[44]] = (nINPUT == 3)           // DVI INPUT
[dvTP, nCHAN_BTN[45]] = (nINPUT == 4)           // COMPOSITE 1 INPUT
[dvTP, nCHAN_BTN[46]] = (nINPUT == 5)           // COMPONENT INPUT
[dvTP, nCHAN_BTN[47]] = (nINPUT == 6)           // VGA 1 INPUT
[dvTP, nCHAN_BTN[48]] = (nINPUT == 7)           // VGA 2 INPUT
[dvTP, nCHAN_BTN[49]] = (nINPUT == 8)           // S-VIDEO 2 INPUT
[dvTP, nCHAN_BTN[50]] = (nINPUT == 9)           // COMPOSITE 2 INPUT

[dvTP, nCHAN_BTN[53]] = (nRESOLUTION == 1)      // 640x480 OUTPUT RESOLUTION
[dvTP, nCHAN_BTN[54]] = (nRESOLUTION == 2)      // 800x600 OUTPUT RESOLUTION
[dvTP, nCHAN_BTN[55]] = (nRESOLUTION == 3)      // 1024x768 OUTPUT RESOLUTION
[dvTP, nCHAN_BTN[56]] = (nRESOLUTION == 4)      // 1280x1024 OUTPUT RESOLUTION
[dvTP, nCHAN_BTN[57]] = (nRESOLUTION == 5)      // 1600x1200 OUTPUT RESOLUTION
[dvTP, nCHAN_BTN[58]] = (nRESOLUTION == 6)      // 852x1024i OUTPUT RESOLUTION
[dvTP, nCHAN_BTN[59]] = (nRESOLUTION == 7)      // 1024x1024i OUTPUT RESOLUTION
[dvTP, nCHAN_BTN[60]] = (nRESOLUTION == 8)      // 1366x768 OUTPUT RESOLUTION
[dvTP, nCHAN_BTN[61]] = (nRESOLUTION == 9)      // 1366x1024 OUTPUT RESOLUTION
[dvTP, nCHAN_BTN[62]] = (nRESOLUTION == 10)      // 1280x720 OUTPUT RESOLUTION
[dvTP, nCHAN_BTN[63]] = (nRESOLUTION == 11)      // 720x483 OUTPUT RESOLUTION
[dvTP, nCHAN_BTN[64]] = (nRESOLUTION == 12)      // 480P OUTPUT RESOLUTION
[dvTP, nCHAN_BTN[65]] = (nRESOLUTION == 13)      // 720P OUTPUT RESOLUTION
[dvTP, nCHAN_BTN[66]] = (nRESOLUTION == 17)      // USER DEFINE 60HZ OUTPUT RESOLUTION

[dvTP, nCHAN_BTN[70]] = (cSIZE == '1/25')       // PIP SIZE 1/25
[dvTP, nCHAN_BTN[71]] = (cSIZE == '1/16')       // PIP SIZE 1/16
[dvTP, nCHAN_BTN[72]] = (cSIZE == '1/9')        // PIP SIZE 1/9
[dvTP, nCHAN_BTN[73]] = (cSIZE == '1/4')        // PIP SIZE 1/4
[dvTP, nCHAN_BTN[74]] = (cSIZE == '1/2')        // PIP SIZE 1/2
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)