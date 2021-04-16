

#allSelectedNetworksBand
{

	overflow-y: auto;
	padding: 0em;
	margin: 0px;
	padding-bottom: .5em;
	border-radius: 3px;
	
}

#allSelectedNetworksBand _div:first-child
{

	border-bottom: 1px solid silver;
	background-color: #f7f7f7;
	padding: .25em;
	padding-bottom: .5em;

}	


#dropZone

{
  position:relative;
  top:-65%;
  left:22%;
  color:#fff;
  font-size:200%;
}

#fullNetworkContainer div
{
	background-color: #f7f7f7;
	padding: .25em;
	border-bottom: 1px solid grey;
		
	
}	



#fullNetworkList
{
 /* width:175px; */
  height:100%;
  list-style-type:none;
  opacity:.75;
 /* overflow:auto;  */
  //background-color:#efefdb;
  margin:5px;
  padding:0;
}


#fullNetworkList h5

{
  white-space:nowrap;
  overflow-x:hidden;
  font-size:60%;
  margin:0;
  padding:0;
}


#fullNetworkList li

{
  max-height:2em;
  cursor:pointer;
  
  border:1px solid #fff;
  margin:0;
  padding:.25em;
  z-index: 99;
}

#individualNetworksBand
{
	
	background-color: #f7f7f7;
	padding: .25em;
	margin-bottom: .5em;
	
}

#selectedNetworkContainer .networkContainer:nth-child(odd)
{
	background-color: #f3f2f2;
}


#selectedNetworkContainer .networkContainer:nth-child(even)
{
	background-color: #f7f7df;
}


/* 
 * override the odd/even stripping when dragging
 */
.networkContainer.ui-draggable.ui-draggable-handle.ui-draggable-dragging
{
	background-color: #eff9f7 !important;
}





#subLabel

{
  
  margin-top:.25em;
  padding-left:1em;
  height:2em;
}


#subLabel span:first-child

{
  width:15em;
  margin-right:8em;
}


#topOfPageErrorMessage

{
  color:red;
  display:none;
}



.codesContainer
{
	display: none;
	
	
	
}

.codesContainer .inputContainer div, .codesContainer .inputContainer input, .codesContainer .inputContainer select
{
	
	
	
	
}



.column

{
  float:left;
  margin-left:1em;
}


.column .columnHeader
{
  font-family:Arial;

  padding:1em;
}


.deleteMe
{
  position:relative;
  top:-26px;
  left:-417px;
  background-color:#fbfbfb;
  border-top-left-radius:1em;
  border-left:1px solid silver;
  border-right:1px solid silver;
  cursor:pointer;
  padding:.20em .20em .5em;
}


.elementsContainer
{
  display:none;
}


.errorMessage
{
  
  font-family:Arial;
  color:red;
  padding-left:1em;
}

.fixedSizeContainer
{
	height: 25em;
    
	overflow:auto;
	margin-top: 1em;
	padding-top: 1em;
}

.infaux
{
    background-color: #efeff5;
    margin: .5em;
    padding-left: .5em;
    border-radius: 50%;
    color: #423737;
    font-size: 90%;
    border: 1px solid #5e5858;
    font-family: serif;
    position: relative;
    top: 11px;
    font-style: italic;
    padding-right: .5em;
    padding-top: .1em;
    padding-bottom: 0.1em;
    font-weight: bold;
    cursor: help;
}	

.inputContainer

{
  float:left;
  padding-left:1em;
}


.inputContainer label

{
  width:20em;
}

.inputContainer #nwReason
{
    width: 10em; 
}

.networkContainer
{
	
	
	border-radius: 5px;
	min-width: 45em;
	
}	


.perNetworkInfo

{
  float:left;
}




.pfinRowContainer

{
  clear:both;
  margin-top:.5em;
  margin-bottom:.5em;
  padding-top:.5em;
  padding-bottom:.5em;
  background-color:#efefef;
  overflow:auto;
  border:1px solid #f0f0f0;
  border-radius:5px;
  width:100%;
}


.required:before

{
  content:"*";
  color:red;
}



.row
{
	clear: both;
	padding-top: 1em;
		
}


.selectedNetworks
{
  list-style-type:none;
  font-family:Arial;
 
  min-height:10em;
  
  width:10em;  
  overflow-x:hidden;
  overflow-y:auto;
  border:3px dashed #fff;
  background-color:#e0e0e0;
  margin:0;
  padding:0;

}


.selectedNetworks .elementsContainer
{
  display:inline;
  padding-bottom:1em;
  margin:-15px .25em .25em;
}


.selectedNetworks li
{
  background-color:silver;

  border-bottom:1px solid #fff;
  margin:0;
  padding:.5em;
}


.selectedNetworks li

{
  font-family:Arial;
  
  padding:.25em;
}

.stringDate
{
	font-size: 80%;
	text-decoration: underline;
	cursor: pointer;
	margin-top: .25em;
	
}	

.subContainer
{
	clear:both;
	background-color: inherit;
	min-height: 2em; 
	padding-top: .5em;
	
	
}

.textareaFix
{
    position: relative;
    top: -24px;
    left: 0px;
}

.trashCan
{
    background-color: #e0e0e0;
    width: 100%;
    height: 10em;
    border: 2px dashed white;
}


.row .ui-state-active
{
  border:1px solid #ccc;
  background:silver;
  font-weight:400;
  color:#fff;
  
}


.ui-tabs .ui-tabs-panel

{
  display:block;
  background:none;
  overflow-y:auto;
  workcontainermargin-top:1em;
  border-width:0;
  padding:1em 1.4em;
}





:-ms-input-placeholder,::-ms-input-placeholder

{
  color:silver;
}


::placeholder

{
  color:silver;
  opacity:1;
}

html, input, select, textarea, ul
{
	font-size: 1em;
	border-radius: 3px;
}

body
{
  background-color:#f8f8f8;
  font-family:Arial;
  margin:0;
  padding:0;
  font-size: 80%;
}


h3

{
  //background-color:#efefdc;
  width:100%;
  
  border-color:#c0be72;
  margin:0;
  padding:.25em;
}

fieldset
{
	background-color: #f7f7f7;
	border-radius: 5px;
	margin-bottom: .5em;
	border: 1px solid #efecec;
	
}


input[type=button]
{
	margin-top: 1em;
	margin-left: 1em;
}

label
{
		
	
}

.fixedSizeContainer legend 
{
    background-color: #f3f3f3; 
    padding: .25em;
    border-radius: 5px;
    border: 1px solid gray;
    color: black;
    margin: .25em;
    font-weight: normal;
}

span.psuedoButton, span.psuedoButton:hover

{
	background-color:#d5deda;
	border:1px solid #fff;
    margin-top: -3px;
	border-radius:5em;
	cursor:pointer;
	padding:.1em .25em;
	float: right;
	display: none;
	z-index: 100;
}


span.psuedoButton:hover

{
  background-color:grey;

}

textarea
{
		overflow: hidden;
}

#saveButton
{
  /*
    background-color: blue;
  border: none;
  color: white;
  padding: 8px 15px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  margin: 4px 2px;
  cursor: pointer
   */
}

#addNetworkButton 
{
    padding-left: 1rem;
    padding-right: 1rem;
    text-align: center;
    vertical-align: middle;
    background-color: #005fb2;
    border: 1px solid #005fb2;
    color: white;
}

#lightinigstyle
{
  background-color: rgba(27, 82, 151, 1);
  color:white;
  padding: 8px 15px;
}

body .helpOrb {
    padding: 0.75rem 1rem 0 0;
}
    
    
}