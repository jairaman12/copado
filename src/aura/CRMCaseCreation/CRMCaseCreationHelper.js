({
    /* Description: Load initial information */ 
    getInitialInformation : function(cmp, event, helper){        
        var action = cmp.get("c.getInitial");
        action.setParams({
            "objId": cmp.get("v.recordId"),
            "sobj": cmp.get("v.sobjecttype")
        });
        
        action.setCallback(this, function(a) {
            
            if (a.getState() == 'SUCCESS') {
                if(a.getReturnValue().substring(0,7) == 'Entity:'){                     
                    cmp.set("v.Entity", a.getReturnValue().substr(10));
                    cmp.set("v.accountFlag", false); 
                    cmp.set("v.planId", a.getReturnValue().substring(7,10));
                }
                else{
                    cmp.set("v.Account", a.getReturnValue().substr(11)); 
                    cmp.set("v.accountFlag", true); 
                    cmp.set("v.planId", a.getReturnValue().substring(8,11));
                }
            }else if(a.getState() === "ERROR"){
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showErrorMessage(cmp, message);
                    }
                }
            }
            
        });
        $A.enqueueAction(action);       
    },
    
    /* Description: Fetch Picklist values */ 
    fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
        console.log('fetchPickListVal:end');
    },
    
    fetchDepPicklist: function(component,objDetails,controllerField, dependentField) {        
        // call the server side function  
        var action = component.get("c.getDependentMap");
        // pass paramerters [object definition , contrller field name ,dependent field name] -
        // to server side function 
        action.setParams({
            'objDetail' : objDetails,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
        //set callback   
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();                
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap",StoreResponse);                
                // create a empty array for store map keys(@@--->which is controller picklist values) 
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                
                //set the controller field value for lightning:select
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('--- None ---');
                }
                
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }  
                ControllerField.sort(); 
                // set the ControllerField variable values
                component.set("v.listControllingValues", ControllerField);
            }else{
                alert('Something went wrong..');
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchDepValues: function(component, ListOfDependentFields) {
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        dependentFields.sort(); 
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set("v.listDependingValues", dependentFields);        
    },
    
    /* Description: Redirect to parent record on click of cancel */ 
    returnToParentRecord : function (cmp, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    /* Description: Save data on click of save button and redirect to master case created */ 
    saveResponses : function(cmp, event, helper){
        
        console.log('ParentId:' + cmp.get("v.caserec").ParentId);
        
        let button = cmp.find('disablebuttonid');
        button.set('v.disabled',true);            
        var err = false;
        var msg = '';
        
        if($A.util.isEmpty(cmp.get("v.caserec").Corporate_received_date__c)){            
            err = true;
            msg = msg + ', Corporate received date';
        }
        if($A.util.isEmpty(cmp.get("v.caserec").Origin)){            
            err = true;
            msg = msg + ', Case Origin';
        }
        if($A.util.isEmpty(cmp.get("v.caserec").Status)){            
            err = true;
            msg = msg + ', Status';
        }
        if($A.util.isEmpty(cmp.get("v.caserec").Priority)){            
            err = true;
            msg = msg + ', Priority';
        }
        if($A.util.isEmpty(cmp.get("v.caserec").CRM_Comments__c)){            
            err = true;
            msg = msg + ', Comments';
        }
        if($A.util.isEmpty(cmp.get("v.caserec").CRM_Types__c)){            
            err = true;
            msg = msg + ', CRM Types';
        }
        if(cmp.get("v.caserec").CRM_Types__c == 'Others' && ($A.util.isEmpty(cmp.get("v.caserec").Other_Reason_Description__c))){            
            err = true;
            msg = msg + ', Other Description';
        }
        
        
        if(err){
            cmp.set("v.message", "Mandatory fields missing: " + msg.substr(2));            
            button.set('v.disabled',false);
        }else{
            var action = cmp.get("c.saveData");
            action.setParams({
                "casere": cmp.get("v.caserec"),
                "spl": cmp.get("v.selectedRows"),
                "accId": cmp.get("v.recordId"),
                "parId": cmp.get("v.selectedCaseLookUpRecord"),
                "conId": cmp.get("v.selectedConLookUpRecord")
            });
            
            action.setCallback(this, function(a) {
                
                if (a.getState() == 'SUCCESS') {
                    console.log('save data came back successfully:' + a.getReturnValue());
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": a.getReturnValue(),
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
                }else if(a.getState() === "ERROR"){
                    var errors = a.getError();  
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            cmp.set("v.message", "Error saving the record: " + errors[0].message);
                            button.set('v.disabled',false);
                            console.log('error firing');                            
                        }
                    }
                }
                
            });
            $A.enqueueAction(action); 
        }
    },
    
    /* Description: Get PFINs and load to table */ 
    getData : function(cmp, event, helper) {
        var action = cmp.get("c.getPFINS");
        
        //Column data for the table
        var taskColumns = [
            {
                'label':'PFIN Number',
                'name':'CM_SPL_PFIN_No__c',
                'type':'string'
            },
            {
                'label':'Tax ID',
                'name':'CM_SPA_Tax_ID__c',
                'type':'string'
            },
            {
                'label':'County',
                'name':'CM_County__c',
                'type':'string'
            },
            {
                'label':'Bill PFIN',
                'name':'Bill_PFIN__c',
                'type':'string'
            },
            {
                'label':'Prov ID',
                'name':'CM_SPL_Prov__r.Prov_ID__c',
                'type':'string'
            },
            {
                'label':'Provider Name',
                'name':'CM_SPL_Prov__r.Name',
                'type':'String'
            }                       
        ];
        
        //Configuration data for the table to enable actions in the table
        var taskTableConfig = {
            "massSelect":true,
            "searchBox":true,
            "searchByColumn":true            
        };  
        
        // if(cmp.get("v.recordId")){
        
        action.setParams({                
            "accountId":cmp.get("v.recordId")             
        });
        
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                //pass the records to be displayed
                cmp.set("v.serLoc",resp.getReturnValue());
                
                //pass the column information
                cmp.set("v.slColumns",taskColumns);
                
                //pass the configuration of task table
                cmp.set("v.slTableConfig",taskTableConfig);
                
                //Workaround to solve the timing issue when rendering
                window.setTimeout($A.getCallback(function(){
                    //initialize the datatable
                    cmp.find("slTable").initialize();
                }),500);                
            }
            else{
                console.log(resp.getError());
            }
        });        
        $A.enqueueAction(action);        
    },
    
    /* Used to launch CRM Creation from Desktop */
    openTabWithSubtab : function(component, event) {
        console.log('Opening subtab...');
        var recId 	= component.get('v.recordId');
        var objType = component.get('v.sobjecttype');
        var workspaceAPI = component.find("workspace");
        var urlString = '';
        
        /* Error messages used when created a new CRM case */
        var errorMessage1 = 'Error: Insufficient Privileges.';	// For Data Rep or Enterprise Profile
        var errorMessage2 = 'Error: New Cases cannot be created under closed cases.';
        var errorMessage3 = 'Error: Please attach either Account Name or Case Entity before creating a CRM case.';
        var errorMessage4 = 'Error: Please select either Account Name(Physician) OR Case Entity(Hospital/Group/Master Entity) not both before creating a CRM case.';
        
        console.log('Launching CRM Case Creation from: ' +  objType);
        
        var action = component.get('c.getCRMURL');	/* Call the Server-Side Controller Method*/
        action.setParams({
            "userId" : $A.get("$SObjectType.CurrentUser.Id"),	/* Pass in parameters to apex method */
            "recordId" : recId,	
            "objType": objType
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                urlString = a.getReturnValue();	/*Retrieve the built URL from the Server-Side Controller */
                if(urlString === 'errorMessage1' ) {
                    this.showToast(component, event, errorMessage1);
                    if(objType == 'Case') {
                    	return false;
                    }
                } else if(urlString === 'errorMessage2' ) {
                    this.showToast(component, event, errorMessage2);
                    if(objType == 'Case') {
                    	return false;
                    }
                } else if(urlString === 'errorMessage3') {
                    this.showToast(component, event, errorMessage3);
                    if(objType == 'Case') {
                    	return false;
                    }
                } else if(urlString === 'errorMessage4') {
                    this.showToast(component, event, errorMessage4);
                    if(objType == 'Case') {
                    	return false;
                    }
                }
                //$A.get('e.force:refreshView').fire();	/*** Refresh the view to prevent rendering issues ***/
                console.log('CRM URL: ' + urlString)
                workspaceAPI.openTab({
                    url: '/lightning/r/' + objType + '/' + recId + '/view',		/* This is the main tab. It is the record the button was clicked from */
                    focus: true
                }).then(function(response) {
                    workspaceAPI.openSubtab({
                        parentTabId: response,
                        url: urlString,			/* This holds the URL that was built from the server-side Apex Controller. This will open in a subtab. */
                        focus: true
                    });
                })
                .catch(function(error) {
                    console.log(error);
                });
            }
        });
        
        $A.enqueueAction(action);
    },
    
    passedMobileValidation: function(component, event) {
      var objType = component.get('v.sobjecttype');
      
       if(objType == 'CM_SPL_Addr__c' || objType == 'Case') {
            console.log('Failed Mobile Validation');
            //this.showToast(component, event, 'You can only create CRM Cases from Accounts on Mobile');
            return false;
        }
        return true;
  	},
    
    showToast: function(component, event, toastMessage) {
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "message" : toastMessage,
            "type"	  : "error"
        });
        
        resultsToast.fire();  
    }
    
})