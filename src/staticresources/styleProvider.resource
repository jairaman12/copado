@charset "utf-8";

html,body {margin:0 .5em; padding:0; height:100%; color:#000; font-family: 'Open Sans', sans-serif; font-size:1em; line-height: 1.2em;}
#container {margin: 0 auto; max-width: 1000px; width: 94%; min-height:100%; position:relative;}
#header {border-bottom: solid 1px #005587; text-align:center; padding:3em 0 0 0;}
#body {padding:10px 1em; padding-bottom:60px;}
#footer {position:absolute; bottom:0; width:100%; text-align: center; color:#bfbfbf; height:30px;}

h1 {color: #005587; font-size: 1.7em; font-weight:normal; line-height: 1.7em; margin:0}
h2 {color: #505050; font-size: 1.3em; font-weight:bold; line-height: 1.4em; margin: .5em 0 0 0;}
h3 {color: #005587; font-size: 1em; font-weight:bold; line-height: 1.1em; margin: .5em 0; padding-bottom:1.5em}
label { line-height:1.4em; font-weight:normal; color:#505050}
p {margin:0 0 1em 0;}
.note {color:#505050; font-style:italic; font-size:.9em}
.required{color: #d40000;font-weight:normal;}
.alert{color: #a40000;font-weight:bold;}
sup {font-size:.6em}

.button {position:relative; display:block; background-color: #005587; color: #fff; font-weight:normal; text-decoration:none; text-align:center; padding:10px; border-radius:4px; border: 1px solid #005587; min-width:150px;}
.inlineButton {position:relative; display:block; background-color: #005587; color: #fff; font-size:.8em; font-weight:normal; text-decoration:none; text-align:center; padding:3px 10px; border-radius:4px; border: 1px solid #005587;}
.subButton {background-color: #fff; color: #005587;}
.button:hover, .button:focus, .inlineButton:hover, .inlineButton:focus { color: #fff; background-color: #003d61; text-decoration: none; }
input[type=text] {padding:5px; border: 0; border-bottom: 1px solid #939393; width:80%}
input[type=text].alert {border-bottom: 1px solid #a40000;}
input[type="checkbox"], input[type="radio"] {height:18px; width: 18px;}
textarea {padding:5px; border: 1px solid #939393; width:80%}
select {padding:4px 5px; border: 0; border-bottom: 1px solid #939393; width:82%}
::-webkit-input-placeholder { color:#979797; font-style:italic;} /* WebKit, Blink, Edge */
:-moz-placeholder {color:#979797; opacity:1; font-style:italic;} /* Mozilla Firefox 4 to 18 */
::-moz-placeholder { color:#979797; opacity:1; font-style:italic;} /* Mozilla Firefox 19+ */
:-ms-input-placeholder {color:#979797; font-style:italic;} /* Internet Explorer 10-11 */

.section {margin:0 5em}
.column {width:50%; min-width:250px; float:left}
.full{width:100%} 
.days {width:40px; float:left; margin-bottom:10px}
.hours {width:40px !important;}
.marginR{margin-right:20px;}
.marginBigR{margin-right:70px;}
.clear {clear:both}
.floatL {float:left}
.floarR {float:right}

/*small screens*/
@media (max-width: 640px) {
	#body {padding:10px 0; padding-bottom:60px;}
	.section {margin:0}
	.column {width:100%;}
.button { min-width:100px;}
}

/* custom file input */
.inputfile {width: 0.1px; height: 0.1px; opacity: 0; overflow: hidden; position: absolute; z-index: -1;}
.inputfile + label {max-width: 100%; text-overflow: ellipsis; white-space: nowrap; cursor: pointer; display: inline-block; overflow: hidden;}

