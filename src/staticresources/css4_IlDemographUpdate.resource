@charset utf-8;

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

#deleteAssociated {
cursor:pointer;
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

#residencyContainer {
padding-bottom:4.5em;
}

#residencyContainer label {
clear:both;
color:#505050;
display:block;
padding-bottom:.75em;
}

.additionalErrorMessage {
color:red;
font-size:80%;
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

.fieldsetInColumn {
padding-bottom:1.5em;
padding-top:.5em;
}

.fileUpload {
    position: relative;
    overflow: hidden;
	padding-top: .5em;
}
.fileUpload input.upload {
    position: absolute;
    top: 0;
    right: 0;
    margin: 0;
    padding: 0;
    font-size: 20px;
    cursor: pointer;
    opacity: 0;
    filter: alpha(opacity=0);
}

.fileUpload input#uploadFile
{
	
	width: 10em;
	
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


.fileUpload span.fileFormatText {
	color: silver;
	font-size: 80%;
	margin-top: 1em;
	display: block;
	border: none;
	padding: 0px;
}

.fileUpload div
{
	padding-top: .5em;
	
}

.floarR {
float:right;
}

.floatL {
float:left;
}

.full {
width:100%;
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

.note {
color:#505050;
font-size:.9em;
font-style:italic;
margin: 0 0 1em 0;
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

.stateAndZipContainer {
padding-bottom:3em;
}

.subButton {
background-color:#fff;
color:#005587;
min-width:150px;
width:25%;
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
width:25em;
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
}

input[type=text].alert {
border-bottom:1px solid #a40000;
}

input[type=text]:focus,textarea:focus {
box-shadow:0 0 5px rgba(81,203,238,1);
margin:5px 1px 3px 0;
padding:3px 0 3px 3px;
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

@media max-width 640px{
#body {
padding:10px 0;
padding-bottom:60px;
}




