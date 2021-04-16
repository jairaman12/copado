/*
* Controller for the embeddedLightningButtons Lightning Component.
* Developer: Travis Self
*/
public class EmbeddedLightningButtonsController {
    
    /* Based on the button clicked, launch the lightning component for case creation */
    @AuraEnabled
    public static String getUrlBasedOnButtonSelected(Id recordId, String objType, String userId, String button){ 
     
        if(button.equals('CRM')) {
            
            return LtngCtrlCRMCase.getCRMURL(recordId, objType, userId);
            
        } else if(button.equals('Manual ADC')) {
            
            return ManualADCButtonController.getManualADCUrl(userId, recordId, objType);
            
        }
        
        return null;
        
    }
    
}