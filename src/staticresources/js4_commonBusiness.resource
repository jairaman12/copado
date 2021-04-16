 function businessObject()
 {
                
	/*
		This is the object which holds the business validation rules for 
		the PIER Intake forms
	*/				


	this.initialize = function(){
		//Do any kind of businessObject initialization in here         
        
	}   
    
    
    this.firstPageRules = function(){
        
        
        var returnVal = true;
        
        /*
         *  Rules to enforce:
            1. Selects Individual Provider or Locum Tenens radio buttons with Type 1 system should not show "Remove Provider" option 
            2. Selects Individual Provider or Locum Tenens radio buttons with Type 2 system should throw error. 
            3. Selects Group/Clinic with Type 1 system should not show "Remove Provider" 
            4. Selects Group/Clinic with Type 2 system should show "Remove Provider" option.
            5. First/Last name contains only alpha, no other chars.
         * 
         */
        

        if($("input[type='radio'][id*='typProvId:2']")[0].checked == true && $("input[type='radio'][id*='billNPTypId:1']")[0].checked == true ){                
                $("#removeProviderContainer").show();
          } 
        else{
                $("#removeProviderContainer").hide();      
            		/*
            		 * Unconditionally remove p10 (Remove Provider) from the page array and
            		 * set the Remove Provider checkbox to unchecked.
            		 */ 
                	no.removeFromVPage("p10");    
                    $("input[id*='rmProvId']").prop('checked', false);
  
            	
        }
        
        
        if(($("input[type='radio'][id*='typProvId:0']")[0].checked == true || $("input[type='radio'][id*='typProvId:1']")[0].checked == true) && 
           $("input[type='radio'][id*='billNPTypId:1']")[0].checked == true ){ 
            vfo.populateAnErrorMessage($("input[type='radio'][id*='typProvId:2']").parentsUntil("div").parent("fieldset"), "Type of Provider (ex. Individual Provider) must match with Type field (ex. Type 1 (Individual)).", "Alert" );
            returnVal = false;
        }  
     

  if(($("input[type='radio'][id*='typProvId:2']")[0].checked == true || $("input[type='radio'][id*='typProvId:3']")[0].checked == true) && 
           $("input[type='radio'][id*='billNPTypId:0']")[0].checked == true ){ 
            vfo.populateAnErrorMessage($("input[type='radio'][id*='typProvId:2']").parentsUntil("div").parent("fieldset"), "Type of Provider (ex. Group/Clinic amd Facility/Ancillary) must match with Type field (ex. Type 2 (Group)).", "Alert" );
            returnVal = false;
        }
        
        
     /*
      * PPN-20007
      * 
      * Check to see first/last names are only alpha characters
      * 
      * 
      */    
 	 if($("input[id*='firstnameSubId']").val() != "" || $("input[id*='lastnameSubId").val() != "" ){                        
        
         var fNameControl = $("input[id*='firstnameSubId']"); 
         var lNameControl = $("input[id*='lastnameSubId']");
         var letters = /^[A-Za-z\s]+$/;
         
         if($(fNameControl).val().match(letters) == null)
         {
            vfo.populateAnErrorMessage(fNameControl, "Please enter value. Can contain only Alpha characters.", "Alert" );
            returnVal = false;  
         }
         
         if($(lNameControl).val().match(letters) == null)
         {
            vfo.populateAnErrorMessage(lNameControl, "Please enter value. Can contain only Alpha characters.", "Alert" );
            returnVal = false;  
         }
         
         
     }       
        
        
        
        
        return returnVal;
        
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
			if ( (hasHoursOfOperation || hasChecked24Hours) && (hasCurrentOfficePhysicalAddressInfo == false && hasNewOfficePhysicalAddressInfo == false))
            {
                 vfo.populateAnErrorMessage($("input[type='text'][id*='addrPhy']"),"If adding Hours of Operation, please include a physical address information.", "Alert" )   				          
				 return false;  
            }
          	else if
            ( 
                	(hasCurrentOfficePhysicalAddressInfo || hasNewOfficePhysicalAddressInfo) && 
					($("input[type='radio'][id*='prLocId:0']")[0].checked == false && $("input[type='radio'][id*='prLocId:1']")[0].checked == false)			
			)
           {
                 vfo.populateAnErrorMessage($("div.fieldsetInColumn fieldset")[0],"Please select a primary location.", "Alert" );
                 return false;
           }
          	else if
            ( 
                ($("input[id*='acordnceWithADA']:checked").val() == "Yes") &&
                	($("#p5 #adaItems input:checked").length < 1)
			)
           {
                 vfo.populateAnErrorMessageForHeader($("#p5 #adaItems .thirds")[0],"Please select at least one checkbox.", "Alert" );
                 return false;
           }             
          	else if
            ( 
                ($("input[id*='acordnceWithADA']:checked").val() == "Yes") &&
                	($("#p5 #treatingCategories input:checked").length < 1)
			)
           {
                 vfo.populateAnErrorMessageForHeader($("#p5 #treatingCategories .thirds")[0],"Please select at least one checkbox.", "Alert" );
                 return false;
           }                      
           else{
			   
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
      
   /*
    * Business validation rules for Remove Provider page.
    */   
   this.removeProviderRules = function(){
       
     var noRPErrors = true;  
       
     /*
		Individual's Type 1 NPI required if Other ID is not entered
		Error: NPI Number or Other ID Number required
      */ 
       
	 if($("input[id*='indType1NPIId']").val() == "" && $("input[id*='otherRId']").val() == "" ){                        
        vfo.populateAnErrorMessageForHeader($("input[id*='indType1NPIId']").siblings("label"), 'NPI Number or Other ID Number required.', 'Alert');
         vfo.populateAnErrorMessageForHeader($("input[id*='otherRId']").siblings("label"), 'NPI Number or Other ID Number required.', 'Alert');
        noRPErrors = false;
     }
	 
       /*
        * If remove from all locations unchecked and no first address 
        */ 
     if($("input[id*='remFrmAllLocId']")[0].checked == false && $("input[id*='strAddProvGrpId']").val() == "" ){                
        vfo.populateAnErrorMessageForHeader($("input[id*='remFrmAllLocId']"), 'Select Remove from all locations or fill out address below.', 'Alert');
        noRPErrors = false;
     }       
	 
       /*
        * If remove from all locations unchecked and first address reason not selected
        */ 
     if($("input[id*='remFrmAllLocId']")[0].checked == false &&  $("select[id*='reasonleavgrpId']").val() == "" ){                
        vfo.populateAnErrorMessage($("select[id*='reasonleavgrpId']"), 'Please complete the required field.', 'Alert');
        noRPErrors = false;
     }              
       /*
        * If remove from all locations unchecked and first address effective date not selected
        */ 
     if($("input[id*='remFrmAllLocId']")[0].checked == false &&  $("input[id*='effDateofTrmId']").val() == "" ){                
        vfo.populateAnErrorMessage( $("input[id*='effDateofTrmId']"), 'Please complete the required field.', 'Alert');
        noRPErrors = false;
     }  
       
       /*
        * If remove from all locations checked and remove all reason not selected
        */ 
     if($("input[id*='remFrmAllLocId']")[0].checked == true &&  $("select[id*='reasonleavgrpAllId']").val() == "" ){                
        vfo.populateAnErrorMessage($("select[id*='reasonleavgrpAllId']"), 'Please complete the required field.', 'Alert');
        noRPErrors = false;
     }              
       /*
        * If remove from all locations checked and remove all effective date not selected
        */ 
     if($("input[id*='remFrmAllLocId']")[0].checked == true &&  $("input[id*='effDateofTrmProvGrpAllId']").val() == "" ){                
        vfo.populateAnErrorMessage( $("input[id*='effDateofTrmProvGrpAllId']"), 'Please complete the required field.', 'Alert');
        noRPErrors = false;
     }         
       
       
       /*
        * If remove from all locations checked and confirm attached documentation is present
        *
     if($("input[id*='remFrmAllLocId']")[0].checked == true && $("input[id*='removeGrpAttachId']").val() == "" ){                
        vfo.populateAnErrorMessage($("input[id*='removeGrpAttachId']")[0], 'Please provide location address spreadsheet.', 'Alert');
        noRPErrors = false;
     }   
     */
       /*
        * If add a location checked and no second address and remove all locations is not checked
        */            
     if($("input[id*='addLocPrvGrpId']")[0].checked == true && $("input[id*='strAddProvGrp1Id']").val() == "" && $("input[id*='remFrmAllLocId']")[0].checked == false  ){                
        vfo.populateAnErrorMessageForHeader($("input[id*='addLocPrvGrpId']"), 'Select Remove from all locations or fill out address information.', 'Alert');
        noRPErrors = false;
     }    
       /*
        * If add a location checked and no second reason for leaving and remove all locations is not checked
        */        
     if($("input[id*='addLocPrvGrpId']")[0].checked == true && $("select[id*='reasonleavgrp1']").val() == "" && $("input[id*='remFrmAllLocId']")[0].checked == false  ){                
        vfo.populateAnErrorMessage($("select[id*='reasonleavgrp1']"), 'Please complete the required field', 'Alert');
        noRPErrors = false;
     }   
       /*
        * If add a location checked and no second effective date and remove all locations is not checked
        */               
     if($("input[id*='addLocPrvGrpId']")[0].checked == true && $("input[id*='effDateofTrm1Id']").val() == "" && $("input[id*='remFrmAllLocId']")[0].checked == false  ){    
        vfo.populateAnErrorMessage($("input[id*='effDateofTrm1Id']"), 'Please complete the required field', 'Alert');
        noRPErrors = false;
     } 
       

       
       
     
       
     return noRPErrors;
                           
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