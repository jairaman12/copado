({
    doinit : function(cmp, event, helper){
        cmp.set("v.searchResultMsg", "Please enter Case Number and click on 'Get Status' button");
    },
    
    fetchResults : function(cmp, event, helper){
        helper.fetchResults(cmp, event, helper);
    },
    
    fetchResultsOnEnter : function(cmp, event, helper){
        if(event.keyCode == 13){
        	helper.fetchResults(cmp, event, helper);
        }
    },
    
})