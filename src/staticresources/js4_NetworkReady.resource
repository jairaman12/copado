
$( 
    function() 
    {
        
        
        
        var instanceObject = null;
        
        
        if(gChangeMode == 'Add')
        {
            instanceObject = (new networkObject());
        }
        else if(gChangeMode =='Change')
        {
            instanceObject = (new changeNetworkObject());
            
        }
            else
            {
                instanceObject = (new deleteNetworkObject());
            }
        
        $("#addNetworkButton").click
        (
            function()
            {
                instanceObject.processAddButton();
            }
        );   
        
        $("#saveButton").click
        (
            
            function()
            {
                /* 
             	* Disable buttons to prevent errors on submit. Show Loading gif...
             	*/
                $("#saveButton").prop('disabled', true);
            	$("#backButton").prop('disabled', true);
                $("#addNetworkButton").prop('disabled', true);
            	$("[id*='savingGifPanel']").css("display","inline-block"); 
                
                instanceObject.clickAllSelectedRows();
                
                instanceObject.processSaveButton();
            } 
        );
        
        /* 
    	* Developer: Travis Self
    	* PPN-30828, Used when clicking the back button.
    	*/
        $("#backButton").click
        (
            function()
            {
                instanceObject.clickAllSelectedRows();
                
                instanceObject.processBackButton();
            }  
        );
        
        instanceObject.init();
        
        
    }
);





