(*********************************************************************)
(*  AMX Corporation                                                  *)
(*  Copyright (c) 2004-2006 AMX Corporation. All rights reserved.    *)
(*********************************************************************)
(* Copyright Notice :                                                *)
(*    Copyright, AMX, Inc., 2004-2006                                *)
(*    Private, proprietary information, the sole property of AMX.    *)
(*    The contents, ideas, and concepts expressed herein are not to  *)
(*    be disclosed except within the confines of a confidential      *)
(*    relationship and only then on a need to know basis.            *)
(*********************************************************************)
PROGRAM_NAME='G4APIConstants'
(***********************************************************)
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)
#IF_NOT_DEFINED __G4API_CONST__
#DEFINE __G4API_CONST__
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT // G4API Version

CHAR G4API_AXI_VERSION[]    = '1.8'

(***********************************************************)
(*                        Amplifier                        *)
(***********************************************************)
DEFINE_CONSTANT // Amplifier Channels/Levels/Variable Text

// Amplifier Channels
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_VOL_UP                     = 24    // Button:  Ramp volume up (Channel FB)
BTN_VOL_DN                     = 25    // Button:  Ramp volume down (Channel FB)
BTN_VOL_MUTE                   = 26    // Button:  Cycle volume mute (Channel FB)

// Amplifier Levels
LVL_VOL                        = 1     // Level:   Volume level (0-255)

(***********************************************************)
(*                    Audio Conferencer                    *)
(***********************************************************)
DEFINE_CONSTANT // Audio Conferencer Channels/Levels/Variable Text

// Audio Conferencer Channels
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_DIGIT_0                    = 10    // Button:  Press menu button digit 0 (Momentary FB)
BTN_DIGIT_1                    = 11    // Button:  Press menu button digit 1 (Momentary FB)
BTN_DIGIT_2                    = 12    // Button:  Press menu button digit 2 (Momentary FB)
BTN_DIGIT_3                    = 13    // Button:  Press menu button digit 3 (Momentary FB)
BTN_DIGIT_4                    = 14    // Button:  Press menu button digit 4 (Momentary FB)
BTN_DIGIT_5                    = 15    // Button:  Press menu button digit 5 (Momentary FB)
BTN_DIGIT_6                    = 16    // Button:  Press menu button digit 6 (Momentary FB)
BTN_DIGIT_7                    = 17    // Button:  Press menu button digit 7 (Momentary FB)
BTN_DIGIT_8                    = 18    // Button:  Press menu button digit 8 (Momentary FB)
BTN_DIGIT_9                    = 19    // Button:  Press menu button digit 9 (Momentary FB)
BTN_MENU_ENTER                 = 21    // Button:  Press menu button enter (Momentary FB)
BTN_VOL_UP                     = 24    // Button:  Ramp volume up (Channel FB)
BTN_VOL_DN                     = 25    // Button:  Ramp volume down (Channel FB)
BTN_VOL_MUTE                   = 26    // Button:  Cycle volume mute (Channel FB)
BTN_MENU_CANCEL                = 43    // Button:  Press menu button cancel (Momentary FB)
BTN_MENU_FUNC                  = 44    // Button:  Press menu button menu (Momentary FB)
BTN_MENU_UP                    = 45    // Button:  Press menu up button (Momentary FB)
BTN_MENU_DN                    = 46    // Button:  Press menu down button (Momentary FB)
BTN_MENU_LT                    = 47    // Button:  Press menu left button (Momentary FB)
BTN_MENU_RT                    = 48    // Button:  Press menu right button (Momentary FB)
BTN_MENU_SELECT                = 49    // Button:  Press Select - Select Menu Item (Momentary FB)
BTN_MENU_EXIT                  = 50    // Button:  Press menu button exit (Momentary FB)
BTN_MENU_ACCEPT                = 60    // Button:  Press menu button accept (Momentary FB)
BTN_MENU_CLEAR                 = 80    // Button:  Press menu button clear (Momentary FB)
BTN_MENU_HOLD                  = 85    // Button:  Press menu button hold (Momentary FB)
BTN_MENU_LT_PAREN              = 87    // Button:  Press menu button left paren (Momentary FB)
BTN_MENU_RT_PAREN              = 88    // Button:  Press menu button right paren (Momentary FB)
BTN_MENU_UNDERSCORE            = 89    // Button:  Press menu button underscore (Momentary FB)
BTN_MENU_DASH                  = 90    // Button:  Press menu button dash (Momentary FB)
BTN_MENU_ASTERISK              = 91    // Button:  Press menu button asterisk (Momentary FB)
BTN_MENU_DOT                   = 92    // Button:  Press menu button dot (Momentary FB)
BTN_MENU_POUND                 = 93    // Button:  Press menu button pound (Momentary FB)
BTN_MENU_COMMA                 = 94    // Button:  Press menu button comma (Momentary FB)
BTN_MENU_DIAL                  = 95    // Button:  Press menu button dial (Momentary FB)
BTN_MENU_CONFERENCE            = 96    // Button:  Press menu button conference (Momentary FB)
BTN_MENU_RETURN                = 104   // Button:  Press menu button return (Momentary FB)
BTN_MENU_HELP                  = 113   // Button:  Press menu button help (Momentary FB)
BTN_ACONF_PRIVACY              = 145   // Button:  Cycle privacy (Momentary FB)
BTN_ACONF_TRAIN                = 147   // Button:  Execute train (Momentary FB)
BTN_DIAL_REDIAL                = 201   // Button:  Redial (Momentary FB)
BTN_DIAL_OFF_HOOK              = 202   // Button:  Cycle off hook state (Channel FB)
BTN_MENU_FLASH                 = 203   // Button:  Press menu button flash (Momentary FB)
BTN_DIAL_AUTO_ANSWER           = 204   // Button:  Cycle auto answer state (Channel FB)
BTN_DIAL_AUDIBLE_RING          = 205   // Button:  Cycle audible ring state (Channel FB)
BTN_PHONEBOOK_NEXT             = 401   // Button:  Next Page (Momentary FB)
BTN_PHONEBOOK_PREV             = 402   // Button:  Previous Page (Momentary FB)
BTN_PHONEBOOK_DIAL             = 407   // Button:  Dial the selected item (Momentary FB)

#IF_NOT_DEFINED BTN_DIAL_LIST
INTEGER BTN_DIAL_LIST[]        =       // Group:   Speed dial (Momentary FB)
{
  341,  342,  343,  344,  345,
  346,  347,  348,  349,  350,
  351,  352,  353,  354,  355,
  356,  357,  358,  359,  360
}
#END_IF // BTN_DIAL_LIST

#IF_NOT_DEFINED BTN_PHONEBOOK_LIST
INTEGER BTN_PHONEBOOK_LIST[]   =       // Group:   Select Phonebook item (Channel FB)
{
  391,  392,  393,  394,  395,
  396,  397,  398,  399,  400
}
#END_IF // BTN_PHONEBOOK_LIST

// Audio Conferencer Levels
LVL_VOL                        = 1     // Level:   Volume level (0-255)

// Audio Conferencer Variable Text
TXT_DIAL_NUMBER                = 19    // Text:    Incoming call number
TXT_DIAL_CALL_PROGRESS         = 20    // Text:    Call progress
TXT_PHONEBOOK_NAME             = 178   // Text:    Phonebook Name
TXT_PHONEBOOK_NUMBER           = 179   // Text:    Phonebook Number
TXT_PHONEBOOK_LIST_STATUS      = 180   // Text:    Phonebook List Status (total records)

#IF_NOT_DEFINED TXT_PHONEBOOK_LIST
INTEGER TXT_PHONEBOOK_LIST[]   =       // Text:    Phonebook List
{
  181,  182,  183,  184,  185,
  186,  187,  188,  189,  190
}
#END_IF // TXT_PHONEBOOK_LIST

(***********************************************************)
(*                       Audio Mixer                       *)
(***********************************************************)
DEFINE_CONSTANT // Audio Mixer Channels/Levels/Variable Text

// Audio Mixer Channels
BTN_VOL_UP                     = 24    // Button:  Ramp volume up (Channel FB)
BTN_VOL_DN                     = 25    // Button:  Ramp volume down (Channel FB)
BTN_VOL_MUTE                   = 26    // Button:  Cycle volume mute (Channel FB)
BTN_GAIN_UP                    = 140   // Button:  Ramp gain up (Channel FB)
BTN_GAIN_DN                    = 141   // Button:  Ramp gain down (Channel FB)
BTN_GAIN_MUTE                  = 144   // Button:  Cycle gain mute (Channel FB)
BTN_MIXER_XPOINT_MUTE          = 256   // Button:  Cycle crosspoint mute (Channel FB)
BTN_SWT_TAKE                   = 257   // Button:  Take switch (Momentary FB)
BTN_MIXER_XPOINT_UP            = 258   // Button:  Crosspoint value up (Momentary FB)
BTN_MIXER_XPOINT_DN            = 259   // Button:  Crosspoint value down (Momentary FB)
BTN_MIXER_PRESET_SAVE          = 260   // Button:  Save Mixer preset (Channel FB)

#IF_NOT_DEFINED BTN_MIXER_PRESET
INTEGER BTN_MIXER_PRESET[]     =       // Group:   Recall Mixer preset (Channel FB)
{
  261,  262,  263,  264,  265,
  266,  267,  268,  269,  270,
  271,  272,  273,  274,  275,
  276,  277,  278,  279,  280
}
#END_IF // BTN_MIXER_PRESET

#IF_NOT_DEFINED BTN_MIXER_INPUT
INTEGER BTN_MIXER_INPUT[]      =       // Group:   Input for crosspoint/switch (Channel FB)
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // BTN_MIXER_INPUT

#IF_NOT_DEFINED BTN_MIXER_OUTPUT
INTEGER BTN_MIXER_OUTPUT[]     =       // Group:   Output for crosspoint/switch (Channel FB)
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // BTN_MIXER_OUTPUT

// Audio Mixer Levels
LVL_VOL                        = 1     // Level:   Volume level (0-255)
LVL_GAIN                       = 5     // Level:   Gain level (0-255)
LVL_MIXER_XPOINT_SET           = 8     // Level:   Crosspoint level

(***********************************************************)
(*                     Audio Processor                     *)
(***********************************************************)
DEFINE_CONSTANT // Audio Processor Channels/Levels/Variable Text

// Audio Processor Channels
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_APROC_XPOINT_UP            = 24    // Button:  Crosspoint value up (Momentary FB)
BTN_APROC_XPOINT_DN            = 25    // Button:  Crosspoint value down (Momentary FB)
BTN_APROC_XPOINT_MUTE          = 26    // Button:  Cycle crosspint mute (Channel FB)
BTN_SWT_TAKE                   = 257   // Button:  Take switch (Momentary FB)
BTN_APROC_PRESET_SAVE          = 260   // Button:  Save Audio Processor preset (Channel FB)

#IF_NOT_DEFINED BTN_APROC_PRESET
INTEGER BTN_APROC_PRESET[]     =       // Group:   Recall Audio Processor preset (Channel FB)
{
  261,  262,  263,  264,  265,
  266,  267,  268,  269,  270,
  271,  272,  273,  274,  275,
  276,  277,  278,  279,  280
}
#END_IF // BTN_APROC_PRESET

#IF_NOT_DEFINED BTN_APROC_INPUT
INTEGER BTN_APROC_INPUT[]      =       // Group:   Input for crosspoint/switch (Channel FB)
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // BTN_APROC_INPUT

#IF_NOT_DEFINED BTN_APROC_OUTPUT
INTEGER BTN_APROC_OUTPUT[]     =       // Group:   Output for crosspoint/switch (Channel FB)
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // BTN_APROC_OUTPUT

// Audio Processor Levels
LVL_APROC_XPOINT_SET           = 8     // Level:   Crosspoint level

(***********************************************************)
(*                        Audio Tape                       *)
(***********************************************************)
DEFINE_CONSTANT // Audio Tape Channels/Levels/Variable Text

// Audio Tape Channels
BTN_PLAY                       = 1     // Button:  Play (Channel FB)
BTN_STOP                       = 2     // Button:  Stop (Channel FB)
BTN_PAUSE                      = 3     // Button:  Pause (Channel FB)
BTN_FFWD                       = 4     // Button:  Fast forward (Channel FB)
BTN_REW                        = 5     // Button:  Rewind (Channel FB)
BTN_SFWD                       = 6     // Button:  Search forward (Channel FB)
BTN_SREV                       = 7     // Button:  Search reverse (Channel FB)
BTN_RECORD                     = 8     // Button:  Record (Channel FB)
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_CASS_TAPE_SIDE             = 42    // Button:  Cycle the audio tape side (Momentary FB)
BTN_SEARCH_SPEED               = 119   // Button:  Cycle search speed (Momentary FB)
BTN_EJECT                      = 120   // Button:  Eject tape (Momentary FB)
BTN_RESET_COUNTER              = 121   // Button:  Reset counter (Momentary FB)
BTN_SLOW_FWD                   = 188   // Button:  Slow forward (Channel FB)
BTN_SLOW_REV                   = 189   // Button:  Slow reverse (Channel FB)

// Audio Tape Variable Text
TXT_TAPE_COUNTER               = 11    // Text:    Tape Counter

(***********************************************************)
(*                    Audio Tuner Device                   *)
(***********************************************************)
DEFINE_CONSTANT // Audio Tuner Device Channels/Levels/Variable Text

// Audio Tuner Device Channels
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_DIGIT_0                    = 10    // Button:  Press menu button digit 0 (Momentary FB)
BTN_DIGIT_1                    = 11    // Button:  Press menu button digit 1 (Momentary FB)
BTN_DIGIT_2                    = 12    // Button:  Press menu button digit 2 (Momentary FB)
BTN_DIGIT_3                    = 13    // Button:  Press menu button digit 3 (Momentary FB)
BTN_DIGIT_4                    = 14    // Button:  Press menu button digit 4 (Momentary FB)
BTN_DIGIT_5                    = 15    // Button:  Press menu button digit 5 (Momentary FB)
BTN_DIGIT_6                    = 16    // Button:  Press menu button digit 6 (Momentary FB)
BTN_DIGIT_7                    = 17    // Button:  Press menu button digit 7 (Momentary FB)
BTN_DIGIT_8                    = 18    // Button:  Press menu button digit 8 (Momentary FB)
BTN_DIGIT_9                    = 19    // Button:  Press menu button digit 9 (Momentary FB)
BTN_MENU_ENTER                 = 21    // Button:  Press menu button enter (Momentary FB)
BTN_CHAN_UP                    = 22    // Button:  Go to next Station Preset (Momentary FB)
BTN_CHAN_DN                    = 23    // Button:  Go to prev Station Preset (Momentary FB)
BTN_TUNER_BAND                 = 40    // Button:  Cycle tuner band  (Momentary FB)
BTN_MENU_CLEAR                 = 80    // Button:  Press menu button clear (Momentary FB)
BTN_MENU_DOT                   = 92    // Button:  Press menu button digit . (Momentary FB)
BTN_TUNER_PRESET_GROUP         = 224   // Button:  Cycle station preset group (Momentary FB)
BTN_TUNER_STATION_UP           = 225   // Button:  Increment Channel (Momentary FB)
BTN_TUNER_STATION_DN           = 226   // Button:  Decrement Channel (Momentary FB)
BTN_TUNER_SCAN_FWD             = 227   // Button:  Station scan forward (Momentary FB)
BTN_TUNER_SCAN_REV             = 228   // Button:  Station scan backward/reverse (Momentary FB)
BTN_TUNER_SEEK_FWD             = 229   // Button:  Station seek forward (Momentary FB)
BTN_TUNER_SEEK_REV             = 230   // Button:  Station seek backward/reverse (Momentary FB)
BTN_TUNER_PREV                 = 235   // Button:  Goto previous tuner station (Momentary FB)

// Audio Tuner Device Variable Text
TXT_TUNER_STATION              = 16    // Text:    Station
TXT_TUNER_BAND                 = 17    // Text:    Tuner Band

(***********************************************************)
(*                          Camera                         *)
(***********************************************************)
DEFINE_CONSTANT // Camera Channels/Levels/Variable Text

// Camera Channels
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_TILT_UP                    = 132   // Button:  Ramp tilt up (Channel FB)
BTN_TILT_DN                    = 133   // Button:  Ramp tilt down (Channel FB)
BTN_PAN_LT                     = 134   // Button:  Ramp pan left (Channel FB)
BTN_PAN_RT                     = 135   // Button:  Ramp pan right (Channel FB)
BTN_ZOOM_OUT                   = 158   // Button:  Ramp zoom out (Channel FB)
BTN_ZOOM_IN                    = 159   // Button:  Ramp zoom in (Channel FB)
BTN_FOCUS_NEAR                 = 160   // Button:  Ramp focus near (Channel FB)
BTN_FOCUS_FAR                  = 161   // Button:  Ramp focus far (Channel FB)
BTN_AUTO_FOCUS                 = 172   // Button:  Cycle auto focus (Channel FB)
BTN_AUTO_IRIS                  = 173   // Button:  Cycle auto iris (Channel FB)
BTN_IRIS_OPEN                  = 174   // Button:  Ramp iris open (Channel FB)
BTN_IRIS_CLOSE                 = 175   // Button:  Ramp iris closed (Channel FB)
BTN_CAM_PRESET_SAVE            = 260   // Button:  Save Camera preset (Channel FB)

#IF_NOT_DEFINED BTN_CAM_PRESET
INTEGER BTN_CAM_PRESET[]       =       // Group:   Recall Camera preset (Channel FB)
{
  261,  262,  263,  264,  265,
  266,  267,  268,  269,  270,
  271,  272,  273,  274,  275,
  276,  277,  278,  279,  280
}
#END_IF // BTN_CAM_PRESET

(***********************************************************)
(*                  Digital Media Decoder                  *)
(***********************************************************)
DEFINE_CONSTANT // Digital Media Decoder Channels/Levels/Variable Text

// Digital Media Decoder Channels
BTN_PLAY                       = 1     // Button:  Play (Channel FB)
BTN_STOP                       = 2     // Button:  Stop (Channel FB)
BTN_PAUSE                      = 3     // Button:  Pause (Channel FB)
BTN_FFWD                       = 4     // Button:  Goto the next track (Momentary FB)
BTN_REW                        = 5     // Button:  Goto the previous track (Momentary FB)
BTN_SFWD                       = 6     // Button:  Scan forward (Channel FB)
BTN_SREV                       = 7     // Button:  Scan reverse (Channel FB)
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_DIGIT_0                    = 10    // Button:  Press menu button digit 0 (Momentary FB)
BTN_DIGIT_1                    = 11    // Button:  Press menu button digit 1 (Momentary FB)
BTN_DIGIT_2                    = 12    // Button:  Press menu button digit 2 (Momentary FB)
BTN_DIGIT_3                    = 13    // Button:  Press menu button digit 3 (Momentary FB)
BTN_DIGIT_4                    = 14    // Button:  Press menu button digit 4 (Momentary FB)
BTN_DIGIT_5                    = 15    // Button:  Press menu button digit 5 (Momentary FB)
BTN_DIGIT_6                    = 16    // Button:  Press menu button digit 6 (Momentary FB)
BTN_DIGIT_7                    = 17    // Button:  Press menu button digit 7 (Momentary FB)
BTN_DIGIT_8                    = 18    // Button:  Press menu button digit 8 (Momentary FB)
BTN_DIGIT_9                    = 19    // Button:  Press menu button digit 9 (Momentary FB)
BTN_MENU_ENTER                 = 21    // Button:  Press menu button enter (Momentary FB)
BTN_VOL_UP                     = 24    // Button:  Ramp volume up (Channel FB)
BTN_VOL_DN                     = 25    // Button:  Ramp volume down (Channel FB)
BTN_VOL_MUTE                   = 26    // Button:  Cycle volume mute (Channel FB)
BTN_MENU_CANCEL                = 43    // Button:  Press menu button cancel (Momentary FB)
BTN_MENU_FUNC                  = 44    // Button:  Press menu button menu (Momentary FB)
BTN_MENU_UP                    = 45    // Button:  Press menu up button (Momentary FB)
BTN_MENU_DN                    = 46    // Button:  Press menu down button (Momentary FB)
BTN_MENU_LT                    = 47    // Button:  Press menu left button (Momentary FB)
BTN_MENU_RT                    = 48    // Button:  Press menu right button (Momentary FB)
BTN_MENU_SELECT                = 49    // Button:  Press Select - Select Menu Item (Momentary FB)
BTN_MENU_EXIT                  = 50    // Button:  Press menu button exit (Momentary FB)
BTN_MENU_BACK                  = 81    // Button:  Press menu button back (Momentary FB)
BTN_MENU_DISPLAY               = 99    // Button:  Press menu button display (Momentary FB)
BTN_MENU_SUBTITLE              = 100   // Button:  Press menu button subtitle (Momentary FB)
BTN_MENU_INFO                  = 101   // Button:  Press menu button info (Momentary FB)
BTN_MENU_RETURN                = 104   // Button:  Press menu button return (Momentary FB)
BTN_MENU_PAGE_UP               = 106   // Button:  Press menu button page up (Momentary FB)
BTN_MENU_PAGE_DN               = 107   // Button:  Press menu button page down (Momentary FB)
BTN_MENU_AB_REPEAT             = 112   // Button:  Press menu button AB repeat (Momentary FB)
BTN_MENU_HELP                  = 113   // Button:  Press menu button help (Momentary FB)
BTN_MENU_TITLE                 = 114   // Button:  Press menu button title (Momentary FB)
BTN_MENU_TOP_MENU              = 115   // Button:  Press menu button top menu (Momentary FB)
BTN_MENU_ZOOM                  = 116   // Button:  Press menu button zoom (Momentary FB)
BTN_MENU_ANGLE                 = 117   // Button:  Press menu button angle (Momentary FB)
BTN_MENU_AUDIO                 = 118   // Button:  Press menu button audio (Momentary FB)
BTN_MEDIA_RANDOM               = 124   // Button:  Cycle the random state (Momentary FB)
BTN_MEDIA_REPEAT               = 125   // Button:  Cycle the repeat state (Momentary FB)

// Digital Media Decoder Levels
LVL_VOL                        = 1     // Level:   Volume level (0-255)

// Digital Media Decoder Variable Text
TXT_MEDIA_COUNTER              = 9     // Text:    Media Counter
TXT_DISC_TRACK_COUNTER         = 10    // Text:    Track Counter
TXT_CURRENT_MEDIA_INFO         = 130   // Text:    Current media information

#IF_NOT_DEFINED TXT_TRACK_INFO
INTEGER TXT_TRACK_INFO[]       =       // Text:    Track info
{
   28,   29
}
#END_IF // TXT_TRACK_INFO

#IF_NOT_DEFINED TXT_TRACK_PROPERTIES
INTEGER TXT_TRACK_PROPERTIES[] =       // Text:    Track property keys
{
  131,  132,  133,  134,  135,
  136,  137,  138,  139,  140
}
#END_IF // TXT_TRACK_PROPERTIES

#IF_NOT_DEFINED TXT_TRACK_VALUES
INTEGER TXT_TRACK_VALUES[]     =       // Text:    Track property values
{
  141,  142,  143,  144,  145,
  146,  147,  148,  149,  150
}
#END_IF // TXT_TRACK_VALUES

#IF_NOT_DEFINED TXT_DECODE_PROPERTIES
INTEGER TXT_DECODE_PROPERTIES[]=       // Text:    Media property keys
{
  201,  202,  203,  204,  205,
  206,  207,  208,  209,  210
}
#END_IF // TXT_DECODE_PROPERTIES

#IF_NOT_DEFINED TXT_DECODE_VALUES
INTEGER TXT_DECODE_VALUES[]    =       // Text:    Media property values
{
  211,  212,  213,  214,  215,
  216,  217,  218,  219,  220
}
#END_IF // TXT_DECODE_VALUES

(***********************************************************)
(*                  Digital Media Encoder                  *)
(***********************************************************)
DEFINE_CONSTANT // Digital Media Encoder Channels/Levels/Variable Text

// Digital Media Encoder Channels
BTN_PLAY                       = 1     // Button:  Play (Channel FB)
BTN_STOP                       = 2     // Button:  Stop (Channel FB)
BTN_PAUSE                      = 3     // Button:  Pause (Channel FB)
BTN_FFWD                       = 4     // Button:  Goto the next track (Momentary FB)
BTN_REW                        = 5     // Button:  Goto the previous track (Momentary FB)
BTN_SFWD                       = 6     // Button:  Scan forward (Channel FB)
BTN_SREV                       = 7     // Button:  Scan reverse (Channel FB)
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_GAIN_UP                    = 140   // Button:  Ramp gain up (Channel FB)
BTN_GAIN_DN                    = 141   // Button:  Ramp gain down (Channel FB)
BTN_GAIN_MUTE                  = 144   // Button:  Cycle gain mute (Channel FB)

// Digital Media Encoder Levels
LVL_GAIN                       = 5     // Level:   Gain level (0-255)

// Digital Media Encoder Variable Text
TXT_DISC_TRACK_COUNTER         = 10    // Text:    Track Counter

#IF_NOT_DEFINED TXT_ENCODE_PROPERTIES
INTEGER TXT_ENCODE_PROPERTIES[]=       // Text:    Media property keys
{
  221,  222,  223,  224,  225,
  226,  227,  228,  229,  230
}
#END_IF // TXT_ENCODE_PROPERTIES

#IF_NOT_DEFINED TXT_ENCODE_VALUES
INTEGER TXT_ENCODE_VALUES[]    =       // Text:    Media property values
{
  231,  232,  233,  234,  235,
  236,  237,  238,  239,  240
}
#END_IF // TXT_ENCODE_VALUES

(***********************************************************)
(*                  Digital Media Server                   *)
(***********************************************************)
DEFINE_CONSTANT // Digital Media Server Channels/Levels/Variable Text

// Digital Media Server Channels
BTN_PLAY                       = 1     // Button:  Play (Channel FB)
BTN_STOP                       = 2     // Button:  Stop (Channel FB)
BTN_PAUSE                      = 3     // Button:  Pause (Channel FB)
BTN_FFWD                       = 4     // Button:  Goto the next track (Momentary FB)
BTN_REW                        = 5     // Button:  Goto the previous track (Momentary FB)
BTN_SFWD                       = 6     // Button:  Scan forward (Channel FB)
BTN_SREV                       = 7     // Button:  Scan reverse (Channel FB)
BTN_RECORD                     = 8     // Button:  Record (Channel FB)
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_DIGIT_0                    = 10    // Button:  Press menu button digit 0 (Momentary FB)
BTN_DIGIT_1                    = 11    // Button:  Press menu button digit 1 (Momentary FB)
BTN_DIGIT_2                    = 12    // Button:  Press menu button digit 2 (Momentary FB)
BTN_DIGIT_3                    = 13    // Button:  Press menu button digit 3 (Momentary FB)
BTN_DIGIT_4                    = 14    // Button:  Press menu button digit 4 (Momentary FB)
BTN_DIGIT_5                    = 15    // Button:  Press menu button digit 5 (Momentary FB)
BTN_DIGIT_6                    = 16    // Button:  Press menu button digit 6 (Momentary FB)
BTN_DIGIT_7                    = 17    // Button:  Press menu button digit 7 (Momentary FB)
BTN_DIGIT_8                    = 18    // Button:  Press menu button digit 8 (Momentary FB)
BTN_DIGIT_9                    = 19    // Button:  Press menu button digit 9 (Momentary FB)
BTN_MENU_ENTER                 = 21    // Button:  Press menu button enter (Momentary FB)
BTN_VOL_UP                     = 24    // Button:  Ramp volume up (Channel FB)
BTN_VOL_DN                     = 25    // Button:  Ramp volume down (Channel FB)
BTN_VOL_MUTE                   = 26    // Button:  Cycle volume mute (Channel FB)
BTN_MENU_CANCEL                = 43    // Button:  Press menu button cancel (Momentary FB)
BTN_MENU_FUNC                  = 44    // Button:  Press menu button menu (Momentary FB)
BTN_MENU_UP                    = 45    // Button:  Press menu up button (Momentary FB)
BTN_MENU_DN                    = 46    // Button:  Press menu down button (Momentary FB)
BTN_MENU_LT                    = 47    // Button:  Press menu left button (Momentary FB)
BTN_MENU_RT                    = 48    // Button:  Press menu right button (Momentary FB)
BTN_MENU_SELECT                = 49    // Button:  Press Select - Select Menu Item (Momentary FB)
BTN_MENU_EXIT                  = 50    // Button:  Press menu button exit (Momentary FB)
BTN_MENU_CLEAR                 = 80    // Button:  Press menu button clear (Momentary FB)
BTN_MENU_BACK                  = 81    // Button:  Press menu button back (Momentary FB)
BTN_MENU_DISPLAY               = 99    // Button:  Press menu button display (Momentary FB)
BTN_MENU_INFO                  = 101   // Button:  Press menu button info (Momentary FB)
BTN_MENU_RETURN                = 104   // Button:  Press menu button return (Momentary FB)
BTN_MENU_PAGE_UP               = 106   // Button:  Press menu button page up (Momentary FB)
BTN_MENU_PAGE_DN               = 107   // Button:  Press menu button page down (Momentary FB)
BTN_MENU_AB_REPEAT             = 112   // Button:  Press menu button AB repeat (Momentary FB)
BTN_MENU_HELP                  = 113   // Button:  Press menu button help (Momentary FB)
BTN_MENU_TITLE                 = 114   // Button:  Press menu button title (Momentary FB)
BTN_MENU_TOP_MENU              = 115   // Button:  Press menu button top menu (Momentary FB)
BTN_MENU_ZOOM                  = 116   // Button:  Press menu button zoom (Momentary FB)
BTN_MENU_AUDIO                 = 118   // Button:  Press menu button audio (Momentary FB)
BTN_MEDIA_RANDOM               = 124   // Button:  Cycle the random state (Momentary FB)
BTN_MEDIA_REPEAT               = 125   // Button:  Cycle the repeat state (Momentary FB)
BTN_GAIN_UP                    = 140   // Button:  Ramp gain up (Channel FB)
BTN_GAIN_DN                    = 141   // Button:  Ramp gain down (Channel FB)
BTN_GAIN_MUTE                  = 144   // Button:  Cycle gain mute (Channel FB)
BTN_MEDIADB_NEXT               = 401   // Button:  Next Page (Momentary FB)
BTN_MEDIADB_PREV               = 402   // Button:  Previous Page (Momentary FB)
BTN_MEDIADB_SELECT             = 405   // Button:  Select Media DB item (Momentary FB)
BTN_MEDIADB_BACK               = 406   // Button:  Navigate up the tree (Momentary FB)
BTN_MEDIADB_PLAY               = 407   // Button:  Play the selected item (Momentary FB)
BTN_MEDIADB_SEARCH             = 410   // Button:  Search (Momentary FB)
BTN_MEDIADB_SEARCH_ALL         = 411   // Button:  Search all columns (Channel FB)
BTN_MEDIADB_SEARCH_ARTIST      = 412   // Button:  Search by Artist (Channel FB)
BTN_MEDIADB_SEARCH_GENRE       = 413   // Button:  Search by Genre (Channel FB)
BTN_MEDIADB_SEARCH_TITLE       = 414   // Button:  Search by Title (Channel FB)
BTN_MEDIADB_SEARCH_KEYWORDS    = 415   // Button:  Search by Keywords (Channel FB)
BTN_MEDIADB_SEARCH_BOOKMARK    = 416   // Button:  Search by Bookmark (Channel FB)
BTN_MEDIADB_SEARCH_TEXT        = 420   // Button:  Search text (Momentary FB)
BTN_MEDIADB_RETURN_ALL         = 421   // Button:  Return all types (Channel FB)
BTN_MEDIADB_RETURN_PICTURE     = 422   // Button:  Return pictures (Channel FB)
BTN_MEDIADB_RETURN_APPLICATION = 423   // Button:  Return applications (Channel FB)
BTN_MEDIADB_RETURN_TRACK       = 424   // Button:  Return tracks (Channel FB)
BTN_MEDIADB_RETURN_CHAPTER     = 425   // Button:  Return chapters (Channel FB)
BTN_MEDIADB_RETURN_PLAYLIST    = 426   // Button:  Return playlists (Channel FB)
BTN_MEDIADB_RETURN_BOOKMARK    = 427   // Button:  Return bookmarks (Channel FB)
BTN_MEDIADB_RETURN_DISC        = 428   // Button:  Return discs (Channel FB)
BTN_MEDIADB_RETURN_AUDIO       = 429   // Button:  Return audio items (Channel FB)
BTN_MEDIADB_RETURN_VIDEO       = 430   // Button:  Return video items (Channel FB)
BTN_MEDIADB_RETURN_GENRE       = 431   // Button:  Return genres (Channel FB)
BTN_MEDIADB_RETURN_ARTIST      = 432   // Button:  Return artists (Channel FB)
BTN_MEDIADB_RETURN_STATION     = 433   // Button:  Return stations (Channel FB)

#IF_NOT_DEFINED BTN_MEDIADB_PROPERTIES
INTEGER BTN_MEDIADB_PROPERTIES[]=      // Group:   Select a property (Momentary FB)
{
  381,  382,  383,  384,  385,
  386,  387,  388,  389,  390
}
#END_IF // BTN_MEDIADB_PROPERTIES

#IF_NOT_DEFINED BTN_MEDIADB_LIST
INTEGER BTN_MEDIADB_LIST[]     =       // Group:   Select Media DB item (Channel FB)
{
  391,  392,  393,  394,  395,
  396,  397,  398,  399,  400
}
#END_IF // BTN_MEDIADB_LIST

// Digital Media Server Levels
LVL_VOL                        = 1     // Level:   Volume level (0-255)
LVL_GAIN                       = 5     // Level:   Gain level (0-255)

// Digital Media Server Variable Text
TXT_MEDIA_COUNTER              = 9     // Text:    Media Counter
TXT_DISC_TRACK_COUNTER         = 10    // Text:    Track Counter
TXT_CURRENT_MEDIA_INFO         = 130   // Text:    Current media information
TXT_MEDIADB_SEARCH_CUR_ITEM    = 174   // Text:    Current item
TXT_MEDIADB_SEARCH_TEXT        = 175   // Text:    Search text
TXT_MEDIADB_SEARCH             = 176   // Text:    Search type
TXT_MEDIADB_RETURN             = 177   // Text:    Return type
TXT_MEDIADB_LIST_STATUS        = 180   // Text:    Media List Status (total records)

#IF_NOT_DEFINED TXT_TRACK_INFO
INTEGER TXT_TRACK_INFO[]       =       // Text:    Track info
{
   28,   29
}
#END_IF // TXT_TRACK_INFO

#IF_NOT_DEFINED TXT_TRACK_PROPERTIES
INTEGER TXT_TRACK_PROPERTIES[] =       // Text:    Track property keys
{
  131,  132,  133,  134,  135,
  136,  137,  138,  139,  140
}
#END_IF // TXT_TRACK_PROPERTIES

#IF_NOT_DEFINED TXT_TRACK_VALUES
INTEGER TXT_TRACK_VALUES[]     =       // Text:    Track property values
{
  141,  142,  143,  144,  145,
  146,  147,  148,  149,  150
}
#END_IF // TXT_TRACK_VALUES

#IF_NOT_DEFINED TXT_MEDIADB_PROPERTIES
INTEGER TXT_MEDIADB_PROPERTIES[]=      // Text:    Media DB property keys
{
  151,  152,  153,  154,  155,
  156,  157,  158,  159,  160
}
#END_IF // TXT_MEDIADB_PROPERTIES

#IF_NOT_DEFINED TXT_MEDIADB_VALUES
INTEGER TXT_MEDIADB_VALUES[]   =       // Text:    Media DB property values
{
  161,  162,  163,  164,  165,
  166,  167,  168,  169,  170
}
#END_IF // TXT_MEDIADB_VALUES

#IF_NOT_DEFINED TXT_MEDIADB_LIST
INTEGER TXT_MEDIADB_LIST[]     =       // Text:    Media List
{
  181,  182,  183,  184,  185,
  186,  187,  188,  189,  190
}
#END_IF // TXT_MEDIADB_LIST

#IF_NOT_DEFINED TXT_DECODE_PROPERTIES
INTEGER TXT_DECODE_PROPERTIES[]=       // Text:    Media property keys
{
  201,  202,  203,  204,  205,
  206,  207,  208,  209,  210
}
#END_IF // TXT_DECODE_PROPERTIES

#IF_NOT_DEFINED TXT_DECODE_VALUES
INTEGER TXT_DECODE_VALUES[]    =       // Text:    Media property values
{
  211,  212,  213,  214,  215,
  216,  217,  218,  219,  220
}
#END_IF // TXT_DECODE_VALUES

#IF_NOT_DEFINED TXT_ENCODE_PROPERTIES
INTEGER TXT_ENCODE_PROPERTIES[]=       // Text:    Media property keys
{
  221,  222,  223,  224,  225,
  226,  227,  228,  229,  230
}
#END_IF // TXT_ENCODE_PROPERTIES

#IF_NOT_DEFINED TXT_ENCODE_VALUES
INTEGER TXT_ENCODE_VALUES[]    =       // Text:    Media property values
{
  231,  232,  233,  234,  235,
  236,  237,  238,  239,  240
}
#END_IF // TXT_ENCODE_VALUES

(***********************************************************)
(*                Digital Satellite System                 *)
(***********************************************************)
DEFINE_CONSTANT // Digital Satellite System Channels/Levels/Variable Text

// Digital Satellite System Channels
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_DIGIT_0                    = 10    // Button:  Press menu button digit 0 (Momentary FB)
BTN_DIGIT_1                    = 11    // Button:  Press menu button digit 1 (Momentary FB)
BTN_DIGIT_2                    = 12    // Button:  Press menu button digit 2 (Momentary FB)
BTN_DIGIT_3                    = 13    // Button:  Press menu button digit 3 (Momentary FB)
BTN_DIGIT_4                    = 14    // Button:  Press menu button digit 4 (Momentary FB)
BTN_DIGIT_5                    = 15    // Button:  Press menu button digit 5 (Momentary FB)
BTN_DIGIT_6                    = 16    // Button:  Press menu button digit 6 (Momentary FB)
BTN_DIGIT_7                    = 17    // Button:  Press menu button digit 7 (Momentary FB)
BTN_DIGIT_8                    = 18    // Button:  Press menu button digit 8 (Momentary FB)
BTN_DIGIT_9                    = 19    // Button:  Press menu button digit 9 (Momentary FB)
BTN_MENU_PLUS_10               = 20    // Button:  Press menu button plus_10 (Momentary FB)
BTN_MENU_ENTER                 = 21    // Button:  Press menu button enter (Momentary FB)
BTN_CHAN_UP                    = 22    // Button:  Go to next Station Preset (Momentary FB)
BTN_CHAN_DN                    = 23    // Button:  Go to prev Station Preset (Momentary FB)
BTN_MENU_CANCEL                = 43    // Button:  Press menu button cancel (Momentary FB)
BTN_MENU_FUNC                  = 44    // Button:  Press menu button menu (Momentary FB)
BTN_MENU_UP                    = 45    // Button:  Press menu up button (Momentary FB)
BTN_MENU_DN                    = 46    // Button:  Press menu down button (Momentary FB)
BTN_MENU_LT                    = 47    // Button:  Press menu left button (Momentary FB)
BTN_MENU_RT                    = 48    // Button:  Press menu right button (Momentary FB)
BTN_MENU_SELECT                = 49    // Button:  Press Select - Select Menu Item (Momentary FB)
BTN_MENU_EXIT                  = 50    // Button:  Press menu button exit (Momentary FB)
BTN_MENU_CLEAR                 = 80    // Button:  Press menu button clear (Momentary FB)
BTN_MENU_PLUS_100              = 97    // Button:  Press menu button plus_100 (Momentary FB)
BTN_MENU_PLUS_1000             = 98    // Button:  Press menu button plus_1000 (Momentary FB)
BTN_MENU_DISPLAY               = 99    // Button:  Press menu button display (Momentary FB)
BTN_MENU_INFO                  = 101   // Button:  Press menu button info (Momentary FB)
BTN_MENU_FAVORITES             = 102   // Button:  Press menu button favorites (Momentary FB)
BTN_MENU_RETURN                = 104   // Button:  Press menu button return (Momentary FB)
BTN_MENU_GUIDE                 = 105   // Button:  Press menu button guide (Momentary FB)
BTN_MENU_PAGE_UP               = 106   // Button:  Press menu button page up (Momentary FB)
BTN_MENU_PAGE_DN               = 107   // Button:  Press menu button page down (Momentary FB)
BTN_MENU_HELP                  = 113   // Button:  Press menu button help (Momentary FB)
BTN_TUNER_PREV                 = 235   // Button:  Goto previous tuner station (Momentary FB)

// Digital Satellite System Variable Text
TXT_TUNER_STATION              = 16    // Text:    Station

(***********************************************************)
(*                  Digital Video Recorder                 *)
(***********************************************************)
DEFINE_CONSTANT // Digital Video Recorder Channels/Levels/Variable Text

// Digital Video Recorder Channels
BTN_PLAY                       = 1     // Button:  Play (Channel FB)
BTN_STOP                       = 2     // Button:  Stop (Channel FB)
BTN_PAUSE                      = 3     // Button:  Pause (Channel FB)
BTN_FFWD                       = 4     // Button:  Goto the next track (Momentary FB)
BTN_REW                        = 5     // Button:  Goto the previous track (Momentary FB)
BTN_SFWD                       = 6     // Button:  Scan forward (Channel FB)
BTN_SREV                       = 7     // Button:  Scan reverse (Channel FB)
BTN_RECORD                     = 8     // Button:  Record (Channel FB)
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_DIGIT_0                    = 10    // Button:  Press menu button digit 0 (Momentary FB)
BTN_DIGIT_1                    = 11    // Button:  Press menu button digit 1 (Momentary FB)
BTN_DIGIT_2                    = 12    // Button:  Press menu button digit 2 (Momentary FB)
BTN_DIGIT_3                    = 13    // Button:  Press menu button digit 3 (Momentary FB)
BTN_DIGIT_4                    = 14    // Button:  Press menu button digit 4 (Momentary FB)
BTN_DIGIT_5                    = 15    // Button:  Press menu button digit 5 (Momentary FB)
BTN_DIGIT_6                    = 16    // Button:  Press menu button digit 6 (Momentary FB)
BTN_DIGIT_7                    = 17    // Button:  Press menu button digit 7 (Momentary FB)
BTN_DIGIT_8                    = 18    // Button:  Press menu button digit 8 (Momentary FB)
BTN_DIGIT_9                    = 19    // Button:  Press menu button digit 9 (Momentary FB)
BTN_MENU_PLUS_10               = 20    // Button:  Press menu button plus_10 (Momentary FB)
BTN_MENU_ENTER                 = 21    // Button:  Press menu button enter (Momentary FB)
BTN_CHAN_UP                    = 22    // Button:  Go to next Station Preset (Momentary FB)
BTN_CHAN_DN                    = 23    // Button:  Go to prev Station Preset (Momentary FB)
BTN_SOURCE_VIDEO1              = 31    // Button:  Video 1 source select (Momentary FB)
BTN_SOURCE_VIDEO2              = 32    // Button:  Video 2 source select (Momentary FB)
BTN_SOURCE_VIDEO3              = 33    // Button:  Video 3 source select (Momentary FB)
BTN_SOURCE_AUX1                = 39    // Button:  Auxiliary 1 source select (Momentary FB)
BTN_MENU_CANCEL                = 43    // Button:  Press menu button cancel (Momentary FB)
BTN_MENU_FUNC                  = 44    // Button:  Press menu button menu (Momentary FB)
BTN_MENU_UP                    = 45    // Button:  Press menu up button (Momentary FB)
BTN_MENU_DN                    = 46    // Button:  Press menu down button (Momentary FB)
BTN_MENU_LT                    = 47    // Button:  Press menu left button (Momentary FB)
BTN_MENU_RT                    = 48    // Button:  Press menu right button (Momentary FB)
BTN_MENU_SELECT                = 49    // Button:  Press Select - Select Menu Item (Momentary FB)
BTN_MENU_EXIT                  = 50    // Button:  Press menu button exit (Momentary FB)
BTN_MENU_THUMBS_DN             = 58    // Button:  Press menu button thumbs down (Momentary FB)
BTN_MENU_THUMBS_UP             = 59    // Button:  Press menu button thumbs up (Momentary FB)
BTN_MENU_LIVE_TV               = 62    // Button:  Press menu button live TV (Momentary FB)
BTN_MENU_CLEAR                 = 80    // Button:  Press menu button clear (Momentary FB)
BTN_MENU_ADVANCE               = 83    // Button:  Press menu button advance (Momentary FB)
BTN_MENU_LIST                  = 86    // Button:  Press menu button list (Momentary FB)
BTN_MENU_PLUS_100              = 97    // Button:  Press menu button plus_100 (Momentary FB)
BTN_MENU_DISPLAY               = 99    // Button:  Press menu button display (Momentary FB)
BTN_MENU_INFO                  = 101   // Button:  Press menu button info (Momentary FB)
BTN_MENU_FAVORITES             = 102   // Button:  Press menu button favorites (Momentary FB)
BTN_MENU_RETURN                = 104   // Button:  Press menu button return (Momentary FB)
BTN_MENU_GUIDE                 = 105   // Button:  Press menu button guide (Momentary FB)
BTN_MENU_PAGE_UP               = 106   // Button:  Press menu button page up (Momentary FB)
BTN_MENU_PAGE_DN               = 107   // Button:  Press menu button page down (Momentary FB)
BTN_MENU_HELP                  = 113   // Button:  Press menu button help (Momentary FB)
BTN_FRAME_FWD                  = 185   // Button:  Frame forward (Momentary FB)
BTN_FRAME_REV                  = 186   // Button:  Frame reverse (Momentary FB)
BTN_SLOW_FWD                   = 188   // Button:  Slow forward (Channel FB)
BTN_SLOW_REV                   = 189   // Button:  Slow reverse (Channel FB)
BTN_SOURCE_CYCLE               = 196   // Button:  Cycle input (Momentary FB)
BTN_MENU_INSTANT_REPLAY        = 218   // Button:  Press menu button instant replay (Momentary FB)
BTN_TUNER_PREV                 = 235   // Button:  Goto previous tuner station (Momentary FB)

#IF_NOT_DEFINED BTN_INPUT_SOURCE
INTEGER BTN_INPUT_SOURCE[]     =       // Group:   Discrete input source selection (Channel FB)
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // BTN_INPUT_SOURCE

#IF_NOT_DEFINED BTN_INPUT_SOURCE_GROUP
INTEGER BTN_INPUT_SOURCE_GROUP[]=      // Group:   Discrete input source group select (Channel FB)
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // BTN_INPUT_SOURCE_GROUP

// Digital Video Recorder Variable Text
TXT_SOURCE_INPUT               = 15    // Text:    Selected input
TXT_TUNER_STATION              = 16    // Text:    Station

#IF_NOT_DEFINED TXT_INPUT_SOURCE
INTEGER TXT_INPUT_SOURCE[]     =       // Text:    Discrete input sources
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // TXT_INPUT_SOURCE

#IF_NOT_DEFINED TXT_INPUT_SOURCE_GROUP
INTEGER TXT_INPUT_SOURCE_GROUP[]=      // Text:    Discrete input source groups
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // TXT_INPUT_SOURCE_GROUP

(***********************************************************)
(*                       Disc Device                       *)
(***********************************************************)
DEFINE_CONSTANT // Disc Device Channels/Levels/Variable Text

// Disc Device Channels
BTN_PLAY                       = 1     // Button:  Play (Channel FB)
BTN_STOP                       = 2     // Button:  Stop (Channel FB)
BTN_PAUSE                      = 3     // Button:  Pause (Channel FB)
BTN_FFWD                       = 4     // Button:  Goto the next track (Momentary FB)
BTN_REW                        = 5     // Button:  Goto the previous track (Momentary FB)
BTN_SFWD                       = 6     // Button:  Scan forward (Channel FB)
BTN_SREV                       = 7     // Button:  Scan reverse (Channel FB)
BTN_RECORD                     = 8     // Button:  Record (Channel FB)
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_DIGIT_0                    = 10    // Button:  Press menu button digit 0 (Momentary FB)
BTN_DIGIT_1                    = 11    // Button:  Press menu button digit 1 (Momentary FB)
BTN_DIGIT_2                    = 12    // Button:  Press menu button digit 2 (Momentary FB)
BTN_DIGIT_3                    = 13    // Button:  Press menu button digit 3 (Momentary FB)
BTN_DIGIT_4                    = 14    // Button:  Press menu button digit 4 (Momentary FB)
BTN_DIGIT_5                    = 15    // Button:  Press menu button digit 5 (Momentary FB)
BTN_DIGIT_6                    = 16    // Button:  Press menu button digit 6 (Momentary FB)
BTN_DIGIT_7                    = 17    // Button:  Press menu button digit 7 (Momentary FB)
BTN_DIGIT_8                    = 18    // Button:  Press menu button digit 8 (Momentary FB)
BTN_DIGIT_9                    = 19    // Button:  Press menu button digit 9 (Momentary FB)
BTN_MENU_PLUS_10               = 20    // Button:  Press menu button plus_10 (Momentary FB)
BTN_MENU_ENTER                 = 21    // Button:  Press menu button enter (Momentary FB)
BTN_MENU_CANCEL                = 43    // Button:  Press menu button cancel (Momentary FB)
BTN_MENU_FUNC                  = 44    // Button:  Press menu button menu (Momentary FB)
BTN_MENU_UP                    = 45    // Button:  Press menu up button (Momentary FB)
BTN_MENU_DN                    = 46    // Button:  Press menu down button (Momentary FB)
BTN_MENU_LT                    = 47    // Button:  Press menu left button (Momentary FB)
BTN_MENU_RT                    = 48    // Button:  Press menu right button (Momentary FB)
BTN_MENU_SELECT                = 49    // Button:  Press Select - Select Menu Item (Momentary FB)
BTN_MENU_EXIT                  = 50    // Button:  Press menu button exit (Momentary FB)
BTN_DISC_NEXT                  = 55    // Button:  Goto the next disc (Momentary FB)
BTN_DISC_PREV                  = 56    // Button:  Goto the previous disc (Momentary FB)
BTN_MENU_SETUP                 = 66    // Button:  Press menu button setup (Momentary FB)
BTN_DISC_CHAPTER               = 67    // Button:  Chapter (Momentary FB)
BTN_DISC_DNR                   = 68    // Button:  DNR (Momentary FB)
BTN_DISC_MEMORY                = 69    // Button:  Memory (Momentary FB)
BTN_DISC_MODE                  = 70    // Button:  Mode (Momentary FB)
BTN_DISC_PLAY_MODE             = 71    // Button:  Play Mode (Momentary FB)
BTN_DISC_SEARCH_MODE           = 72    // Button:  Search Mode (Momentary FB)
BTN_DISC_TIME                  = 73    // Button:  Time (Momentary FB)
BTN_MENU_CLEAR                 = 80    // Button:  Press menu button clear (Momentary FB)
BTN_MENU_BACK                  = 81    // Button:  Press menu button back (Momentary FB)
BTN_MENU_DIMMER                = 84    // Button:  Press menu button dimmer (Momentary FB)
BTN_MENU_PLUS_100              = 97    // Button:  Press menu button plus_100 (Momentary FB)
BTN_MENU_DISPLAY               = 99    // Button:  Press menu button display (Momentary FB)
BTN_MENU_SUBTITLE              = 100   // Button:  Press menu button subtitle (Momentary FB)
BTN_MENU_CONTINUE              = 103   // Button:  Press menu button continue (Momentary FB)
BTN_MENU_RETURN                = 104   // Button:  Press menu button return (Momentary FB)
BTN_MENU_AB_REPEAT             = 112   // Button:  Press menu button AB repeat (Momentary FB)
BTN_MENU_TITLE                 = 114   // Button:  Press menu button title (Momentary FB)
BTN_MENU_TOP_MENU              = 115   // Button:  Press menu button top menu (Momentary FB)
BTN_MENU_ZOOM                  = 116   // Button:  Press menu button zoom (Momentary FB)
BTN_MENU_ANGLE                 = 117   // Button:  Press menu button angle (Momentary FB)
BTN_MENU_AUDIO                 = 118   // Button:  Press menu button audio (Momentary FB)
BTN_DISC_TRAY                  = 120   // Button:  Open/Close disc tray (Momentary FB)
BTN_DISC_RANDOM                = 124   // Button:  Cycle Random (Momentary FB)
BTN_DISC_REPEAT                = 125   // Button:  Cycle Repeat (Momentary FB)
BTN_FRAME_FWD                  = 185   // Button:  Frame forward (Momentary FB)
BTN_FRAME_REV                  = 186   // Button:  Frame reverse (Momentary FB)
BTN_SLOW_FWD                   = 188   // Button:  Slow forward (Channel FB)
BTN_SLOW_REV                   = 189   // Button:  Slow reverse (Channel FB)
BTN_SCAN_SPEED                 = 192   // Button:  Cycle the scanning speed (Momentary FB)
BTN_MENU_RESET                 = 215   // Button:  Press menu button reset (Momentary FB)

#IF_NOT_DEFINED BTN_DISC_LIST
INTEGER BTN_DISC_LIST[]        =       // Group:   Disc select (Momentary FB)
{
  341,  342,  343,  344,  345,
  346,  347,  348,  349,  350,
  351,  352,  353,  354,  355,
  356,  357,  358,  359,  360
}
#END_IF // BTN_DISC_LIST

// Disc Device Variable Text
TXT_DISC_COUNTER               = 9     // Text:    Title Counter
TXT_DISC_TRACK_COUNTER         = 10    // Text:    Track Counter

#IF_NOT_DEFINED TXT_DISC_INFO
INTEGER TXT_DISC_INFO[]        =       // Text:    Disc Info: Disc Number, Duration, # of Titles, # of Tracks, Disc Type
{
    1,    2,    3,    4,    5
}
#END_IF // TXT_DISC_INFO

#IF_NOT_DEFINED TXT_TITLE_INFO
INTEGER TXT_TITLE_INFO[]       =       // Text:    Title Info: Title Number, Duration, # of Tracks
{
    6,    7,    8
}
#END_IF // TXT_TITLE_INFO

#IF_NOT_DEFINED TXT_TRACK_INFO
INTEGER TXT_TRACK_INFO[]       =       // Text:    Track info
{
   28,   29
}
#END_IF // TXT_TRACK_INFO

#IF_NOT_DEFINED TXT_TRACK_PROPERTIES
INTEGER TXT_TRACK_PROPERTIES[] =       // Text:    Track property keys
{
  131,  132,  133,  134,  135,
  136,  137,  138,  139,  140
}
#END_IF // TXT_TRACK_PROPERTIES

#IF_NOT_DEFINED TXT_TRACK_VALUES
INTEGER TXT_TRACK_VALUES[]     =       // Text:    Track property values
{
  141,  142,  143,  144,  145,
  146,  147,  148,  149,  150
}
#END_IF // TXT_TRACK_VALUES

#IF_NOT_DEFINED TXT_DISC_PROPERTIES
INTEGER TXT_DISC_PROPERTIES[]  =       // Text:    Disc property keys
{
  201,  202,  203,  204,  205,
  206,  207,  208,  209,  210
}
#END_IF // TXT_DISC_PROPERTIES

#IF_NOT_DEFINED TXT_DISC_VALUES
INTEGER TXT_DISC_VALUES[]      =       // Text:    Disc property values
{
  211,  212,  213,  214,  215,
  216,  217,  218,  219,  220
}
#END_IF // TXT_DISC_VALUES

#IF_NOT_DEFINED TXT_DISC_TITLE_PROPERTIES
INTEGER TXT_DISC_TITLE_PROPERTIES[]=   // Text:    Title property keys
{
  221,  222,  223,  224,  225,
  226,  227,  228,  229,  230
}
#END_IF // TXT_DISC_TITLE_PROPERTIES

#IF_NOT_DEFINED TXT_DISC_TITLE_VALUES
INTEGER TXT_DISC_TITLE_VALUES[]=       // Text:    Title property values
{
  231,  232,  233,  234,  235,
  236,  237,  238,  239,  240
}
#END_IF // TXT_DISC_TITLE_VALUES

(***********************************************************)
(*                     Document Camera                     *)
(***********************************************************)
DEFINE_CONSTANT // Document Camera Channels/Levels/Variable Text

// Document Camera Channels
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_SOURCE_VIDEO1              = 31    // Button:  Video 1 source select (Momentary FB)
BTN_SOURCE_VIDEO2              = 32    // Button:  Video 2 source select (Momentary FB)
BTN_SOURCE_VIDEO3              = 33    // Button:  Video 3 source select (Momentary FB)
BTN_ZOOM_OUT                   = 158   // Button:  Ramp zoom out (Channel FB)
BTN_ZOOM_IN                    = 159   // Button:  Ramp zoom in (Channel FB)
BTN_FOCUS_NEAR                 = 160   // Button:  Ramp focus near (Channel FB)
BTN_FOCUS_FAR                  = 161   // Button:  Ramp focus far (Channel FB)
BTN_AUTO_FOCUS                 = 172   // Button:  Cycle auto focus (Channel FB)
BTN_AUTO_IRIS                  = 173   // Button:  Cycle auto iris (Channel FB)
BTN_IRIS_OPEN                  = 174   // Button:  Ramp iris open (Channel FB)
BTN_IRIS_CLOSE                 = 175   // Button:  Ramp iris closed (Channel FB)
BTN_DOCCAM_LIGHT               = 176   // Button:  Cycle light (Channel FB)
BTN_SOURCE_CYCLE               = 196   // Button:  Cycle input (Momentary FB)

#IF_NOT_DEFINED BTN_INPUT_SOURCE
INTEGER BTN_INPUT_SOURCE[]     =       // Group:   Discrete input source selection (Channel FB)
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // BTN_INPUT_SOURCE

#IF_NOT_DEFINED BTN_INPUT_SOURCE_GROUP
INTEGER BTN_INPUT_SOURCE_GROUP[]=      // Group:   Discrete input source group select (Channel FB)
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // BTN_INPUT_SOURCE_GROUP

// Document Camera Variable Text
TXT_SOURCE_INPUT               = 15    // Text:    Selected input

#IF_NOT_DEFINED TXT_INPUT_SOURCE
INTEGER TXT_INPUT_SOURCE[]     =       // Text:    Discrete input sources
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // TXT_INPUT_SOURCE

#IF_NOT_DEFINED TXT_INPUT_SOURCE_GROUP
INTEGER TXT_INPUT_SOURCE_GROUP[]=      // Text:    Discrete input source groups
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // TXT_INPUT_SOURCE_GROUP

(***********************************************************)
(*                          HVAC                           *)
(***********************************************************)
DEFINE_CONSTANT // HVAC Channels/Levels/Variable Text

// HVAC Channels
BTN_HVAC_COOL_UP               = 140   // Button:  Increment cooling set point (Momentary FB)
BTN_HVAC_COOL_DN               = 141   // Button:  Decrement cooling set point (Momentary FB)
BTN_HVAC_HEAT_UP               = 143   // Button:  Increment heating set point (Momentary FB)
BTN_HVAC_HEAT_DN               = 144   // Button:  Decrement heating set point (Momentary FB)
BTN_HVAC_HUMIDIFY_UP           = 148   // Button:  Increment humidifier set point (Momentary FB)
BTN_HVAC_HUMIDIFY_DN           = 149   // Button:  Decrement humidifier set point (Momentary FB)
BTN_HVAC_DEHUMIDIFY_UP         = 150   // Button:  Increment dehumidifier set point (Momentary FB)
BTN_HVAC_DEHUMIDIFY_DN         = 151   // Button:  Decrement dehumidifier set point (Momentary FB)
BTN_HVAC_UNITS                 = 209   // Button:  Off is fahrenheit, on is celsius (Channel FB)
BTN_HVAC_FAN                   = 213   // Button:  HVAC Fan Status (On/Auto) (Channel FB)
BTN_HVAC_FAN_STATUS            = 216   // Button:  Fan status state feedback (Channel FB)
BTN_HVAC_HUMIDIFY_STATE        = 217   // Button:  Cycle Humidify State/Mode (Momentary FB)
BTN_HVAC_STATE                 = 218   // Button:  Cycle HVAC State/Mode (Momentary FB)

// HVAC Variable Text
TXT_HVAC_STATE                 = 21    // Text:    HVAC State/Mode (Auto, Cool, Heat...)
TXT_HVAC_STATUS                = 22    // Text:    HVAC Status (Off, Heating, Cooling...)
TXT_HVAC_HUMID_STATE           = 23    // Text:    HVAC Humidstat State/Mode (Auto, Humidify, Dehumidify...)
TXT_HVAC_HUMID_STATUS          = 24    // Text:    HVAC Humidstat Status (Off, Humidifing, Dehumidifing...)
TXT_HVAC_COOL                  = 31    // Text:    Cooling set point, range is n..m degrees F or C
TXT_HVAC_HEAT                  = 32    // Text:    Heating set point, range is n..m degrees F or C
TXT_HVAC_TEMP                  = 33    // Text:    Indoor temperature, range is n..m degrees F or C
TXT_HVAC_OUTDOOR_TEMP          = 34    // Text:    Outdoor temperature, range is n..m degrees F or C
TXT_HVAC_HUMID                 = 35    // Text:    Indoor humidity, range is 0..100 percent
TXT_HVAC_OUTDOOR_HUMID         = 36    // Text:    Outdoor humidity, range is 0..100 percent
TXT_HVAC_HUMIDIFY              = 37    // Text:    Humidifier set point, range is 0..100 percent
TXT_HVAC_DEHUMIDIFY            = 38    // Text:    Dehumidifier set point, range is 0..100 percent

(***********************************************************)
(*                        IO Device                        *)
(***********************************************************)
DEFINE_CONSTANT // IO Device Channels/Levels/Variable Text

// IO Device Channels

#IF_NOT_DEFINED BTN_IO_STATE
INTEGER BTN_IO_STATE[]         =       // Group:   I/O Channel Control and FB (Channel FB)
{
    1,    2,    3,    4,    5,
    6,    7,    8,    9,   10,
   11,   12,   13,   14,   15,
   16,   17,   18,   19,   20
}
#END_IF // BTN_IO_STATE

(***********************************************************)
(*                          Keypad                         *)
(***********************************************************)
DEFINE_CONSTANT // Keypad Channels/Levels/Variable Text

// Keypad Channels

#IF_NOT_DEFINED BTN_KEYPAD_BUTTON
INTEGER BTN_KEYPAD_BUTTON[]    =       // Group:   Toggle keypad button (Channel FB)
{
    1,    2,    3,    4,    5,
    6,    7,    8,    9,   10,
   11,   12,   13,   14,   15,
   16,   17,   18,   19,   20
}
#END_IF // BTN_KEYPAD_BUTTON

(***********************************************************)
(*                          Light                          *)
(***********************************************************)
DEFINE_CONSTANT // Light Channels/Levels/Variable Text

// Light Channels
BTN_LIGHT_PRESET_1             = 261   // Button:  Toggle Light Preset 1 (Channel FB)
BTN_LIGHT_PRESET_2             = 262   // Button:  Toggle Light Preset 2 (Channel FB)
BTN_LIGHT_PRESET_3             = 263   // Button:  Toggle Light Preset 3 (Channel FB)
BTN_LIGHT_PRESET_4             = 264   // Button:  Toggle Light Preset 4 (Channel FB)
BTN_LIGHT_PRESET_5             = 265   // Button:  Toggle Light Preset 5 (Channel FB)
BTN_LIGHT_PRESET_6             = 266   // Button:  Toggle Light Preset 6 (Channel FB)
BTN_LIGHT_PRESET_7             = 267   // Button:  Toggle Light Preset 7 (Channel FB)
BTN_LIGHT_PRESET_8             = 268   // Button:  Toggle Light Preset 8 (Channel FB)
BTN_LIGHT_PRESET_9             = 269   // Button:  Toggle Light Preset 9 (Channel FB)
BTN_LIGHT_PRESET_10            = 270   // Button:  Toggle Light Preset 10 (Channel FB)
BTN_LIGHT_PRESET_11            = 271   // Button:  Toggle Light Preset 11 (Channel FB)
BTN_LIGHT_PRESET_12            = 272   // Button:  Toggle Light Preset 12 (Channel FB)
BTN_LIGHT_PRESET_13            = 273   // Button:  Toggle Light Preset 13 (Channel FB)
BTN_LIGHT_PRESET_14            = 274   // Button:  Toggle Light Preset 14 (Channel FB)
BTN_LIGHT_PRESET_15            = 275   // Button:  Toggle Light Preset 15 (Channel FB)
BTN_LIGHT_PRESET_16            = 276   // Button:  Toggle Light Preset 16 (Channel FB)
BTN_LIGHT_PRESET_17            = 277   // Button:  Toggle Light Preset 17 (Channel FB)
BTN_LIGHT_PRESET_18            = 278   // Button:  Toggle Light Preset 18 (Channel FB)
BTN_LIGHT_PRESET_19            = 279   // Button:  Toggle Light Preset 19 (Channel FB)
BTN_LIGHT_PRESET_20            = 280   // Button:  Toggle Light Preset 20 (Channel FB)

#IF_NOT_DEFINED BTN_LIGHT_PRESET
INTEGER BTN_LIGHT_PRESET[]     =       // Group:   Toggle lighting preset (Channel FB)
{
  261,  262,  263,  264,  265,
  266,  267,  268,  269,  270,
  271,  272,  273,  274,  275,
  276,  277,  278,  279,  280
}
#END_IF // BTN_LIGHT_PRESET

(***********************************************************)
(*                         Monitor                         *)
(***********************************************************)
DEFINE_CONSTANT // Monitor Channels/Levels/Variable Text

// Monitor Channels
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_MENU_ENTER                 = 21    // Button:  Press menu button enter (Momentary FB)
BTN_VOL_UP                     = 24    // Button:  Ramp volume up (Channel FB)
BTN_VOL_DN                     = 25    // Button:  Ramp volume down (Channel FB)
BTN_VOL_MUTE                   = 26    // Button:  Cycle volume mute (Channel FB)
BTN_SOURCE_VIDEO1              = 31    // Button:  Video 1 source select (Momentary FB)
BTN_SOURCE_VIDEO2              = 32    // Button:  Video 2 source select (Momentary FB)
BTN_SOURCE_VIDEO3              = 33    // Button:  Video 3 source select (Momentary FB)
BTN_SOURCE_TAPE1               = 34    // Button:  Tape 1 source select (Momentary FB)
BTN_SOURCE_TAPE2               = 35    // Button:  Tape 2 source select (Momentary FB)
BTN_SOURCE_AUX1                = 39    // Button:  Auxiliary 1 source select (Momentary FB)
BTN_MENU_CANCEL                = 43    // Button:  Press menu button cancel (Momentary FB)
BTN_MENU_FUNC                  = 44    // Button:  Press menu button menu (Momentary FB)
BTN_MENU_UP                    = 45    // Button:  Press menu up button (Momentary FB)
BTN_MENU_DN                    = 46    // Button:  Press menu down button (Momentary FB)
BTN_MENU_LT                    = 47    // Button:  Press menu left button (Momentary FB)
BTN_MENU_RT                    = 48    // Button:  Press menu right button (Momentary FB)
BTN_MENU_SELECT                = 49    // Button:  Press Select - Select Menu Item (Momentary FB)
BTN_MENU_EXIT                  = 50    // Button:  Press menu button exit (Momentary FB)
BTN_MENU_CLEAR                 = 80    // Button:  Press menu button clear (Momentary FB)
BTN_MENU_DISPLAY               = 99    // Button:  Press menu button display (Momentary FB)
BTN_MENU_RETURN                = 104   // Button:  Press menu button return (Momentary FB)
BTN_MENU_AUDIO                 = 118   // Button:  Press menu button audio (Momentary FB)
BTN_ASPECT_RATIO               = 142   // Button:  Aspect Ratio (Momentary FB)
BTN_BRIGHT_UP                  = 148   // Button:  Increment brightness (Momentary FB)
BTN_BRIGHT_DN                  = 149   // Button:  Decrement brightness (Momentary FB)
BTN_COLOR_UP                   = 150   // Button:  Increment color (Momentary FB)
BTN_COLOR_DN                   = 151   // Button:  Decrement color (Momentary FB)
BTN_CONTRAST_UP                = 152   // Button:  Increment contrast (Momentary FB)
BTN_CONTRAST_DN                = 153   // Button:  Decrement contrast (Momentary FB)
BTN_SHARP_UP                   = 154   // Button:  Increment sharpness (Momentary FB)
BTN_SHARP_DN                   = 155   // Button:  Decrement sharpness (Momentary FB)
BTN_TINT_UP                    = 156   // Button:  Increment tint (Momentary FB)
BTN_TINT_DN                    = 157   // Button:  Decrement tint (Momentary FB)
BTN_PIP_POS                    = 191   // Button:  Cycle pip position (Momentary FB)
BTN_PIP_SWAP                   = 193   // Button:  Swap pip (Momentary FB)
BTN_PIP                        = 194   // Button:  Cycle pip (Channel FB)
BTN_SOURCE_CYCLE               = 196   // Button:  Cycle input (Momentary FB)
BTN_PIC_MUTE                   = 210   // Button:  Cycle picture/video mute (Channel FB)
BTN_PIC_FREEZE                 = 213   // Button:  Cycle freeze (Channel FB)
BTN_MENU_RESET                 = 215   // Button:  Press menu button reset (Momentary FB)
BTN_VOL_PRESET_SAVE            = 376   // Button:  Save Volume preset (Channel FB)

#IF_NOT_DEFINED BTN_INPUT_SOURCE
INTEGER BTN_INPUT_SOURCE[]     =       // Group:   Discrete input source selection (Channel FB)
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // BTN_INPUT_SOURCE

#IF_NOT_DEFINED BTN_INPUT_SOURCE_GROUP
INTEGER BTN_INPUT_SOURCE_GROUP[]=      // Group:   Discrete input source group select (Channel FB)
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // BTN_INPUT_SOURCE_GROUP

// Monitor Levels
LVL_VOL                        = 1     // Level:   Volume level (0-255)
LVL_BRIGHT                     = 10    // Level:   Brightness level (0-255)
LVL_COLOR                      = 11    // Level:   Color level (0-255)
LVL_CONTRAST                   = 12    // Level:   Contrast level (0-255)
LVL_SHARP                      = 13    // Level:   Sharpness level (0-255)
LVL_TINT                       = 14    // Level:   Tint level (0-255)

// Monitor Variable Text
TXT_SOURCE_INPUT               = 15    // Text:    Selected input
TXT_ASPECT_RATIO               = 27    // Text:    Aspect Ratio

#IF_NOT_DEFINED TXT_INPUT_SOURCE
INTEGER TXT_INPUT_SOURCE[]     =       // Text:    Discrete input sources
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // TXT_INPUT_SOURCE

#IF_NOT_DEFINED TXT_INPUT_SOURCE_GROUP
INTEGER TXT_INPUT_SOURCE_GROUP[]=      // Text:    Discrete input source groups
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // TXT_INPUT_SOURCE_GROUP

(***********************************************************)
(*                          Motor                          *)
(***********************************************************)
DEFINE_CONSTANT // Motor Channels/Levels/Variable Text

// Motor Channels
BTN_MOTOR_STOP                 = 2     // Button:  Motor stop (Channel FB)
BTN_MOTOR_OPEN                 = 4     // Button:  Motor open (Channel FB)
BTN_MOTOR_CLOSE                = 5     // Button:  Motor close (Channel FB)

(***********************************************************)
(*                      Multi Window                       *)
(***********************************************************)
DEFINE_CONSTANT // Multi Window Channels/Levels/Variable Text

// Multi Window Channels
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_MENU_CANCEL                = 43    // Button:  Press menu button cancel (Momentary FB)
BTN_MENU_FUNC                  = 44    // Button:  Press menu button menu (Momentary FB)
BTN_MENU_UP                    = 45    // Button:  Press menu up button (Momentary FB)
BTN_MENU_DN                    = 46    // Button:  Press menu down button (Momentary FB)
BTN_MENU_LT                    = 47    // Button:  Press menu left button (Momentary FB)
BTN_MENU_RT                    = 48    // Button:  Press menu right button (Momentary FB)
BTN_MENU_SELECT                = 49    // Button:  Press Select - Select Menu Item (Momentary FB)
BTN_MENU_EXIT                  = 50    // Button:  Press menu button exit (Momentary FB)
BTN_MENU_CLEAR                 = 80    // Button:  Press menu button clear (Momentary FB)
BTN_MENU_RETURN                = 104   // Button:  Press menu button return (Momentary FB)
BTN_PAN_UP                     = 132   // Button:  Pan up (Momentary FB)
BTN_PAN_DN                     = 133   // Button:  Pan down (Momentary FB)
BTN_PAN_LT                     = 134   // Button:  Pan left (Momentary FB)
BTN_PAN_RT                     = 135   // Button:  Pan right (Momentary FB)
BTN_BRIGHT_UP                  = 148   // Button:  Increment brightness (Momentary FB)
BTN_BRIGHT_DN                  = 149   // Button:  Decrement brightness (Momentary FB)
BTN_COLOR_UP                   = 150   // Button:  Increment color (Momentary FB)
BTN_COLOR_DN                   = 151   // Button:  Decrement color (Momentary FB)
BTN_CONTRAST_UP                = 152   // Button:  Increment contrast (Momentary FB)
BTN_CONTRAST_DN                = 153   // Button:  Decrement contrast (Momentary FB)
BTN_SHARP_UP                   = 154   // Button:  Increment sharpness (Momentary FB)
BTN_SHARP_DN                   = 155   // Button:  Decrement sharpness (Momentary FB)
BTN_TINT_UP                    = 156   // Button:  Increment tint (Momentary FB)
BTN_TINT_DN                    = 157   // Button:  Decrement tint (Momentary FB)
BTN_ZOOM_OUT                   = 158   // Button:  Zoom out (Momentary FB)
BTN_ZOOM_IN                    = 159   // Button:  Zoom in (Momentary FB)
BTN_PIC_MUTE                   = 210   // Button:  Cycle picture/video mute (Channel FB)
BTN_PIC_FREEZE                 = 213   // Button:  Cycle freeze (Channel FB)
BTN_WINDOW_FRONT               = 230   // Button:  Bring window to front (Momentary FB)
BTN_WINDOW_BACK                = 231   // Button:  Send window to back (Momentary FB)
BTN_WINDOW_FORWARD             = 232   // Button:  Shift Window up (Momentary FB)
BTN_WINDOW_BACKWARD            = 233   // Button:  Shift Window down (Momentary FB)
BTN_MULTIWIN_PRESET_SAVE       = 260   // Button:  Save Multi Window preset (Channel FB)

#IF_NOT_DEFINED BTN_MULTIWIN_PRESET
INTEGER BTN_MULTIWIN_PRESET[]  =       // Group:   Recall Multi Window preset (Channel FB)
{
  261,  262,  263,  264,  265,
  266,  267,  268,  269,  270,
  271,  272,  273,  274,  275,
  276,  277,  278,  279,  280
}
#END_IF // BTN_MULTIWIN_PRESET

#IF_NOT_DEFINED BTN_WINDOW_INPUT
INTEGER BTN_WINDOW_INPUT[]     =       // Group:   Input select (Channel FB)
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // BTN_WINDOW_INPUT

// Multi Window Levels
LVL_BRIGHT                     = 10    // Level:   Brightness level (0-255)
LVL_COLOR                      = 11    // Level:   Color level (0-255)
LVL_CONTRAST                   = 12    // Level:   Contrast level (0-255)
LVL_SHARP                      = 13    // Level:   Sharpness level (0-255)
LVL_TINT                       = 14    // Level:   Tint level (0-255)

(***********************************************************)
(*                        Pool Spa                         *)
(***********************************************************)
DEFINE_CONSTANT // Pool Spa Channels/Levels/Variable Text

// Pool Spa Channels
BTN_POOL_HEAT                  = 123   // Button:  Cycle pool heat state (Momentary FB)
BTN_SPA_HEAT                   = 124   // Button:  Cycle spa heat state (Momentary FB)
BTN_SPA_JETS                   = 125   // Button:  Cycle spa jets (Momentary FB)
BTN_POOL_HEAT_UP               = 152   // Button:  Increment pool setpoint (Momentary FB)
BTN_POOL_HEAT_DN               = 153   // Button:  Decrement pool setpoint (Momentary FB)
BTN_SPA_HEAT_UP                = 154   // Button:  Increment spa setpoint (Momentary FB)
BTN_SPA_HEAT_DN                = 155   // Button:  Decrement spa setpoint (Momentary FB)
BTN_POOL_PUMP_ON               = 170   // Button:  Set pool pump state on or off (Channel FB)
BTN_SPA_PUMP_ON                = 171   // Button:  Set spa pump state on or off (Channel FB)
BTN_POOL_LIGHT_ON              = 172   // Button:  Set pool lights on or off (Channel FB)
BTN_SPA_LIGHT_ON               = 173   // Button:  Set spa lights on or off (Channel FB)
BTN_SPA_BLOWER_ON              = 186   // Button:  Set spa blower on or off (Channel FB)
BTN_POOL_UNITS                 = 209   // Button:  Off is fahrenheit, on is celsius (Channel FB)

#IF_NOT_DEFINED BTN_POOL_AUX
INTEGER BTN_POOL_AUX[]         =       // Group:   Cycle Pool/Spa Aux (Channel FB)
{
  261,  262,  263,  264,  265,
  266,  267,  268,  269,  270,
  271,  272,  273,  274,  275,
  276,  277,  278,  279,  280
}
#END_IF // BTN_POOL_AUX

// Pool Spa Variable Text
TXT_OUTDOOR_TEMP               = 34    // Text:    Pool/Spa outdoor temperature, range is n..m degrees F or C
TXT_POOL_SETPOINT              = 39    // Text:    Pool heating set point, range is n..m degrees F or C
TXT_SPA_SETPOINT               = 40    // Text:    Spa heating set point, range is n..m degrees F or C
TXT_POOL_TEMP                  = 41    // Text:    Pool water temperature, range is n..m degrees F or C
TXT_SPA_TEMP                   = 42    // Text:    Spa water temperature, range is n..m degrees F or C
TXT_POOL_HEATER                = 123   // Text:    Pool Heater State (Off, Heat, Solar...)
TXT_SPA_HEATER                 = 124   // Text:    Spa Heater State (Off, Heat, Solar...)
TXT_SPA_JETS                   = 125   // Text:    Spa Jets Status
TXT_POOL_HEATING               = 126   // Text:    Pool Heating Status
TXT_SPA_HEATING                = 127   // Text:    Spa Heating Status

(***********************************************************)
(*            Pre Amp Surround Sound Processor             *)
(***********************************************************)
DEFINE_CONSTANT // Pre Amp Surround Sound Processor Channels/Levels/Variable Text

// Pre Amp Surround Sound Processor Channels
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_VOL_UP                     = 24    // Button:  Ramp volume up (Channel FB)
BTN_VOL_DN                     = 25    // Button:  Ramp volume down (Channel FB)
BTN_VOL_MUTE                   = 26    // Button:  Cycle volume mute (Channel FB)
BTN_SOURCE_TV1                 = 30    // Button:  TV 1 source select (Momentary FB)
BTN_SOURCE_VIDEO1              = 31    // Button:  Video 1 source select (Momentary FB)
BTN_SOURCE_VIDEO2              = 32    // Button:  Video 2 source select (Momentary FB)
BTN_SOURCE_VIDEO3              = 33    // Button:  Video 3 source select (Momentary FB)
BTN_SOURCE_TAPE1               = 34    // Button:  Tape 1 source select (Momentary FB)
BTN_SOURCE_TAPE2               = 35    // Button:  Tape 2 source select (Momentary FB)
BTN_SOURCE_CD1                 = 36    // Button:  CD 1 source select (Momentary FB)
BTN_SOURCE_TUNER1              = 37    // Button:  Tuner 1 source select (Momentary FB)
BTN_SOURCE_PHONO1              = 38    // Button:  Phono 1 source select (Momentary FB)
BTN_SOURCE_AUX1                = 39    // Button:  Auxiliary 1 source select (Momentary FB)
BTN_MENU_CANCEL                = 43    // Button:  Press menu button cancel (Momentary FB)
BTN_MENU_FUNC                  = 44    // Button:  Press menu button menu (Momentary FB)
BTN_MENU_UP                    = 45    // Button:  Press menu up button (Momentary FB)
BTN_MENU_DN                    = 46    // Button:  Press menu down button (Momentary FB)
BTN_MENU_LT                    = 47    // Button:  Press menu left button (Momentary FB)
BTN_MENU_RT                    = 48    // Button:  Press menu right button (Momentary FB)
BTN_MENU_SELECT                = 49    // Button:  Press Select - Select Menu Item (Momentary FB)
BTN_MENU_EXIT                  = 50    // Button:  Press menu button exit (Momentary FB)
BTN_MENU_CLEAR                 = 80    // Button:  Press menu button clear (Momentary FB)
BTN_MENU_RETURN                = 104   // Button:  Press menu button return (Momentary FB)
BTN_BALANCE_UP                 = 164   // Button:  Increment balance (Momentary FB)
BTN_BALANCE_DN                 = 165   // Button:  Decrement balance (Momentary FB)
BTN_BASS_UP                    = 166   // Button:  Increment bass (Momentary FB)
BTN_BASS_DN                    = 167   // Button:  Decrement bass (Momentary FB)
BTN_TREBLE_UP                  = 168   // Button:  Increment treble  (Momentary FB)
BTN_TREBLE_DN                  = 169   // Button:  Decrement treble (Momentary FB)
BTN_SURROUND_NEXT              = 170   // Button:  Next surround sound mode (Momentary FB)
BTN_SURROUND_PREV              = 171   // Button:  Previous surround sound mode (Momentary FB)
BTN_SOURCE_CYCLE               = 196   // Button:  Cycle input (Momentary FB)
BTN_LOUDNESS                   = 206   // Button:  Cycle loudness (Channel FB)
BTN_VOL_PRESET_SAVE            = 376   // Button:  Save Volume preset (Channel FB)

#IF_NOT_DEFINED BTN_INPUT_SOURCE
INTEGER BTN_INPUT_SOURCE[]     =       // Group:   Discrete input source selection (Channel FB)
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // BTN_INPUT_SOURCE

#IF_NOT_DEFINED BTN_INPUT_SOURCE_GROUP
INTEGER BTN_INPUT_SOURCE_GROUP[]=      // Group:   Discrete input source group select (Channel FB)
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // BTN_INPUT_SOURCE_GROUP

#IF_NOT_DEFINED BTN_VOL_PRESET
INTEGER BTN_VOL_PRESET[]       =       // Group:   Recall Volume preset (Channel FB)
{
  371,  372,  373,  374,  375
}
#END_IF // BTN_VOL_PRESET

// Pre Amp Surround Sound Processor Levels
LVL_VOL                        = 1     // Level:   Volume level (0-255)
LVL_BALANCE                    = 2     // Level:   Balance level (0=left, 255=right)
LVL_BASS                       = 3     // Level:   Bass level (0-255)
LVL_TREBLE                     = 4     // Level:   Treble level (0-255)

// Pre Amp Surround Sound Processor Variable Text
TXT_SOURCE_INPUT               = 15    // Text:    Selected input

#IF_NOT_DEFINED TXT_INPUT_SOURCE
INTEGER TXT_INPUT_SOURCE[]     =       // Text:    Discrete input sources
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // TXT_INPUT_SOURCE

#IF_NOT_DEFINED TXT_INPUT_SOURCE_GROUP
INTEGER TXT_INPUT_SOURCE_GROUP[]=      // Text:    Discrete input source groups
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // TXT_INPUT_SOURCE_GROUP

(***********************************************************)
(*                        Receiver                         *)
(***********************************************************)
DEFINE_CONSTANT // Receiver Channels/Levels/Variable Text

// Receiver Channels
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_DIGIT_0                    = 10    // Button:  Press menu button digit 0 (Momentary FB)
BTN_DIGIT_1                    = 11    // Button:  Press menu button digit 1 (Momentary FB)
BTN_DIGIT_2                    = 12    // Button:  Press menu button digit 2 (Momentary FB)
BTN_DIGIT_3                    = 13    // Button:  Press menu button digit 3 (Momentary FB)
BTN_DIGIT_4                    = 14    // Button:  Press menu button digit 4 (Momentary FB)
BTN_DIGIT_5                    = 15    // Button:  Press menu button digit 5 (Momentary FB)
BTN_DIGIT_6                    = 16    // Button:  Press menu button digit 6 (Momentary FB)
BTN_DIGIT_7                    = 17    // Button:  Press menu button digit 7 (Momentary FB)
BTN_DIGIT_8                    = 18    // Button:  Press menu button digit 8 (Momentary FB)
BTN_DIGIT_9                    = 19    // Button:  Press menu button digit 9 (Momentary FB)
BTN_MENU_PLUS_10               = 20    // Button:  Press menu button plus_10 (Momentary FB)
BTN_MENU_ENTER                 = 21    // Button:  Press menu button enter (Momentary FB)
BTN_CHAN_UP                    = 22    // Button:  Go to next Station Preset (Momentary FB)
BTN_CHAN_DN                    = 23    // Button:  Go to prev Station Preset (Momentary FB)
BTN_VOL_UP                     = 24    // Button:  Ramp volume up (Channel FB)
BTN_VOL_DN                     = 25    // Button:  Ramp volume down (Channel FB)
BTN_VOL_MUTE                   = 26    // Button:  Cycle volume mute (Channel FB)
BTN_SOURCE_TV1                 = 30    // Button:  TV 1 source select (Momentary FB)
BTN_SOURCE_VIDEO1              = 31    // Button:  Video 1 source select (Momentary FB)
BTN_SOURCE_VIDEO2              = 32    // Button:  Video 2 source select (Momentary FB)
BTN_SOURCE_VIDEO3              = 33    // Button:  Video 3 source select (Momentary FB)
BTN_SOURCE_TAPE1               = 34    // Button:  Tape 1 source select (Momentary FB)
BTN_SOURCE_TAPE2               = 35    // Button:  Tape 2 source select (Momentary FB)
BTN_SOURCE_CD1                 = 36    // Button:  CD 1 source select (Momentary FB)
BTN_SOURCE_TUNER1              = 37    // Button:  Tuner 1 source select (Momentary FB)
BTN_SOURCE_PHONO1              = 38    // Button:  Phono 1 source select (Momentary FB)
BTN_SOURCE_AUX1                = 39    // Button:  Auxiliary 1 source select (Momentary FB)
BTN_TUNER_BAND                 = 40    // Button:  Cycle tuner band  (Momentary FB)
BTN_MENU_CANCEL                = 43    // Button:  Press menu button cancel (Momentary FB)
BTN_MENU_FUNC                  = 44    // Button:  Press menu button menu (Momentary FB)
BTN_MENU_UP                    = 45    // Button:  Press menu up button (Momentary FB)
BTN_MENU_DN                    = 46    // Button:  Press menu down button (Momentary FB)
BTN_MENU_LT                    = 47    // Button:  Press menu left button (Momentary FB)
BTN_MENU_RT                    = 48    // Button:  Press menu right button (Momentary FB)
BTN_MENU_SELECT                = 49    // Button:  Press Select - Select Menu Item (Momentary FB)
BTN_MENU_EXIT                  = 50    // Button:  Press menu button exit (Momentary FB)
BTN_MENU_XM                    = 77    // Button:  Press menu button xm (Momentary FB)
BTN_MENU_FM                    = 78    // Button:  Press menu button fm (Momentary FB)
BTN_MENU_AM                    = 79    // Button:  Press menu button am (Momentary FB)
BTN_MENU_CLEAR                 = 80    // Button:  Press menu button clear (Momentary FB)
BTN_MENU_DIMMER                = 84    // Button:  Press menu button dimmer (Momentary FB)
BTN_MENU_DOT                   = 92    // Button:  Press menu button dot (Momentary FB)
BTN_MENU_PLUS_100              = 97    // Button:  Press menu button plus_100 (Momentary FB)
BTN_MENU_RETURN                = 104   // Button:  Press menu button return (Momentary FB)
BTN_MENU_AUDIO                 = 118   // Button:  Press menu button audio (Momentary FB)
BTN_BALANCE_UP                 = 164   // Button:  Increment balance (Momentary FB)
BTN_BALANCE_DN                 = 165   // Button:  Decrement balance (Momentary FB)
BTN_BASS_UP                    = 166   // Button:  Increment bass (Momentary FB)
BTN_BASS_DN                    = 167   // Button:  Decrement bass (Momentary FB)
BTN_TREBLE_UP                  = 168   // Button:  Increment treble  (Momentary FB)
BTN_TREBLE_DN                  = 169   // Button:  Decrement treble (Momentary FB)
BTN_SURROUND_NEXT              = 170   // Button:  Next surround sound mode (Momentary FB)
BTN_SURROUND_PREV              = 171   // Button:  Previous surround sound mode (Momentary FB)
BTN_SOURCE_CYCLE               = 196   // Button:  Cycle input (Momentary FB)
BTN_LOUDNESS                   = 206   // Button:  Cycle loudness (Channel FB)
BTN_TUNER_PRESET_GROUP         = 224   // Button:  Cycle station preset group (Momentary FB)
BTN_TUNER_STATION_UP           = 225   // Button:  Increment Channel (Momentary FB)
BTN_TUNER_STATION_DN           = 226   // Button:  Decrement Channel (Momentary FB)
BTN_TUNER_SCAN_FWD             = 227   // Button:  Station scan forward (Momentary FB)
BTN_TUNER_SCAN_REV             = 228   // Button:  Station scan backward/reverse (Momentary FB)
BTN_TUNER_SEEK_FWD             = 229   // Button:  Station seek forward (Momentary FB)
BTN_TUNER_SEEK_REV             = 230   // Button:  Station seek backward/reverse (Momentary FB)
BTN_TUNER_PREV                 = 235   // Button:  Goto previous tuner station (Momentary FB)
BTN_VOL_PRESET_SAVE            = 376   // Button:  Save Volume preset (Channel FB)

#IF_NOT_DEFINED BTN_INPUT_SOURCE
INTEGER BTN_INPUT_SOURCE[]     =       // Group:   Discrete input source selection (Channel FB)
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // BTN_INPUT_SOURCE

#IF_NOT_DEFINED BTN_INPUT_SOURCE_GROUP
INTEGER BTN_INPUT_SOURCE_GROUP[]=      // Group:   Discrete input source group select (Channel FB)
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // BTN_INPUT_SOURCE_GROUP

#IF_NOT_DEFINED BTN_VOL_PRESET
INTEGER BTN_VOL_PRESET[]       =       // Group:   Recall Volume preset (Channel FB)
{
  371,  372,  373,  374,  375
}
#END_IF // BTN_VOL_PRESET

// Receiver Levels
LVL_VOL                        = 1     // Level:   Volume level (0-255)
LVL_BALANCE                    = 2     // Level:   Balance level (0=left, 255=right)
LVL_BASS                       = 3     // Level:   Bass level (0-255)
LVL_TREBLE                     = 4     // Level:   Treble level (0-255)

// Receiver Variable Text
TXT_SOURCE_INPUT               = 15    // Text:    Selected input
TXT_TUNER_STATION              = 16    // Text:    Station
TXT_TUNER_BAND                 = 17    // Text:    Tuner Band

#IF_NOT_DEFINED TXT_INPUT_SOURCE
INTEGER TXT_INPUT_SOURCE[]     =       // Text:    Discrete input sources
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // TXT_INPUT_SOURCE

#IF_NOT_DEFINED TXT_INPUT_SOURCE_GROUP
INTEGER TXT_INPUT_SOURCE_GROUP[]=      // Text:    Discrete input source groups
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // TXT_INPUT_SOURCE_GROUP

(***********************************************************)
(*                      Relay Device                       *)
(***********************************************************)
DEFINE_CONSTANT // Relay Device Channels/Levels/Variable Text

// Relay Device Channels

#IF_NOT_DEFINED BTN_RELAY_STATE
INTEGER BTN_RELAY_STATE[]      =       // Group:   Relay Channel Control and FB (Channel FB)
{
    1,    2,    3,    4,    5,
    6,    7,    8,    9,   10,
   11,   12,   13,   14,   15,
   16,   17,   18,   19,   20
}
#END_IF // BTN_RELAY_STATE

(***********************************************************)
(*                     Security System                     *)
(***********************************************************)
DEFINE_CONSTANT // Security System Channels/Levels/Variable Text

// Security System Channels
BTN_DIGIT_0                    = 10    // Button:  Press menu button digit 0 (Momentary FB)
BTN_DIGIT_1                    = 11    // Button:  Press menu button digit 1 (Momentary FB)
BTN_DIGIT_2                    = 12    // Button:  Press menu button digit 2 (Momentary FB)
BTN_DIGIT_3                    = 13    // Button:  Press menu button digit 3 (Momentary FB)
BTN_DIGIT_4                    = 14    // Button:  Press menu button digit 4 (Momentary FB)
BTN_DIGIT_5                    = 15    // Button:  Press menu button digit 5 (Momentary FB)
BTN_DIGIT_6                    = 16    // Button:  Press menu button digit 6 (Momentary FB)
BTN_DIGIT_7                    = 17    // Button:  Press menu button digit 7 (Momentary FB)
BTN_DIGIT_8                    = 18    // Button:  Press menu button digit 8 (Momentary FB)
BTN_DIGIT_9                    = 19    // Button:  Press menu button digit 9 (Momentary FB)
BTN_MENU_CLEAR                 = 80    // Button:  Press menu button clear (Momentary FB)
BTN_SEC_ARM                    = 130   // Button:  Arm away (Momentary FB)
BTN_SEC_ARM_HOME               = 131   // Button:  Arm home (Momentary FB)
BTN_SEC_DISARM                 = 132   // Button:  Disarm (Momentary FB)
BTN_SEC_PANIC                  = 134   // Button:  Panic (Momentary FB)
BTN_SEC_POLICE                 = 135   // Button:  Police (Momentary FB)
BTN_SEC_FIRE                   = 136   // Button:  Fire (Momentary FB)
BTN_SEC_MEDICAL                = 137   // Button:  Medical (Momentary FB)
BTN_SEC_ARM_NOW                = 139   // Button:  Arm Now (Momentary FB)
BTN_SEC_ARM_HOME_NOW           = 140   // Button:  Arm Home Now (Momentary FB)
BTN_SEC_PT_ACTIVE              = 141   // Button:  Press to enter point to be un-bypassed (Blink FB)
BTN_SEC_PT_BYPASS              = 142   // Button:  Press to enter point to be bypassed (Blink FB)

// Security System Variable Text
TXT_SEC_STATUS                 = 18    // Text:    Security system status
TXT_SEC_PASSWORD               = 25    // Text:    Password

(***********************************************************)
(*                        Settop Box                       *)
(***********************************************************)
DEFINE_CONSTANT // Settop Box Channels/Levels/Variable Text

// Settop Box Channels
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_DIGIT_0                    = 10    // Button:  Press menu button digit 0 (Momentary FB)
BTN_DIGIT_1                    = 11    // Button:  Press menu button digit 1 (Momentary FB)
BTN_DIGIT_2                    = 12    // Button:  Press menu button digit 2 (Momentary FB)
BTN_DIGIT_3                    = 13    // Button:  Press menu button digit 3 (Momentary FB)
BTN_DIGIT_4                    = 14    // Button:  Press menu button digit 4 (Momentary FB)
BTN_DIGIT_5                    = 15    // Button:  Press menu button digit 5 (Momentary FB)
BTN_DIGIT_6                    = 16    // Button:  Press menu button digit 6 (Momentary FB)
BTN_DIGIT_7                    = 17    // Button:  Press menu button digit 7 (Momentary FB)
BTN_DIGIT_8                    = 18    // Button:  Press menu button digit 8 (Momentary FB)
BTN_DIGIT_9                    = 19    // Button:  Press menu button digit 9 (Momentary FB)
BTN_MENU_ENTER                 = 21    // Button:  Press menu button enter (Momentary FB)
BTN_CHAN_UP                    = 22    // Button:  Go to next Station Preset (Momentary FB)
BTN_CHAN_DN                    = 23    // Button:  Go to prev Station Preset (Momentary FB)
BTN_VOL_UP                     = 24    // Button:  Ramp volume up (Channel FB)
BTN_VOL_DN                     = 25    // Button:  Ramp volume down (Channel FB)
BTN_VOL_MUTE                   = 26    // Button:  Cycle volume mute (Channel FB)
BTN_CABLE_AB                   = 42    // Button:  Cycle AB switch (Channel FB)
BTN_MENU_CANCEL                = 43    // Button:  Press menu button cancel (Momentary FB)
BTN_MENU_FUNC                  = 44    // Button:  Press menu button menu (Momentary FB)
BTN_MENU_UP                    = 45    // Button:  Press menu up button (Momentary FB)
BTN_MENU_DN                    = 46    // Button:  Press menu down button (Momentary FB)
BTN_MENU_LT                    = 47    // Button:  Press menu left button (Momentary FB)
BTN_MENU_RT                    = 48    // Button:  Press menu right button (Momentary FB)
BTN_MENU_SELECT                = 49    // Button:  Press Select - Select Menu Item (Momentary FB)
BTN_MENU_EXIT                  = 50    // Button:  Press menu button exit (Momentary FB)
BTN_MENU_PPV                   = 64    // Button:  Press menu button PPV (Momentary FB)
BTN_MENU_FUNCTION              = 65    // Button:  Press menu button function (Momentary FB)
BTN_CABLE_PC                   = 67    // Button:  Parental Control (Momentary FB)
BTN_CABLE_TIMER                = 68    // Button:  Timer (Momentary FB)
BTN_CABLE_CLOCK                = 69    // Button:  Clock (Momentary FB)
BTN_CABLE_ALT                  = 70    // Button:  Alt (Momentary FB)
BTN_CABLE_IPPV                 = 71    // Button:  IPPV (Momentary FB)
BTN_CABLE_CREDIT               = 72    // Button:  Credit (Momentary FB)
BTN_CABLE_SCAN                 = 73    // Button:  Scan (Momentary FB)
BTN_CABLE_CE                   = 74    // Button:  CA (Momentary FB)
BTN_CABLE_BUY                  = 75    // Button:  Code (Momentary FB)
BTN_CABLE_DCR                  = 76    // Button:  DCR (Momentary FB)
BTN_MENU_CLEAR                 = 80    // Button:  Press menu button clear (Momentary FB)
BTN_MENU_ASTERISK              = 91    // Button:  Press menu button asterisk (Momentary FB)
BTN_MENU_DISPLAY               = 99    // Button:  Press menu button display (Momentary FB)
BTN_MENU_INFO                  = 101   // Button:  Press menu button info (Momentary FB)
BTN_MENU_FAVORITES             = 102   // Button:  Press menu button favorites (Momentary FB)
BTN_MENU_RETURN                = 104   // Button:  Press menu button return (Momentary FB)
BTN_MENU_GUIDE                 = 105   // Button:  Press menu button guide (Momentary FB)
BTN_MENU_PAGE_UP               = 106   // Button:  Press menu button page up (Momentary FB)
BTN_MENU_PAGE_DN               = 107   // Button:  Press menu button page down (Momentary FB)
BTN_MENU_PROGRAM               = 111   // Button:  Press menu button program (Momentary FB)
BTN_TUNER_PREV                 = 235   // Button:  Goto previous tuner station (Momentary FB)

// Settop Box Levels
LVL_VOL                        = 1     // Level:   Volume level (0-255)

// Settop Box Variable Text
TXT_TUNER_STATION              = 16    // Text:    Station

(***********************************************************)
(*                     Slide Projector                     *)
(***********************************************************)
DEFINE_CONSTANT // Slide Projector Channels/Levels/Variable Text

// Slide Projector Channels
BTN_SLIDE_NEXT                 = 4     // Button:  Goto next slide (Momentary FB)
BTN_SLIDE_PREV                 = 5     // Button:  Goto previous slide (Momentary FB)
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_FOCUS_NEAR                 = 160   // Button:  Ramp focus near (Channel FB)
BTN_FOCUS_FAR                  = 161   // Button:  Ramp focus far (Channel FB)
BTN_LAMP_WARMING_FB            = 253   // Button:  Lamp Warming FB (Channel FB)
BTN_LAMP_COOLING_FB            = 254   // Button:  Lamp Cooling FB (Channel FB)
BTN_LAMP_POWER_FB              = 255   // Button:  Lamp Power FB (Channel FB)

// Slide Projector Variable Text
TXT_LAMP_COOLDOWN              = 12    // Text:    Cooldown counter
TXT_LAMP_WARMUP                = 13    // Text:    Warmup counter
TXT_LAMP_HOURS                 = 14    // Text:    Lamp hours

(***********************************************************)
(*                        Switcher                         *)
(***********************************************************)
DEFINE_CONSTANT // Switcher Channels/Levels/Variable Text

// Switcher Channels
BTN_VOL_UP                     = 24    // Button:  Ramp volume up (Channel FB)
BTN_VOL_DN                     = 25    // Button:  Ramp volume down (Channel FB)
BTN_VOL_MUTE                   = 26    // Button:  Cycle volume mute (Channel FB)
BTN_GAIN_UP                    = 140   // Button:  Ramp gain up (Channel FB)
BTN_GAIN_DN                    = 141   // Button:  Ramp gain down (Channel FB)
BTN_GAIN_MUTE                  = 144   // Button:  Cycle gain mute (Channel FB)
BTN_SWT_TAKE                   = 257   // Button:  Take switch (Momentary FB)
BTN_SWT_PRESET_SAVE            = 260   // Button:  Save Switcher preset (Channel FB)
BTN_SWT_LEVEL_ALL              = 321   // Button:  Switch all levels (Channel FB)
BTN_SWT_LEVEL_VIDEO            = 322   // Button:  Switch video level (Channel FB)
BTN_SWT_LEVEL_AUDIO            = 323   // Button:  Switch audio level (Channel FB)
BTN_VOL_PRESET_SAVE            = 376   // Button:  Save Volume preset (Channel FB)

#IF_NOT_DEFINED BTN_SWT_PRESET
INTEGER BTN_SWT_PRESET[]       =       // Group:   Recall Switcher preset (Channel FB)
{
  261,  262,  263,  264,  265,
  266,  267,  268,  269,  270,
  271,  272,  273,  274,  275,
  276,  277,  278,  279,  280
}
#END_IF // BTN_SWT_PRESET

#IF_NOT_DEFINED BTN_SWT_INPUT
INTEGER BTN_SWT_INPUT[]        =       // Group:   Input for switch (Channel FB)
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // BTN_SWT_INPUT

#IF_NOT_DEFINED BTN_SWT_OUTPUT
INTEGER BTN_SWT_OUTPUT[]       =       // Group:   Output for switch (Channel FB)
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // BTN_SWT_OUTPUT

#IF_NOT_DEFINED BTN_VOL_PRESET
INTEGER BTN_VOL_PRESET[]       =       // Group:   Recall Volume preset (Channel FB)
{
  371,  372,  373,  374,  375
}
#END_IF // BTN_VOL_PRESET

// Switcher Levels
LVL_VOL                        = 1     // Level:   Volume level (0-255)
LVL_GAIN                       = 5     // Level:   Gain level (0-255)

(***********************************************************)
(*                       Text Keypad                       *)
(***********************************************************)
DEFINE_CONSTANT // Text Keypad Channels/Levels/Variable Text

// Text Keypad Channels

#IF_NOT_DEFINED BTN_KEYPAD_BUTTON
INTEGER BTN_KEYPAD_BUTTON[]    =       // Group:   Toggle keypad button (Channel FB)
{
    1,    2,    3,    4,    5,
    6,    7,    8,    9,   10,
   11,   12,   13,   14,   15,
   16,   17,   18,   19,   20
}
#END_IF // BTN_KEYPAD_BUTTON

(***********************************************************)
(*                            TV                           *)
(***********************************************************)
DEFINE_CONSTANT // TV Channels/Levels/Variable Text

// TV Channels
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_DIGIT_0                    = 10    // Button:  Press menu button digit 0 (Momentary FB)
BTN_DIGIT_1                    = 11    // Button:  Press menu button digit 1 (Momentary FB)
BTN_DIGIT_2                    = 12    // Button:  Press menu button digit 2 (Momentary FB)
BTN_DIGIT_3                    = 13    // Button:  Press menu button digit 3 (Momentary FB)
BTN_DIGIT_4                    = 14    // Button:  Press menu button digit 4 (Momentary FB)
BTN_DIGIT_5                    = 15    // Button:  Press menu button digit 5 (Momentary FB)
BTN_DIGIT_6                    = 16    // Button:  Press menu button digit 6 (Momentary FB)
BTN_DIGIT_7                    = 17    // Button:  Press menu button digit 7 (Momentary FB)
BTN_DIGIT_8                    = 18    // Button:  Press menu button digit 8 (Momentary FB)
BTN_DIGIT_9                    = 19    // Button:  Press menu button digit 9 (Momentary FB)
BTN_MENU_PLUS_10               = 20    // Button:  Press menu button plus_10 (Momentary FB)
BTN_MENU_ENTER                 = 21    // Button:  Press menu button enter (Momentary FB)
BTN_CHAN_UP                    = 22    // Button:  Go to next Station Preset (Momentary FB)
BTN_CHAN_DN                    = 23    // Button:  Go to prev Station Preset (Momentary FB)
BTN_VOL_UP                     = 24    // Button:  Ramp volume up (Channel FB)
BTN_VOL_DN                     = 25    // Button:  Ramp volume down (Channel FB)
BTN_VOL_MUTE                   = 26    // Button:  Cycle volume mute (Channel FB)
BTN_SOURCE_TV1                 = 30    // Button:  TV 1 source select (Momentary FB)
BTN_SOURCE_VIDEO1              = 31    // Button:  Video 1 source select (Momentary FB)
BTN_SOURCE_VIDEO2              = 32    // Button:  Video 2 source select (Momentary FB)
BTN_SOURCE_VIDEO3              = 33    // Button:  Video 3 source select (Momentary FB)
BTN_SOURCE_AUX1                = 39    // Button:  Auxiliary 1 source select (Momentary FB)
BTN_MENU_CANCEL                = 43    // Button:  Press menu button cancel (Momentary FB)
BTN_MENU_FUNC                  = 44    // Button:  Press menu button menu (Momentary FB)
BTN_MENU_UP                    = 45    // Button:  Press menu up button (Momentary FB)
BTN_MENU_DN                    = 46    // Button:  Press menu down button (Momentary FB)
BTN_MENU_LT                    = 47    // Button:  Press menu left button (Momentary FB)
BTN_MENU_RT                    = 48    // Button:  Press menu right button (Momentary FB)
BTN_MENU_SELECT                = 49    // Button:  Press Select - Select Menu Item (Momentary FB)
BTN_MENU_EXIT                  = 50    // Button:  Press menu button exit (Momentary FB)
BTN_MENU_VIDEO                 = 57    // Button:  Press menu button video (Momentary FB)
BTN_MENU_SLEEP                 = 63    // Button:  Press menu button sleep (Momentary FB)
BTN_MENU_CLEAR                 = 80    // Button:  Press menu button clear (Momentary FB)
BTN_MENU_DOT                   = 92    // Button:  Press menu button dot (Momentary FB)
BTN_MENU_PLUS_100              = 97    // Button:  Press menu button plus_100 (Momentary FB)
BTN_MENU_PLUS_1000             = 98    // Button:  Press menu button plus_1000 (Momentary FB)
BTN_MENU_DISPLAY               = 99    // Button:  Press menu button display (Momentary FB)
BTN_MENU_INFO                  = 101   // Button:  Press menu button info (Momentary FB)
BTN_MENU_FAVORITES             = 102   // Button:  Press menu button favorites (Momentary FB)
BTN_MENU_RETURN                = 104   // Button:  Press menu button return (Momentary FB)
BTN_MENU_GUIDE                 = 105   // Button:  Press menu button guide (Momentary FB)
BTN_MENU_PAGE_UP               = 106   // Button:  Press menu button page up (Momentary FB)
BTN_MENU_PAGE_DN               = 107   // Button:  Press menu button page down (Momentary FB)
BTN_MENU_HELP                  = 113   // Button:  Press menu button help (Momentary FB)
BTN_ASPECT_RATIO               = 142   // Button:  Aspect Ratio (Momentary FB)
BTN_BRIGHT_UP                  = 148   // Button:  Increment brightness (Momentary FB)
BTN_BRIGHT_DN                  = 149   // Button:  Decrement brightness (Momentary FB)
BTN_COLOR_UP                   = 150   // Button:  Increment color (Momentary FB)
BTN_COLOR_DN                   = 151   // Button:  Decrement color (Momentary FB)
BTN_CONTRAST_UP                = 152   // Button:  Increment contrast (Momentary FB)
BTN_CONTRAST_DN                = 153   // Button:  Decrement contrast (Momentary FB)
BTN_SHARP_UP                   = 154   // Button:  Increment sharpness (Momentary FB)
BTN_SHARP_DN                   = 155   // Button:  Decrement sharpness (Momentary FB)
BTN_TINT_UP                    = 156   // Button:  Increment tint (Momentary FB)
BTN_TINT_DN                    = 157   // Button:  Decrement tint (Momentary FB)
BTN_PIP_POS                    = 191   // Button:  Cycle pip position (Momentary FB)
BTN_PIP_SWAP                   = 193   // Button:  Swap pip (Momentary FB)
BTN_PIP                        = 194   // Button:  Cycle pip (Channel FB)
BTN_SOURCE_CYCLE               = 196   // Button:  Cycle input (Momentary FB)
BTN_PIC_MUTE                   = 210   // Button:  Cycle picture/video mute (Channel FB)
BTN_PIC_FREEZE                 = 213   // Button:  Cycle freeze (Channel FB)
BTN_TUNER_PREV                 = 235   // Button:  Goto previous tuner station (Momentary FB)

#IF_NOT_DEFINED BTN_INPUT_SOURCE
INTEGER BTN_INPUT_SOURCE[]     =       // Group:   Discrete input source selection (Channel FB)
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // BTN_INPUT_SOURCE

#IF_NOT_DEFINED BTN_INPUT_SOURCE_GROUP
INTEGER BTN_INPUT_SOURCE_GROUP[]=      // Group:   Discrete input source group select (Channel FB)
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // BTN_INPUT_SOURCE_GROUP

// TV Levels
LVL_VOL                        = 1     // Level:   Volume level (0-255)
LVL_BRIGHT                     = 10    // Level:   Brightness level (0-255)
LVL_COLOR                      = 11    // Level:   Color level (0-255)
LVL_CONTRAST                   = 12    // Level:   Contrast level (0-255)
LVL_SHARP                      = 13    // Level:   Sharpness level (0-255)
LVL_TINT                       = 14    // Level:   Tint level (0-255)

// TV Variable Text
TXT_SOURCE_INPUT               = 15    // Text:    Selected input
TXT_TUNER_STATION              = 16    // Text:    Station
TXT_ASPECT_RATIO               = 27    // Text:    Aspect Ratio

#IF_NOT_DEFINED TXT_INPUT_SOURCE
INTEGER TXT_INPUT_SOURCE[]     =       // Text:    Discrete input sources
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // TXT_INPUT_SOURCE

#IF_NOT_DEFINED TXT_INPUT_SOURCE_GROUP
INTEGER TXT_INPUT_SOURCE_GROUP[]=      // Text:    Discrete input source groups
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // TXT_INPUT_SOURCE_GROUP

(***********************************************************)
(*                           UPS                           *)
(***********************************************************)
DEFINE_CONSTANT // UPS Channels/Levels/Variable Text

// UPS Channels

#IF_NOT_DEFINED BTN_UPS_OUTLET_STATE
INTEGER BTN_UPS_OUTLET_STATE[] =       // Group:   UPS outlet state (Channel FB)
{
  434,  435,  436,  437,  438,
  439
}
#END_IF // BTN_UPS_OUTLET_STATE

// UPS Variable Text
TXT_UPS_STATUS                 = 302   // Text:    UPS status
TXT_UPS_BACKUP_TIME            = 303   // Text:    UPS backup time remaining
TXT_UPS_ALARM                  = 304   // Text:    UPS alarm state

(***********************************************************)
(*                           VCR                           *)
(***********************************************************)
DEFINE_CONSTANT // VCR Channels/Levels/Variable Text

// VCR Channels
BTN_PLAY                       = 1     // Button:  Play (Channel FB)
BTN_STOP                       = 2     // Button:  Stop (Channel FB)
BTN_PAUSE                      = 3     // Button:  Pause (Channel FB)
BTN_FFWD                       = 4     // Button:  Fast forward (Channel FB)
BTN_REW                        = 5     // Button:  Rewind (Channel FB)
BTN_SFWD                       = 6     // Button:  Search forward (Channel FB)
BTN_SREV                       = 7     // Button:  Search reverse (Channel FB)
BTN_RECORD                     = 8     // Button:  Record (Channel FB)
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_DIGIT_0                    = 10    // Button:  Press menu button digit 0 (Momentary FB)
BTN_DIGIT_1                    = 11    // Button:  Press menu button digit 1 (Momentary FB)
BTN_DIGIT_2                    = 12    // Button:  Press menu button digit 2 (Momentary FB)
BTN_DIGIT_3                    = 13    // Button:  Press menu button digit 3 (Momentary FB)
BTN_DIGIT_4                    = 14    // Button:  Press menu button digit 4 (Momentary FB)
BTN_DIGIT_5                    = 15    // Button:  Press menu button digit 5 (Momentary FB)
BTN_DIGIT_6                    = 16    // Button:  Press menu button digit 6 (Momentary FB)
BTN_DIGIT_7                    = 17    // Button:  Press menu button digit 7 (Momentary FB)
BTN_DIGIT_8                    = 18    // Button:  Press menu button digit 8 (Momentary FB)
BTN_DIGIT_9                    = 19    // Button:  Press menu button digit 9 (Momentary FB)
BTN_MENU_PLUS_10               = 20    // Button:  Press menu button plus_10 (Momentary FB)
BTN_MENU_ENTER                 = 21    // Button:  Press menu button enter (Momentary FB)
BTN_CHAN_UP                    = 22    // Button:  Go to next Station Preset (Momentary FB)
BTN_CHAN_DN                    = 23    // Button:  Go to prev Station Preset (Momentary FB)
BTN_SOURCE_VIDEO1              = 31    // Button:  Video 1 source select (Momentary FB)
BTN_SOURCE_VIDEO2              = 32    // Button:  Video 2 source select (Momentary FB)
BTN_SOURCE_VIDEO3              = 33    // Button:  Video 3 source select (Momentary FB)
BTN_MENU_CANCEL                = 43    // Button:  Press menu button cancel (Momentary FB)
BTN_MENU_FUNC                  = 44    // Button:  Press menu button menu (Momentary FB)
BTN_MENU_UP                    = 45    // Button:  Press menu up button (Momentary FB)
BTN_MENU_DN                    = 46    // Button:  Press menu down button (Momentary FB)
BTN_MENU_LT                    = 47    // Button:  Press menu left button (Momentary FB)
BTN_MENU_RT                    = 48    // Button:  Press menu right button (Momentary FB)
BTN_MENU_SELECT                = 49    // Button:  Press Select - Select Menu Item (Momentary FB)
BTN_MENU_EXIT                  = 50    // Button:  Press menu button exit (Momentary FB)
BTN_MENU_CLEAR                 = 80    // Button:  Press menu button clear (Momentary FB)
BTN_MENU_PLUS_100              = 97    // Button:  Press menu button plus_100 (Momentary FB)
BTN_MENU_DISPLAY               = 99    // Button:  Press menu button display (Momentary FB)
BTN_MENU_INFO                  = 101   // Button:  Press menu button info (Momentary FB)
BTN_MENU_FAVORITES             = 102   // Button:  Press menu button favorites (Momentary FB)
BTN_MENU_RETURN                = 104   // Button:  Press menu button return (Momentary FB)
BTN_MENU_GUIDE                 = 105   // Button:  Press menu button guide (Momentary FB)
BTN_MENU_PAGE_UP               = 106   // Button:  Press menu button page up (Momentary FB)
BTN_MENU_PAGE_DN               = 107   // Button:  Press menu button page down (Momentary FB)
BTN_MENU_TV_VCR                = 109   // Button:  Press menu button TV VCR (Momentary FB)
BTN_MENU_RECORD_SPEED          = 110   // Button:  Press menu button record speed (Momentary FB)
BTN_MENU_PROGRAM               = 111   // Button:  Press menu button program (Momentary FB)
BTN_MENU_HELP                  = 113   // Button:  Press menu button help (Momentary FB)
BTN_EJECT                      = 120   // Button:  Eject tape (Momentary FB)
BTN_RESET_COUNTER              = 121   // Button:  Reset counter (Momentary FB)
BTN_SOURCE_CYCLE               = 196   // Button:  Cycle input (Momentary FB)
BTN_TUNER_PREV                 = 235   // Button:  Goto previous tuner station (Momentary FB)

#IF_NOT_DEFINED BTN_INPUT_SOURCE
INTEGER BTN_INPUT_SOURCE[]     =       // Group:   Discrete input source selection (Channel FB)
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // BTN_INPUT_SOURCE

#IF_NOT_DEFINED BTN_INPUT_SOURCE_GROUP
INTEGER BTN_INPUT_SOURCE_GROUP[]=      // Group:   Discrete input source group select (Channel FB)
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // BTN_INPUT_SOURCE_GROUP

// VCR Variable Text
TXT_TAPE_COUNTER               = 11    // Text:    Tape Counter
TXT_SOURCE_INPUT               = 15    // Text:    Selected input
TXT_TUNER_STATION              = 16    // Text:    Station

#IF_NOT_DEFINED TXT_INPUT_SOURCE
INTEGER TXT_INPUT_SOURCE[]     =       // Text:    Discrete input sources
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // TXT_INPUT_SOURCE

#IF_NOT_DEFINED TXT_INPUT_SOURCE_GROUP
INTEGER TXT_INPUT_SOURCE_GROUP[]=      // Text:    Discrete input source groups
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // TXT_INPUT_SOURCE_GROUP

(***********************************************************)
(*                    Video Conferencer                    *)
(***********************************************************)
DEFINE_CONSTANT // Video Conferencer Channels/Levels/Variable Text

// Video Conferencer Channels
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_DIGIT_0                    = 10    // Button:  Press menu button digit 0 (Momentary FB)
BTN_DIGIT_1                    = 11    // Button:  Press menu button digit 1 (Momentary FB)
BTN_DIGIT_2                    = 12    // Button:  Press menu button digit 2 (Momentary FB)
BTN_DIGIT_3                    = 13    // Button:  Press menu button digit 3 (Momentary FB)
BTN_DIGIT_4                    = 14    // Button:  Press menu button digit 4 (Momentary FB)
BTN_DIGIT_5                    = 15    // Button:  Press menu button digit 5 (Momentary FB)
BTN_DIGIT_6                    = 16    // Button:  Press menu button digit 6 (Momentary FB)
BTN_DIGIT_7                    = 17    // Button:  Press menu button digit 7 (Momentary FB)
BTN_DIGIT_8                    = 18    // Button:  Press menu button digit 8 (Momentary FB)
BTN_DIGIT_9                    = 19    // Button:  Press menu button digit 9 (Momentary FB)
BTN_MENU_ENTER                 = 21    // Button:  Press menu button enter (Momentary FB)
BTN_VOL_UP                     = 24    // Button:  Ramp volume up (Channel FB)
BTN_VOL_DN                     = 25    // Button:  Ramp volume down (Channel FB)
BTN_VOL_MUTE                   = 26    // Button:  Cycle volume mute (Channel FB)
BTN_SOURCE_VIDEO1              = 31    // Button:  Video 1 source select (Momentary FB)
BTN_SOURCE_VIDEO2              = 32    // Button:  Video 2 source select (Momentary FB)
BTN_SOURCE_VIDEO3              = 33    // Button:  Video 3 source select (Momentary FB)
BTN_SOURCE_AUX1                = 39    // Button:  Auxiliary 1 source select (Momentary FB)
BTN_MENU_CANCEL                = 43    // Button:  Press menu button cancel (Momentary FB)
BTN_MENU_FUNC                  = 44    // Button:  Press menu button menu (Momentary FB)
BTN_MENU_UP                    = 45    // Button:  Press menu up button (Momentary FB)
BTN_MENU_DN                    = 46    // Button:  Press menu down button (Momentary FB)
BTN_MENU_LT                    = 47    // Button:  Press menu left button (Momentary FB)
BTN_MENU_RT                    = 48    // Button:  Press menu right button (Momentary FB)
BTN_MENU_SELECT                = 49    // Button:  Press Select - Select Menu Item (Momentary FB)
BTN_MENU_EXIT                  = 50    // Button:  Press menu button exit (Momentary FB)
BTN_MENU_ACCEPT                = 60    // Button:  Press menu button accept (Momentary FB)
BTN_MENU_REJECT                = 61    // Button:  Press menu button reject (Momentary FB)
BTN_MENU_CLEAR                 = 80    // Button:  Press menu button clear (Momentary FB)
BTN_MENU_HOLD                  = 85    // Button:  Press menu button hold (Momentary FB)
BTN_MENU_LT_PAREN              = 87    // Button:  Press menu button left paren (Momentary FB)
BTN_MENU_RT_PAREN              = 88    // Button:  Press menu button right paren (Momentary FB)
BTN_MENU_UNDERSCORE            = 89    // Button:  Press menu button underscore (Momentary FB)
BTN_MENU_DASH                  = 90    // Button:  Press menu button dash (Momentary FB)
BTN_MENU_ASTERISK              = 91    // Button:  Press menu button asterisk (Momentary FB)
BTN_MENU_DOT                   = 92    // Button:  Press menu button dot (Momentary FB)
BTN_MENU_POUND                 = 93    // Button:  Press menu button pound (Momentary FB)
BTN_MENU_COMMA                 = 94    // Button:  Press menu button comma (Momentary FB)
BTN_MENU_DIAL                  = 95    // Button:  Press menu button dial (Momentary FB)
BTN_MENU_CONFERENCE            = 96    // Button:  Press menu button conference (Momentary FB)
BTN_MENU_DISPLAY               = 99    // Button:  Press menu button display (Momentary FB)
BTN_MENU_RETURN                = 104   // Button:  Press menu button return (Momentary FB)
BTN_MENU_PAGE_UP               = 106   // Button:  Press menu button page up (Momentary FB)
BTN_MENU_PAGE_DN               = 107   // Button:  Press menu button page down (Momentary FB)
BTN_MENU_HELP                  = 113   // Button:  Press menu button help (Momentary FB)
BTN_MENU_AUDIO                 = 118   // Button:  Press menu button audio (Momentary FB)
BTN_MENU_PREVIEW_INPUT         = 129   // Button:  Press menu button preview input (Momentary FB)
BTN_MENU_SEND_INPUT            = 130   // Button:  Press menu button send input (Momentary FB)
BTN_MENU_SEND_GRAPHICS         = 131   // Button:  Press menu button send graphics (Momentary FB)
BTN_TILT_UP                    = 132   // Button:  Ramp tilt up (Channel FB)
BTN_TILT_DN                    = 133   // Button:  Ramp tilt down (Channel FB)
BTN_PAN_LT                     = 134   // Button:  Ramp pan left (Channel FB)
BTN_PAN_RT                     = 135   // Button:  Ramp pan right (Channel FB)
BTN_VCONF_PRIVACY              = 145   // Button:  Cycle privacy (Channel FB)
BTN_VCONF_TRAIN                = 147   // Button:  Execute train (Momentary FB)
BTN_ZOOM_OUT                   = 158   // Button:  Ramp zoom out (Channel FB)
BTN_ZOOM_IN                    = 159   // Button:  Ramp zoom in (Channel FB)
BTN_FOCUS_NEAR                 = 160   // Button:  Ramp focus near (Channel FB)
BTN_FOCUS_FAR                  = 161   // Button:  Ramp focus far (Channel FB)
BTN_AUTO_FOCUS                 = 172   // Button:  Cycle auto focus (Channel FB)
BTN_AUTO_IRIS                  = 173   // Button:  Cycle auto iris (Channel FB)
BTN_IRIS_OPEN                  = 174   // Button:  Ramp iris open (Channel FB)
BTN_IRIS_CLOSE                 = 175   // Button:  Ramp iris closed (Channel FB)
BTN_PIP_POS                    = 191   // Button:  Cycle pip position (Momentary FB)
BTN_PIP_SWAP                   = 193   // Button:  Swap pip (Momentary FB)
BTN_PIP                        = 194   // Button:  Cycle pip (Channel FB)
BTN_SOURCE_CYCLE               = 196   // Button:  Cycle input (Momentary FB)
BTN_DIAL_REDIAL                = 201   // Button:  Redial (Momentary FB)
BTN_DIAL_OFF_HOOK              = 202   // Button:  Cycle off hook state (Channel FB)
BTN_MENU_FLASH                 = 203   // Button:  Press menu button flash (Momentary FB)
BTN_DIAL_AUTO_ANSWER           = 204   // Button:  Cycle auto answer state (Channel FB)
BTN_DIAL_AUDIBLE_RING          = 205   // Button:  Cycle audible ring state (Channel FB)
BTN_CAM_PRESET_SAVE            = 260   // Button:  Save Camera preset (Channel FB)
BTN_PHONEBOOK_NEXT             = 401   // Button:  Next Page (Momentary FB)
BTN_PHONEBOOK_PREV             = 402   // Button:  Previous Page (Momentary FB)
BTN_PHONEBOOK_DIAL             = 407   // Button:  Dial the selected item (Momentary FB)

#IF_NOT_DEFINED BTN_CAM_PRESET
INTEGER BTN_CAM_PRESET[]       =       // Group:   Recall Camera preset (Channel FB)
{
  261,  262,  263,  264,  265,
  266,  267,  268,  269,  270,
  271,  272,  273,  274,  275,
  276,  277,  278,  279,  280
}
#END_IF // BTN_CAM_PRESET

#IF_NOT_DEFINED BTN_INPUT_SOURCE
INTEGER BTN_INPUT_SOURCE[]     =       // Group:   Discrete input source selection (Channel FB)
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // BTN_INPUT_SOURCE

#IF_NOT_DEFINED BTN_INPUT_SOURCE_GROUP
INTEGER BTN_INPUT_SOURCE_GROUP[]=      // Group:   Discrete input source group select (Channel FB)
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // BTN_INPUT_SOURCE_GROUP

#IF_NOT_DEFINED BTN_DIAL_LIST
INTEGER BTN_DIAL_LIST[]        =       // Group:   Speed dial (Momentary FB)
{
  341,  342,  343,  344,  345,
  346,  347,  348,  349,  350,
  351,  352,  353,  354,  355,
  356,  357,  358,  359,  360
}
#END_IF // BTN_DIAL_LIST

#IF_NOT_DEFINED BTN_PHONEBOOK_LIST
INTEGER BTN_PHONEBOOK_LIST[]   =       // Group:   Select Phonebook item (Channel FB)
{
  391,  392,  393,  394,  395,
  396,  397,  398,  399,  400
}
#END_IF // BTN_PHONEBOOK_LIST

// Video Conferencer Levels
LVL_VOL                        = 1     // Level:   Volume level (0-255)

// Video Conferencer Variable Text
TXT_SOURCE_INPUT               = 15    // Text:    Selected input
TXT_DIAL_NUMBER                = 19    // Text:    Incoming call number
TXT_DIAL_CALL_PROGRESS         = 20    // Text:    Call progress
TXT_PHONEBOOK_NAME             = 178   // Text:    Phonebook Name
TXT_PHONEBOOK_NUMBER           = 179   // Text:    Phonebook Number
TXT_PHONEBOOK_LIST_STATUS      = 180   // Text:    Phonebook List Status (total records)

#IF_NOT_DEFINED TXT_PHONEBOOK_LIST
INTEGER TXT_PHONEBOOK_LIST[]   =       // Text:    Phonebook List
{
  181,  182,  183,  184,  185,
  186,  187,  188,  189,  190
}
#END_IF // TXT_PHONEBOOK_LIST

#IF_NOT_DEFINED TXT_INPUT_SOURCE
INTEGER TXT_INPUT_SOURCE[]     =       // Text:    Discrete input sources
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // TXT_INPUT_SOURCE

#IF_NOT_DEFINED TXT_INPUT_SOURCE_GROUP
INTEGER TXT_INPUT_SOURCE_GROUP[]=      // Text:    Discrete input source groups
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // TXT_INPUT_SOURCE_GROUP

(***********************************************************)
(*                     Video Processor                     *)
(***********************************************************)
DEFINE_CONSTANT // Video Processor Channels/Levels/Variable Text

// Video Processor Channels
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_SOURCE_VIDEO1              = 31    // Button:  Video 1 source select (Momentary FB)
BTN_SOURCE_VIDEO2              = 32    // Button:  Video 2 source select (Momentary FB)
BTN_SOURCE_VIDEO3              = 33    // Button:  Video 3 source select (Momentary FB)
BTN_MENU_CANCEL                = 43    // Button:  Press menu button cancel (Momentary FB)
BTN_MENU_FUNC                  = 44    // Button:  Press menu button menu (Momentary FB)
BTN_MENU_UP                    = 45    // Button:  Press menu up button (Momentary FB)
BTN_MENU_DN                    = 46    // Button:  Press menu down button (Momentary FB)
BTN_MENU_LT                    = 47    // Button:  Press menu left button (Momentary FB)
BTN_MENU_RT                    = 48    // Button:  Press menu right button (Momentary FB)
BTN_MENU_SELECT                = 49    // Button:  Press Select - Select Menu Item (Momentary FB)
BTN_MENU_EXIT                  = 50    // Button:  Press menu button exit (Momentary FB)
BTN_MENU_CLEAR                 = 80    // Button:  Press menu button clear (Momentary FB)
BTN_MENU_RETURN                = 104   // Button:  Press menu button return (Momentary FB)
BTN_VPROC_PRESET_SAVE          = 260   // Button:  Save Video Processor preset (Channel FB)

#IF_NOT_DEFINED BTN_VPROC_PRESET
INTEGER BTN_VPROC_PRESET[]     =       // Group:   Recall Video Processor preset (Channel FB)
{
  261,  262,  263,  264,  265,
  266,  267,  268,  269,  270,
  271,  272,  273,  274,  275,
  276,  277,  278,  279,  280
}
#END_IF // BTN_VPROC_PRESET

#IF_NOT_DEFINED BTN_INPUT_SOURCE
INTEGER BTN_INPUT_SOURCE[]     =       // Group:   Discrete input source selection (Channel FB)
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // BTN_INPUT_SOURCE

#IF_NOT_DEFINED BTN_INPUT_SOURCE_GROUP
INTEGER BTN_INPUT_SOURCE_GROUP[]=      // Group:   Discrete input source group select (Channel FB)
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // BTN_INPUT_SOURCE_GROUP

// Video Processor Variable Text
TXT_SOURCE_INPUT               = 15    // Text:    Selected input

#IF_NOT_DEFINED TXT_INPUT_SOURCE
INTEGER TXT_INPUT_SOURCE[]     =       // Text:    Discrete input sources
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // TXT_INPUT_SOURCE

#IF_NOT_DEFINED TXT_INPUT_SOURCE_GROUP
INTEGER TXT_INPUT_SOURCE_GROUP[]=      // Text:    Discrete input source groups
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // TXT_INPUT_SOURCE_GROUP

(***********************************************************)
(*                     Video Projector                     *)
(***********************************************************)
DEFINE_CONSTANT // Video Projector Channels/Levels/Variable Text

// Video Projector Channels
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_MENU_ENTER                 = 21    // Button:  Press menu button enter (Momentary FB)
BTN_VOL_UP                     = 24    // Button:  Ramp volume up (Channel FB)
BTN_VOL_DN                     = 25    // Button:  Ramp volume down (Channel FB)
BTN_VOL_MUTE                   = 26    // Button:  Cycle volume mute (Channel FB)
BTN_SOURCE_VIDEO1              = 31    // Button:  Video 1 source select (Momentary FB)
BTN_SOURCE_VIDEO2              = 32    // Button:  Video 2 source select (Momentary FB)
BTN_SOURCE_VIDEO3              = 33    // Button:  Video 3 source select (Momentary FB)
BTN_SOURCE_AUX1                = 39    // Button:  Auxiliary 1 source select (Momentary FB)
BTN_MENU_CANCEL                = 43    // Button:  Press menu button cancel (Momentary FB)
BTN_MENU_FUNC                  = 44    // Button:  Press menu button menu (Momentary FB)
BTN_MENU_UP                    = 45    // Button:  Press menu up button (Momentary FB)
BTN_MENU_DN                    = 46    // Button:  Press menu down button (Momentary FB)
BTN_MENU_LT                    = 47    // Button:  Press menu left button (Momentary FB)
BTN_MENU_RT                    = 48    // Button:  Press menu right button (Momentary FB)
BTN_MENU_SELECT                = 49    // Button:  Press Select - Select Menu Item (Momentary FB)
BTN_MENU_EXIT                  = 50    // Button:  Press menu button exit (Momentary FB)
BTN_MENU_CLEAR                 = 80    // Button:  Press menu button clear (Momentary FB)
BTN_MENU_DISPLAY               = 99    // Button:  Press menu button display (Momentary FB)
BTN_MENU_INFO                  = 101   // Button:  Press menu button info (Momentary FB)
BTN_MENU_RETURN                = 104   // Button:  Press menu button return (Momentary FB)
BTN_ASPECT_RATIO               = 142   // Button:  Aspect Ratio (Momentary FB)
BTN_BRIGHT_UP                  = 148   // Button:  Increment brightness (Momentary FB)
BTN_BRIGHT_DN                  = 149   // Button:  Decrement brightness (Momentary FB)
BTN_COLOR_UP                   = 150   // Button:  Increment color (Momentary FB)
BTN_COLOR_DN                   = 151   // Button:  Decrement color (Momentary FB)
BTN_CONTRAST_UP                = 152   // Button:  Increment contrast (Momentary FB)
BTN_CONTRAST_DN                = 153   // Button:  Decrement contrast (Momentary FB)
BTN_SHARP_UP                   = 154   // Button:  Increment sharpness (Momentary FB)
BTN_SHARP_DN                   = 155   // Button:  Decrement sharpness (Momentary FB)
BTN_TINT_UP                    = 156   // Button:  Increment tint (Momentary FB)
BTN_TINT_DN                    = 157   // Button:  Decrement tint (Momentary FB)
BTN_PIP_POS                    = 191   // Button:  Cycle pip position (Momentary FB)
BTN_PIP_SWAP                   = 193   // Button:  Swap pip (Momentary FB)
BTN_PIP                        = 194   // Button:  Cycle pip (Channel FB)
BTN_SOURCE_CYCLE               = 196   // Button:  Cycle input (Momentary FB)
BTN_PIC_MUTE                   = 210   // Button:  Cycle picture/video mute (Channel FB)
BTN_PIC_FREEZE                 = 213   // Button:  Cycle freeze (Channel FB)
BTN_LAMP_WARMING_FB            = 253   // Button:  Lamp Warming FB (Channel FB)
BTN_LAMP_COOLING_FB            = 254   // Button:  Lamp Cooling FB (Channel FB)
BTN_LAMP_POWER_FB              = 255   // Button:  Lamp Power FB (Channel FB)

#IF_NOT_DEFINED BTN_VPROJ_PRESET
INTEGER BTN_VPROJ_PRESET[]     =       // Group:   Recall Video Projector preset (Channel FB)
{
  261,  262,  263,  264,  265,
  266,  267,  268,  269,  270,
  271,  272,  273,  274,  275,
  276,  277,  278,  279,  280
}
#END_IF // BTN_VPROJ_PRESET

#IF_NOT_DEFINED BTN_INPUT_SOURCE
INTEGER BTN_INPUT_SOURCE[]     =       // Group:   Discrete input source selection (Channel FB)
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // BTN_INPUT_SOURCE

#IF_NOT_DEFINED BTN_INPUT_SOURCE_GROUP
INTEGER BTN_INPUT_SOURCE_GROUP[]=      // Group:   Discrete input source group select (Channel FB)
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // BTN_INPUT_SOURCE_GROUP

// Video Projector Levels
LVL_VOL                        = 1     // Level:   Volume level (0-255)
LVL_BRIGHT                     = 10    // Level:   Brightness level (0-255)
LVL_COLOR                      = 11    // Level:   Color level (0-255)
LVL_CONTRAST                   = 12    // Level:   Contrast level (0-255)
LVL_SHARP                      = 13    // Level:   Sharpness level (0-255)
LVL_TINT                       = 14    // Level:   Tint level (0-255)

// Video Projector Variable Text
TXT_LAMP_COOLDOWN              = 12    // Text:    Cooldown counter
TXT_LAMP_WARMUP                = 13    // Text:    Warmup counter
TXT_LAMP_HOURS                 = 14    // Text:    Lamp hours
TXT_SOURCE_INPUT               = 15    // Text:    Selected input
TXT_ASPECT_RATIO               = 27    // Text:    Aspect Ratio

#IF_NOT_DEFINED TXT_INPUT_SOURCE
INTEGER TXT_INPUT_SOURCE[]     =       // Text:    Discrete input sources
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // TXT_INPUT_SOURCE

#IF_NOT_DEFINED TXT_INPUT_SOURCE_GROUP
INTEGER TXT_INPUT_SOURCE_GROUP[]=      // Text:    Discrete input source groups
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // TXT_INPUT_SOURCE_GROUP

(***********************************************************)
(*                        Video Wall                       *)
(***********************************************************)
DEFINE_CONSTANT // Video Wall Channels/Levels/Variable Text

// Video Wall Channels
BTN_POWER                      = 9     // Button:  Cycle power (Channel FB)
BTN_PAN_UP                     = 132   // Button:  Pan up (Momentary FB)
BTN_PAN_DN                     = 133   // Button:  Pan down (Momentary FB)
BTN_PAN_LT                     = 134   // Button:  Pan left (Momentary FB)
BTN_PAN_RT                     = 135   // Button:  Pan right (Momentary FB)
BTN_BRIGHT_UP                  = 148   // Button:  Increment brightness (Momentary FB)
BTN_BRIGHT_DN                  = 149   // Button:  Decrement brightness (Momentary FB)
BTN_COLOR_UP                   = 150   // Button:  Increment color (Momentary FB)
BTN_COLOR_DN                   = 151   // Button:  Decrement color (Momentary FB)
BTN_CONTRAST_UP                = 152   // Button:  Increment contrast (Momentary FB)
BTN_CONTRAST_DN                = 153   // Button:  Decrement contrast (Momentary FB)
BTN_SHARP_UP                   = 154   // Button:  Increment sharpness (Momentary FB)
BTN_SHARP_DN                   = 155   // Button:  Decrement sharpness (Momentary FB)
BTN_TINT_UP                    = 156   // Button:  Increment tint (Momentary FB)
BTN_TINT_DN                    = 157   // Button:  Decrement tint (Momentary FB)
BTN_ZOOM_OUT                   = 158   // Button:  Zoom out (Momentary FB)
BTN_ZOOM_IN                    = 159   // Button:  Zoom in (Momentary FB)
BTN_PIC_MUTE                   = 210   // Button:  Cycle picture/video mute (Channel FB)
BTN_PIC_FREEZE                 = 213   // Button:  Cycle freeze (Channel FB)
BTN_WINDOW_FRONT               = 230   // Button:  Bring window to front (Momentary FB)
BTN_WINDOW_BACK                = 231   // Button:  Send window to back (Momentary FB)
BTN_WINDOW_FORWARD             = 232   // Button:  Shift Window up (Momentary FB)
BTN_WINDOW_BACKWARD            = 233   // Button:  Shift Window down (Momentary FB)
BTN_VWALL_CONFIG_SAVE          = 260   // Button:  Save Video Wall Configuration (Channel FB)
BTN_VWALL_CONFIG_NEXT          = 401   // Button:  Next Page (Momentary FB)
BTN_VWALL_CONFIG_PREV          = 402   // Button:  Prev Page (Momentary FB)

#IF_NOT_DEFINED BTN_VWALL_CONFIG
INTEGER BTN_VWALL_CONFIG[]     =       // Group:   Recall Video Wall Configuration (Channel FB)
{
  261,  262,  263,  264,  265,
  266,  267,  268,  269,  270,
  271,  272,  273,  274,  275,
  276,  277,  278,  279,  280
}
#END_IF // BTN_VWALL_CONFIG

#IF_NOT_DEFINED BTN_WINDOW_INPUT
INTEGER BTN_WINDOW_INPUT[]     =       // Group:   Input select (Channel FB)
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // BTN_WINDOW_INPUT

// Video Wall Levels
LVL_BRIGHT                     = 10    // Level:   Brightness level (0-255)
LVL_COLOR                      = 11    // Level:   Color level (0-255)
LVL_CONTRAST                   = 12    // Level:   Contrast level (0-255)
LVL_SHARP                      = 13    // Level:   Sharpness level (0-255)
LVL_TINT                       = 14    // Level:   Tint level (0-255)

// Video Wall Variable Text

#IF_NOT_DEFINED TXT_VWALL_CONFIG
INTEGER TXT_VWALL_CONFIG[]     =       // Text:    Configuration List VT
{
  241,  242,  243,  244,  245,
  246,  247,  248,  249,  250,
  251,  252,  253,  254,  255,
  256,  257,  258,  259,  260
}
#END_IF // TXT_VWALL_CONFIG

(***********************************************************)
(*                    Volume Controller                    *)
(***********************************************************)
DEFINE_CONSTANT // Volume Controller Channels/Levels/Variable Text

// Volume Controller Channels
BTN_VOL_UP                     = 24    // Button:  Ramp volume up (Channel FB)
BTN_VOL_DN                     = 25    // Button:  Ramp volume down (Channel FB)
BTN_VOL_MUTE                   = 26    // Button:  Cycle volume mute (Channel FB)
BTN_VOL_PRESET_SAVE            = 376   // Button:  Save Volume preset (Channel FB)

#IF_NOT_DEFINED BTN_VOL_PRESET
INTEGER BTN_VOL_PRESET[]       =       // Group:   Recall Volume preset (Channel FB)
{
  371,  372,  373,  374,  375
}
#END_IF // BTN_VOL_PRESET

// Volume Controller Levels
LVL_VOL                        = 1     // Level:   Volume level (0-255)

(***********************************************************)
(*                         Weather                         *)
(***********************************************************)
DEFINE_CONSTANT // Weather Channels/Levels/Variable Text

// Weather Channels
BTN_WEATHER_FORCE_READING      = 208   // Button:  Force new readings (Momentary FB)
BTN_WEATHER_UNITS              = 209   // Button:  Off is imperial, on is metric (Channel FB)

// Weather Variable Text
TXT_INDOOR_TEMP                = 33    // Text:    Indoor temperature, range is n..m degrees F or C
TXT_OUTDOOR_TEMP               = 34    // Text:    Outdoor temperature, range is n..m degrees F or C
TXT_INDOOR_HUMID               = 35    // Text:    Indoor humidity range is 0..100 percent
TXT_OUTDOOR_HUMID              = 36    // Text:    Outdoor humidity, range is 0..100 percent
TXT_WEATHER_HI_TEMP            = 43    // Text:    Today's actual high temperature, range is n..m degrees F or C
TXT_WEATHER_LO_TEMP            = 44    // Text:    Today's actual low temperature, range is n..m degrees F or C
TXT_WEATHER_WIND_CHILL         = 45    // Text:    Wind chill, range is n..m degrees F or C
TXT_WEATHER_HEAT_INDEX         = 46    // Text:    Heat index, range is n..m degrees F or C
TXT_WEATHER_DEWPOINT           = 47    // Text:    Dew point, range is n..m degrees F or C
TXT_WEATHER_BAR_PRESS          = 48    // Text:    Barometric pressure, range is n..m in inches hg or millimeter hg/torr
TXT_WEATHER_BAR_TREND          = 49    // Text:    Barometric Pressure trend (rising, falling)
TXT_WEATHER_CONDITION          = 50    // Text:    Current Weather Condition
TXT_WEATHER_RAIN_TODAY         = 53    // Text:    Rainfall (today)
TXT_WEATHER_RAIN_WEEK          = 54    // Text:    Rainfall (this week)
TXT_WEATHER_RAIN_MONTH         = 55    // Text:    Rainfall (this month)
TXT_WEATHER_RAIN_YEAR          = 56    // Text:    Rainfall (this year)
TXT_WEATHER_ALERT              = 57    // Text:    Weather alert

#IF_NOT_DEFINED TXT_WEATHER_WIND_INFO
INTEGER TXT_WEATHER_WIND_INFO[]=       // Text:    Wind Info: Wind speed, Wind direction
{
   51,   52
}
#END_IF // TXT_WEATHER_WIND_INFO

#IF_NOT_DEFINED TXT_WEATHER_FORECAST_CONDITION
INTEGER TXT_WEATHER_FORECAST_CONDITION[]= // Text: Forecast Conditon
{
   61,   62,   63,   64,   65,
   66,   67,   68,   69,   70
}
#END_IF // TXT_WEATHER_FORECAST_CONDITION

#IF_NOT_DEFINED TXT_WEATHER_FORECAST_HI
INTEGER TXT_WEATHER_FORECAST_HI[]=     // Text:    Forecast High temperature
{
   71,   72,   73,   74,   75,
   76,   77,   78,   79,   80
}
#END_IF // TXT_WEATHER_FORECAST_HI

#IF_NOT_DEFINED TXT_WEATHER_FORECAST_LO
INTEGER TXT_WEATHER_FORECAST_LO[]=     // Text:    Forecast Low temperature
{
   81,   82,   83,   84,   85,
   86,   87,   88,   89,   90
}
#END_IF // TXT_WEATHER_FORECAST_LO

#IF_NOT_DEFINED TXT_WEATHER_FORECAST_COP
INTEGER TXT_WEATHER_FORECAST_COP[]=    // Text:    Forecast Chance of Precipitation
{
   91,   92,   93,   94,   95,
   96,   97,   98,   99,  100
}
#END_IF // TXT_WEATHER_FORECAST_COP

(***********************************************************)
(*                    Deprecated constants                 *)
(***********************************************************)
DEFINE_CONSTANT // Deprecated constants

// Audio/Video Conferencer Device
BTN_DIAL_FLASH_HOOK            = 208   // Button:  Flash hook (Momentary FB)

// Disc Device
TXT_DISC_NUMBER                = 1     // Text:    Disc number, replaced by TXT_DISC_INFO
TXT_DISC_DURATION              = 2     // Text:    Disc Duration, replaced by TXT_DISC_INFO
TXT_DISC_TITLES                = 3     // Text:    # of Title per Disc, replaced by TXT_DISC_INFO
TXT_DISC_TRACKS                = 4     // Text:    # of Tracks per Disc, replaced by TXT_DISC_INFO
TXT_DISC_TYPE                  = 5     // Text:    Disc Type, replaced by TXT_DISC_INFO
TXT_DISC_TITLE_NUMBER          = 6     // Text:    Title Number, replaced by TXT_TITLE_INFO
TXT_DISC_TITLE_DURATION        = 7     // Text:    Title Duration, replaced by TXT_TITLE_INFO
TXT_DISC_TITLE_TRACKS          = 8     // Text:    # of Tracks per Title, replaced by TXT_TITLE_INFO

// Document Camera Device
BTN_DOCCAM_LOWER_LIGHT_ON      = 197   // Button:  Set the lower light on or off (Channel FB)
BTN_DOCCAM_UPPER_LIGHT_ON      = 198   // Button:  Set the upper light on or off (Channel FB)

// HVAC Device
BTN_HVAC_HOLD_ON               = 211   // Button:  Set thermostat hold mode (Channel FB)
BTN_HVAC_LOCK_ON               = 212   // Button:  Set thermostat lock state (Channel FB)

// Mixer Device
BTN_MIXER_TAKE                 = 257   // Button:  Take switch (Momentary FB), replaced by BTN_SWT_TAKE

// Pre Amp Surround Sound Processor/Receiver Device
BTN_LOUDNESS_ON                = 207   // Button:  Set loudness state (Channel FB)

// Weather Device
TXT_WEATHER_WIND_SPEED         = 51    // Text:    Wind speed, replaced by TXT_WEATHER_WIND_INFO
TXT_WEATHER_WIND_DIR           = 52    // Text:    Wind direction, replaced by TXT_WEATHER_WIND_INFO

(***********************************************************)
(*                     Soft-map constants                  *)
(***********************************************************)
DEFINE_CONSTANT // Soft-map constants

// Tuner Presets
#IF_NOT_DEFINED BTN_TUNER_PRESET
INTEGER BTN_TUNER_PRESET[]     =       // Group:   Recall Station preset (Channel FB)
{
  261,  262,  263,  264,  265,
  266,  267,  268,  269,  270,
  271,  272,  273,  274,  275,
  276,  277,  278,  279,  280
}
#END_IF // BTN_TUNER_PRESET

// Source Selects
#IF_NOT_DEFINED BTN_SOURCE_INPUT
INTEGER BTN_SOURCE_INPUT[]     =       // Group:   Select input (Channel FB)
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // BTN_SOURCE_INPUT

// Surround Modes
#IF_NOT_DEFINED BTN_PREAMP_SURROUND
INTEGER BTN_PREAMP_SURROUND[]  =       // Group:   Surround Sound mode (Channel FB)
{
  321,  322,  323,  324,  325,
  326,  327,  328,  329,  330,
  331,  332,  333,  334,  335,
  336,  337,  338,  339,  340
}
#END_IF // BTN_PREAMP_SURROUND

#END_IF //  __G4API_CONST__
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
