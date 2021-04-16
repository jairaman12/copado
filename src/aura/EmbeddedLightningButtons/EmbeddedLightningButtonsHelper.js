({
	/* Used to launch CRM Creation from Desktop */
    openCRMTabs : function(component, event) {
        console.log('Opening subtab...');
        var recId 	= component.get('v.recordId');
        var objType = component.get('v.sobjecttype');
        var workspaceAPI = component.find("workspace");
        var urlString = '';
        
        /* Error messages used when created a new CRM case */
        var errorMessage1 = 'Error: Insufficient Privileges.';	// For Data Rep or Enterprise Profile
        var errorMessage2 = 'Error: New Cases cannot be created under closed cases.';
        var errorMessage3 = 'Error: Please attach either Account Name or Case Entity before creating a CRM case.';
        var errorMessage4 = 'Error: Please select either Account Name(Physician) OR Case Entity(Hospital/Group/Master Entity) not both before creating a CRM case.';
        
        console.log('Launching CRM Case Creation from ' +  objType + '...');
        
        var action = component.get('c.getUrlBasedOnButtonSelected');	/* Call the Server-Side Controller Method*/
        action.setParams({
            "userId" : $A.get("$SObjectType.CurrentUser.Id"),	/* Pass in parameters to apex method */
            "recordId" : recId,	
            "objType": objType,
            "button" : "CRM"
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                urlString = a.getReturnValue();	/*Retrieve the built URL from the Server-Side Controller */
                if(urlString === 'errorMessage1' ) {
                    this.showToast(component, event, errorMessage1);
                    return false;
                } else if(urlString === 'errorMessage2' ) {
                    this.showToast(component, event, errorMessage2);
                    return false;
                } else if(urlString === 'errorMessage3') {
                    this.showToast(component, event, errorMessage3);
                    return false;
                } else if(urlString === 'errorMessage4') {
                    this.showToast(component, event, errorMessage4);
                    return false;
                }
                //$A.get('e.force:refreshView').fire();	/*** Refresh the view to prevent rendering issues ***/
                console.log('CRM URL: ' + urlString)
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
    
    /* Used to launch Manual ADC Creation from Desktop */
    openManualADCTabs : function(component, event) {
        var recId 	= component.get('v.recordId');
        var objType = component.get('v.sobjecttype');
        var workspaceAPI = component.find("workspace");
        var urlString = '';
        
        /* Error messages used when created a new Manual ADC case */
        var errorMessage1 = 'Error: Insufficient Privileges for TX Users.';	
        var errorMessage2 = 'Error: New Cases cannot be created under closed cases.';
        var errorMessage3 = 'Error: Please attach either Account Name or Case Entity before creating a Manual ADC case.';
        var errorMessage4 = 'Error: Please select either Account Name(Physician) OR Case Entity(Hospital/Group/Master Entity) not both before creating a Manual ADC case.';
        
        console.log('Launching Manual ADC from ' + objType + '...');
        
        var action = component.get('c.getUrlBasedOnButtonSelected');	/* Call the Server-Side Controller Method*/
        action.setParams({
            "userId" : $A.get("$SObjectType.CurrentUser.Id"),
            "recordId" : recId,	/* Pass in paramters to apex method */
            "objType": objType,
            "button": "Manual ADC"
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                urlString = a.getReturnValue();	/*Retrieve the built URL from the Server-Side Controller */
                if(urlString === 'errorMessage1' ) {
                    this.showToast(component, event, errorMessage1);
                    return false;
                } else if(urlString === 'errorMessage2' ) {
                    this.showToast(component, event, errorMessage2);
                    return false;
                } else if(urlString === 'errorMessage3' ) {
                    this.showToast(component, event, errorMessage3);
                    return false;
                } else if(urlString === 'errorMessage4' ) {
                    this.showToast(component, event, errorMessage4);
                    return false;
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
    
    showToast: function(component, event, toastMessage) {
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "message" : toastMessage,
            "type"	  : "error"
        });
        
        resultsToast.fire();  
    }
})