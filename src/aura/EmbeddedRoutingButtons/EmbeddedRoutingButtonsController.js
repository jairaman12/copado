/**
* Controller for the EmbeddedRoutingButtons component.
* <p /><p />
* @author Josh McGhee
*/
({
    doInit : function(component, event, helper) 
    {
        var caseId = component.get('v.recordId');
		helper.doInit(component, caseId);
	},
    
    routeToContractingArea : function(component, event, helper) {        
        var caseId = component.get('v.recordId');
        helper.routeToContractingArea(component, caseId);
    },
    
    routeToDataEntry : function(component, event, helper) {
        var caseId = component.get('v.recordId');
        helper.routeToDataEntry(component, caseId);
    },
    
    validateUserToEscalate:function(component, event, helper)
    {
        var caseId = component.get('v.recordId');
        helper.validateUserToEscalate(component, caseId);
    }
})