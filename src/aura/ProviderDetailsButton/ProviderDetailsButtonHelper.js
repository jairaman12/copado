({
    
	navigateToProviderDetails : function (component, event) {
        console.log('Navigating to Provider Details Page...');
        var recordId = component.get("v.recordId");      
        var sobject = component.get("v.sobjecttype");
        var workspaceAPI = component.find("workspace");
        
        /* Open Account as main tab and the Provider details vfp as a subtab in the console */
        workspaceAPI.openTab({
            url: '/lightning/r/' + sobject + '/' + recordId + '/view?0.source=alohaHeader',		
            focus: true
        }).then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                url:  '/apex/ProviderDetails_Extended?name=&Id=' + recordId ,	
                focus: true
            });
        })
    }
    
    
})