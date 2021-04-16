({
    doInit : function(component, event, helper) {
        //Get case recordid
        var b = component.get('c.validateCaseOwner');
        $A.enqueueAction(b); 
    },
    validateCaseOwner:function(component, event) {
        
        var caseId			=	component.get('v.recordId') ;
        var isButton 		= 	component.get('v.isLightningButton'); //Shows whether this was launched from the lightning button
        var sucessString 	=	'';	
        var action 			=	component.get('c.getCaseMessage');
        var closeTab		= 	component.get('c.closeFocusedTab');
        action.setParams({"caseRecId":caseId});
        action.setCallback(this, function(a) {
            
            var state		=	a.getState(); // get the response state
            
            if(state == 'SUCCESS') {
                
                sucessString	=	a.getReturnValue();
                
                if(sucessString != "Success" && sucessString!="") {
                    // alert('hello!!! its failure'+a.getReturnValue());
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "message" : sucessString,
                        "type"	  : "warning"
                    });
                    
                    //Update the UI: closePanel, show toast
                    if(isButton == true) {
                        //If this was launched from the lightning button, 
                        //this closes the new tab via the closeFocusedTab method
                        $A.enqueueAction(closeTab);
                    } else {
                        $A.get("e.force:closeQuickAction").fire();
                    }
                    resultsToast.fire();
                    
                } else {
                    
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "message" : "Case successfully routed to data entry.",
                        "type"	  : "success"
                    });
                    
                    //Update the UI: closePanel, show toast
                    if(isButton == true) {
                        
                        //If this was launched from the lightning button, 
                        //this closes the new tab and fires the results toast.
                        $A.enqueueAction(closeTab);
                        resultsToast.fire();
                        
                    } else {
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
                    }
                }
            } else {
                
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "message" : "Something went wrong reach out to your System Admin.",
                    "type"	  : "error"
                });
                
                //Update the UI: closePanel, show toast
                if(isButton == true) {
                    //If this was launched from the lightning button, 
                    //this closes the new tab and fires the results toast.
                    $A.enqueueAction(closeTab);
                    resultsToast.fire();
                } else {
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire();
                    $A.get("e.force:refreshView").fire();
                }  
            }
        });
        $A.enqueueAction(action);
    },
    
    //This function closes the tab
    closeFocusedTab : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    }
})