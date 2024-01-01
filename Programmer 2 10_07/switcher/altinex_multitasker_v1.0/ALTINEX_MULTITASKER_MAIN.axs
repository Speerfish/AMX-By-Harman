PROGRAM_NAME='ALTINEX_MULTITASKER_MAIN'
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 09/08/2003 AT: 14:57:01               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 09/26/2003 AT: 13:19:08         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 09/08/2003                              *)
(*                                                         *)
(* COMMENTS: The ALTINEX_MULTITASKER_COMM communication module was developed to work with switcher type cards, therefore
the communication module is not suitable for all types of cards. Due to the high number of cards available
and the high number of card-specific RS232 commands, only certain type of cards are supported with
a maximum of 8 inputs / 8 outputs. 

The ALTINEX_MULTITASKER_COMM communication module will work with the following cards:

MT103-102/MT103-107
MT104-100/MT104-101/MT104-103/MT104-107
MT105-102/MT105-103/MT105-105/MT105-106/MT105-107/MT105-108/MT105-109
MT106-100/MT106-101/MT106-102
MT108-107
MT109-100
MT110-101/MT110-103 
MT113-100/MT113-101                         *)

(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)


(********************************************************************)
(* FILE CREATED ON: 09/08/03  AT: 14:54:46                          *)
(********************************************************************)
DEFINE_DEVICE
dvALTINEX_MULTITASKER=5001:1:0 //real device

dvTP   =128:1:0

vdvALTINEX_MULTITASKER=33001:1:0 //virtual device

DEFINE_CONSTANT

INTEGER ALTINEX_MULTITASKER_BUTTONS[]=
{
// button definitions  
  1, //1-  Card # button on the Main page
  2, //2-  Input # button on the Main page
  3, //    Output # button on the Main page
  4, //    Switch button on the Main page
  5, //    Group # button on the Grouping page
  6, //    Go button on the Grouping page
  7, //    Group # (Clear Group) on the Grouping page
  8, //    Clear button on the Grouping page
  9, //NOT USED
  10,//NOT USED
  11,//    Card #1 button on Grouping page
  12,//    Card #2 button on Grouping page
  13,//    Card #3 button on Grouping page
  14,//    Card #4 button on Grouping page
  15,//    ...
  16,
  17,
  18,
  19,
  20,
  21,
  22,
  23,
  24,
  25,
  26,
  27,
  28,//    ...
  29,//    Card #19 button on Grouping page
  30,//    Card # button on Set Path page
  31,//NOT USED
  32,//    Source # button on Set Path page
  33,//NOT USED
  34,//    Go button on Set Path page
  35,//    Switch button on Set Path page
  36,//    Set Unit ID button on Setup page
  37,//    Unit ID button on popup
  38,//    OK button on popup
  39,//    CANCEL button on popip
  40,//    ONLINE button
  41,//    Label 1 button on Set Up page
  42,//    Label 2 
  43,//    Label 3
  44,//    ...
  45,
  46,
  47,
  48,
  49,
  50,
  51,
  52,
  53,//    ...
  54,//    Label 14 button on Set Up page
  55,//NOT USED
  56,//NOT USED
  57,//NOT USED
  58,//NOT USED
  59,//NOT USED
  60,//    Refresh button on Set Up page
  61,//    Set Paths button on the Main page
  62,//    Close button on Set Path page    
  63,//    Source # button on Enable page
  64,//    Enable button on Enable page
  65,//    Disable button on Enable page
  66,//NOT USED
  67,//NOT USED
  68,//NOT USED
  69,//NOT USED
  70,//NOT USED
  71,//NOT USED
  72,//NOT USED
  73,//NOT USED
  74,//NOT USED
  75,//NOT USED    
// text box definitions
  76,//     Unit ID
  77,//     Card # selected on Main page
  78,// NOT USED
  79,//     Input # on Main page
  80,//     Output # on Main page
  81,//     Switch status on Main page
  82,//     Group # on Grouping page
  83,//     Group # (Clear Group) 
  84,//     Group Membership
  85,//     Source selected on Enable page
  86,//     Label of card # selected 
  87,//     Enabled sources on Enable page
  88,//     Output # on Set Path page
  89,//     Set Path status 
  90,//     Set Unit ID on Setup page
  91,//     Card #1 version and type
  92,//     Card #2 version and type
  93,//     ...
  94,
  95,
  96,
  97,
  98,
  99,
  100,
  101,
  102,
  103,
  104,//    Card #14 version and type
  105,//NOT USED
  106,//NOT USED
  107,//NOT USED
  108,//NOT USED
  109,//NOT USED
  110 //    Unit ID on popup page
  
}


DEFINE_MODULE 'ALTINEX_MULTITASKER_COMM' comm_code(dvALTINEX_MULTITASKER,vdvALTINEX_MULTITASKER)
DEFINE_MODULE 'ALTINEX_MULTITASKER_UI' ui_code(vdvALTINEX_MULTITASKER, dvTP, ALTINEX_MULTITASKER_BUTTONS)

(* System Information Strings ******************************)
(* Use this section if there is a TP in the System!        *)
(*
    SEND_COMMAND TP,"'!F',250,'1'"
    SEND_COMMAND TP,"'TEXT250-',__NAME__"
    SEND_COMMAND TP,"'!F',251,'1'"
    SEND_COMMAND TP,"'TEXT251-',__FILE__,', ',S_DATE,', ',S_TIME"
    SEND_COMMAND TP,"'!F',252,'1'"
    SEND_COMMAND TP,"'TEXT252-',__VERSION__"
    SEND_COMMAND TP,"'!F',253,'1'"
    (* Must fill this (Master Ver) *)
    SEND_COMMAND TP,'TEXT253-'
    SEND_COMMAND TP,"'!F',254,'1'"
    (* Must fill this (Panel File) *)
    SEND_COMMAND TP,'TEXT254-'
    SEND_COMMAND TP,"'!F',255,'1'"
    (* Must fill this (Dealer Info) *)
    SEND_COMMAND TP,'TEXT255-'
*)
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