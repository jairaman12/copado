
 function businessObject()
 {
                
	/*
		This is the object which holds the business validation rules for 
		the Illinois PIER Intake forms
	*/				


	this.initialize = function(){
		//Do any kind of businessObject initialization in here                  
	}    
		
      this.secondPageRules = function(){
          
         /*
            Processing check boxes going to next page

            If there are no checkboxes selected
         */
          if( $("div#p2.success input:checkbox:checked").length < 1){
              vfo.populateAnErrorMessageForHeader($("div#p2 h2"), 'Please select at least one type of change.', 'Alert');
              return false;
          }
          else{
              return true;
          }
          
				
      }    
                                                 
      this.nameChangeRules = function(){
			/*		
				If you selected group/clinic on the first page, you must include a w-9 form here.
			*/					  	
         	if($("input[type='radio'][id*='typProvId:2']")[0].checked == true &&
              $("input[type='file'][id*='nmAttachId']")[0].value.length < 1){                
                vfo.populateAnErrorMessage($("input[type='file'][id*='nmAttachId']")[0], "If you have selected provider type Group/Clinic, you must include a W-9 form when making a name change.", "Alert" );
            	return false;
          	 }
          else{
              	return true;
          }                    
      }    
      
      this.npiAndTaxIdRules = function(){
               
			/*		
				If you added Tax ID info, you must include a w-9 form
			*/	        
          /** if($("input[type='text'][id*='taxCurId']")[0].value.length > 0 &&
              $("input[type='file'][id*='npiAttachId']")[0].value.length < 1) {               
                vfo.populateAnErrorMessage($("input[type='file'][id*='npiAttachId']"), "You must include a W-9 form when making a Tax ID change.", "Alert" );
            	return false;                                               
            }
          else **/
		  if($("input[type='text'][id*='taxNewId']")[0].value.length > 0 &&
              $("input[type='file'][id*='npiAttachId']")[0].value.length < 1){
                vfo.populateAnErrorMessage($("input[type='file'][id*='npiAttachId']")[0], "You must include a W-9 form when making a Tax ID change.", "Alert" );
            	return false;                                                            
          }    
          else{
              return true;
          }         
              
                    
       }  
      
      this.officeAndAddressRules = function(){		  
				  
			/*
				Need to check all individual address fields when HoO are added. 
				Usage scenario: user needs to update just the Address Line 2, or just city or just zip code and is adding HoO.
				
				if any of the HoO fields have been entered,
				at least one of the Address fields should have a value.
			
			
			
			*/									  
			var hasHoursOfOperation = this.doesThisObjectHaveInputFieldsWithValues($("div#h input"));
			var hasCurrentOfficePhysicalAddressInfo = this.doesThisObjectHaveInputFieldsWithValues($("div#currentOfficePhysicalAddressContainer input"));
			var hasNewOfficePhysicalAddressInfo = this.doesThisObjectHaveInputFieldsWithValues($("div#newOfficePhysicalAddressContainer input:not([type='radio']"));
			var hasChecked24Hours = $("input[type='checkbox'][id*='open24Id']")[0].checked;
			
			
		
			/*
				If there is a value in any of the first hours of operation field or the open 24 hours box is checked
				   and there is no information in any of the address values (current and new),
				   issue an error.
				   
			*/				  
			if ( (hasHoursOfOperation || hasChecked24Hours) && (hasCurrentOfficePhysicalAddressInfo == false && hasNewOfficePhysicalAddressInfo == false)){
                 vfo.populateAnErrorMessage($("input[type='text'][id*='addrPhy']"),"If adding Hours of Operation, please include a physical address information.", "Alert" )   				          
				 return false;  
           }else if( (hasCurrentOfficePhysicalAddressInfo || hasNewOfficePhysicalAddressInfo) && 
					  ($("input[type='radio'][id*='prLocId:0']")[0].checked == false && $("input[type='radio'][id*='prLocId:1']")[0].checked == false)			
			){
                 vfo.populateAnErrorMessage($("div.fieldsetInColumn fieldset")[0],"Please select a primary location.", "Alert" );
                 return false;
           }else{
			   
			   return true;
		   }          
            
          
       }   
      
      this.otherRules = function(){
                    
          if($('[id$=dobId]').val().length > 0){
          
                var dob = new Date($('[id$=dobId]').val());	

                var age = vfo.calculateAge(dob);
				
				if (age < 18)
				{
                    vfo.populateAnErrorMessage($('[id$=dobId]'), "Provider age must be between 18 and 100.", "Alert");
                    return false;                                               
                }else if(age > 100){
                    vfo.populateAnErrorMessage($('[id$=dobId]'), "Provider age must be between 18 and 100.", "Alert");
                    return false;                                               
                }else{
                     
                    return true;
                }				
				
                /** commented out in favor of code above
		var currentDate = new Date();
                var eighteenYearsAgo = new Date((new Date()).setDate(-18 * 365));
          		var oneHundredYearsAgo = new Date((new Date()).setDate(-100 * 365));
          
          		if(dob >= currentDate){
                    vfo.populateAnErrorMessage($('[id$=dobId]'), "Date of birth must be less than the current date.", "Alert");
                    return false;                                               
                }
          		else if(dob > eighteenYearsAgo){
                    vfo.populateAnErrorMessage($('[id$=dobId]'), "Provider age must be between 18 and 100.", "Alert");
                    return false;                                               
                }
          		else if(dob < oneHundredYearsAgo){
                    vfo.populateAnErrorMessage($('[id$=dobId]'), "Provider age must be between 18 and 100.", "Alert");
                    return false;                                               
                }else{
                     
                    return true;
                }**/                 	          
   	  }   
      
          return true;
   }    
   
   
   this.doesThisObjectHaveInputFieldsWithValues = function(object){
	   
			var objectHasInputsWithValues = false;
	   
	   
			$(object).each(			
				function(){
					
					if(this.value.length > 0){
						objectHasInputsWithValues = true;
					}
					
				}
				
			);	   
	   
	   
	   return objectHasInputsWithValues;
	   
	   
   }
		
       this.initialize();
                
}