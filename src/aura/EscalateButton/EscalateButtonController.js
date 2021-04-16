({
	doInit : function(component, event, helper) 
    {
		//Get case recordid
		var b = component.get('c.validateUserToEscalate');
       $A.enqueueAction(b); 
	},validateUserToEscalate:function(component, event)
    {
         var caseId			=	component.get('v.recordId') ;
        var sucessString 	=	'';	
        var action 			=	component.get('c.getEscalateCaseOwnerUpdate');
        action.setParams({"caseRecId":caseId});
        action.setCallback(this, function(a)
        {
            var state		=	a.getState(); // get the response state
            //alert(state+"===>>>");
            if(state == 'SUCCESS') 
            {
             	sucessString	=	a.getReturnValue();
                if(sucessString != "Success" && sucessString!="")
                {
                    // alert('hello!!! its failure'+a.getReturnValue());
                            var resultsToast = $A.get("e.force:showToast");
                            resultsToast.setParams({
                                "message" : sucessString,
                                "type"	  : "warning"
                            });
                            
                            //Update the UI: closePanel, show toast, refresh page
                            $A.get("e.force:closeQuickAction").fire();
                            resultsToast.fire();
                           $A.get("e.force:refreshView").fire();  
                }else {
                        var resultsToast = $A.get("e.force:showToast");
                            resultsToast.setParams({
                                "message" : "Case successfully escalated.",
                                "type"	  : "success"
                            });
                            
                            //Update the UI: closePanel, show toast, refresh page
                            $A.get("e.force:closeQuickAction").fire();
                            resultsToast.fire();
                    
                        var workspaceAPI = component.find("workspace");
                        workspaceAPI.getFocusedTabInfo().then(function(response) {
                            var focusedTabId = response.tabId;
                            workspaceAPI.closeTab({tabId: focusedTabId});
                        })
                        .catch(function(error) {
                            console.log(error);
                        });
                      $A.get("e.force:refreshView").fire(); 
                }
            }else{
               var resultsToast = $A.get("e.force:showToast");
                            resultsToast.setParams({
                                "message" : "Something went wrong reach out to your System Admin.",
                                "type"	  : "error"
                            });
                            
                            //Update the UI: closePanel, show toast, refresh page
                            $A.get("e.force:closeQuickAction").fire();
                            resultsToast.fire();
                            $A.get("e.force:refreshView").fire();  
            }     
        });
        $A.enqueueAction(action);
    }
})