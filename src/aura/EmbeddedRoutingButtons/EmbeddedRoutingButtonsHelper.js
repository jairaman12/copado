/**
* Helper for the EmbeddedRoutingButtonsController.
* <p /><p />
* @author Josh McGhee
*/
({
    doInit : function(component, caseId) {
        var isEscalatable = component.get('c.showEscalate');
        isEscalatable.setParams({caseRecId:caseId});
        isEscalatable.setCallback(this, function(response){
            
            var state = response.getState();
            
            if(state === "SUCCESS") {
                component.set('v.escalatable', response.getReturnValue());
            }
        });
        
        var isDataEntry = component.get('c.showDataEntry');
        isDataEntry.setParams({caseRecId:caseId});
        isDataEntry.setCallback(this, function(response){
            
            var state = response.getState();
            
            if(state === "SUCCESS") {
                component.set('v.canRouteToDataEntry', response.getReturnValue());
            }
        });
        
        var isContracting = component.get('c.showContracting');
        isContracting.setParams({caseRecId:caseId});
        isContracting.setCallback(this, function(response){
            
            var state = response.getState();
            
            if(state === "SUCCESS") {
                component.set('v.canRouteToContracting', response.getReturnValue());
            }
        });
        
        $A.enqueueAction(isContracting);
        $A.enqueueAction(isDataEntry);
        $A.enqueueAction(isEscalatable);
    },
    
    routeToContractingArea : function(component, caseId) {
        var sucessString 	=	'';	
        var action 			=	component.get('c.getContracting');
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
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire();
                    
                } else {
                    
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "message" : "Case successfully routed to contracting.",
                        "type"	  : "success"
                    });
                    
                    //Update the UI: closePanel, show toast
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
            } else {
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "message" : "Something went wrong reach out to your System Admin.",
                    "type"	  : "error"
                });
                
                //Update the UI: closePanel, show toast
                $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire(); 
            }
        });
        $A.enqueueAction(action);
    },
    
    routeToDataEntry : function(component, caseId) {
        var sucessString 	=	'';	
        var action 			=	component.get('c.getDataEntry');
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
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire();
                    
                } else {
                    
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "message" : "Case successfully routed to data entry.",
                        "type"	  : "success"
                    });
                    
                    //Update the UI: closePanel, show toast
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
            } else {
                
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "message" : "Something went wrong reach out to your System Admin.",
                    "type"	  : "error"
                });
                
                //Update the UI: closePanel, show toast
                $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire(); 
            }
        });
        $A.enqueueAction(action);
    },
    
    validateUserToEscalate : function(component, caseId) {
        var sucessString 	=	'';	
        var action 			=	component.get('c.getEscalateCaseOwnerUpdate');
        action.setParams({"caseRecId":caseId});
        action.setCallback(this, function(a) {
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