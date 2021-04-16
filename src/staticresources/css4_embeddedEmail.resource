        
    	table
        {
            background: #f2f3f3;
        	clear: both;
        	width: 100%;
        	border: 1px solid #ededed;
        	margin-top: 2em;
        	border-radius: .5em;
            margin-left: .25em;
        	margin-right: .25em;
    		margin-bottom: .25em;
    		border-collapse: collapse;
    		

        }  
        
        table thead tr
        {                
			
        }
        
        table thead td
        {
        	font-weight: bold;
        	padding: .5em 0 .5em .5em;
        	border-left: 1px solid #ededed;
        	border-bottom: 1px solid #ededed;
        	margin: 0px;
        	font-size: 90%;
        
        }
        
        table tbody
        {
        	background: white;
        
        }

        table tbody tr
        {                
			
        }
        
        table tbody td
        {
        	padding: .5em;
        	margin: 0px;
    		border-bottom: 1px solid #ededed;
    		color: #000;
        
        }

		table tbody td a
        {
            color: #000;                       
        }
        
        table tbody td.actionLinks, table tbody td.actionLinks a
        {
        	padding: .25em;
        	margin: 0px;
        	color: #015ba7;    
        	white-space: nowrap;
    		text-decoration: none;
        }          
        
		table tbody td.actionLinks span
		{
			color: #d0d3d5;
			
		}        
        
        h3
        {
        	font-size: 130%;
        }
        
        #affiliationsDisplayContainer
        {
        	border-radius: 4px;
        	background: #f8f8f8;
        	padding: .25em;
        	border-top: 3px solid #236fbd;
        	border-left: 1px solid #ededed;
        	border-right: 1px solid #ededed;        
        	border-bottom: 1px solid #ededed; 
    		
        }                
        
        #headerWrapper span
        {
        	width: 48%;
        	float: left;
        
        }
        
        #headerWrapper a
        {
        	text-decoration: none;
        
        }
        /*
        	Sets up scrollbars for when the data overflows the 200px space allocation
        */
        #tableWrapper
        {
    		height: 420px;
        	overflow-y: auto;
        	overflow-x: none;
        	width: 100%;        
        }
 
        
        /*
        Super hacky here
        Used the Affiliations_r object as the id of the fields
        if it = "[]", then I know there are no relations, hide the object
        if it does not = "[]", then I know there are relations, show the rows.
        Would love to have used Account.Affiliations__r.size for render attribute,
        but that did not work.
        
        */
        
        .emptyMessage
        {
        	clear: both;
        	background: #f8f8f8;
        	padding: .5em;
        	border: 1px solid #ededed;
        	margin:.25em;
        }

    	.fauxButton
        {
            color: #333;
            margin: 1px;
            padding: 2px 3px;
            border: 1px solid #b5b5b5;
            border-bottom-color: rgb(181, 181, 181);
            border-bottom-color: #7f7f7f;
            background: #e8e8e9 url(/img/alohaSkin/btn_sprite.png) repeat-x right top;
            font-weight: bold;
            font-size: .9em;
            -moz-border-radius: 3px;
            -webkit-border-radius: 3px;
            border-radius: 3px;
            width: 7.5em;
            text-align: center;
                    
        }   


		/* If there are no email messages hide this  */
        .hideIfEmpty[id="[]"]
		{
    		display:none;   
		}
		/* If there are email messages show */
        .hideIfEmpty:not([id="[]"])
		{
    		display:block;   
		}

		/* If there are no email messages show this  */
        .showIfEmpty[id="[]"]
		{
    		display:block;   
		}
		/* If there are email messages hide */
        .showIfEmpty:not([id="[]"])
		{
    		display:none;   
		}

        .hideOrShowBasedOnId:not([id="[]"]) 
        {
        	display:block ;      
        }
        



		.underText
		{
    		font-size: 85%;
    		font-style: italic;
		}
        
          
        
        
        
        
        