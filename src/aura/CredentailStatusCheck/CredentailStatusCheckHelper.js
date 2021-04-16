({
	
 /*
  * @author       : Ashok Nettem
  * @date         : 06/05/2019
  * @description  :call the controller and display the list of values
  * ver           :1.0 
  * @JIRA Stories : PPN-40802
*/
  
   getStatusHelper:function(component,LicenseNumber,NpiNumber){
        //To set the header of the table
        component.set('v.Mycolumns',[
            {label: 'Provider Name', fieldName: 'Name', type: 'text'},
            {label: 'Cred Status', fieldName: 'Cred_Status__c', type: 'text'},
            {label: 'State', fieldName: 'CM_Corporate_Entity_Code__c', type: 'text'},
            {label: 'Cred Status Date', fieldName: 'Cred_Status_Date__c', type: 'date'},
        ]);
       
        
        //Call Your Apex Controller Method based on the LicenseNumber
        if(LicenseNumber!=null || LicenseNumber!='')
         { 
             var action = component.get("c.getProviderDetailsByLicenseNumber");
             action.setParams({
                 'License_Number': LicenseNumber
         });
    }
        //Call Your Apex Controller Method  getProviderDetailsByNPINumber() based on the NpiNumber based 
        if(NpiNumber.length!=0)
        { 
            var action = component.get("c.getProviderDetailsByNPINumber");
            action.setParams({
                'NPI_Number': NpiNumber
            });
        }
        //Respone from the Apex class
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.CredentialingStatusListWrapper', response.getReturnValue());
                component.find("NPI_Number").set("v.disabled", false);
                component.find("License_Number").set("v.disabled", false);
                component.find("Get_Status").set("v.disabled", true);
                component.set("v.LicenseNumber",'');
                component.set("v.NPINumber",'');
                
            } else if(state === "ERROR"){
                $A.log("callback error", response.getError());
				var errors = response.getError();                      
                component.set("v.showErrors",true);
                component.set("v.errorMessage",errors[0].message);
                component.find("NPI_Number").set("v.disabled", false);
                component.find("License_Number").set("v.disabled", false);
                console.log('Ashokerrors==='+errors[0].message);
            }
        });
        $A.enqueueAction(action); 
       
    },
     
/*
  * @author       : Ashok Nettem
  * @date         : 06/05/2019
  * @description  : used to show spinner image based on button until the page gets loaded hideSpinner
  *  .            
  * ver           :1.0 
  * @JIRA Stories : PPN-40802
*/
    
    getShowSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
/*
  * @author       : Ashok Nettem
  * @date         : 06/05/2019
  * @description  : used to show spinner image based on button until the page gets loaded hideSpinner
  *  .            
  * ver           :1.0 
  * @JIRA Stories : PPN-40802
*/
    
    getHideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    },

/*
  * @author       : Ashok Nettem
  * @date         : 06/05/2019
  * @description  : To disable/enable the inputs fields based on the input by using aura:Id
  *  .              License_Number
  * ver           :1.0 
  * @JIRA Stories : PPN-40802
*/
    
     
        getLicenseNumber : function(component, event, helper)
        {
            let __inputLicenseNumber = component.find("License_Number");
            let __License_Number=__inputLicenseNumber.get("v.value");
            var __inputNPI_Number = component.find("NPI_Number");
            if(typeof(__License_Number)!='undefined')
            {
                if(__License_Number.length>0)
                {
                    component.find("NPI_Number").set("v.disabled", true);
                    component.find("Get_Status").set("v.disabled", false);
                }
                else{
                    component.find("NPI_Number").set("v.disabled", false);
                    component.find("Get_Status").set("v.disabled", true); 
                }
            }
        },
            
/*
  * @author       : Ashok Nettem
  * @date         : 06/05/2019
  * @description  : To disable/enable the inputs fields based on the input by using aura:Id
  *  .              NPI_Number
  * ver           :1.0 
  * @JIRA Stories : PPN-40802
*/
    
            
        getNPINumber :function(component, event, helper){
            var __inputNPI_Number = component.find("NPI_Number");
            let __NPI_Number=__inputNPI_Number.get("v.value"); 
            if(typeof(__NPI_Number)!='undefined'){
                if(__NPI_Number.length>0)
                {
                    component.find("License_Number").set("v.disabled", true);
                    component.find("Get_Status").set("v.disabled", false);
                }
                else{
                    component.find("License_Number").set("v.disabled", false);
                    component.find("Get_Status").set("v.disabled", true); 
                }
            }
            },

   
    
})