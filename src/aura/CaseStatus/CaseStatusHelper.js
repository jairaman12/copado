({
    /* This function is to call apex controller and fetch results based on case number */
    fetchResults : function(cmp, event, helper){        
        console.log('CaseNumber:' + cmp.get("v.caseNumberInput"));        
        let button = cmp.find('disablebuttonid');
        button.set('v.disabled',true);            
        var err = false;
        var msg = '';        
        cmp.set("v.message", msg);
        cmp.set("v.searchResultMsg", "");
        if($A.util.isEmpty(cmp.get("v.caseNumberInput"))){            
            err = true;
            msg = 'Please enter case number and retry';
        }        
        if(err){
            cmp.set("v.searchResultMsg", msg);            
            button.set('v.disabled',false);
        }else{
            var action = cmp.get("c.fetchData");
            action.setParams({
                "caseNumberInput": cmp.get("v.caseNumberInput")
            });            
            action.setCallback(this, function(a) { 
                if (a.getState() == 'SUCCESS') {
                    console.log('Results came back successfully:' + a.getReturnValue());
                    console.log('status:' + a.getReturnValue().caseStatus);
                    cmp.set("v.caseOutput", a.getReturnValue());
                    console.log('v.caseOutput.caseType:' + a.getReturnValue().caseType);
                    if(a.getReturnValue().caseStatus === undefined || a.getReturnValue().caseStatus == null || a.getReturnValue().caseStatus.length <= 0 ){
                        cmp.set("v.searchResultMsg", "No Results found for entered Case Number " + cmp.get("v.caseNumberInput").toString() + ". Please contact your appropriate state below for further information."); 
                        cmp.set("v.outcomeFlag", false); 
                        cmp.set("v.caseNumberInput", "");
                    }else{
                        cmp.set("v.outcomeFlag", true); 
                        cmp.set("v.caseNumberInput", "");
                        if(a.getReturnValue().caseType === 'Email'){
                            cmp.set('v.Mycolumns',[
                                {label: 'Case Number', fieldName: 'caseNumber', type: 'text'},
                                {label: 'Provider Name', fieldName: 'providerName', type: 'text'},
                                {label: 'Case Status', fieldName: 'caseStatus', type: 'text'},
                                {label: 'State', fieldName: 'caseState', type: 'text'},
                                {label: 'Case Type', fieldName: 'caseType', type: 'text'},
                                {label: 'Subject Line of Email', fieldName: 'caseSubject', type: 'text'},
                                {label: 'Case Received Date', fieldName: 'CorporateReceivedDate', type: 'text'},
                                {label: 'For questions and concerns contact', fieldName: 'contactInfo', type: 'text'}
                            ]);
                        }else{
                            cmp.set('v.Mycolumns',[
                                {label: 'Case Number', fieldName: 'caseNumber', type: 'text'},
                                {label: 'Provider Name', fieldName: 'providerName', type: 'text'},
                                {label: 'Case Status', fieldName: 'caseStatus', type: 'text'},
                                {label: 'State', fieldName: 'caseState', type: 'text'},
                                {label: 'Case Type', fieldName: 'caseType', type: 'text'},
                                {label: 'Case Received Date', fieldName: 'CorporateReceivedDate', type: 'text'},
                                {label: 'For questions and concerns contact', fieldName: 'contactInfo', type: 'text'}
                            ]);
                        }
                    }
                    button.set('v.disabled',false);
                }else if(a.getState() === "ERROR"){
                    var errors = a.getError();  
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            cmp.set("v.searchResultMsg", "Technical issue encountered in fetching the results. Please contact your appropriate state below for further information.");
                            button.set('v.disabled',false);
                            console.log('error firing');                            
                        }
                    }
                    button.set('v.disabled',false);
                }                
            });
            $A.enqueueAction(action); 
        }
        
    }
})