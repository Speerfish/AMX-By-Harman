PROGRAM_NAME='AMX01,Database Test,Exam Database,,Rev 0,TW'
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 04/06/2002 AT: 10:13:35               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/08/2002 AT: 08:53:31         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 04/08/2002                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 04/06/2002                              *)
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

dvTP            = 10001:1:0             //AXT-CA10  

//dvTP            = 128:1:0             //AXT-CA10  
//dvWebTP         = 10001:1:0           //Web test panel

// Use either the real or web touch panel to use this program

#INCLUDE 'ExamDB_AXI.axi'
//This is the include file created by DBWizard.  It will have the
//name you gave it on the "Files" tab of DBWizard

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

DEVCHAN dcDBOps[] =
{
   {dvTP,1},                        //Read record
   {dvTP,2},                        //Edit record
   {dvTP,3},                        //Add record
   {dvTP,4},                        //Delete record
   {dvTP,5},                        //Listbox down
   {dvTP,6}                         //Listbox up
}

DEVCHAN dcAdvancedDB[] =
{
   {dvTP,10},                       //Edit record using keyboard
   {dvTP,11},                       //Add record using keyboard
   {dvTP,12},                       //Search for certain records
   {dvTP,15},                       //Select Var Text window #1 to edit
   {dvTP,16},                       //Select Var Text window #2 to edit
   {dvTP,17},                       //Select Var Text window #3 to edit
   {dvTP,18},                       //Select Var Text window #4 to edit
   {dvTP,19}                        //Select Var Text window #5 to edit
}

DEVCHAN dcEdit[] =
{
   {dvTP,20},                       //Var Text window for editing records
   {dvTP,25},                       //Caps Lock key
   {dvTP,26},                       //Backspace key
   {dvTP,27},                       //Enter new line key
   {dvTP,28},                       //Clear all text key
   {dvTP,29},                       //Finished entering new data
   {dvTP,30}                        //Delete Record
}

SLONG slMyQuestionNum               //Question number
CHAR strMyQuestion[200]             //Question text
CHAR strNewQuestionData[200]        //Holds new or edited data for records
CHAR strKeyboardData[2]             //Holds characters from keyboard
INTEGER nFunctionFlag               //1=Edit,2=Add,3=Search
INTEGER nEditWindow                 //Which record selected to edit
CHAR strSearchData[200]             //Holds string to search records against

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

//When the database returns information to the NetLinx master it fires a
//DATA_EVENT in the INCLUDE file ExamDB_AXI.axi.  This DATA_EVENT
//converts the XML data from the database, using XML_TO_VARIABLE, to the
//structure sDB_EXAMQUERY[] and then calls this function.
//Therefore, you never need to call this function in your program code.
//In class, we tried calling this function and we got the error message about
//sTempListBox not being defined.
DEFINE_FUNCTION DB_DISPLAY_EXAMQUERY(_sDB_EXAMQUERY sDB_EXAMQUERY[],_sDB_LISTBOX sTempListBox)
LOCAL_VAR
INTEGER   nLOOP
{
  (* The following are elements of the structure where nLOOP=1 to nCOUNT: *)
  //nCOUNT is the number of records being returned from the database to the master
  //This is either all the records or the result of a search
  FOR (nLOOP = 1; nLOOP <= sTempListBox.nCOUNT; nLOOP++)
  {
    SEND_COMMAND dvTP,"'@TXT',nLOOP,ITOA(sDB_EXAMQUERY[nLOOP].slQuestionNum),'  ',sDB_EXAMQUERY[nLOOP].strQuestion"
    SEND_STRING 0,"'strQuestion=',sDB_EXAMQUERY[nLOOP].strQuestion"
    SEND_STRING 0,"'slQuestionNum=',ITOA(sDB_EXAMQUERY[nLOOP].slQuestionNum)"
    (* ADD DISPLAY CODE HERE *)
  }
  FOR (; nLOOP <= sTempListBox.nDISPLAY_SIZE; nLOOP++)
  {
    (* CLEAN UP EMPTY ENTRIES HERE *)
    //nDisplay_Size is the number of var text windows you have to display records on
    //your touch panel.  This is the PAGE SIZE you enter in DBWizard.
    //DBWizard creates a structure using the fields in your database as its members.
    //Then it creates a variable array of that structure with PAGE SIZE as the array size.
    //The name of this structure/array is determined by the table name in your database.
    //In this example the array is named: sDB_EXAMQUERY[5] and has the following members:
    //slQuestionNum and strQuestion.  The structure and the variable are created in the
    //INCLUDE ExamDB_AXI.axi file.
    //Remember, a record can use more than 1 var text window.
    //I put both the question number and the question in 1 text window so for this
    //example I use 1 text window per record.
    //There are 5 records to start with.
    SEND_COMMAND dvTP,"'@TXT',nLOOP,''"
  }
  SEND_STRING 0,"'Displaying ',ITOA(sTempListBox.snFIRST),'-',ITOA(sTempListBox.snLAST),' of ',ITOA(sTempListBox.snTOTAL)"
  SEND_STRING 0,"'Bargraph Level=',ITOA(sTempListBox.nLEVEL_VAL)"
  
  //In a large database with lots of records the level value will show where in the database
  //you are relative to the records being displayed in your text windows.
  //In this example, it is either at the top of the database which has a level value
  //of 255, or at the end of the database, which has a level value of 0.
  SEND_LEVEL dvTP,1,sTempListBox.nLEVEL_VAL //Shows location in database currently displayed
  
  (* Copy sTempListBox to your listbox and clean up current selection *)
  sEXAMQUERY_LB = sTempListBox
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

nEditWindow = 0
strNewQuestionData = ''
slMyQuestionNum = 0

(***********************************************************)
(*                THE EVENTS GOES BELOW                    *)
(***********************************************************)
DEFINE_EVENT

(***********************************************************

Functions created by DBWizard that we call to do all the work
located in the INCLUDE file ExamDB_AXI.axi

DB_DELETE_EXAMQUERY(slQuestionNum)
DB_ADD_EXAMQUERY(strQuestion)
DB_UPDATE_EXAMQUERY(strQuestion,slQuestionNum)
DB_READ_EXAMQUERY(sEXAMQUERY_LB,strSEARCH)

************************************************************)

BUTTON_EVENT[dcDBOps]               //Basic database functions to show fundamental operations
{
   PUSH:
   {
      STACK_VAR
      INTEGER nIndex
      
      nIndex = GET_LAST(dcDBOps)

      SWITCH (nIndex)
      {
         CASE 1:                          //Read record
         {
            TO [dvTP,BUTTON.INPUT.CHANNEL]  //Feedback
            DB_READ_EXAMQUERY(sEXAMQUERY_LB,'') //Return all records
            //If we had a search criteria it would be put in place of the ''
            //The DATA_EVENT calls the display function to display the data
         }
         CASE 2:                          //Edit record
         {
            TO [dvTP,BUTTON.INPUT.CHANNEL]  //Feedback
            slMyQuestionNum = 3             //Preselected question number to edit
            strMyQuestion = 'This is an edited record' //This will be the new record data
            DB_UPDATE_EXAMQUERY(strMyQuestion,slMyQuestionNum) //This function changes
            //the existing data in the database.  The database sends the new data back
            // to the master and fires the DATA_EVENT.  The DATA_EVENT will call the display
            //function to display the new data.
         }
         CASE 3:                          //Add record
         {
            TO [dvTP,BUTTON.INPUT.CHANNEL]  //Feedback
            strMyQuestion = 'This is a new record'  //This adds a new record with this data
            //to the database.  The database itself adds the new QuestionNum so we don't have
            //to supply that parameter.
            DB_ADD_EXAMQUERY(strMyQuestion) //This adds the data to the database.  The database
            //sends the new data back to the master and fires the DATA_EVENT.
            //The DATA_EVENT calls the display function to display the data
         }
         CASE 4:                          //Delete record
         {
            TO [dvTP,BUTTON.INPUT.CHANNEL]  //Feedback
            slMyQuestionNum = 4             //This deletes record number 4
            //There will never be another record number 4 so this will only work 1 time.
            DB_DELETE_EXAMQUERY(slMyQuestionNum)
         }
         CASE 5:                          //Listbox Down
         {
            TO [dvTP,BUTTON.INPUT.CHANNEL]  //Feedback
            DB_LISTBOX_DOWN(sEXAMQUERY_LB)  //This is a function defined in the INCLUDE
            //file NetlinxDBInclude.axi.  If there are more records than you can show
            //on your touch panel page you use this function to show the next set of records.
            IF (nFunctionFlag = 3)        //If displaying search results
              DB_READ_EXAMQUERY(sEXAMQUERY_LB,strSearchData)  //Only display search results
            ELSE
              DB_READ_EXAMQUERY(sEXAMQUERY_LB,'') //Display all records
         }
         CASE 6:                          //Listbox up
         {
            TO [dvTP,BUTTON.INPUT.CHANNEL]  //Feedback
            DB_LISTBOX_UP(sEXAMQUERY_LB)    //This is a function defined in the INCLUDE
            //file NetlinxDBInclude.axi.  If there are more records than you can show
            //on your touch panel page you use this function to show the previous set
            //of records after scrolling down.
            IF (nFunctionFlag = 3)        //If displaying search results
              DB_READ_EXAMQUERY(sEXAMQUERY_LB,strSearchData)  //Only display search results
            ELSE
              DB_READ_EXAMQUERY(sEXAMQUERY_LB,'') //Display all records
         }
      }            
   }
}

BUTTON_EVENT[dcAdvancedDB]
{
  PUSH:
  {
    STACK_VAR
    INTEGER nIndex
    
    nIndex = GET_LAST(dcAdvancedDB)
    
    SWITCH (nIndex)
    {
       CASE 1:                      //Edit record using keyboard
       {                            //Flips to keyboard page to enter data
          nFunctionFlag = 1
          //The current info from the database is stored in a structure array
          //named sDB_EXAMQUERY[].  Here we display the selected question
          //in a text window so we can edit it.
          strNewQuestionData = sDB_EXAMQUERY[nEditWindow].strQuestion
          SEND_COMMAND dvTP,"'@TXT',10,strNewQuestionData"
       }
       CASE 2:                      //Add record using keyboard
       {                            //Flips to keyboard page to enter data
          nFunctionFlag = 2
          SEND_COMMAND dvTP,"'@TXT',10,''"  //Clears var text window
       }
       CASE 3:                      //Search for certain records
       {                            //Flips to keyboard page to enter data
          nFunctionFlag = 3
          SEND_COMMAND dvTP,"'@TXT',10,''"  //Clears var text window
       }
       DEFAULT:
       {                            //One of the var text windows has been selected to edit
          nEditWindow = nIndex-3    //Var text windows 1 - 5
       }
    }
  }
}

BUTTON_EVENT[dcEdit]
{
   PUSH:
   {  
      STACK_VAR
      INTEGER nIndex
      
      nIndex = GET_LAST(dcEdit)

      SWITCH (nIndex)
      {
         CASE 2:                    //Caps Lock key
         {
            [dvTP,25] = ! [dvTP,25] //Toggle state of Caps Lock key
         }
         CASE 3:                    //Backspace key
         {
            TO [dvTP,BUTTON.INPUT.CHANNEL]  //Feedback
            //Delete last character from string
            SET_LENGTH_ARRAY(strNewQuestionData,LENGTH_ARRAY(strNewQuestionData)-1) 
            SEND_COMMAND dvTP,"'@TXT',10,strNewQuestionData"
         }
         CASE 4:                    //Enter new line key
         {
            TO [dvTP,BUTTON.INPUT.CHANNEL]  //Feedback
            strNewQuestionData = "strNewQuestionData,'|'"
            //Causes test to be displayed on a new line in a var text box
            SEND_COMMAND dvTP,"'@TXT',10,strNewQuestionData"
         }
         CASE 5:                    //Clear all text key
         {
            TO [dvTP,BUTTON.INPUT.CHANNEL]  //Feedback
            //Clears the var text window and the string buffer
            SEND_COMMAND dvTP,"'@TXT',10,''"
            CLEAR_BUFFER strNewQuestionData
         }
         CASE 6:                    //Finished entering new data
         {
            IF (nFunctionFlag = 1)  //Editing record
            {
              //strNewQuestionData is the new edited data
              //sDB_EXAMQUERY[nEditWindow].slQuestionNum is the currently selected question number
              DB_UPDATE_EXAMQUERY(strNewQuestionData,sDB_EXAMQUERY[nEditWindow].slQuestionNum)
              DB_READ_EXAMQUERY(sEXAMQUERY_LB,'') //Update var text windows from database
            }
            IF (nFunctionFlag = 2)  //Adding record
            {
              //strNewQuestionData is the new data
              DB_ADD_EXAMQUERY(strNewQuestionData)
              DB_READ_EXAMQUERY(sEXAMQUERY_LB,'') //Update var text windows from database
            }
            IF (nFunctionFlag = 3)  //Searching for record
            {
              //The name Exam.Question is unique for this database.  Exam is the name of
              //the table in the database where the info is stored.
              //Question is a field in that table that holds the data we are searching for.
              //LIKE is an SQL keyword and the % signs are wildcards like * is in DOS.
              strNewQuestionData = "'(((Exam.Question) LIKE "%',strNewQuestionData,'%"))'"
              strSearchData = strNewQuestionData
              DB_READ_EXAMQUERY(sEXAMQUERY_LB,strSearchData) //Returns only data that
              //matches our search criteria.
              CLEAR_BUFFER strSearchData
            }
            CLEAR_BUFFER strNewQuestionData
         }
         CASE 7:                    //Delete record
         {
            TO [dvTP,BUTTON.INPUT.CHANNEL]  //Feedback
            DB_DELETE_EXAMQUERY(sDB_EXAMQUERY[nEditWindow].slQuestionNum)
            DB_READ_EXAMQUERY(sEXAMQUERY_LB,'') //Update var text windows from database
         }
      }
   }

   HOLD[5,REPEAT]:                 //Backspace key - repeat every 1/2 seconds
   {
      IF ([dvTP,26])
      {
        SET_LENGTH_ARRAY(strNewQuestionData,LENGTH_ARRAY(strNewQuestionData)-1) 
        SEND_COMMAND dvTP,"'@TXT',10,strNewQuestionData"
      }
   }
}

DATA_EVENT[dvTP]                    //Get data from keyboard
{
  STRING:
  {
    strKeyboardData = "strKeyboardData,DATA.TEXT"
    
    IF ([dvTP,25])                  //If Caps Lock on
    {
      strNewQuestionData = "strNewQuestionData,MID_STRING(strKeyboardData,2,1)"
      SEND_COMMAND dvTP,"'@TXT',10,strNewQuestionData"
    }
    ELSE
    {
      strNewQuestionData = "strNewQuestionData,LEFT_STRING(strKeyboardData,1)"
      SEND_COMMAND dvTP,"'@TXT',10,strNewQuestionData"
    }
    CLEAR_BUFFER strKeyboardData
  }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

[dvTP,10] = (nFunctionFlag = 1)     //Edit record
[dvTP,11] = (nFunctionFlag = 2)     //Add record
[dvTP,12] = (nFunctionFlag = 3)     //Search for record
[dvTP,15] = (nEditWindow=1)         //Var text window 1 selected
[dvTP,16] = (nEditWindow=2)         //Var text window 2 selected
[dvTP,17] = (nEditWindow=3)         //Var text window 3 selected
[dvTP,18] = (nEditWindow=4)         //Var text window 4 selected
[dvTP,19] = (nEditWindow=5)         //Var text window 5 selected

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

