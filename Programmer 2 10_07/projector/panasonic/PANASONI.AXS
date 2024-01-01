PROGRAM_NAME='PANASONIC, PT-L797U VIDEO PROJECTOR, RS232, 06-22-99, MJR'
(*   DATE:06/23/99    TIME:15:35:38    *)

(***********************************************************)
(* The following code block is provided as a guide to      *)
(* programming the device(s) listed above. This is a       *)
(* sample only, and will most likely require modification  *)
(* to be integrated into a master program.                 *)
(*                                                         *)
(* Device-specific protocols should be obtained directly   *)
(* from the equipment manufacturer to ensure compliance    *)
(* with the most current versions. Within the limits       *)
(* imposed by any non-disclosure agreements, AMX will      *)
(* provide protocols upon request.                         *)
(*                                                         *)
(* If further programming assistance is required, please   *)
(* contact your AMX customer support team.                 *)
(*                                                         *)

(***********************************************************)
(*               DEVICE DEFINITIONS GO BELOW               *)
(***********************************************************)
DEFINE_DEVICE

PROJ  =  1       (*PANASONIC VIDEO PROJECTOR*)
                 (* 9600,8,N,1 FG752-04     *)

TP    =  192     (*AXT-MCA MINI-TOUCH PANEL *)


(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(* !!                                 !! *)
(* !! DO NOT OVERRIDE THESE CONSTANTS !! *)
(* !!                                 !! *)

#IF_NOT_DEFINED VP_FUNCTION_CONST
#DEFINE VP_FUNCTION_CONST
VP_POWER_SET      = 1
VP_VIDEO_MUTE_SET = 2
VP_AUDIO_MUTE_SET = 3
VP_INPUT_SELECT   = 4
VP_CHANNEL_SELECT = 5
VP_VOLUME_SET     = 10
VP_BRIGHT_SET     = 11
VP_COLOR_SET      = 12
VP_CONTR_SET      = 13
VP_SHARP_SET      = 14
VP_TINT_SET       = 15
VP_VOLUME_RAMP    = 20
VP_BRIGHT_RAMP    = 21
VP_COLOR_RAMP     = 22
VP_CONTR_RAMP     = 23
VP_SHARP_RAMP     = 24
VP_TINT_RAMP      = 25
VP_VIDEO1         = 31
VP_VIDEO2         = 32
VP_VIDEO3         = 33
VP_RGB1           = 34
VP_RGB2           = 35
VP_MENU           = 36
VP_ENTER          = 37
VP_CURSOR_UP      = 38
VP_CURSOR_DN      = 39
VP_CURSOR_LT      = 40
VP_CURSOR_RT      = 41
VP_STANDARD       = 42
#END_IF

#IF_NOT_DEFINED VP_DATA_CONST
#DEFINE VP_DATA_CONST
VP_SET_ON     = 1
VP_SET_OFF    = 2
VP_SET_TOGGLE = 3
VP_INCREASE   = 4
VP_DECREASE   = 5
#END_IF

#IF_NOT_DEFINED VP_FEEDBACK_CONST
#DEFINE VP_FEEDBACK_CONST
VP_POWER_FB   = 200
VP_VIDMUTE_FB = 208
VP_AUDMUTE_FB = 216
VP_BASE_ADDR  = 224
VP_BRIT_UP_FB = 233
VP_BRIT_DN_FB = 234
VP_COLR_UP_FB = 235
VP_COLR_DN_FB = 236
VP_CONT_UP_FB = 237
VP_CONT_DN_FB = 238
VP_SHRP_UP_FB = 239
VP_SHRP_DN_FB = 240
VP_TINT_UP_FB = 241
VP_TINT_DN_FB = 242
VP_VOL_UP_FB  = 243
VP_VOL_DN_FB  = 244
VP_VIDEO1_FB  = 245
VP_VIDEO2_FB  = 246
VP_VIDEO3_FB  = 247
VP_RGB1_FB    = 248
VP_RGB2_FB    = 249
VP_BUSY       = 254
#END_IF

LAMP_COND_QUERY  = 1
LAMP_CHECK_QUERY = 2


#IF_NOT_DEFINED PANVP_DEFEAT_FEEDBACK
PANVP_DEFEAT_FEEDBACK = 0
#END_IF
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOL_LEVEL
VOL_UP_FLAG
VOL_DN_FLAG
CURSOR_UP_FLAG
CURSOR_DN_FLAG
CURSOR_LT_FLAG
CURSOR_RT_FLAG
PROJ_BUFFER[255]
TEMP_PROJ_BUFFER[255]
CHECK
CONDITION
PROJ_Q[255]
PROJ_CMD
PROJ_READY
PROJ_STRING[30]
COUNTER1
COUNTER2
COUNTER3
COUNTER4
CON_FLAG
VID_FLAG
SVID_FLAG
RG1_FLAG
RG2_FLAG
(***********************************************************)
(*             SUBROUTINE DEFINITIONS GO BELOW             *)
(***********************************************************)

(**************************************)
(* NAME: PANASONIC PT-L797U FUNCTION  *)
(* PURPOSE: SYSTEM CALL LIKE FORMAT   *)
(*          FOR FUNCTION OF PT-L797U  *)
(**************************************)
DEFINE_CALL 'PANVP00F' (DEV,FUNC,DATA)
{
   SELECT
   {
      ACTIVE (FUNC = VP_POWER_SET) :
      {
         IF (DATA = VP_SET_ON)
         {
            SEND_STRING DEV,"$02,'PON',$03"
            ON[DEV,VP_POWER_FB]
         }
         ELSE IF (DATA = VP_SET_OFF)
         {
            SEND_STRING DEV,"$02,'POF',$03"
            OFF[DEV,VP_POWER_FB]
         }
      }
      ACTIVE (FUNC = VP_VOLUME_SET) :
      {
         IF (DATA = VP_INCREASE)
         {
           VOL_LEVEL = VOL_LEVEL + 1
           SEND_STRING DEV,"$02,'AVL:0',ITOA(VOL_LEVEL/10),
                            ITOA(VOL_LEVEL%10),$03"
           ON[DEV,VP_VOL_UP_FB]
         }
         ELSE IF (DATA = VP_DECREASE)
         {
           VOL_LEVEL = VOL_LEVEL - 1
           SEND_STRING DEV,"$02,'AVL:0',ITOA(VOL_LEVEL/10),
                             ITOA(VOL_LEVEL%10),$03"
           ON[DEV,VP_VOL_DN_FB]
         }
      }
      ACTIVE (FUNC = VP_VIDEO_MUTE_SET) :
      {
         IF (DATA = VP_SET_ON)
         {
            SEND_STRING DEV,"$02,'AMT:1',$03"
            ON[DEV,VP_VIDMUTE_FB]
         }
         ELSE IF (DATA = VP_SET_OFF)
         {
            SEND_STRING DEV,"$02,'AMT:0',$03"
            OFF[DEV,VP_VIDMUTE_FB]
         }
      }
      ACTIVE (FUNC = VP_VIDEO1) :
      {
         SEND_STRING DEV,"$02,'IIS:VID',$03"
         ON[DEV,VP_VIDEO1_FB]
         OFF[DEV,VP_VIDEO2_FB]
         OFF[DEV,VP_RGB1_FB]
         OFF[DEV,VP_RGB2_FB]
      }
      ACTIVE (FUNC = VP_VIDEO2) :
      {
         SEND_STRING DEV,"$02,'IIS:SVD',$03"
         OFF[DEV,VP_VIDEO1_FB]
         ON[DEV,VP_VIDEO2_FB]
         OFF[DEV,VP_RGB1_FB]
         OFF[DEV,VP_RGB2_FB]
      }
      ACTIVE (FUNC = VP_RGB1) :
      {
         SEND_STRING DEV,"$02,'IIS:RG1',$03"
         OFF[DEV,VP_VIDEO1_FB]
         OFF[DEV,VP_VIDEO2_FB]
         ON[DEV,VP_RGB1_FB]
         OFF[DEV,VP_RGB2_FB]
      }
      ACTIVE (FUNC = VP_RGB2) :
      {
         SEND_STRING DEV,"$02,'IIS:RG2',$03"
         OFF[DEV,VP_VIDEO1_FB]
         OFF[DEV,VP_VIDEO2_FB]
         OFF[DEV,VP_RGB1_FB]
         ON[DEV,VP_RGB2_FB]
      }
      ACTIVE (FUNC = VP_MENU) :
      {
         SEND_STRING DEV,"$02,'OMN',$03"
      }
      ACTIVE (FUNC = VP_ENTER) :
      {
         SEND_STRING DEV,"$02,'OEN',$03"
      }
      ACTIVE (FUNC = VP_CURSOR_UP) :
      {
         SEND_STRING DEV,"$02,'OCU',$03"
      }
      ACTIVE (FUNC = VP_CURSOR_DN) :
      {
         SEND_STRING DEV,"$02,'OCD',$03"
      }
      ACTIVE (FUNC = VP_CURSOR_LT) :
      {
         SEND_STRING DEV,"$02,'OCL',$03"
      }
      ACTIVE (FUNC = VP_CURSOR_RT) :
      {
         SEND_STRING DEV,"$02,'OCR',$03"
      }
      ACTIVE (FUNC = VP_STANDARD) :
      {
         SEND_STRING DEV,"$02,'OST',$03"
      }
   }
}

(**************************************)
(* NAME: PANVP001                     *)
(* PURPOSE: SYSTEM CALL LIKE FORMAT   *)
(*          FOR PANASONIC PT-L797U    *)
(**************************************)
(**********************************************************)
(*    COMMANDS TO PROJECTOR MUST BE DELAYED BETWEEN       *)
(*  CONSECUTIVE COMMANDS TO PREVENT COMMUNICATION ERRORS  *)
(**********************************************************)
DEFINE_CALL 'PANVP001' (DEV,TP,PNB,PFB,VUB,VDB,MNB,MFB,VIB,SVB,
                        R1B,R2B,MUB,ENB,CUB,CDB,CLB,CRB,STB)
{
  PUSH[TP,PNB]                  (* POWER ON *)
  IF (![DEV,VP_BUSY])
  {
    ON [DEV,VP_BUSY]
    WAIT 10 'PANVP BUSY' OFF [DEV,VP_BUSY]
    CALL 'PANVP00F' (DEV,VP_POWER_SET,VP_SET_ON)
  }

  PUSH[TP,PFB]                  (* POWER OFF *)
  IF (![DEV,VP_BUSY])
  {
    ON [DEV,VP_BUSY]
    WAIT 10 'PANVP BUSY' OFF [DEV,VP_BUSY]
    CALL 'PANVP00F' (DEV,VP_POWER_SET,VP_SET_OFF)
  }

  PUSH[TP,VUB]                  (* VOLUME UP *)
  IF (![DEV,VP_BUSY])
  {
    ON [DEV,VP_BUSY]
    WAIT 10 'PANVP BUSY' OFF [DEV,VP_BUSY]
    ON[VOL_UP_FLAG]
    CALL 'PANVP00F' (DEV,VP_VOLUME_SET,VP_INCREASE)
    CALL 'PANVP00F' (DEV,VP_VIDEO_MUTE_SET,VP_SET_OFF)
  }

  RELEASE[TP,VUB]
    OFF[VOL_UP_FLAG]

  PUSH[TP,VDB]                  (* VOLUME DOWN *)
  IF (![DEV,VP_BUSY])
  {
    ON [DEV,VP_BUSY]
    WAIT 10 'PANVP BUSY' OFF [DEV,VP_BUSY]
    ON[VOL_DN_FLAG]
    CALL 'PANVP00F' (DEV,VP_VOLUME_SET,VP_DECREASE)
    CALL 'PANVP00F' (DEV,VP_VIDEO_MUTE_SET,VP_SET_OFF)
  }

  RELEASE[TP,VDB]
    OFF[VOL_DN_FLAG]

(**********************************************************)
(*   WHETHER AUDIO OR PICTURE MUTE IS CALLED FROM THESE   *)
(*    COMMANDS DEPENDS ON WHICH ONE IS SELECTED IN THE    *)
(*                PROJECTOR'S OPTION MENU                 *)
(**********************************************************)
  PUSH[TP,MNB]                  (* AUDIO/PICTURE MUTE *)
  IF (![DEV,VP_BUSY])
  {
    ON [DEV,VP_BUSY]
    WAIT 10 'PANVP BUSY' OFF [DEV,VP_BUSY]
    CALL 'PANVP00F' (DEV,VP_VIDEO_MUTE_SET,VP_SET_ON)
  }

  PUSH[TP,MFB]                  (* AUDIO/PICTURE MUTE *)
  IF (![DEV,VP_BUSY])
  {
    ON [DEV,VP_BUSY]
    WAIT 10 'PANVP BUSY' OFF [DEV,VP_BUSY]
    CALL 'PANVP00F' (DEV,VP_VIDEO_MUTE_SET,VP_SET_OFF)
  }

  PUSH[TP,VIB]                  (* SELECT VIDEO INPUT *)
  IF (![DEV,VP_BUSY])
  {
    ON [DEV,VP_BUSY]
    WAIT 10 'PANVP BUSY' OFF [DEV,VP_BUSY]
    CALL 'PANVP00F' (DEV,VP_VIDEO1,VP_SET_ON)
  }

  PUSH[TP,SVB]                  (* SELECT S-VIDEO INPUT *)
  IF (![DEV,VP_BUSY])
  {
    ON [DEV,VP_BUSY]
    WAIT 10 'PANVP BUSY' OFF [DEV,VP_BUSY]
    CALL 'PANVP00F' (DEV,VP_VIDEO2,VP_SET_ON)
  }

  PUSH[TP,R1B]                  (* SELECT RGB1 INPUT *)
  IF (![DEV,VP_BUSY])
  {
    ON [DEV,VP_BUSY]
    WAIT 10 'PANVP BUSY' OFF [DEV,VP_BUSY]
    CALL 'PANVP00F' (DEV,VP_RGB1,VP_SET_ON)
  }

  PUSH[TP,R2B]                  (* SELECT RGB2 INPUT *)
  IF (![DEV,VP_BUSY])
  {
    ON [DEV,VP_BUSY]
    WAIT 10 'PANVP BUSY' OFF [DEV,VP_BUSY]
    CALL 'PANVP00F' (DEV,VP_RGB2,VP_SET_ON)
  }

  PUSH[TP,MUB]                  (* MENU POPUP WINDOW *)
  IF (![DEV,VP_BUSY])
  {
    ON [DEV,VP_BUSY]
    WAIT 10 'PANVP BUSY' OFF [DEV,VP_BUSY]
    CALL 'PANVP00F' (DEV,VP_MENU,VP_SET_TOGGLE)
  }

  PUSH[TP,ENB]                  (* ENTER *)
  IF (![DEV,VP_BUSY])
  {
    ON [DEV,VP_BUSY]
    WAIT 10 'PANVP BUSY' OFF [DEV,VP_BUSY]
    CALL 'PANVP00F' (DEV,VP_ENTER,VP_SET_TOGGLE)
  }

  PUSH[TP,CUB]                  (* CURSOR UP *)
  {
    ON[CURSOR_UP_FLAG]
    CALL 'PANVP00F' (DEV,VP_CURSOR_UP,VP_SET_TOGGLE)
  }

  RELEASE[TP,CUB]
  {
    OFF[CURSOR_UP_FLAG]
    CANCEL_WAIT 'Up Wait'
  }

  PUSH[TP,CDB]                  (* CURSOR DOWN *)
  {
    CALL 'PANVP00F' (DEV,VP_CURSOR_DN,VP_SET_TOGGLE)
    ON[CURSOR_DN_FLAG]
  }

  RELEASE[TP,CDB]
  {
    OFF[CURSOR_DN_FLAG]
    CANCEL_WAIT 'Down Wait'
  }

  PUSH[TP,CLB]                  (* CURSOR LEFT *)
  {
    CALL 'PANVP00F' (DEV,VP_CURSOR_LT,VP_SET_TOGGLE)
    ON[CURSOR_LT_FLAG]
  }

  RELEASE[TP,CLB]
  {
    OFF[CURSOR_LT_FLAG]
    CANCEL_WAIT 'Left Wait'
  }

  PUSH[TP,CRB]                  (* CURSOR RIGHT *)
  {
    CALL 'PANVP00F' (DEV,VP_CURSOR_RT,VP_SET_TOGGLE)
    ON[CURSOR_RT_FLAG]
  }

  RELEASE[TP,CRB]
  {
    OFF[CURSOR_RT_FLAG]
    CANCEL_WAIT 'Right Wait'
  }

  PUSH[TP,STB]                  (* STANDARD *)
  IF (![DEV,VP_BUSY])
  {
    ON [DEV,VP_BUSY]
    WAIT 10 'PANVP BUSY' OFF [DEV,VP_BUSY]
    CALL 'PANVP00F' (DEV,VP_STANDARD,VP_SET_TOGGLE)
  }
(***********************************************************)
(* PANASONIC DOES NOT PROVIDE PROTOCOLS FOR PLAYER STATUS  *)
(* REQUESTS OTHER THAN LAMP CONDITION QUERY AND LAMP CHECK *)
(* QUERY. THEREFORE MOST OF THE FEEDBACK IS NOT REAL       *)
(***********************************************************)
(* FEEDBACK *)
  IF (!PANVP_DEFEAT_FEEDBACK)
  {
    [TP,PNB] = [DEV,VP_POWER_FB]
    [TP,PFB] = !([DEV,VP_POWER_FB])
    [TP,VUB] = [DEV,VP_VOL_UP_FB]
    [TP,VDB] = [DEV,VP_VOL_DN_FB]
    [TP,MNB] = [DEV,VP_VIDMUTE_FB]
    [TP,MFB] = !([DEV,VP_VIDMUTE_FB])
    [TP,VIB] = [DEV,VP_VIDEO1_FB]
    [TP,SVB] = [DEV,VP_VIDEO2_FB]
    [TP,R1B] = [DEV,VP_RGB1_FB]
    [TP,R2B] = [DEV,VP_RGB2_FB]
  }
}

(* QUEUE FOR PROJECTOR LAMP STATUS REQUESTS *)
DEFINE_CALL 'Add To Projector Queue' (STR[100])
{
    PROJ_Q = "PROJ_Q,STR"
}
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

CREATE_BUFFER PROJ,PROJ_BUFFER
PROJ_READY = 1

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(* SYSTEM CALL TO SET UP PROJECTOR FUNCTIONS *)
CALL 'PANVP001' (PROJ,TP,11,12,8,9,10,4,13,14,15,16,3,5,19,2,7,6,24)

PUSH[TP,4]                         (* MUTE OFF             *)
PUSH[TP,8]                         (* VOLUME UP            *)
PUSH[TP,9]                         (* VOLUME DOWN          *)
PUSH[TP,10]                        (* MUTE ON              *)
PUSH[TP,11]                        (* POWER ON             *)
PUSH[TP,12]                        (* POWER OFF            *)
PUSH[TP,13]                        (* VIDEO INPUT SELECT   *)
PUSH[TP,14]                        (* S-VIDEO INPUT SELECT *)
PUSH[TP,15]                        (* RGB1 INPUT SELECT    *)
PUSH[TP,16]                        (* RGB2 INPUT SELECT    *)
{
  CANCEL_WAIT 'Get Projector Status'
}

(* FUNCTION CALLS TO POWER ON AND TURN MUTE OFF WHEN INPUT SELECTION MADE *)
PUSH[TP,13]                        (* VIDEO INPUT SELECT   *)
{
  IF ((CONDITION = 0) || (CONDITION = 3))
  {
     CALL 'PANVP00F' (PROJ,VP_POWER_SET,VP_SET_ON)
     ON[VID_FLAG]
     WAIT 70 CALL 'PANVP00F' (PROJ,VP_VIDEO_MUTE_SET,VP_SET_OFF)
  }
  ELSE
     CALL 'PANVP00F' (PROJ,VP_VIDEO_MUTE_SET,VP_SET_OFF)
  OFF[SVID_FLAG]
  OFF[RG1_FLAG]
  OFF[RG2_FLAG]
}
IF (VID_FLAG)
{
  IF (CONDITION = 2)
  {
     CALL 'PANVP00F' (PROJ,VP_VIDEO1,VP_SET_ON)
     OFF[VID_FLAG]
  }
}

PUSH[TP,14]                        (* S-VIDEO INPUT SELECT *)
{
  IF ((CONDITION = 0) || (CONDITION = 3))
  {
     CALL 'PANVP00F' (PROJ,VP_POWER_SET,VP_SET_ON)
     WAIT 70 CALL 'PANVP00F' (PROJ,VP_VIDEO_MUTE_SET,VP_SET_OFF)
     ON[SVID_FLAG]
  }
  ELSE
     CALL 'PANVP00F' (PROJ,VP_VIDEO_MUTE_SET,VP_SET_OFF)
  OFF[VID_FLAG]
  OFF[RG1_FLAG]
  OFF[RG2_FLAG]
}
IF (SVID_FLAG)
{
  IF (CONDITION = 2)
  {
     CALL 'PANVP00F' (PROJ,VP_VIDEO2,VP_SET_ON)
     OFF[SVID_FLAG]
  }
}


PUSH[TP,15]                        (* RGB1 INPUT SELECT    *)
{
  IF ((CONDITION = 0) || (CONDITION = 3))
  {
     CALL 'PANVP00F' (PROJ,VP_POWER_SET,VP_SET_ON)
     WAIT 70 CALL 'PANVP00F' (PROJ,VP_VIDEO_MUTE_SET,VP_SET_OFF)
     ON[RG1_FLAG]
  }
  ELSE
     CALL 'PANVP00F' (PROJ,VP_VIDEO_MUTE_SET,VP_SET_OFF)
  OFF[VID_FLAG]
  OFF[SVID_FLAG]
  OFF[RG2_FLAG]
}
IF (RG1_FLAG)
{
  IF (CONDITION = 2)
  {
     CALL 'PANVP00F' (PROJ,VP_RGB1,VP_SET_ON)
     OFF[RG1_FLAG]
  }
}


PUSH[TP,16]                        (* RGB2 INPUT SELECT    *)
{
  IF ((CONDITION = 0) || (CONDITION = 3))
  {
     CALL 'PANVP00F' (PROJ,VP_POWER_SET,VP_SET_ON)
     WAIT 70 CALL 'PANVP00F' (PROJ,VP_VIDEO_MUTE_SET,VP_SET_OFF)
     ON[RG2_FLAG]
  }
  ELSE
     CALL 'PANVP00F' (PROJ,VP_VIDEO_MUTE_SET,VP_SET_OFF)
  OFF[VID_FLAG]
  OFF[SVID_FLAG]
  OFF[RG1_FLAG]
}
IF (RG2_FLAG)
{
  IF (CONDITION = 2)
  {
     CALL 'PANVP00F' (PROJ,VP_RGB2,VP_SET_ON)
     OFF[RG2_FLAG]
  }
}


PUSH[TP,11]
{
  (* FUNCTION CALLS TO POWER ON AND THEN TURN MUTE ON *)
  IF ((CONDITION = 0) || (CONDITION = 3))
  {
     CALL 'PANVP00F' (PROJ,VP_POWER_SET,VP_SET_ON)
     ON[CON_FLAG]
  }
}

IF (CON_FLAG)
{
  IF (CONDITION = 2)
  {
     CALL 'PANVP00F' (PROJ,VP_VIDEO_MUTE_SET,VP_SET_ON)
     OFF[CON_FLAG]
  }
}


(* FUNCTION CALLS THAT ALLOW FOR VOLUME RAMPING *)
IF (VOL_UP_FLAG)
    CALL 'PANVP00F' (PROJ,VP_VOLUME_SET,VP_INCREASE)

IF (VOL_DN_FLAG)
    CALL 'PANVP00F' (PROJ,VP_VOLUME_SET,VP_DECREASE)

(* FUNCTION CALLS FOR CURSORS THAT ALLOW FOR RAMPING AFTER 4 SECONDS *)
IF (CURSOR_UP_FLAG)
{
    WAIT 5 'Up Wait' CALL 'PANVP00F' (PROJ,VP_CURSOR_UP,VP_SET_TOGGLE)
    COUNTER1 = COUNTER1 + 1
    IF (COUNTER1 >= 80) CALL 'PANVP00F' (PROJ,VP_CURSOR_UP,VP_SET_TOGGLE)
}
ELSE COUNTER1 = 0

IF (CURSOR_DN_FLAG)
{
    WAIT 5 'Down Wait' CALL 'PANVP00F' (PROJ,VP_CURSOR_DN,VP_SET_TOGGLE)
    COUNTER2 = COUNTER2 + 1
    IF (COUNTER2 >= 80) CALL 'PANVP00F' (PROJ,VP_CURSOR_DN,VP_SET_TOGGLE)
}
ELSE COUNTER2 = 0

IF (CURSOR_LT_FLAG)
{
    WAIT 5 'Left Wait' CALL 'PANVP00F' (PROJ,VP_CURSOR_LT,VP_SET_TOGGLE)
    COUNTER3 = COUNTER3 + 1
    IF (COUNTER3 >= 80) CALL 'PANVP00F' (PROJ,VP_CURSOR_LT,VP_SET_TOGGLE)
}
ELSE COUNTER3 = 0

IF (CURSOR_RT_FLAG)
{
    WAIT 5 'Right Wait' CALL 'PANVP00F' (PROJ,VP_CURSOR_RT,VP_SET_TOGGLE)
    COUNTER4 = COUNTER4 + 1
    IF (COUNTER4 >= 80) CALL 'PANVP00F' (PROJ,VP_CURSOR_RT,VP_SET_TOGGLE)
}
ELSE COUNTER4 = 0

(* ADDS LAMP STATUS REQUESTS TO THE QUEUE *)
WAIT 10 'Get Projector Status'
{
   CALL 'Add To Projector Queue' ("$02,'Q$S',$03")
   CALL 'Add To Projector Queue' ("$02,'QLS',$03")
}

(* TAKES STRING OFF TOP OF QUEUE AND SENDS IT TO PROJECTOR *)
IF (PROJ_READY && LENGTH_STRING(PROJ_Q))
{
   PROJ_READY = 0
   WAIT 5 PROJ_READY = 1
   PROJ_STRING = REMOVE_STRING(PROJ_Q,"$03",1)
   SELECT
   {
      ACTIVE (FIND_STRING(PROJ_STRING,'Q$S',1)) : PROJ_CMD = LAMP_COND_QUERY
      ACTIVE (FIND_STRING(PROJ_STRING,'QLS',1)) : PROJ_CMD = LAMP_CHECK_QUERY
   }
   SEND_STRING PROJ,"PROJ_STRING"
}

(* BUFFER PROCESSING FROM PROJECTOR TO SEND COMMANDS TO TP *)
TEMP_PROJ_BUFFER = REMOVE_STRING(PROJ_BUFFER,"$03",1)
IF (LENGTH_STRING(TEMP_PROJ_BUFFER) && ![PROJ,VP_BUSY])
{
   SELECT
   {
      ACTIVE (PROJ_CMD = LAMP_COND_QUERY) :
      {
         CONDITION = ATOI(TEMP_PROJ_BUFFER)
         SELECT
         {
            ACTIVE (CONDITION = 0) :
            {
               (* LAMP CONDITION IN STANDBY MODE *)
                 SEND_COMMAND TP,"'!T',1,'Standby'"
            }
            ACTIVE (CONDITION = 1) :
            {
               (* CONDITION IS LAMP ON CONTROL ACTIVE MODE *)
               SEND_COMMAND TP,"'!T',1,'Lamp ON control active'"
            }
            ACTIVE (CONDITION = 2) :
            {
               (* CONDITION IS LAMP ON MODE *)
               SEND_COMMAND TP,"'!T',1,'Lamp ON'"
            }
            ACTIVE (CONDITION = 3) :
            {
               (* CONDITION IS LAMP OFF CONTROL ACTIVE MODE *)
               SEND_COMMAND TP,"'!T',1,'Lamp OFF control active'"
            }
            ACTIVE (CONDITION = 401) : SEND_COMMAND TP,"'!T',1,'ERROR'"
         }
      }
      ACTIVE (PROJ_CMD = LAMP_CHECK_QUERY) :
      {
         CHECK = ATOI(TEMP_PROJ_BUFFER)
         SELECT
         {
            ACTIVE (CHECK = 0) :
            {
               (* CHECK RETURNS THAT BOTH LAMPS ARE OFF *)
               SEND_COMMAND TP,"'!T',2,'Both lamps 1 and 2 are OFF'"
            }
            ACTIVE (CHECK = 1) :
            {
               (* CHECK RETURNS THAT ONLY LAMP 1 IS ON *)
               SEND_COMMAND TP,"'!T',2,'Only lamp 1 is ON'"
            }
            ACTIVE (CHECK = 2) :
            {
               (* CHECK RETURNS THAT ONLY LAMP 2 IS ON *)
               SEND_COMMAND TP,"'!T',2,'Only lamp 2 is ON'"
            }
            ACTIVE (CHECK = 3) :
            {
               (* CHECK RETURNS THAT BOTH LAMPS ARE ON *)
               SEND_COMMAND TP,"'!T',2,'Both lamps 1 and 2 are ON'"
            }
            ACTIVE (CHECK = 401) : SEND_COMMAND TP,"'!T',2,'ERROR'"
         }
      }
      ACTIVE (1) : SEND_COMMAND TP,"'!T',1,'ERROR'"
   }
   TEMP_PROJ_BUFFER = ''
}



(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

