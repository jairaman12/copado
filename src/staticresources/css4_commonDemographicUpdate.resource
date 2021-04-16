@charset utf-8;

#add2{
    
    display: none; 
}

#body {
    padding:10px 1em;
    padding-bottom:60px;
}

#container {
    margin:0 auto;
    max-width:1000px;
    min-height:100%;
    position:relative;
    width:94%;
}

#deleteAssociated, #calendarDeleteAssociated, .addAFile {
    cursor: pointer;
    background-color: whitesmoke;
    color: #005587;
    padding: .15em;
    border-radius: 3px;
    border: 1px solid grey;
    
}


#errorMessageContainer {
    color:#444;
    display:none;
    font-size:80%;
    margin:0;
    padding:0;
    text-align:left;
    width:100%;
}

#errorMessageContainer #emcMoreInfo {
    background-color:#5DADE2;
    border-radius:.5em;
    color:#FFF;
    cursor:pointer;
    font-size:75%;
    padding:.25em;
    padding-left:.25em;
}

#errorMessageContainer div#detailMessages {
    color:#000;
    cursor:pointer;
    padding-left:2em;
}

#errorMessageContainer div#emcBoilerPlate {
    color:red;
}

#footer {
    bottom:0;
    color:#bfbfbf;
    height:30px;
    position:absolute;
    text-align:center;
    width:100%;
}

#header {
    border-bottom:none;
    padding:3em 0 0;
    text-align:center;
}

/* hack for h2 on p2 page*/
#p2 ul li h2
{
    
    padding-bottom: 1em; 
    
}

#p5 .section h2 {
    padding-top: 1em;
}



#removeAllContainer, #removeProviderContainer{    
    display:none;
}

#residencyContainer {
    padding-bottom:3em;
}

#residencyContainer label {
    clear:both;
    color:#505050;
}

#residencyContainer div.floatL {
    padding-right: .5em;
}

#s1{
    display:none;
}

.additionalErrorMessage {
    color:red;
    font-size:80%;
    word-wrap:break-word;
}

.additionalInformation {
    padding-top:3em;
}

.alert {
    color:#a40000;
    font-weight:700;
}

.button {
    cursor:pointer;
    min-width:150px;
    width:25%;
}

/*
* This provides some padding above the Attach Documentation label's div/column
* for responsive view

div.section.additionalInformation div.column div.column:nth-of-type(2) 
{
padding-top: 1em;

}    
*/

.msgConfirm {
    -moz-box-shadow: 0px 0px 0px 2px #9fb4f2;
    -webkit-box-shadow: 0px 0px 0px 2px #9fb4f2;
    box-shadow: 0px 0px 0px 2px #9fb4f2;
    background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #7892c2), color-stop(1, #476e9e));
    background:-moz-linear-gradient(top, #7892c2 5%, #476e9e 100%);
    background:-webkit-linear-gradient(top, #7892c2 5%, #476e9e 100%);
    background:-o-linear-gradient(top, #7892c2 5%, #476e9e 100%);
    background:-ms-linear-gradient(top, #7892c2 5%, #476e9e 100%);
    background:linear-gradient(to bottom, #7892c2 5%, #476e9e 100%);
    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#7892c2', endColorstr='#476e9e',GradientType=0);
    background-color:#7892c2;
    -moz-border-radius:10px;
    -webkit-border-radius:10px;
    border-radius:10px;
    border:1px solid #4e6096;
    display:inline-block;
    cursor:pointer;
    color:#ffffff;
    font-family:Arial;
    font-size:19px;
    padding:12px 37px;
    text-decoration:none;
    text-shadow:0px 1px 0px #283966;
}
.subRequestButton {
    -moz-box-shadow: 0px 0px 0px 2px #9fb4f2;
    -webkit-box-shadow: 0px 0px 0px 2px #9fb4f2;
    box-shadow: 0px 0px 0px 2px #9fb4f2;
    background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #7892c2), color-stop(1, #476e9e));
    background:-moz-linear-gradient(top, #7892c2 5%, #476e9e 100%);
    background:-webkit-linear-gradient(top, #7892c2 5%, #476e9e 100%);
    background:-o-linear-gradient(top, #7892c2 5%, #476e9e 100%);
    background:-ms-linear-gradient(top, #7892c2 5%, #476e9e 100%);
    background:linear-gradient(to bottom, #7892c2 5%, #476e9e 100%);
    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#7892c2', endColorstr='#476e9e',GradientType=0);
    background-color:#7892c2;
    -moz-border-radius:10px;
    -webkit-border-radius:10px;
    border-radius:10px;
    border:1px solid #4e6096;
    display:inline-block;
    cursor:pointer;
    color:#ffffff;
    font-family:Arial;
    font-size:19px;
    padding:12px 37px;
    text-decoration:none;
    text-shadow:0px 1px 0px #283966;
}
.subRequestButton:hover {
    background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #476e9e), color-stop(1, #7892c2));
    background:-moz-linear-gradient(top, #476e9e 5%, #7892c2 100%);
    background:-webkit-linear-gradient(top, #476e9e 5%, #7892c2 100%);
    background:-o-linear-gradient(top, #476e9e 5%, #7892c2 100%);
    background:-ms-linear-gradient(top, #476e9e 5%, #7892c2 100%);
    background:linear-gradient(to bottom, #476e9e 5%, #7892c2 100%);
    
    background-color:#476e9e;
}
.subRequestButton:active {
    position:relative;
    top:1px;
}



.buttonContainer {
    clear:both;
    padding-top:4em;
}

.buttonContainer button {
    background-color: #005587;
    border-radius: .5em;
    color: #fff;
    cursor: pointer;
    font-weight: 400;
    min-width: 95px;
    padding: 1em;
    text-align: center;
    text-decoration: none;
    font-size: 120%;
}

.buttonContainer button.back {
    float:left;
}

.buttonContainer button.next {
    float:right;
}

.clear {
    clear:both;
}

.column {
    float:left;
    min-width:250px;
    width:50%;
}

.column fieldset table tr td {
    padding-right:0;
}

.days {
    float:left;
    margin-bottom:10px;
    width:40px;
}

.errorGlow {
    box-shadow:0 0 15px 5px rgba(247,102,102,0.31);
}

.highlightGlow {
    box-shadow:0 0 15px 5px rgba(102,102,102,0.31);
}

.fieldsetInColumn {
    padding-bottom:1.5em;
    padding-top:.5em;
}

.fileUpload {
    position: relative;
    overflow: hidden;
    padding-top: .5em;
    width: 300px;
}
.fileUpload input.upload {
    position: absolute;
    top: 0;
    left: -125px;
    margin: 0;
    padding: 0;
    font-size: 20px;
    cursor: pointer;
    opacity: 0;
    filter: alpha(opacity=0);
    width: 220px;
}

.fileUpload input#uploadFile
{	
    width: 10em;
}

.fileUpload label
{
    display: block;
    margin-bottom: .5em;
    
}


.fileUpload span
{
    padding: .5em;
    border: 2px solid rgb(95, 148, 179);
    margin: .25em;
    font-size: small;
    border-radius: .25em;
    color: rgb(95, 148, 179);	
    
}


span.fileFormatText, div.fileFormatText 
{
    color: silver;
    font-size: 80%;
    margin-bottom: 1em;
    display: block;
    border: none;
    padding: 0px;
}

div.fileFormatText
{
    margin-bottom: 0px;
    
}


.fileUpload div
{
    padding-top: .5em;
    
}

.floarR, .floatR {
    float:right;
}

.floatL {
    float:left;
}

.full {
    width:100%;
}

.greyedOut h2, .greyedOut label, .greyedOut .padTopAndBottom
{
    color: lightgrey;
    
}

.hours {
    width:40px!important;
}

.inlineButton {
    background-color:#005587;
    border:1px solid #005587;
    border-radius:4px;
    color:#fff;
    display:block;
    font-size:.8em;
    font-weight:400;
    padding:3px 10px;
    position:relative;
    text-align:center;
    text-decoration:none;
}

.inputfile {
    height:.1px;
    opacity:0;
    overflow:hidden;
    position:absolute;
    width:.1px;
    z-index:-1;
}

.inputfile + label {
    cursor:pointer;
    display:inline-block;
    max-width:100%;
    overflow:hidden;
    text-overflow:ellipsis;
    white-space:nowrap;
}

.marginBigR {
    margin-right:3em;
}

.marginBigR label div,div.floatL.marginBigR input[fauxtype="date"] {
    margin-left:.7em;
}

.marginR {
    margin-right:20px;
}

.msgConfirm {
    -moz-box-shadow: 0px 0px 0px 2px #9fb4f2;
    -webkit-box-shadow: 0px 0px 0px 2px #9fb4f2;
    box-shadow: 0px 0px 0px 2px #9fb4f2;
    background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #7892c2), color-stop(1, #476e9e));
    background:-moz-linear-gradient(top, #7892c2 5%, #476e9e 100%);
    background:-webkit-linear-gradient(top, #7892c2 5%, #476e9e 100%);
    background:-o-linear-gradient(top, #7892c2 5%, #476e9e 100%);
    background:-ms-linear-gradient(top, #7892c2 5%, #476e9e 100%);
    background:linear-gradient(to bottom, #7892c2 5%, #476e9e 100%);
    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#7892c2', endColorstr='#476e9e',GradientType=0);
    background-color:#7892c2;
    -moz-border-radius:10px;
    -webkit-border-radius:10px;
    border-radius:10px;
    border:1px solid #4e6096;
    display:inline-block;
    cursor:pointer;
    color:#ffffff;
    font-family:Arial;
    font-size:19px;
    padding:12px 37px;
    text-decoration:none;
    text-shadow:0px 1px 0px #283966;
}


.note {
    color:#505050;
    font-size:.9em;
    font-style:italic;
    margin: 0 0 1em 0;
}

.padTopAndBottom
{
    padding-top: 1em;
    padding-bottom: 1em;
    
}



fieldset legend:before, label.required:before , p.required:before {
    color:red;
    content:'* ';
    display:inline;
}


.sButton {
    background-color: #005587;
    border-radius: .5em;
    color: #fff;
    cursor: pointer;
    font-weight: 400;
    min-width: 95px;
    padding: 1em;
    text-align: center;
    text-decoration: none;
    font-size: 120%;
    margin-top: -2em;
}

.section {
    clear:both;
    margin:0;
}

.section ul li {
    list-style-type:none;
}

.section ul li span {
    position:relative;
    top:-.25em;
}

.smallSpaceOnTop
{
    margin-top: .5em;
}

.smallSpaceOnTop .fileFormatText
{
      color: silver;
    font-size: 80%;
    border: none;
    padding: 0px;  
    display: inline;
    margin-left: .25em;
}


.greyedOut h2
{
    color: lightgrey;
    
}

.stateAndZipContainer {
    padding-bottom:4em;
}

.subButton {
    background-color:#fff;
    color:#005587;
    min-width:150px;
    width:25%;
}

.submitButton {
    -moz-box-shadow: 0px 0px 0px 2px #9fb4f2;
    -webkit-box-shadow: 0px 0px 0px 2px #9fb4f2;
    box-shadow: 0px 0px 0px 2px #9fb4f2;
    background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #7892c2), color-stop(1, #476e9e));
    background:-moz-linear-gradient(top, #7892c2 5%, #476e9e 100%);
    background:-webkit-linear-gradient(top, #7892c2 5%, #476e9e 100%);
    background:-o-linear-gradient(top, #7892c2 5%, #476e9e 100%);
    background:-ms-linear-gradient(top, #7892c2 5%, #476e9e 100%);
    background:linear-gradient(to bottom, #7892c2 5%, #476e9e 100%);
    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#7892c2', endColorstr='#476e9e',GradientType=0);
    background-color:#7892c2;
    -moz-border-radius:10px;
    -webkit-border-radius:10px;
    border-radius:10px;
    border:1px solid #4e6096;
    display:inline-block;
    cursor:pointer;
    color:#ffffff;
    font-family:Arial;
    font-size:19px;
    padding:12px 37px;
    text-decoration:none;
    text-shadow:0px 1px 0px #283966;
}
.submitButton:hover {
    background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #476e9e), color-stop(1, #7892c2));
    background:-moz-linear-gradient(top, #476e9e 5%, #7892c2 100%);
    background:-webkit-linear-gradient(top, #476e9e 5%, #7892c2 100%);
    background:-o-linear-gradient(top, #476e9e 5%, #7892c2 100%);
    background:-ms-linear-gradient(top, #476e9e 5%, #7892c2 100%);
    background:linear-gradient(to bottom, #476e9e 5%, #7892c2 100%);
    
    background-color:#476e9e;
}
.submitButton:active {
    position:relative;
    top:1px;
}

.thirds
{
    float: left;
    min-width: 150px;
    width: 30%;
}

.thirds label{
    display: block;
}


.ui-datepicker {
    background:#AED6F1;
    border:1px solid #42AAEF;
    color:##3498DB;
    font-family:Garamond;
    font-size:14px;
    margin-left:25px;
}

.ui-datepicker-trigger {
    background-color:#fff;
    border:none;
    cursor:pointer;
    margin:0;
    padding:0;
    padding-top:.5em;
}

.ui-dialog-content.ui-widget-content {
    padding-top:1em;
    text-align:center;
    width:100%;
}

.ui-dialog-titlebar-close {
    visibility:hidden;
}

.ui-dialog.success-dialog {
    left:0;
    outline:0 none;
    padding:0!important;
    position:absolute;
    top:0;
}

.ui-dialog.success-dialog .ui-dialog-content {
    background:none repeat scroll 0 0 transparent;
    border:0 none;
    margin:0;
    overflow:auto;
    padding:0!important;
    position:relative;
}

.ui-dialog.success-dialog .ui-dialog-titlebar {
    font-size:1em;
    padding:.1em .5em;
    position:relative;
}

.ui-dialog.success-dialog .ui-widget-header {
    background:#005587;
    border:0;
    color:#fff;
    font-weight:400;
}

.ui-widget-content.success-dialog {
    background:#F9F9F9;
    border:1px solid #005587;
    color:#222;
}

.ui-widget.success-dialog {
    font-family:Verdana, Arial, sans-serif;
    font-size:.8em;
}

:-moz-placeholder {
    color:#979797;
    font-style:italic;
    opacity:1;
}

:-ms-input-placeholder {
    color:#979797;
    font-style:italic;
}

::-moz-placeholder {
    color:#979797;
    font-style:italic;
    opacity:1;
}

::-webkit-input-placeholder {
    color:#979797;
    font-style:italic;
}

/*
button:hover,button:focus,.inlineButton:hover,.inlineButton:focus {
background-color:#003d61;
border-radius:4px;
buttonbackground-color:#005587;
color:#fff;
cursor:pointer;
font-weight:400;
min-width:150px;
padding:1em;
text-align:center;
text-decoration:none;
}
*/

div#container div#p1.success {
    display:block;
}

div#container div[id*="p"] {
    display:none;
}

div#h input[type="text"] {
    width:4.5em;
}

div#h input[type='text']::-ms-clear {
    display: none;
}

div#s1
{
    
    margin-top: 1.5em;
}

div#s1 a.sButton {
    cursor:pointer;
}

fieldset {
    border:none;
    display:inline;
    padding:0;
    width: 100%;
}

fieldset legend:before {
    color:red;
    content:'* ';
    display:inline;
}

fieldset table tr td {
    padding-right:2em;
}

fieldset[input:checked] {
    color:red;
}

footer {
    clear:both;
    padding:1em;
}

footer div {
    color:silver;
    font-size:80%;
    margin:auto;
    text-align:center;
    width:100%;
}

h1 {
    color:#005587;
    font-size:1.7em;
    font-weight:400;
    line-height:1.7em;
    margin:0;
}

h2 {
    color:#505050;
    font-size:1.3em;
    font-weight:700;
    line-height:1.4em;
    margin:.5em 0 0;
}

h3 {
    color:#005587;
    font-size:1em;
    font-weight:700;
    line-height:1.1em;
    margin:.5em 0;
    padding-bottom:1em;
    padding-top:.75em;
}

html,body {
    color:#000;
    font-family:'Open Sans', sans-serif;
    font-size:1em;
    height:100%;
    line-height:1.2em;
    margin:0 .5em;
    padding:0;
}

input::-webkit-calendar-picker-indicator {
    display:none;
}



input[fauxtype="date"]::-webkit-input-placeholder {
    visibility:hidden!important;
}

input[type="checkbox"],input[type="radio"] {
    height:18px;
    width:18px;
}

input[type="file"] {
	margin-top: .25em;
}

input[type="text"] {
    border:0;
    border-bottom:1px solid #939393;
    padding:5px;
    width:80%;
    margin-bottom:1em;
}

input[fauxtype="date"] {
    border:none;
    border-bottom:1px solid #939393;
    color:#999;
    width:7em;
}

input[type=text],textarea {
    -moz-transition:all .3s ease-in-out;
    -ms-transition:all .3s ease-in-out;
    -o-transition:all .3s ease-in-out;
    -webkit-transition:all .3s ease-in-out;
    margin:5px 1px 3px 0;
    outline:none;
    padding:3px 0 3px 3px;
    resize:none;
}

input[type=text].alert {
    border-bottom:1px solid #a40000;
}

input[type=text]:focus,textarea:focus {
    box-shadow:0 0 5px rgba(81,203,238,1);
    margin:5px 1px 3px 0;
    
}

label {
    color:#505050;
    font-weight:400;
    line-height:1.4em;
}

legend {
    color:#505050;
    float:left;
    padding-right:1em;
    position:relative;
    top:.25em;
}

p {
    margin:1em 0;
}

select {
    border:0;
    border-bottom:1px solid #939393;
    padding:4px 5px;
    width:82%;
}

sup {
    font-size:.6em;
}

td label {
    padding-right:1.5em;
    position:relative;
    top:-.25em;
}

textarea {
    border:1px solid #939393;
    padding:5px;
    width:80%;
}

.section.additionalInformation .column:first-of-type
{
    width: 35%;  
}

.section.additionalInformation .column:last-of-type
{
    width: 65%;
    
}

.section.additionalInformation .column:last-of-type .column:first-of-type
{
    width: 30%;
    
}

.section.additionalInformation .column:last-of-type .column:last-of-type
{
    width: 60%;
    
}


@media max-width 640px{
    #body {
        padding:10px 0;
        padding-bottom:60px;
    }
    
    
    
    
    
