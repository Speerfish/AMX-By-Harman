MODULE_NAME='Yamaha_DVDC940_UI'(DEV vdvDEVICE, DEV dvTPArray[], 
                                 INTEGER nTransportBtns[], INTEGER nMenuBtns[], 
                                 INTEGER  nKeypadBtns[],   INTEGER nOtherBtns[])

(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 6/10/2004 AT: 10:53:40               *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)

DEFINE_DEVICE

DEFINE_CONSTANT   
     
   INTEGER SET_DISC_OFFSET = 5    // specific disc buttons start at 6th position in array 
DEFINE_TYPE

DEFINE_VARIABLE
    VOLATILE CHAR bDebug 
    
    VOLATILE INTEGER bPower = 2      // Initialize to unknown state
    VOLATILE CHAR sTransport[16] 
    
 
DEFINE_LATCHING

DEFINE_MUTUALLY_EXCLUSIVE

DEFINE_START

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
                SEND_COMMAND vdvDEVICE, "'POWER=1'"
            }
            CASE 2:
            {
                SEND_COMMAND vdvDEVICE, "'POWER=0'"
            }
            CASE 3:
            {
                SEND_COMMAND vdvDEVICE, "'TRANSPORT=PLAY'"
            }
            CASE 4:
            {
                SEND_COMMAND vdvDEVICE, "'TRANSPORT=STOP'"
            }
            CASE 5:
            {
                SEND_COMMAND vdvDEVICE, "'TRANSPORT=PAUSE'"
            }
            CASE 6:
            {
                SEND_COMMAND vdvDEVICE, "'TRANSPORT=NEXT'"
            }
            CASE 7:
            {
                SEND_COMMAND vdvDEVICE, "'TRANSPORT=PREVIOUS'"
            }
            CASE 8:
            {
                SEND_COMMAND vdvDEVICE, "'SCAN=+'"
            }
            CASE 9:
            {
                SEND_COMMAND vdvDEVICE, "'SCAN=-'"
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
                SEND_COMMAND vdvDEVICE, "'MENU'"
            }
            CASE 2:
            {
                SEND_COMMAND vdvDEVICE, "'TOPMENU'"
            }
            CASE 3:
            {
                SEND_COMMAND vdvDEVICE, "'RETURN'"
            }
            CASE 4:
            {
                SEND_COMMAND vdvDEVICE, "'MENUSELECT'"
            }
            CASE 5:
            {
                SEND_COMMAND vdvDEVICE, "'CURSOR=UP'"
            }
            CASE 6:
            {
                SEND_COMMAND vdvDEVICE, "'CURSOR=DOWN'"
            }
            CASE 7:
            {
                SEND_COMMAND vdvDEVICE, "'CURSOR=LEFT'"
            }
            CASE 8:
            {
                SEND_COMMAND vdvDEVICE, "'CURSOR=RIGHT'"
            }
            CASE 9:
            {
                SEND_COMMAND vdvDEVICE, "'CLEAR'"
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
        SEND_COMMAND vdvDEVICE, "'NUMPAD=',ITOA(nBtnIndex-1)"
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
                SEND_COMMAND vdvDEVICE,"'DISPLAY'"
            }
            CASE 2:
            {
                SEND_COMMAND vdvDEVICE,"'ANGLE=+'"
            }
            CASE 3:
            {
                SEND_COMMAND vdvDEVICE,"'SUBTITLE=T'"
            }
            CASE 4:
            {
                SEND_COMMAND vdvDEVICE,"'AUDIO=T'"
            }
            CASE 5:
            {
                SEND_COMMAND vdvDEVICE,"'REPEATAB'"
            }
            CASE 6:
            CASE 7:
            CASE 8:
            CASE 9:
            CASE 10:
            {
                SEND_COMMAND vdvDEVICE,"'DISC=',ITOA(nBtnIndex - SET_DISC_OFFSET)"
            }
        }
    }
}

DATA_EVENT[vdvDEVICE]
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
            CASE 'POWER=' :
            {   
                bPower = ATOI(DATA.TEXT)
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
    }
    OFFLINE:
    {
    }
}

DEFINE_PROGRAM

[dvTPArray,nTransportBtns[1]] = (bPower = 1)        // power ON
[dvTPArray,nTransportBtns[2]] = (bPower = 0)        // power OFF

[dvTPArray,nTransportBtns[3]] = (sTransport = 'PLAY') 
[dvTPArray,nTransportBtns[4]] = (sTransport = 'STOP')
[dvTPArray,nTransportBtns[5]] = (sTransport = 'PAUSE')
[dvTPArray,nTransportBtns[8]] = ( (sTransport = 'SLOW+') OR (sTRANSPORT = 'FAST+') ) 
[dvTPArray,nTransportBtns[9]] = ( (sTransport = 'SLOW-') OR (sTRANSPORT = 'FAST-') ) 
