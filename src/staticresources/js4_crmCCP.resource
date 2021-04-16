$(
    function()
    {
        
        $('.crmReqType').chosen
        (
            
            {
                hide_results_on_select: true,
                width: "100%"
            }
            
        );  
        
        
        $('.crmReqType').on
        (
            'change', 
            function(evt, params) 
            {             
                selectedCrmTypesToController(JSON.stringify(returnArrayOfSelectedOptions('.crmReqType')));

              }
        );
   
    }
);

function returnArrayOfSelectedOptions(input)
{
    var opts = $(input).find(":selected");
    var aOpts = [];
    for(option in opts)
    {
        (opts[option].innerText != undefined)?
            aOpts.push((opts[option].innerText))
        :false;
        
    }
    
    return aOpts;  
}



function loadSelectedClick()
{   
   
    $('li.result-selected').removeAttr("disabled");
    
    $('li.result-selected').click
    (
        function()
        {
            $('.search-choice-close[data-option-array-index=' +  $(this).attr("data-option-array-index") + ']').click();            
        }
    );
}
