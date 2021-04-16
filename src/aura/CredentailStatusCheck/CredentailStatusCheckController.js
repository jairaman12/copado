({
    
    doInit:function(component, event, helper){
    //loadJquery();
},
    
    /*
  * @author       : Ashok Nettem
  * @date         : 06/05/2019
  * @description  :getstatus function is called when the button is clicked based on the LicenseNumber
  					  and NPI number we call helper class function.
  * ver           :1.0 
  * @JIRA Stories : PPN-40802
*/
    
	getStatus : function(component, event, helper) {
        var LicenseNumber;
        var NpiNumber;
        var Temp_LicenseNumber;
        var Temp_NpiNumber;
        LicenseNumber=component.get("v.LicenseNumber");
        NpiNumber=component.get("v.NPINumber");
        if(typeof(LicenseNumber)=='undefined')
        {
            Temp_LicenseNumber='';
        }else{
            Temp_LicenseNumber=LicenseNumber;
        }
        
        if(typeof(NpiNumber)=='undefined')
        {
            Temp_NpiNumber='';
        }else{
            Temp_NpiNumber =NpiNumber;
        }
       helper.getStatusHelper(component,Temp_LicenseNumber,Temp_NpiNumber);
      },  
    
    /*
  * @author       : Ashok Nettem
  * @date         : 06/05/2019
  * @description  : used to show spinner image based on button until the page gets loaded showSpinner
  *                this function automatic call by aura:waiting event  based on helper class
  * ver           :1.0 
  * @JIRA Stories : PPN-40802
*/
    
    showSpinner: function(component, event, helper) {
        helper.getShowSpinner(component, event, helper);
    },
    
     /*
  * @author       : Ashok Nettem
  * @date         : 06/05/2019
  * @description  : used to show spinner image based on button until the page gets loaded hideSpinner
  *  .            
  * ver           :1.0 
  * @JIRA Stories : PPN-40802
*/
    
    hideSpinner: function(component, event, helper) {
        helper.getHideSpinner(component, event, helper);
    },

    /*
  * @author       : Ashok Nettem
  * @date         : 06/05/2019
  * @description  : To disable/enable the inputs fields based on the input
  * ver           :1.0 
  * @JIRA Stories : PPN-40802
*/
    
    Onchangelicensenumber :function(component, event, helper){
        helper.getLicenseNumber(component, event, helper);
        
    },
    
    OnchangeNPINumber:function(component,event,helper){
        helper.getNPINumber(component,event,helper);
    },
    
    
        /*
  * @author       : Ashok Nettem
  * @date         : 06/05/2019
  * @description  : to laod the jquery 
  * ver           :1.0 
  * @JIRA Stories : PPN-40802
*/
    
    loadJquery:function(component, event, helper){
        var $ = jQuery.noConflict();
        jQuery(document).ready(function(){
         $('[id$=Get_Status]').click(function(){
             //alert('onclick');
         });
           
        });
        
    },
    
  	
})