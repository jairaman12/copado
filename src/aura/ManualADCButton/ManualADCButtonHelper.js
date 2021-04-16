({
    openManualADCTabs : function(component, event) {
        var recId 	= component.get('v.recordId');
        var objType = component.get('v.sobjecttype');
        var workspaceAPI = component.find("workspace");
        var urlString = '';
        
        console.log("Launching Manual ADC from " + objType + '...');
        
         /* Error messages used when created a new Manual ADC case */
        var errorMessage1 = 'Error: Insufficient Privileges for TX Users.';
        
        var action = component.get('c.getManualADCUrl');	/* Call the Server-Side Controller Method*/
        action.setParams({
            "userId" : $A.get("$SObjectType.CurrentUser.Id"),
            "recordId" : recId,	/* Pass in paramters to apex method */
            "objType": objType
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                urlString = a.getReturnValue();	/*Retrieve the built URL from the Server-Side Controller */
                if(urlString == 'errorMessage1' ) {
                    this.showToast(component, event, errorMessage1);
                }
                console.log('MANUAL ADC URL: ' + urlString)
                workspaceAPI.openTab({
                    url: '/lightning/r/' + objType + '/' + recId + '/view',		/* This is the main tab. It is the record the button was clicked from */
                    focus: true
                }).then(function(response) {
                    workspaceAPI.openSubtab({
                        parentTabId: response,
                        url: urlString,			/* This holds the URL that was built from the server-side Apex Controller. This will open in a subtab. */
                        focus: true
                    });
                })
                .catch(function(error) {
                    console.log(error);
                });
            }
        });
        
        $A.enqueueAction(action);
    }, 
    
    navigateToMobilePage : function(component, event) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:MobileErrorPage",
            componentAttributes: {
                recordType : 'Manual ADC'
            }
        });
        evt.fire();
	},
    
    showToast: function(component, event, toastMessage) {
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "message" : toastMessage,
            "type"	  : "error"
        });
        
        resultsToast.fire();  
    }  
})