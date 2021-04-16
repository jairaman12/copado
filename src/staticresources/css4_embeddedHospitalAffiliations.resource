        
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
			padding-right: 33%;
        	float: left;
        
        }
        
        #headerWrapper a
        {
        	text-decoration: none;
        
        }

		/*
		 * Faux button, since Firefox has issues with opening <button> items
		 */ 
        #headerWrapper div
        {
            background: #f8f8f9;
            padding: .5em;
            border: 1px solid #b5b5b5;
            border-radius: .25em;
            font-weight: bold;                   
        }
        /*
        	Sets up scrollbars for when the data overflows the 200px space allocation
        */
        #tableWrapper
        {
        	height: 192px;
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
        
        .hideOrShowRows[id="[][]"] 
        {
        	display:none ;
        
        }
        
        .hideOrShowMessage
        {
        	display: none;
        	clear: both;
        	background: #f8f8f8;
        	padding: .5em;
        	border: 1px solid #ededed;
        	margin:.25em;
        }
        
        .hideOrShowMessage[id*="[][]"] 
        {
        	display:block ;
        
        } 
        
          
        
        
        
        
        