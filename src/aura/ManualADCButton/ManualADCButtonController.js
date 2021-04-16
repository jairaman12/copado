({
    
    doInit: function(component, event, helper) {
        var deviceType = $A.get("$Browser.formFactor");
        if(deviceType == 'DESKTOP') {
            helper.openManualADCTabs(component,event);
        } else {
            helper.navigateToMobilePage(component, event);
        }     
    }
})