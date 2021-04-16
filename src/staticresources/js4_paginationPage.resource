		  $(function() {
              
				$( ".list" )                
					.each(
						function( index ) 
							{
								if($(this).children().children().length > numberOfRecordsToShow ){								
									
                                    $(this).DataTable(
                                        {
                                        "pageLength": numberOfRecordsToShow
                                        
                                        }
                                    
                                    );
								}
                                
							}
					)                    
                  .show();
              
              $(".dataTables_wrapper select").prepend((new Option("5", "5"))); 
              
              /*Include this line for issue in IE, PPN-8358
               */
              $(".dataTables_wrapper select").val("5");
                            
			}
		);

