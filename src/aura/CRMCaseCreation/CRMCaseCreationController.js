({
    doinit : function(cmp, event, helper){
        /* Launch CRM Creation based on broswer type, Desktop uses a visualforce page. Mobile uses a lightning component */
        var deviceType = $A.get("$Browser.formFactor");
        if(deviceType == 'DESKTOP') {
            console.log('Navigating to CRM Desktop...');
            helper.openTabWithSubtab(cmp,event);
        } else {
    		console.log("Navigating to CRM Mobile...");
            if(helper.passedMobileValidation(cmp, event)) {
                helper.getInitialInformation(cmp, event, helper);
                helper.fetchPickListVal(cmp, 'Origin', 'caseOrigin');
                helper.fetchPickListVal(cmp, 'Status', 'caseStatus');  
                helper.fetchPickListVal(cmp, 'Priority', 'casePriority');         
                helper.getData(cmp, event, helper); 
                
                // get the fields API name and pass it to helper function          
                var controllerField = cmp.get("v.controllingFieldAPI");
                var dependentField = cmp.get("v.dependingFieldAPI");
                var objDetails = cmp.get("v.caserec");        
                // call the helper function
                helper.fetchDepPicklist(cmp,objDetails,controllerField, dependentField);
                
                //set the status default to 'New'        
                objDetails.Status = 'New';
                cmp.set("v.caserec", objDetails);
            } else {
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "c:MobileErrorPage",
                    componentAttributes: {
            			recordType : 'CRM'
        			}
                });
                evt.fire();
            }
		} 
    },
    
    returnToParentRecord : function(cmp, event, helper){
        helper.returnToParentRecord(cmp, event, helper);
    },
    
    saveResponses : function(cmp, event, helper){
        helper.saveResponses(cmp, event, helper);
    },
    
    onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false); 
                component.set("v.outcomeFlag" , true); 
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true);
                component.set("v.outcomeFlag" , false); 
                component.set("v.listDependingValues", ['--- None ---']);
            }  
            
            if(component.get("v.caserec.CRM_Types__c") == 'Others')   
                component.set("v.otherDescFlag", true); 
            else 
                component.set("v.otherDescFlag", false); 
                      
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }
    }
})