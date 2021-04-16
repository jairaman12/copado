

th 
{
    background-color: #d0dbed;
    color: black;
    font-size: 14px;
    font-family: Arial, Helvetica, serif; 
    padding: .5em;
    padding-left: .1em;
    width: 33%;
    
}
td
{
    font-size: 105%;
}

/*
* Properties for the client-side error messages
*/ 
#showOptMsgAlt
{
    color: #c00;
    background-image: url('/img/msg_icons/error24.png');
    background-position: 1em;
    background-repeat: no-repeat;
    padding-left: 25px;
    background-color: #ffc;
    border: 1px solid #c00;
    padding: 1em;
    margin: 1em;
    border-radius: 4px;
    font-weight: bold;
    display: none;
}
#showOptMsgAlt div
{
    padding-left: 3.5em;
}

#showOptMsgAlt ul
{
    margin: 0px;
}

#showOptMsgAlt #message
{
    color: black;
    font-weight: normal;
    
}

#supplementaryMessage
{
    font-size: 80%;
    color: #c00;
    
}

.greyedOut
{
    color: lightgrey;
    
}  

/*
* Adds the lock icon before readonly checkboxes.
*/ 
input[type="checkbox"][readonly="readonly"]::before
{
    background: url('/img/func_icons/util/lock12.gif') no-repeat;
    padding-left: 11px;
    content: "";
    margin-left: -14px;
}



