({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
     var action = component.get("c.fetchLookUpValues");
      // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName")
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('current data is:' + JSON.stringify(response.getReturnValue()));
                var regex = new RegExp("CaseNumber","g");
				var text1 = JSON.stringify(response.getReturnValue()).replace(regex, "Name");
                console.log('text1:' + text1);                
                var chg = JSON.parse(text1);
                console.log('chg :' + chg );
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", chg);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
    
   
})