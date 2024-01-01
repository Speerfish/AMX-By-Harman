PROGRAM_NAME='DVD9000Test'

(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 11/30/2001 AT: 17:21:48               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 09/10/2002 AT: 13:12:04         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 11/30/2001                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)

DEFINE_DEVICE
    TP      = 130:1:0            // touch panel
    DVD     = 5001:1:0           // DVD device - serial
    vDVD    = 33001:1:0          // virtual dev: DVD-9000



DEFINE_VARIABLE
    // No longer need polling because the unit sends info asynchronously.
    //    However, the ability to do polling is left in the software for
    //    future consideration.  Setting this to zero will disabled polling.
    integer pollTime = 0


// DVD-9000 module
DEFINE_MODULE 'Denon_DVD9000' DVDmod(DVD, vDVD, pollTime)


DEFINE_MUTUALLY_EXCLUSIVE
([TP,1]..[TP,3])             // touch panel: play,stop,pause
([TP,27]..[TP,28])           // touch panel: power on,off


DEFINE_START


DEFINE_EVENT

data_event[vDVD]
{
    string:
    {
        stack_var char temp[100]

        // Is this a chapter feedback message?
        temp = remove_string(data.text, 'CHAPTER=', 1)
        if (length_string(temp) > 0)
        {
            // Message received was 'CHAPTER=nn' where nn is the chapter 
            //    number.  The remove_string command above removed the
            //    'CHAPTER=' string so what's left in data.text is just
            //    the number.  Send this to the touch panel.
            send_command TP,"'!T',1,data.text"
        }

        // The above is only a small sample of the feedback commands that can
        //    be processed.  There are many more feedback commands that can be 
        //    received and processed from the DVD player.  See the NetLinx 
        //    module interface document for more details.
    }
}


channel_event[vDVD,1]      // feedback:play
channel_event[vDVD,2]      // feedback:stop
channel_event[vDVD,3]      // feedback:pause
{
    on:
    {
        on[TP,channel.channel]
    }
}


channel_event[vDVD,9]      // feedback:power
{
    on:
    {
        on[TP,27]
    }
    off:
    {
        on[TP,28]
    }
}


data_event[TP]
{
    string:
    {
        // Don't let touch panel go to sleep.  We want to keep video 
        //    window active.

        if (data.text == 'SLEEP')
        {
            send_command TP, 'WAKE'
        }
    }
}


button_event[TP, 0]
{
    push:
    {
        // Touch panel button id's for this test were set to correspond with
        //    their respective IR channels to simplify NetLinx programming.
        //    Each of these inputs could also be acted on by sending a command
        //    (send_command) to the vDVD device.  See the NetLinx module
        //    interface document for details on these commands.
        pulse[vDVD, button.input.channel]
    }
}


DEFINE_PROGRAM

