PROGRAM_NAME='Sharp_XGC50X_MAIN'
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 02/26/2003 AT: 15:12:06               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/29/2003 AT: 10:14:12         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 02/26/2003                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*  main file for the Sharp XGC50X projector               *)
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

dvSHARP_XGC50X  = 5001:1:0 // configuration for RS232
                    (*    rate = 9600 bps
                          data bits = 8
                          stop bit  = 1
                          parity    = no parity
                          Handshaking = none
                       RS232 port connections:
                       AMX                  XGC50X
                       
                       TxD   ------------->  RxD
                       RxD  <-------------   TxD
                       GND   -------------   GND
                       
                                                     
                                                      *)
vdvSHARP_XGC50X   = 33001:1:0     // VIRTUAL DEVICE

dvTP           = 128:1:0       // TOUCH PANEL
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

VOLATILE INTEGER nSHARP_BUTTONS[]=
{
    1, //1- SEE ITEM 42 
    2, //2- POWER ON
    3, //3- MUTE ON/OFF
    4, //4- VIDEO ON/OFF
    5, //5- INPUT 1
    6, //6- INPUT 2
    7, //7- INPUT 3
    8, //8- INPUT 4
    9, //9- FREEZE ON/OFF
   10, //10-AUTO SYNC START
   11, //11-
   12, //12-
   13, //13-
   14, //14-
   15, //15-
   16, //16- GAMMA - STANDARD
   17, //17- GAMMA - PRESENTATION
   18, //18- GAMMA - CINEMA
   19, //19- GAMMA - CUSTOM
   20, //20- PIP
   21, //21- 
   22, //22- INPUT CONTRAST
   23, //23- INPUT BRIGHTNESS
   24, //24- OSD
   25, //25- IMAGE BUTTON
   26, //26- INPUT COLOR
   27, //27- INPUT TINT
   28, //28- INPUT SHARPNESS
   29, //29- 
   30, //30- 
   31, //31- 
   32, //32- 
   33, //33- 
   34, //34- H-POSITION
   35, //35- V-POSITION
   36, //36- 
   37, //37-
   38, //38- 
   39, //39- 
   40, //40- 
   41, //41- 
   42, //42- POWER OFF // HAD TO MOVE POWER OFF TO SLOT 42 SO THAT IT WILL NOT ECHO - NUMBER 1 IS ALSO USED FOR A LEVEL AND IT ECHOS
   43, //43- AUTO SYNC OFF
   44, //44- NORMAL AUTO SYNC
   45, //45- HIGH SPEED AUTO SYNC
   46, //46- 
   47, //47- SPEAKER ON/OFF
   48, //48- VIDEO SYSTEM - AUTO
   49, //49- VIDEO SYSTEM - PAL
   50, //50- VIDEO SYSTEM - SECAM
   51, //51- VIDEO SYSTEM - NTSC 4.43
   52, //52- VIDEO SYSTEM - NTSC 3.58
   53, //53- PAL_M
   54, //54- PAL_N
   55, //55- BACKGROUND SELECTOR
   56, //56- STARTUP IMAGE SELECTOR
   57, //57- 
   58, //58- LAMP STATUS
   59, //59- PROJECTOR REVERSE ON/OFF
   60, //60- PROJECTOR INVERT ON/OFF
   61, //61- KEYLOCK LEVEL
   62, //62- LANGUAGE ENGLISH
   63, //63- LANGUAGE GERMAN
   64, //64- keystone 
   65, //65- 
   66, //66- 
   67, //67- LAMP STATE 
   68, //68- 
   69, //69- 
   70, //70- 
   71, //71- 
   72, //72- 
   73, //73- 
   74, //74-
   75, //75- 
   76, //76- 
   77, //77- 
   78, //78-
   // TEXT BOXES
   79, //79  - 
   80, //80  - 
   81, //81  - 
   82, //82  - 
   83, //83  - 
   84, //84  - 
   85, //85  - 
   86, //86  - 
   87, //87  -  
   88, //88  - 
   89, //89  - 
   90, //90  - 
   91, //91  -
   92, //92  -
   // LEVEL NUMBER DEFINITIONS
    1  //93  - LAMP LIFE
   
}
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
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

DEFINE_MODULE 'SHARP_XGC50X_UI' UI(dvTP,vdvSHARP_XGC50X,nSHARP_BUTTONS)
DEFINE_MODULE 'SHARP_XGC50X_COMM' COMM(vdvSHARP_XGC50X,dvSHARP_XGC50X)


(***********************************************************)
(*                THE EVENTS GOES BELOW                    *)
(***********************************************************)
DEFINE_EVENT

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

