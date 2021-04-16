/**************************************************************************************************
Apex Class Name  : ManualCaseCreationControllerSupoortCls
Version          : 1.0  
Functionality    : 
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Sreekanth Kalluru          06/27/2018              Sprint 13
***************************************************************************************************/
public class ManualCaseCreationControllerSupoortCls 
{
    public static List<Provider_Networks__c> providerNetworksList = new List<Provider_Networks__c>();
  
    private static string convertToValueOfFormat(String inDate)
    {
        /*
         Convert from: mm/dd/yyyy
                   to: yyyy-MM-dd HH:mm:ss
        */
        System.debug('inDate --->' + inDate);
        String[] dateParts = inDate.split('/');
        
        System.debug('mm ->' + dateParts[0] + '----- dd->' + dateParts[1] + ' ---- yyyy->' + dateParts[2] );
        
        String valueOfFormattedDateString = dateParts[2] + '-' + dateParts[0] + '-' + dateParts[1]+ ' 00:00:00';
         System.debug('valueofformatteddatestring ->' + valueOfFormattedDateString); 
        return valueOfFormattedDateString;
    }
    /**********************************************************************************
     * Below method deserialize the Json and process the Provider networks for insert
     * @input : Network child case list, json and mode of the request type
     * @output: Provider network records list for insert
     * ***********************************************************************************/
    public static void createNetworkRecords(List<Case> networkCaseList , String hiddenJson , String mode  )
    {
        if( !networkCaseList.isEmpty() 
            && !String.isEmpty( hiddenJson ) 
            && ( mode=='Add' || mode == 'Change')
          )
        {
           /***************************************************
            * Below code to handle if received JSON has Comp code . 
            * If empty comp codes then counter will remains '0'
            * *************************************************/
           NetworkJsonSupportCls ntwrks = NetworkJsonSupportCls.parse( hiddenJson );
            
           System.debug('JSON class-->' + ntwrks);
           for( Case cs : networkCaseList )
           {
              for( NetworkJsonSupportCls.NetworkGroups tempNtwrk : ntwrks.networkGroups )
                {
                    
                    for( NetworkJsonSupportCls.SelectedNetworks tempSelNtwrks : tempNtwrk.SelectedNetworks )
                    {
                        Integer networkCodeCount  = 0;
                            for(NetworkJsonSupportCls.Designationcode tempDesigCodes : tempSelNtwrks.compgridcode )
                            {
                                System.debug('tempDesigCode -->' + tempDesigCodes);
                                if( !String.isEmpty( tempDesigCodes.code ) 
                                   ||  !String.isEmpty( tempDesigCodes.effectivedate ) 
                                   || !String.isEmpty( tempDesigCodes.enddate )
                                  )
                                {
                                    networkCodeCount++;
                                    Provider_Networks__c provNetwork			=	new Provider_Networks__c();
                                    provNetwork.Case_Number__c					=	cs.id;
                                    provNetwork.PFIN_onBoarding__c				=   cs.MC_PFIN__c;
                                    provNetwork.Comment__c						=	tempNtwrk.comments; 
                                    provNetwork.Network_Name__c 				=	tempSelNtwrks.networkName;
                                    provNetwork.Panel_code__c 					=	tempSelNtwrks.panel!='none'? tempSelNtwrks.panel : '';
                                    provNetwork.Roles_Code__c 					=	tempSelNtwrks.role!='none'? tempSelNtwrks.role : '';
                                    provNetwork.Plan_Id__c						=	cs.Plan_ID__c;
                                    provNetwork.Comp_Grid_Code__c 				=	tempDesigCodes.code;
                                    
                                    System.debug('provNetwork object 1 -->' + provNetwork);
                                    System.debug('provNetwork object 1.1 -->' + tempNtwrk.effectiveDate);
                                    System.debug('provNetwork object 1.2 -->' + tempDesigCodes.effectivedate);
                                    System.debug('provNetwork object 1.3 -->' + tempDesigCodes.enddate);
                                    
                                    if( !String.isEmpty (tempNtwrk.effectiveDate ) ){
                                        provNetwork.Networks_Effective_Date__c 		=	Date.valueOf(convertToValueOfFormat( tempNtwrk.effectiveDate)); 
                                    }
                                    
                                     if( !String.isEmpty( tempDesigCodes.effectivedate ))
                                     {
                                          provNetwork.Comp_Grid_Effective_Date__c 	=	Date.valueOf(convertToValueOfFormat( tempDesigCodes.effectivedate ));
                                     }
                                    if( !String.isEmpty( tempDesigCodes.enddate  ))
                                     {
                                          provNetwork.Comp_Grid_End_Date__c 		    =	Date.valueOf(convertToValueOfFormat( tempDesigCodes.enddate ));
                                     }

                                    System.debug('provNetwork object 2 -->' + provNetwork);
                                    
                                    providerNetworksList.add( provNetwork );                         
                                } 
                                
                            }
                       
                         /***************************************************
                            * Below code to handle if received JSON has Comp code . 
                            * If empty designation codes then counter will remains '0'
                            * *************************************************/
                        for(NetworkJsonSupportCls.Designationcode tempDesigCodes1 : tempSelNtwrks.designationcode )
                        {
                           if( String.isNotEmpty( tempDesigCodes1.code ) 
                               ||  String.isNotEmpty( tempDesigCodes1.effectivedate ) 
                               || String.isNotEmpty( tempDesigCodes1.enddate ) 
                              )
                            { 
                                networkCodeCount++;
                                Provider_Networks__c provNetwork			=	new Provider_Networks__c();
                                provNetwork.Case_Number__c					=	cs.id;
                                provNetwork.PFIN_onBoarding__c				=   cs.MC_PFIN__c;
                                provNetwork.Comment__c						=	tempNtwrk.comments; 
                                provNetwork.Network_Name__c 				=	tempSelNtwrks.networkName;
                                provNetwork.Panel_code__c 					=	tempSelNtwrks.panel!='none' ? tempSelNtwrks.panel : '' ;
                                provNetwork.Roles_Code__c 					=	tempSelNtwrks.role!='none'? tempSelNtwrks.role : '';
                                provNetwork.Designation_Code__c 			=	tempDesigCodes1.code;
                                provNetwork.Plan_Id__c						=	cs.Plan_ID__c;
                               if( !String.isEmpty( tempNtwrk.effectiveDate ))
                                {
                                    provNetwork.Networks_Effective_Date__c 		=	Date.valueOf(convertToValueOfFormat( tempNtwrk.effectiveDate ));
                                }
								 if(!String.isEmpty( tempDesigCodes1.effectivedate ))
                                {
                               		 provNetwork.Desgnation_Effective_Date__c 	=	Date.valueOf(convertToValueOfFormat( tempDesigCodes1.effectivedate ));
                                }
                                 if(!String.isEmpty(tempDesigCodes1.enddate ))
                                {
                                     provNetwork.Designation_End_Date__c 		=	Date.valueOf(convertToValueOfFormat( tempDesigCodes1.enddate) );
                                }
                               
                                providerNetworksList.add( provNetwork );
                            }
                        } 
                        
                        
                         /***************************************************
                          * Below code to handle if received JSON has both Comp 
                          * and designation code has empty values . 
                          * *************************************************/
                        if( networkCodeCount <= 0 )
                        {
                            System.debug('networkCodeCount===>>>'+networkCodeCount);
                            Provider_Networks__c provNetwork			=	new Provider_Networks__c();
                            provNetwork.Case_Number__c					=	cs.id;
                            provNetwork.PFIN_onBoarding__c				=   cs.MC_PFIN__c;
                            provNetwork.Comment__c						=	tempNtwrk.comments; 
                            provNetwork.Network_Name__c 				=	tempSelNtwrks.networkName;
                            if( !String.isEmpty (tempNtwrk.effectiveDate ) )
                            {
                                 provNetwork.Networks_Effective_Date__c 		=	Date.valueOf(convertToValueOfFormat( tempNtwrk.effectiveDate) ); 
                            }
                            provNetwork.Panel_code__c 					=	tempSelNtwrks.panel!='none'? tempSelNtwrks.panel : '';
                            provNetwork.Roles_Code__c 					=	tempSelNtwrks.role!='none'? tempSelNtwrks.role : '';
                            provNetwork.Plan_Id__c						=	cs.Plan_ID__c;
                            System.debug('networkCodeCount111111===>>>'+networkCodeCount);
                            providerNetworksList.add( provNetwork );
                        }
                    }
                }           
           }
        }else if( !networkCaseList.isEmpty() 
            && !String.isEmpty( hiddenJson ) 
            && mode=='Delete'
          )
        {
            DeleteModeNetworkJsonSupportCls deleteNtwrks = DeleteModeNetworkJsonSupportCls.parse( hiddenJson );
            System.debug('hiddenJson===>>>'+hiddenJson);
            System.debug('deleteNtwrks===>>>'+deleteNtwrks);
            for( Case cs : networkCaseList )
           {
               for( DeleteModeNetworkJsonSupportCls.NetworkGroups deleteNetworks : deleteNtwrks.NetworkGroups )
               {
                   for( String networkforDelete : deleteNetworks.selectedNetworks )
                   {
                       System.debug('networkforDelete===>>>'+networkforDelete);
                       Provider_Networks__c provNetworkForDelete			=	new Provider_Networks__c();
                       provNetworkForDelete.Case_Number__c					=	cs.id;
                       provNetworkForDelete.PFIN_onBoarding__c				=   cs.MC_PFIN__c;
                       provNetworkForDelete.Comment__c						=	deleteNetworks.comments; 
                       provNetworkForDelete.Remove_Network_Reson__c			=	deleteNetworks.nwReason;
                       provNetworkForDelete.Network_Name__c 				=	networkforDelete;
                       if(!String.isEmpty(deleteNetworks.effectiveDate ))
                       {
                                provNetworkForDelete.Networks_Effective_Date__c 	=	Date.valueOf(convertToValueOfFormat( deleteNetworks.effectiveDate) );
                       }    
                       providerNetworksList.add( provNetworkForDelete );
                   }                        
               }
           }
        }
        /********************
         * Final records for insert
         * ******************/
        System.debug('providerNetworksList ->' + providerNetworksList);
        
        if(!providerNetworksList.isEmpty())
        {
            try{
            	insert providerNetworksList;
            }catch(Exception e){
                System.debug('error message'+e.getMessage());
            }
        }   
    }
}