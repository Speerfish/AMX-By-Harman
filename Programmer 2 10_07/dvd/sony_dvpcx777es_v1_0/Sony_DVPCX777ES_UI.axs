MODULE_NAME='Sony_DVPCX777ES_UI'(DEV vdvDVP, DEV dvTPArray[], 
                                 INTEGER nTransportBtns[], INTEGER nMenuBtns[], 
                                 INTEGER  nKeypadBtns[], INTEGER nWriteBtns[],
                                 INTEGER nGoToBtns[], INTEGER nOtherBtns[])

(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 10/21/2003 AT: 10:53:40               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 11/06/2003 AT: 14:55:31         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 10/21/2003                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)

DEFINE_DEVICE

DEFINE_CONSTANT
    INTEGER DISC = 1 
DEFINE_TYPE

DEFINE_VARIABLE
    VOLATILE CHAR bDebug 
    VOLATILE CHAR bInfoPopup

    VOLATILE INTEGER nDiscNumber 
    VOLATILE INTEGER nTitleOrAlbum
    VOLATILE INTEGER nChapterOrTrack
    VOLATILE INTEGER nDiscType 
    
    VOLATILE INTEGER bPower = 2      // Initialize to unknown state
    VOLATILE CHAR sTransport[16]
    VOLATILE CHAR sDisc_Type[9][13] =
    { 
        'CD',
        'VCD/SVCD', 
        'DVD', 
        'DVD No Play', 
        'SACD-CD', 
        'SACD-2CH', 
        'SACD-MULTI_CH', 
        'MP3', 
        'Unknown'
    }
    VOLATILE CHAR sCounter[8]         // HH:MM:SS two digits each for hour, minutes, seconds  
    
    VOLATILE INTEGER nGoToIndex = DISC      // used for disc direct set, default to 'disc'
    VOLATILE CHAR sGoToValue[3][3]  
 
DEFINE_LATCHING

DEFINE_MUTUALLY_EXCLUSIVE

DEFINE_START
    sGoToValue[1] = ''
    sGoToValue[2] = ''
    sGoToValue[3] = ''

DEFINE_EVENT

BUTTON_EVENT[dvTPArray, nTransportBtns]
{
    PUSH:
    {
        STACK_VAR CHAR nBtnIndex                        // no more than 255 buttons in the array 

        nBtnIndex = GET_LAST(nTransportBtns)
        PULSE [dvTPArray,nTransportBtns[nBtnIndex]]
        SWITCH (nBtnIndex)
        {
            CASE 1:
            {
                SEND_COMMAND vdvDVP, "'POWER=1'"
            }
            CASE 2:
            {
                SEND_COMMAND vdvDVP, "'POWER=0'"
            }
            CASE 3:
            {
                SEND_COMMAND vdvDVP, "'TRANSPORT=PLAY'"
            }
            CASE 4:
            {
                SEND_COMMAND vdvDVP, "'TRANSPORT=STOP'"
            }
            CASE 5:
            {
                SEND_COMMAND vdvDVP, "'TRANSPORT=PAUSE'"
            }
            CASE 6:
            {
                SEND_COMMAND vdvDVP, "'TRANSPORT=NEXT'"
            }
            CASE 7:
            {
                SEND_COMMAND vdvDVP, "'TRANSPORT=PREVIOUS'"
            }
            CASE 8:
            {
                SEND_COMMAND vdvDVP, "'SCAN=+'"
            }
            CASE 9:
            {
                SEND_COMMAND vdvDVP, "'SCAN=-'"
            }
            CASE 10:    // disc up
            {
                SEND_COMMAND vdvDVP, "'DISC=+'"
            }
            CASE 11:    // disc down 
            {
                SEND_COMMAND vdvDVP, "'DISC=-'"
            }
            CASE 12:    //
            {
                IF (bInfoPopup)
                    send_command dvTPArray, "'@PPF-Information'"                    // close popup
                ELSE 
                    send_command dvTPArray, "'@PPN-Information'"                    // turn on popup
                                    
                bInfoPopup = !bInfoPopup
                
            }
        }   // END OF - switch on button index         
    }
    RELEASE:
    {
    }
}

BUTTON_EVENT[dvTPArray, nMenuBtns]
{
    PUSH:
    {
        STACK_VAR CHAR nBtnIndex                        // no more than 255 buttons in the array        
        nBtnIndex = GET_LAST(nMenuBtns)
        PULSE [dvTPArray,nMenuBtns[nBtnIndex]] 
        SWITCH (nBtnIndex)
        {
            CASE 1:
            {
                SEND_COMMAND vdvDVP, "'MENU'"
            }
            CASE 2:
            {
                SEND_COMMAND vdvDVP, "'TOPMENU'"
            }
            CASE 3:
            {
                SEND_COMMAND vdvDVP, "'RETURN'"
            }
            CASE 4:
            {
                SEND_COMMAND vdvDVP, "'MENUSELECT'"
            }
            CASE 5:
            {
                SEND_COMMAND vdvDVP, "'CURSOR=UP'"
            }
            CASE 6:
            {
                SEND_COMMAND vdvDVP, "'CURSOR=DOWN'"
            }
            CASE 7:
            {
                SEND_COMMAND vdvDVP, "'CURSOR=LEFT'"
            }
            CASE 8:
            {
                SEND_COMMAND vdvDVP, "'CURSOR=RIGHT'"
            }
            CASE 9:
            {
                SEND_COMMAND vdvDVP, "'FOLDER'"
            }
        }
    }
    RELEASE:
    {
    }
}

BUTTON_EVENT[dvTPArray, nKeypadBtns]
{
    PUSH:
    {
        STACK_VAR CHAR nBtnIndex                        // no more than 255 buttons in the array        
        nBtnIndex = GET_LAST(nKeypadBtns)
        SEND_COMMAND vdvDVP, "'NUMPAD=',ITOA(nBtnIndex-1)"
    }
    RELEASE:
    {
    }
}

BUTTON_EVENT[dvTPArray, nOtherBtns]
{
    PUSH:
    {
        STACK_VAR CHAR nBtnIndex
        nBtnIndex = GET_LAST(nOtherBtns)
        SWITCH (nBtnIndex)
        {
            CASE 1:
            {
                SEND_COMMAND vdvDVP,"'CLEAR'"
            }
            CASE 2:
            {
                SEND_COMMAND vdvDVP,"'ANGLE=+'"
            }
            CASE 3:
            {
                SEND_COMMAND vdvDVP,"'SUBTITLE=T'"
            }
            CASE 4:
            {
                SEND_COMMAND vdvDVP,"'AUDIO=T'"
            }
        }
    }
}

BUTTON_EVENT[dvTPArray, nGoToBtns]
{
    PUSH:
    {
        STACK_VAR INTEGER nTempVar1 
        STACK_VAR CHAR nBtnIndex                        // no more than 255 buttons in the array        
        nBtnIndex = GET_LAST(nGoToBtns)
        PULSE [dvTPArray,nGoToBtns[nBtnIndex]] 
        SWITCH (nBtnIndex)
        {
            CASE 1:     // jump 
            {
                // 
                // send 0 if empty string
                // 
                IF (sGoToValue[1] = '')
                {
                    sGoToValue[1] = '0'
                }
                
                IF (sGoToValue[2] = '')
                {
                    sGoToValue[2] = '0'                
                }
                
                IF (sGoToValue[3] = '')
                {
                    sGoToValue[3] = '0'
                }
                
                SEND_COMMAND vdvDVP,"'DISC_SET=',sGoToValue[1],':',sGoToValue[2],':',sGoToValue[3]"
                sGoToValue[1] = ''
                sGoToValue[2] = ''
                sGoToValue[3] = ''
                nGoToIndex= DISC                    // reset everything, default to DISC
                SEND_COMMAND dvTPArray,"'!T',nWriteBtns[4],''"
                SEND_COMMAND dvTPArray,"'!T',nWriteBtns[5],''"
                SEND_COMMAND dvTPArray,"'!T',nWriteBtns[6],''"
            }
            CASE 2:     // digit 0 
            CASE 3:
            CASE 4:
            CASE 5:
            CASE 6:
            CASE 7:
            CASE 8:
            CASE 9:
            CASE 10:    // digit 8
            CASE 11:    // digit 9
            {
                sGoToValue[nGoToIndex] = "sGoToValue[nGoToIndex],ITOA(nBtnIndex-2)"
                SEND_COMMAND dvTPArray,"'!T',nWriteBtns[3+nGoToIndex],sGoToValue[nGoToIndex]"
            }
            CASE 12:    // clear 
            {
                nTempVar1 = LENGTH_STRING(sGoToValue[nGoToIndex])
                IF (nTempVar1 > 1)
                    sGoToValue[nGoToIndex] = GET_BUFFER_STRING(sGoToValue[nGoToIndex], nTempVar1 - 1)
                ELSE
                    sGoToValue[nGoToIndex] = '' 
                    
                SEND_COMMAND dvTPArray,"'!T',nWriteBtns[3+nGoToIndex],sGoToValue[nGoToIndex]"
            }
            // set index (which value is being specified, DISC, TITLE, or CHAPTER) 
            CASE 13:
            CASE 14:
            CASE 15:
            {
                nGoToIndex = nBtnIndex - 12
            }
        }
    }
    RELEASE:
    {
    }
}
DATA_EVENT[vdvDVP]
{
    STRING:
    {
        STACK_VAR char sName[32]
        STACK_VAR CHAR bTempState
        
        
        IF (bDebug)     
            SEND_STRING 0,"'Rcvd from Comm:',DATA.TEXT" 
                       
        sName = REMOVE_STRING (DATA.TEXT,'=',1)
        SWITCH (sName) 
        {
            CASE 'DEBUG=' :            // debug = <state> 
            {
                bDebug = ATOI(DATA.TEXT) 
            }
            CASE 'DISC=' :
            {
                nDiscNumber = ATOI(DATA.TEXT)
                IF (nDiscNumber == 0)
                    SEND_COMMAND dvTPArray,"'!T',nWriteBtns[1],'--'"
                ELSE
                    SEND_COMMAND dvTPArray,"'!T',nWriteBtns[1],DATA.TEXT"
            }
            CASE 'DISC_TYPE=':
            {
                nDiscType = ATOI(DATA.TEXT)
                SEND_COMMAND dvTPArray,"'!T',nWriteBtns[7],sDISC_TYPE[nDiscType]"
                IF  ((nDiscType = 1) OR (nDiscType > 5) )
                {
                    ON[dvTPArray,13]        // title-album label is Album
                    ON[dvTPArray,14]        // chapter-track label is Track 
                }
                ELSE
                {
                    OFF[dvTPArray,13]       // title-album label is title
                    OFF[dvTPArray,14]       // chapter-track label is cahpter 
                }
            }
            CASE 'POWER=' :
            {   
                bPower = ATOI(DATA.TEXT)
            }
            CASE 'TITLE=' :             // or album for a CD 
            {
                nTitleOrAlbum = ATOI(DATA.TEXT)
                IF (nTitleOrAlbum == 0)
                    SEND_COMMAND dvTPArray,"'!T',nWriteBtns[2],'--'"
                ELSE
                    SEND_COMMAND dvTPArray,"'!T',nWriteBtns[2],DATA.TEXT"
            }
            CASE 'TRACK=' :            // or chapter for a DVD
            {
                nChapterOrTrack = ATOI(DATA.TEXT) 
                IF (nChapterOrTrack == 0)
                    SEND_COMMAND dvTPArray,"'!T',nWriteBtns[3],'--'"
                ELSE
                    SEND_COMMAND dvTPArray,"'!T',nWriteBtns[3],DATA.TEXT"
            }
            CASE 'TRANSPORT=' :
            {
                sTransport = DATA.TEXT
            }
            CASE 'VERSION=' :
            {
                // print version if you like
            }

        }   // END OF -switch on name 
    }
    COMMAND:
    {
    }
    ONLINE:
    {
    }
    OFFLINE:
    {
    }
}

DATA_EVENT[dvTPArray]
{
   STRING:
    {
    }
    COMMAND:
    {
    }
    ONLINE:
    {
        send_command dvTPArray, "'@PPX'"                    // close all popups
        SEND_COMMAND dvTPArray,"'!T',nWriteBtns[1],''"
        SEND_COMMAND dvTPArray,"'!T',nWriteBtns[2],''"
        SEND_COMMAND dvTPArray,"'!T',nWriteBtns[3],''"
        SEND_COMMAND dvTPArray,"'!T',nWriteBtns[4],''"
        SEND_COMMAND dvTPArray,"'!T',nWriteBtns[5],''"
        SEND_COMMAND dvTPArray,"'!T',nWriteBtns[6],''"
        SEND_COMMAND dvTPArray,"'!T',nWriteBtns[7],''"

    }
    OFFLINE:
    {
    }
}

DEFINE_PROGRAM

[dvTPArray,nTransportBtns[1]] = (bPower = 1)        // power ON
[dvTPArray,nTransportBtns[2]] = (bPower = 0)        // power OFF
[dvTPArray,nTransportBtns[12]] = (bInfoPopup = 1)    

[dvTPArray,nTransportBtns[3]] = (sTransport = 'PLAY') 
[dvTPArray,nTransportBtns[4]] = (sTransport = 'STOP')
[dvTPArray,nTransportBtns[5]] = (sTransport = 'PAUSE')

[dvTPArray,nGoToBtns[13]] = (nGoToIndex = 1)
[dvTPArray,nGoToBtns[14]] = (nGoToIndex = 2)
[dvTPArray,nGoToBtns[15]] = (nGoToIndex = 3)
