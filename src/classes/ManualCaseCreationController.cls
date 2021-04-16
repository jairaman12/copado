/****************************************************************
@Author      : Provider Intake Salesforce team 
@Date        : 08/09/2017
@Description : This class is created for manual case creation for Request Type Category 
Demographic update, Network Change and Status Check
*******************************************************
SI.No       Author                Modification Comments
1          Saravana Bharathi      Userstory PPN-14267 Changes
2          Subhashini             User Stories PPN-13772 Changes 
3          Rajesh Paleti          UserStory PPN-14330 Changes
4          Jacquline Vinnarasi    UserStory PPN-14333 Changes
5          Saravana Bharathi      UserStory PPN-15737 Changes
6          SethuRaman             UserStory PPN-15773 Changes
7          SethuRaman             UserStory PPN-14330 Changes
8          SethuRaman             UserStory PPN-13808 Changes
9          Sreekanth K            Defect PPN-23432 changes
10         Travis Self            UserStory PPN-20163 Changes
11         Travis Self            Defect PPN-23908
12         Travis Self            Defect PPN-24497
13         G Sujatha              R4_Changes PPN-24812
14         Travis Self            Defect PPN-25321
15         Ashok N                Defect PPN-31197 SIT_PPN-29616
******************************************************************/
Global class ManualCaseCreationController 
{
    //Case Object Instance Creation
    public List<SelectOption> taxIdsSelectOption1    { get; set; }
    public Set<SelectOption> taxIdsSelectOption    { get; set; } /* PPN-17976 */
    public List<SelectOption> pfinsSelectOption { get; set; }
    public Case caseInfo                            {set; get;} 
    public Case parentCase                          {set; get;} 
    public Case npiChg                              {set; get;}
    public Case nameChg                             {set; get;}   
    public Case billAddrChg                         {set; get;} 
    public Case phyAddrChg                          {set; get;}
    public Case admAddrChg                          {set; get;}
    public Case crdAddrChg                          {set; get;}
    public Case otherProv                           {set; get;}
    public Case removeProv{set; get;} 
    public Case addProv{set; get;} 
    public Case networkChg{set; get;}
    public Case statusCheck{set; get;}
    public String numberOfRecordsToShow{ get; set; }
    //some comment
    
    public List<String> listOfTaxNumbers{get;set;}  
    
    public boolean npiChgFlg{set; get;} 
    public boolean nameChgFlg{set; get;} 
    public boolean billChgFlg{set; get;} 
    public boolean phyChgFlg{set; get;} 
    public boolean admChgFlg{set; get;} 
    public boolean crdChgFlg{set; get;} 
    //public boolean otherProvFlg{set; get;}
    public boolean removeProvFlg{set; get;} 
    public boolean addProvFlg{set; get;} 
    public boolean networkChgFlg{set; get;}
    public boolean statusCheckFlg{set; get;}
    public boolean eftCheckFlg{set; get;}
    
    public boolean specialtyFlg{set; get;} 
    public boolean privilegesFlg{set; get;}
    public boolean providerIDsFlg{set; get;}
    public boolean othersFlg{set; get;}
    
    
    public boolean addNwkChgFlg{set;get;}
    public boolean termPrvChgFlg{set;get;}
    public boolean reinPrvChgFlg{set;get;}
    public boolean rmNwrkChgFlg{set;get;}
    public boolean benfChgFlg{set;get;}
    public boolean caseCheckChgFlg{set;get;}
    public boolean claimCheckChgFlg{set;get;}
    public boolean contractCheckFlg{set;get;}
    public boolean credCheckChgFlg{set;get;}
    public boolean compCheckFlg{set;get;}
    public boolean netwrkCheckFlg{set;get;}
    public boolean paperCheckFlg{set;get;}
    public boolean preDeterCheckFlg{set;get;}
    public boolean preAuthCheckFlg{set;get;}
    public boolean retroCheckFlg{set;get;}
    public boolean feeScheduleFlg{set;get;}
    public boolean ClaimsProjectFlg{set;get;}
    public boolean rosterCheckFlg{set;get;}
    public boolean retroReqCheckFlg{set;get;}
    public List<SelectOption> statusOptions{ get;set; }
    public List<SelectOption> reasonOption{ get;set; }
    public List<SelectOption> billTypOption{ get;set; }
    public List<SelectOption> phyActOption{ get;set; }
    public List<SelectOption> suffixOption{ get;set; }
    public List<SelectOption> OrginOption{ get;set; }
    public List<SelectOption> typeOfProvOption{ get;set; }
    public List<SelectOption> genderOption{ get;set; }
    
    
    public String stringifiedPFINList{get;set;}
    /*
    * Support for PPN-5342  
    * Create variables for option lists, these are used by the 
    DynamicRequestTypePage.vfp for drop down values
    */       
    public List<SelectOption> NetworksByPFINList{get;set;}    
    public List<SelectOption> AllExceptNetworksByPFINList{get;set;}
    public List<SelectOption> RemoveNetworkReasons{get;set;}
    public List<SelectOption> TermProviderReasonsOptions{get;set;}    
    /* US :13772 Starts */
    public List<SelectOption> selectAllNonBPFINOption{ get; set; }
    public String selectAllNonBillPfin{get;set;}
    public Boolean selectAllCheckBox {get;set;}
    public Boolean showSelectAllPanel {get;set;}
    public boolean showAddGrid {get;set;}
    /* US :13772 Ends */
    
        /** PPN-24702 Code Start**/
    public List<String> listOfAllNonBillPfins{get;set;}
    public List<String> listOfDisplayNonBillPfins{get;set;}
    public Integer pageNumber{get;set;}
    public Integer totalPageNumber{get;set;}
    public Integer totalWrapPageNumber{get;set;}
    public Integer totalMccPageNumber {get; set;}
    public Integer wrapPageNumber{get;set;}
    public List<ServicePayeeLocation> listOfDisplayWrapList{get;set;}
    public List<String> listOfAllPfinsToNavigate{get;set;}
    public List<String> listOfAllPfinsToDisplay{get;set;}
    public Integer manualPageNumber{get;set;}
    public Integer mccPageNumber{get;set;}
    /** PPN-24702 Code End**/
    
    public String reasonLvlGrp1{set; get;}
    public String reasonLvlGrp{set; get;}
    public String reasonLvlGrp2{set; get;}
    public String typeOfProv{set; get;}
    public String phyNewPat{set; get;}
    public String phyCurPat{set; get;}
    /**** PPN-14267 Code Start ****/
    public String selPFIN{set; get;}
    public String selNonBillPfin{get;set;}
    public Boolean isRenderRequestPage{get;set;}
    /**** PPN-14267 Code End ***/
    public String renderNPI{set; get;}
    public String billNPI{set; get;}
    public String billNpiType{set; get;}
    public String suffixCur{set; get;}
    public String suffixNew{set; get;}
    public String gender{set; get;}
    public String removeNwkCode{set; get;}
    public String removeNwkReason{set; get;}
    public String addNetwork{set; get;}
    public String termReason{set; get;}
    public static List<String> pFinNumList{get;set;}
    public String hiddenJSON{get;set;}
    public List<Case> otherProvCasesforValidation = new List<Case>();

    /**
    * AccountToCase and EmailToCase variables
    * Setting and Getting
    * */
    public boolean emailToCase{set; get;}
    public boolean accountToCase{set; get;}
    public boolean showPersonAcct{set; get;}
    public boolean showEntityAcct{set;get;}
    public boolean showData{set; get;}
    public boolean AccountCase = false;
    public String caseOrigin{set; get;}
    public String accOrigin{set; get;}
    public String parentCaseId{set;get;}
    public String accountName{set;get;}
    public String caseMode{set; get;}
    public String acctId{set; get;}
    public boolean hidePFINPage{set; get;}
    public boolean isDisabled{get;set;}  
    
    String origin = '';
    String planId = ''; 
    String backwardUrl = ''; 
    String sobjName = '';
    String parentId = '';
    String caseEntity = '';
    String acctType = '';
    String pfinaddrId = '';
    String curHrs;
    Id cAccId=null;
    boolean isBusinessError = false;

    
    
    
    Account actList = null;
    Case    cList   = null; 
    
    public List<CM_SPL_Addr__c> AddrTaxId;
    public List<CM_Provider_Tax_Id__c> ProvTaxId; 
    public List<CM_SPL_Addr__c> billingAddr;
    public CM_SPL_Addr__c  selectedPFIN {get;set;}
    public  String addrId {get;set;}
    
    public set<Id>  provTaxIdentSet =   new Set<Id>();
    public List<CM_Provider_Identification__c> provIdentificationList{ get; set; }
    public List<CM_SPL_Addr__c> pFINListVal{ get; set; }
    //40K pfin select all
    public Boolean isSelectAll{get;set;}
    // PPN-15837 Code Starts
    public Boolean isServiceLocation{get;set;}
    public Boolean isBilling{get;set;}
    public Boolean isAdmin{get;set;}
    public Boolean isDirectory{get;set;}
    public Boolean isCredentialing{get;set;}  
    public List<String> pFINNumberList{get;set;}
    //1433
    public List<string> overAllPfinList{get;set;}
    // PPN-15837 Code Ends
    // PPN-20163 Start
    public String addrTypeNotDeletable {get;set;} {addrTypeNotDeletable='Billing';}
    // PPN-20163 End
    public void fetchData() {
        system.debug('pfin number lis-------------------');
        fetchAddress(); 
    }
    
    public list<ServicePayeeLocation> wrapList { get; set; }
    public List<CM_SPL_Addr__c> servicePayeeLocationList {get;set;}
    public String DelPFIN {get; set;} 
    String strTaxNumber ;/* US-14375*/ 
    public  string RegExp = '^((\\+1)?\\s?\\(\\d{3}\\)\\s?\\d{3}\\-\\d{4})?$';   //PPN=29257
    
    /* PPN-30828 */
    public String billPfin  {get; set;}
    public String nonbillpfin {get; set;}
    public Boolean selectAllNonBillPfinsChecked {get; set;}
    
    public ManualCaseCreationController()    
    {
        selectAllNonBillPfinsChecked = false;
        pFINNumberList = new List<String>();
        npiChg  = new Case();
        nameChg = new Case();
        addProv = new Case();
        removeProv = new Case();
        billAddrChg = new Case();
        phyAddrChg = new Case();
        admAddrChg = new Case();
        crdAddrChg = new Case();
        otherProv  = new Case();
        caseInfo = new Case();  
        statusCheck = new Case();
        networkChg  = new Case();
        parentCase  = new Case();  
        //40k pfin - select all
        isSelectAll=false;
        //40kPfin userstory
        showSelectAllPanel = false;     /* US PPN-13772 */
        showAddGrid = false;        /* US PPN-13772 */
        admChgFlg =false;       /* US PPN-13773 */
        billChgFlg=false;       /* US PPN-13773 */
        phyChgFlg=false;        /* US PPN-13773 */
        strTaxNumber='';        /* US-14375*/
        emailToCase = false;
        listOfTaxNumbers = new List<String>(); 
        taxIdsSelectOption      =   new Set<SelectOption>();
        pfinsSelectOption       =   new List<SelectOption>();
        setIntParam();
        /****PPN-14267 Code Start ****/
        isRenderRequestPage = false;
        /***** PPN-14267 Code End ***/
        
        Web2Case__c cs_numberOfRecordsToShow = (Web2Case__c.getValues('NumberOfRecordsToShow'));
        
        if (cs_numberOfRecordsToShow !=null){
            this.numberOfRecordsToShow = cs_numberOfRecordsToShow.CaseObjectValues__c;                 
        } 
        else{
            this.numberOfRecordsToShow = '10';
        }        
        // PPN-15737 Code Starts
        isServiceLocation = false;
        isBilling = false;
        isAdmin =false;
        isDirectory = false;
        isCredentialing = false;
        selectAllCheckBox = true;
        //PPN-15737 Code Ends
                
        wrapPageNumber = 0;     /* PPN-27985 */   
    }
    //PPN-15737 Code Starts    
    public void changeAddressType()
    {
        if(wrapList !=NULL && !wrapList.isEmpty())
        {
            for(ServicePayeeLocation newLocation:wrapList)
            {
                newLocation.selectedAddr=false;
            }
            for(ServicePayeeLocation newLocation:wrapList)
            {
                if(isServiceLocation && newLocation.servicePayeeAddress.CM_SPL_Addr_Type__c=='Service')
                {
                    newLocation.selectedAddr=true;
                }
                if(isBilling && newLocation.servicePayeeAddress.CM_SPL_Addr_Type__c=='Billing' && caseMode!='Delete')
                {
                    newLocation.selectedAddr=true;
                }
                if(isAdmin && newLocation.servicePayeeAddress.CM_SPL_Addr_Type__c=='Administration')
                {
                    newLocation.selectedAddr=true;
                }

                if(isCredentialing && newLocation.servicePayeeAddress.CM_SPL_Addr_Type__c=='Credentialing' && caseMode!='Delete')
                {
                    newLocation.selectedAddr=true;
                }
                
            }
        }
    }
    public void addRow()
    {
        PFINWrapper pfin = new PFINWrapper();
        system.debug('DelPFIN '+DelPFIN );
        String selectedNonBillpfin;               
        for (Integer idx=0; idx<pFINNumberList.size(); idx++)
        {         
            system.debug('What is the index '+idx+' pfinNumberList '+PfinNumberList+' value '+pfinNumberList[idx]);
            if (pFINNumberList[idx]==DelPFIN )
            {
                system.debug('What is the index '+idx+' pfinNumberList '+PfinNumberList+' value '+pfinNumberList[idx]);
                pFINNumberList.remove(idx);
                idx=idx-1;
            }
        } 
           //PPN-36814 -starts      
        if(DelPFIN!= null && DelPFIN.contains('-'))
            {
                selectedNonBillpfin= DelPFIN .split('-')[0];  
                DelPFIN = selectedNonBillpfin; 
                system.debug('DelPFIN '+DelPFIN );    
            }

       if(wrapList.size()>0){
       system.debug('coming here+++');
            for(Integer index=0;index<wrapList.size();index++)
            {
            
                //system.debug('wrapList[index].servicePayeeAddress.CM_SPL_PFIN_No__c++'+wrapList[index].servicePayeeAddress.CM_SPL_PFIN_No__c);
                if(wrapList[index].servicePayeeAddress.CM_SPL_PFIN_No__c==DelPFIN)
                {
                    wrapList.remove(index); 
                    listOfDisplayWrapList.remove(index);
                    index=index-1;   
                }
            }
                    listOfDisplayWrapList = wrapList;   //PPN-36814 -starts  
                //PPN-37892 -Starts  
                if(listOfDisplayWrapList.isempty()){
                            showSelectAllPanel = false;
                            showAddGrid = true;
                            fetchAddress();
                          // system.debug('listOfDisplayWrapList+++++++empty'+listOfDisplayWrapList);
                }
                //PPN-37892 Ends
                   // system.debug('wrapList++++++'+wrapList.size());
                    //system.debug('listOfDisplayWrapList+++++++ if'+listOfDisplayWrapList.size());
        }
        else{
            showSelectAllPanel = false;
            showAddGrid = true;
            fetchAddress();
            system.debug('listOfDisplayWrapList+++++++else'+listOfDisplayWrapList);
        }
        //PPN-36814 -ends
           
        
        system.debug('listOfDisplayWrapList.sie() +++++ '+listOfDisplayWrapList.size()+ '   listOfDisplayWrapList  '+listOfDisplayWrapList);
        system.debug('WrapList.sie() +++++ '+wrapList.size()+ '   WrapList  '+WrapList);
        system.debug('What is the index pfinNumberList++++'+ pfinNumberList.size() + '   pfinNumberList  '+pfinNumberList); 
        system.debug('selPFIN'+selPFIN);         
        if(pfinNumberList !=NULL && !pfinNumberList.isEmpty() && wrapList !=NULL && ((!wrapList.isEmpty() && wrapList.size()==1 && wrapList[0].servicePayeeAddress.CM_SPL_PFIN_No__c==selPFIN)||(wrapList.isEmpty())))
        {System.debug('coming inside IF');
         fetchAddress();
        }
        else
        {
            System.debug('Coming inside else');
            wrapList = new List<ServicePayeeLocation>();
            List<Account> listOfAccount = [Select Id, CM_Corporate_Entity_Code__c From Account Where Id =:acctId];
            
            for(CM_SPL_Addr__c newAddress:[select CM_SPL_Prov__c,CM_SPL_Prov__r.Name,CM_SPL_Prov__r.CM_Corporate_Entity_Code__c,CM_SPL_PFIN_No__c,CM_SPL_Addr_Type__c,CM_SPL_Addr_Line_1__c,CM_SPL_Add_Line_2__c,CM_SPL_State__c from CM_SPL_Addr__c where ((Bill_PFIN__c =:selPFIN AND CM_SPL_PFIN_No__c IN:pfinNumberList AND CM_SPL_Prov__r.CM_Corporate_Entity_Code__c=:listOfAccount[0].CM_Corporate_Entity_Code__c)) ORDER BY CM_SPL_PFIN_No__c])
            {
                System.debug('What is in newAddress'+newAddress+'Boolean '+newAddress.CM_SPL_Prov__c+'acctId'+acctId+'set');
                if( !listOfAccount.isEmpty() &&   
                   (((listOfAccount[0].CM_Corporate_Entity_Code__c=='IL1' || listOfAccount[0].CM_Corporate_Entity_Code__c=='OK1') && (newAddress.CM_SPL_Addr_Type__c =='Billing' || newAddress.CM_SPL_Addr_Type__c =='Service'))
                    || ((listOfAccount[0].CM_Corporate_Entity_Code__c=='TX1' || listOfAccount[0].CM_Corporate_Entity_Code__c=='MT1' || listOfAccount[0].CM_Corporate_Entity_Code__c=='NM1') && (newAddress.CM_SPL_Addr_Type__c =='Billing' || newAddress.CM_SPL_Addr_Type__c =='Service' || newAddress.CM_SPL_Addr_Type__c =='Administration'))))
                {
                    System.debug('Coming Inside');
                    wrapList.add(new ServicePayeeLocation (newAddress));                       
                }                    
            }
            System.debug('What is in list '+wrapList);
            
        }  
        
                
    }     
    //PPN-15737 Code Ends    
    public Class PFINWrapper
    {
        public String pFINNumber { get;set; }
        public PFINWrapper()
        {
        }
        public PFINWrapper(String pFIN)
        {
            this.pFINNumber = pFIN;    
        }
    }
    
    public void autoRun()
    { 
        List<String> addProvGender = Utils.getPicklistValues('Case','Gender__c');
        genderOption = new list<SelectOption>();
        for (integer i=0;i<addProvGender.size();i++){
            genderOption.add(new SelectOption(addProvGender.get(i),addProvGender.get(i)));
        }
        
        List<String> typeOfProvList = Utils.getPicklistValues('Case','Completing_the_form_for__c');
        typeOfProvOption = new list<SelectOption>();
        typeOfProvOption.add(new SelectOption('None','--None--'));
        
        for (integer i=0;i<typeOfProvList.size();i++){
            typeOfProvOption.add(new SelectOption(typeOfProvList.get(i),typeOfProvList.get(i)));
        }
        List<String> reasonListVal = Utils.getPicklistValues('Case','Reason_For_Leaving_Group_Location__c');
        reasonOption = new list<SelectOption>();
        reasonOption.add(new SelectOption('None','--None--'));
        
        for (integer i=0;i<reasonListVal.size();i++){
            reasonOption.add(new SelectOption(reasonListVal.get(i),reasonListVal.get(i)));
        }
        
        List<String> billTypListVal = Utils.getPicklistValues('Case','Bill_NPI_Type__c');
        billTypOption = new list<SelectOption>();
        billTypOption.add(new SelectOption('None','--None--'));
        for (integer i=0;i<billTypListVal.size();i++){
            billTypOption.add(new SelectOption(billTypListVal.get(i),billTypListVal.get(i)));
        }
        
        List<String> suffixListVal = Utils.getPicklistValues('Case','Suffix_Current__c');
        suffixOption = new list<SelectOption>();
        suffixOption.add(new SelectOption('None','--None--'));
        for (integer i=0;i<suffixListVal.size();i++){
            suffixOption.add(new SelectOption(suffixListVal.get(i),suffixListVal.get(i)));
        }
        
        List<String> accNewAccListVal = Utils.getPicklistValues('Case','Accepting_New_Patients__c');
        phyActOption = new list<SelectOption>();
        phyActOption.add(new SelectOption('None','--None--'));
        for (integer i=0;i<accNewAccListVal.size();i++){
            phyActOption.add(new SelectOption(accNewAccListVal.get(i),accNewAccListVal.get(i)));
        }
        
    /*
    * Support for AC 10 in PPN-5342
    * 10. Under Terminate Provider section, Add "Others" in Term Reason field drop down values.
    */         
        TermProviderReasonsOptions = createSelectOptionsFromList(Utils.getPicklistValues('Case','Term_Reason__c'), true);
        
   /*
    * Support for AC 10 in PPN-5342
    * 10. Under Terminate Provider section, Add "Others" in Term Reason field drop down values.
    */         
        TermProviderReasonsOptions = createSelectOptionsFromList(Utils.getPicklistValues('Case','Term_Reason__c'), true);                                          
    }
    /**
    * Initialize the values for Account-To-Case and Email-To-Case
    * Determine the Account Business Entity or Person 
    * Identify the parent case
    * */
    public void SetCaseAccVal(){   
        if (sobjName.equalsIgnoreCase('Case')){ 
            case emailParent = new case();
            emailParent =  [Select Govt_Programs__c From Case  Where Id = :parentId];
            emailParent.Govt_Programs__c = caseInfo.Govt_Programs__c;
            system.debug('Lax:SetCaseAccVal:parentId:' + parentId + ':npiChgFlg:' + npiChgFlg);
            if (npiChgFlg){
                if (caseInfo.AccountId!=null){
                    npiChg.AccountId =caseInfo.AccountId; 
                }else if (caseInfo.Case_Entity__c!=null){
                    npiChg.Case_Entity__c =caseInfo.Case_Entity__c; 
                }
                npiChg.ParentId = parentId; 
                npiChg.Origin = caseOrigin; 
                emailParent.NPI_Tax_Id_Change__c = true;
            }
            system.debug('npiChg:' + npiChg + ':npiChg.parentId:' + npiChg.parentId);
            if (nameChgFlg){ 
                if (caseInfo.AccountId!=null){
                    nameChg.AccountId =caseInfo.AccountId; 
                }else if (caseInfo.Case_Entity__c!=null){
                    nameChg.Case_Entity__c =caseInfo.Case_Entity__c; 
                }
                nameChg.ParentId = parentId;
                nameChg.Origin = caseOrigin;
                emailParent.Name_Change__c = true;
            }
            if (billChgFlg){ 
                if ( caseInfo.AccountId!=null){
                    billAddrChg.AccountId =caseInfo.AccountId; 
                }else if (caseInfo.Case_Entity__c!=null){
                    billAddrChg.Case_Entity__c =caseInfo.Case_Entity__c; 
                }
                billAddrChg.ParentId = parentId;
                billAddrChg.Origin = caseOrigin; 
                emailParent.Billing_Address_Telephone_Fax_Email_Chan__c = true;
            }
            if (phyChgFlg){
                if (caseInfo.AccountId!=null){
                    phyAddrChg.AccountId =caseInfo.AccountId; 
                }else if (caseInfo.Case_Entity__c!=null){
                    phyAddrChg.Case_Entity__c =caseInfo.Case_Entity__c; 
                }
                phyAddrChg.ParentId = parentId;
                phyAddrChg.Origin = caseOrigin; 
                emailParent.Office_Physical_Address_Telephone_Fax_Em__c = true;
                
            }
            if (admChgFlg){
                if (caseInfo.AccountId!=null){
                    admAddrChg.AccountId =caseInfo.AccountId; 
                }else if (caseInfo.Case_Entity__c!=null){
                    admAddrChg.Case_Entity__c =caseInfo.Case_Entity__c; 
                }
                admAddrChg.ParentId = parentId;
                admAddrChg.Origin = caseOrigin; 
                emailParent.Administrative_Address_Telephone_Fax_Ema__c = true;
            }

            if (specialtyFlg || privilegesFlg || providerIDsFlg || othersFlg){
                if (caseInfo.AccountId!=null){
                    otherProv.AccountId =caseInfo.AccountId; 
                }else if (caseInfo.Case_Entity__c!=null){
                    otherProv.Case_Entity__c =caseInfo.Case_Entity__c; 
                }
                otherProv.ParentId = parentId;
                otherProv.Origin = caseOrigin;
                emailParent.Other_provider_Info__c =  true;
            }
            if (removeProvFlg){
                if (caseInfo.AccountId!=null){
                    removeProv.AccountId =caseInfo.AccountId; 
                }else if (caseInfo.Case_Entity__c!=null){
                    removeProv.Case_Entity__c =caseInfo.Case_Entity__c; 
                }
                removeProv.ParentId = parentId;
                removeProv.Origin = caseOrigin;
                emailParent.Remove_Provider_from_Group_Location__c = true;
            }
            if (addProvFlg){
                if (caseInfo.AccountId!=null){
                    addProv.AccountId =caseInfo.AccountId; 
                }else if (caseInfo.Case_Entity__c!=null){
                    addProv.Case_Entity__c =caseInfo.Case_Entity__c; 
                }
                addProv.ParentId = parentId;
                addProv.Origin = caseOrigin;
                emailParent.Add_Provider_from_Group_Location__c = true;
            }
            if (addNwkChgFlg || rmNwrkChgFlg || reinPrvChgFlg || termPrvChgFlg){
                if (caseInfo.AccountId!=null){
                    networkChg.AccountId =caseInfo.AccountId; 
                }else if (caseInfo.Case_Entity__c!=null){
                    networkChg.Case_Entity__c =caseInfo.Case_Entity__c; 
                }                 
                networkChg.ParentId = parentId; 
                networkChg.Origin = caseOrigin;
                emailParent.Network_Change__c = true;
            }
            try{
                update emailParent;
            }catch(DmlException ex){
                System.debug('Exception :'+ex.getMessage());
            }
            
        }

         if ((sobjName.equalsIgnoreCase('Account')||sobjName.equalsIgnoreCase('Pfin')) && 
             (nameChgFlg || npiChgFlg || billChgFlg || phyChgFlg || /* --was-- chrChgFlg */ admChgFlg || specialtyFlg || 
              privilegesFlg || providerIDsFlg || othersFlg || removeProvFlg || addProvFlg || addNwkChgFlg ||
              rmNwrkChgFlg || reinPrvChgFlg || termPrvChgFlg || benfChgFlg || caseCheckChgFlg ||
              claimCheckChgFlg || contractCheckFlg || credCheckChgFlg || compCheckFlg || statusCheckFlg ||
              netwrkCheckFlg || paperCheckFlg || preDeterCheckFlg || preAuthCheckFlg || retroCheckFlg || feeScheduleFlg
              || ClaimsProjectFlg || rosterCheckFlg || retroReqCheckFlg || eftCheckFlg))
         {
            parentCase.Origin =accOrigin;
            if (actList.IsPersonAccount)
                parentCase.AccountId = acctId;                  
            else
                parentCase.Case_Entity__c = acctId; 
            if (nameChgFlg || npiChgFlg 
                || billChgFlg || phyChgFlg 
               /* --was-- || crdChgFlg*/ || admChgFlg 
                || specialtyFlg || privilegesFlg 
                || providerIDsFlg || othersFlg 
                || removeProvFlg || addProvFlg 
                || addNwkChgFlg || rmNwrkChgFlg 
                || reinPrvChgFlg || termPrvChgFlg
               )
                CreateParentCase(); 
            if (npiChgFlg){
                npiChg.Origin =accOrigin;
                npiChg.ParentId = parentCase.Id;  
                if (actList.IsPersonAccount)
                    npiChg.AccountId = acctId;
                else
                    npiChg.Case_Entity__c = acctId;
                
            }
            if (nameChgFlg){
                nameChg.Origin =accOrigin;
                nameChg.ParentId = parentCase.Id;
                if (actList.IsPersonAccount)
                    nameChg.AccountId = acctId;
                else
                    nameChg.Case_Entity__c = acctId;
                
            }
            if (billChgFlg){
                billAddrChg.Origin =accOrigin;
                billAddrChg.ParentId = parentCase.Id;
                if (actList.IsPersonAccount){
                    billAddrChg.AccountId = acctId;
                }else{
                    billAddrChg.Case_Entity__c = acctId;
                }
            }    
            if (phyChgFlg){                
                phyAddrChg.Origin =accOrigin;
                phyAddrChg.ParentId = parentCase.Id;
                if (actList.IsPersonAccount){
                    phyAddrChg.AccountId = acctId;
                }else{
                    phyAddrChg.Case_Entity__c = acctId;
                }
            }
            if (admChgFlg){
                admAddrChg.Origin =accOrigin;
                admAddrChg.ParentId = parentCase.Id;
                if (actList.IsPersonAccount){
                    admAddrChg.AccountId = acctId;
                }else{
                    admAddrChg.Case_Entity__c = acctId;
                }
            }

            if (specialtyFlg || privilegesFlg || providerIDsFlg || othersFlg){
                otherProv.Origin =accOrigin;
                otherProv.ParentId = parentCase.Id;
                if (actList.IsPersonAccount){
                    otherProv.AccountId = acctId;
                }else{
                    otherProv.Case_Entity__c = acctId;
                }
            }
            if (removeProvFlg){
                removeProv.Origin =accOrigin;
                removeProv.ParentId = parentCase.Id; 
                if (actList.IsPersonAccount){
                    removeProv.AccountId = acctId;
                }else{
                    removeProv.Case_Entity__c = acctId;
                }   
            }
            if (addProvFlg){
                addProv.Origin =accOrigin;
                addProv.ParentId = parentCase.Id; 
                if (actList.IsPersonAccount){
                    addProv.AccountId = acctId;
                }else{
                    addProv.Case_Entity__c = acctId;
                }   
            }
            if (addNwkChgFlg || rmNwrkChgFlg || reinPrvChgFlg || termPrvChgFlg){
                networkChg.Origin =accOrigin;
                networkChg.ParentId = parentCase.Id;                    
                if (actList.IsPersonAccount){
                    networkChg.AccountId = acctId;
                }else{
                    networkChg.Case_Entity__c = acctId;
                }   
            }
            
        }
        system.debug('npiChg2:' + npiChg + ':npiChg.parentId:' + npiChg.parentId);
    }
    
    public void setEmailAccount(String accountID,String caseEntity){
        if (accountID=='' && caseEntity==''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select either Account Name(Physician) OR Case Entity(Hospital/Group)');
            ApexPages.addmessage(myMsg); 
            isBusinessError = true;
            hidePFINPage = false;
            isDisabled = true;
        }else if ((accountID!=null && accountID!='') && (caseEntity!='' && caseEntity!=null)){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select either Account Name(Physician) OR Case Entity(Hospital/Group) not both');
            ApexPages.addmessage(myMsg); 
            isBusinessError = true;
            hidePFINPage = false;
            isDisabled = true;
        }else if (accountID!=null && accountID!=''){
            caseInfo.AccountId = accountID;
            acctId = accountID;
            actList = getAccount(accountID);
            accountName = actList.Name;
            if (actList.IsPersonAccount){
                showPersonAcct = true;
            }else{
                showEntityAcct= true; 
            }
        }else if (caseEntity!=null && caseEntity!=''){
            caseInfo.Case_Entity__c = caseEntity;
            acctId = caseEntity;
            actList = getAccount(caseEntity);
            accountName = actList.Name;
            if (actList.IsPersonAccount){
                showPersonAcct = true;
            }else{
                showEntityAcct= true; 
            }
            
        }
        
    }
    
    /**
    * Set Initial Parameter values for Account-To-Case and Email-To-Case
    * Determine the Case Origin, Plan ID, Parent Case 
    * Identify the parameter values
    * */
    public void setIntParam(){
        sobjName = ApexPages.currentPage().getParameters().get('from'); 
        origin = ApexPages.currentPage().getParameters().get('caseorg'); 
        acctId = ApexPages.currentPage().getParameters().get('accountId'); 
        acctType = ApexPages.currentPage().getParameters().get('accountType');
        parentId = ApexPages.currentPage().getParameters().get('parentId'); 
        caseEntity = ApexPages.currentPage().getParameters().get('caseEntity');  
        planId = ApexPages.currentPage().getParameters().get('planId');
        System.debug('planId===>>>'+planId);
        pfinaddrId = ApexPages.currentPage().getParameters().get('pfinaddressId');
        //40 PFIN Changes
        accountName = ApexPages.currentPage().getParameters().get('accountName');
        
        hidePFINPage = true;
        try{
            if (pFINList==null && pFINList.size()==0){
                hidePFINPage = false;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No PFINS found for this Entity/Individual');
                ApexPages.addmessage(myMsg);   
            }
        }catch (Exception ex) {
            
        }
        
        if (sobjName != NULL && sobjName.equalsIgnoreCase('Case')){ 
            setEmailAccount(acctId,caseEntity);
            cList =  [Select caseNumber,SuppliedEmail, Corporate_Received_Date_Time__c From Case  Where Id = :parentId];
            caseInfo.Corporate_Received_Date_Time__c = cList.Corporate_Received_Date_Time__c;
            caseInfo.Email_Address_Submitter__c = cList.SuppliedEmail;
            caseOrigin = origin;
            parentCaseId = cList.CaseNumber;
            emailToCase= true;  
        }if (sobjName !=NULL && ((sobjName.equalsIgnoreCase('Account'))||(sobjName.equalsIgnoreCase('Pfin')))){ 
            caseInfo.Origin= accOrigin;   
            accountToCase = true;
            selNonBillPFIN = ApexPages.currentPage().getParameters().get('urlNonBillPfin');
            selPfin = ApexPages.currentPage().getParameters().get('urlPFIN');
            billpfin = selPfin;
            if(selNonBillPFIN != null && selNonBillPFIN != '') {
                nonbillpfin = selNonBillPFIN + '-' + ApexPages.currentPage().getParameters().get('name');
                showAddGrid = true;
            }
            if (acctId!=null && acctId!=''){
                actList = getAccount(acctId);
                accountName = actList.Name;
                caseInfo.AccountId = acctId; 
                if (actList.IsPersonAccount){
                    showPersonAcct = true;
                }else{
                    showEntityAcct = true; 
                }
            }
            
        }
        setCaseInfo();
    }
    
    /**
    * Method to determine Entity or Person Account
    * Input Parameter account ID.
    * */
    public Account getAccount(String accountId){ 
        actList = [Select name,IsPersonAccount From Account  Where Id = :accountId]; 
        return actList;   
    }
    
    public void setCaseInfo(){
        caseInfo.Plan_ID__c = planId;
        caseInfo.Status = 'New';
        caseInfo.Priority = 'Medium'; 
        CaseInfo.MC_PFIN__c = selPFIN;
    }
    
    /**
    * Method to Create Parent Case for Account To Case
    * Determine all the Request Category to Create Case
    * Identify Type of Request.
    * */
    public void CreateParentCase()
    { 
        //parentCase.MC_PFIN__c = CaseInfo.MC_PFIN__c;
        RecordType masterCaseRecType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE and DeveloperName = :CaseUtil.REC_TYPE_MASTER_PROVIDER_CASE]; 
        if (CaseMode == 'Add'){
            parentCase.MC_Add__c = true;           
        }
        if (CaseMode == 'Change'){
            parentCase.MC_Change__c = true;           
        }
        if (CaseMode == 'Delete'){
            parentCase.MC_Delete__c = true;           
        }
        if (addNwkChgFlg==true || rmNwrkChgFlg==true || reinPrvChgFlg==true || termPrvChgFlg==true)
        {
            parentCase.Network_Change__c=true; 
        }
        parentCase.recordtypeId = masterCaseRecType.Id;
        parentCase.Status = caseInfo.Status;
        parentCase.Priority = caseInfo.Priority;             
        parentCase.Plan_ID__c = planId; 
        parentCase.Govt_Programs__c = caseInfo.Govt_Programs__c;
        parentCase.Completing_the_form_for__c = typeOfProv;  
        parentCase.Corporate_Received_Date_Time__c = CaseInfo.Corporate_Received_Date_Time__c;
        parentCase.Name_Submitter__c = CaseInfo.Name_Submitter__c; 
        parentCase.Title_Submitter__c = CaseInfo.Title_Submitter__c; 
        parentCase.Telephone_Number_Submitter__c = CaseInfo.Telephone_Number_Submitter__c;  
        parentCase.Submitter_Phone_Ext__c = CaseInfo.Submitter_Phone_Ext__c;  
        parentCase.Email_Address_Submitter__c = CaseInfo.Email_Address_Submitter__c;  
        parentCase.Name_of_Provider_Group__c = caseInfo.Name_of_Provider_Group__c;
        parentCase.Tax_ID_Number__c = caseInfo.Tax_ID_Number__c;
        parentCase.Rendering_NPI__c = renderNPI;
        parentCase.Billing_NPI_Number__c = billNPI;  
        parentCase.Bill_NPI_Type__c = billNpiType;  
        parentCase.Original_Creation_Date__c=System.now();  
        parentCase.Name_Change__c = nameChgFlg;
        parentCase.NPI_Tax_Id_Change__c = npiChgFlg;
        parentCase.Office_Physical_Address_Telephone_Fax_Em__c = phyChgFlg; 
        parentCase.Billing_Address_Telephone_Fax_Email_Chan__c = billChgFlg;
        parentCase.Administrative_Address_Telephone_Fax_Ema__c = admChgFlg;
        parentCase.Remove_Provider_from_Group_Location__c = removeProvFlg;      // for defect PPN-15723, Blue Avengers Release 3, Sprint 9 5/8/2018
        parentCase.Add_Provider_from_Group_Location__c = addProvFlg;
        if(specialtyFlg || privilegesFlg || providerIDsFlg || othersFlg)          
            parentCase.Other_provider_Info__c=true;
        
        /* --was-- the following section is not commented out in SIT2 code, so I'm adding it */
        if (addProvFlg){
            parentCase.Group_Name__c = addProv.Group_Name__c;
            parentCase.Group_Tax_ID__c = addProv.Group_Tax_ID__c;
            parentCase.Gender__c =   addProv.Gender__c;
            parentCase.Group_Provider_Type_Specialty__c = addProv.Group_Provider_Type_Specialty__c;
            parentCase.License_Number__c = addProv.License_Number__c;
            parentCase.CAQH_Number__c=addProv.CAQH_Number__c;    
            parentCase.Other_Provider_Number__c=addProv.Other_Provider_Number__c;
            parentCase.Add_Provider_Supervising_Physician__c=addProv.Add_Provider_Supervising_Physician__c;
            parentCase.Networks__c=addProv.Networks__c;
            parentCase.Add_Provider_Accepting_New_Patients__c=addProv.Add_Provider_Accepting_New_Patients__c;
            parentCase.Provider_s_Name__c=addProv.Provider_s_Name__c;
            parentCase.Group_NPI__c=addProv.Group_NPI__c;
            parentCase.Group_PFIN__c=addProv.Group_PFIN__c;
            parentCase.Individual_NPI__c=addProv.Individual_NPI__c;
            parentCase.Add_Provider_Date_Of_Birth__c = addProv.Add_Provider_Date_Of_Birth__c;            
            parentCase.Indivudual_Type_Speciality__c = addProv.Indivudual_Type_Speciality__c;
            parentCase.Comp_Grid_Code_If_applicable__c=addProv.Comp_Grid_Code_If_applicable__c;
            parentCase.Designation_Code_If_applicable__c=addProv.Designation_Code_If_applicable__c;
            parentCase.Supervising_Physician_License__c=addProv.Supervising_Physician_License__c;
            parentCase.Add_Nwk_Eff_Date__c=addProv.Add_Nwk_Eff_Date__c;
            parentCase.Hospital_Affilitation__c=addProv.Hospital_Affilitation__c;
            
            parentCase.Site_Acce__c=addProv.Site_Acce__c;
            parentCase.Office_Reception_Area__c=addProv.Office_Reception_Area__c;
            parentCase.Exam_Room__c=addProv.Exam_Room__c;
            parentCase.Exterior__c=addProv.Exterior__c;
            parentCase.Scale__c=addProv.Scale__c;
            parentCase.Interior_Building__c=addProv.Interior_Building__c;
            parentCase.Parking_Accessbility__c=addProv.Parking_Accessbility__c;
            parentCase.Restroom__c=addProv.Restroom__c;
            parentCase.Exam_Table__c=addProv.Exam_Table__c;
            parentCase.Close_Proximity_to_Public_Transportation__c=addProv.Close_Proximity_to_Public_Transportation__c;
            
            parentCase.Current_Addr_Line_1_add_prov_Phy__c=addProv.Current_Addr_Line_1_add_prov_Phy__c;
            parentCase.Current_Addr_Line_2_add_prov_Phy__c=addProv.Current_Addr_Line_2_add_prov_Phy__c;
            parentCase.Current_City_add_prov_Phy__c=addProv.Current_City_add_prov_Phy__c;
            parentCase.Current_State_add_prov_Phy__c=addProv.Current_State_add_prov_Phy__c;
            parentCase.Current_Zip_add_prov_Phy__c=addProv.Current_Zip_add_prov_Phy__c;
            parentCase.Current_Phone_add_prov_Phy__c=addProv.Current_Phone_add_prov_Phy__c;
            parentCase.Current_Email_add_prov_Phy__c=addProv.Current_Email_add_prov_Phy__c;
            parentCase.Current_Fax_add_prov_Phy__c=addProv.Current_Fax_add_prov_Phy__c;
            parentCase.Accepting_New_Patients_add_prov_Phy__c=addProv.Accepting_New_Patients_add_prov_Phy__c;
            parentCase.New_Addr_Line_1_add_prov_Phy__c=addProv.New_Addr_Line_1_add_prov_Phy__c;
            parentCase.New_Addr_Line_2_add_prov_Phy__c=addProv.New_Addr_Line_2_add_prov_Phy__c;
            parentCase.New_City_add_prov_Phy__c=addProv.New_City_add_prov_Phy__c;
            parentCase.New_State_add_prov_Phy__c=addProv.New_State_add_prov_Phy__c;
            parentCase.New_Zip_add_prov_Phy__c=addProv.New_Zip_add_prov_Phy__c;
            parentCase.New_Phone_add_prov_Phy__c=addProv.New_Phone_add_prov_Phy__c;
            parentCase.Physical_Address_Current_Phone_Ext__c=addProv.Physical_Address_Current_Phone_Ext__c;
            parentCase.New_Email_add_prov_Phy__c=addProv.New_Email_add_prov_Phy__c;
            parentCase.New_Fax_add_prov_Phy__c=addProv.New_Fax_add_prov_Phy__c;
            parentCase.Primary_Location_add_prov_Phy__c=addProv.Primary_Location_add_prov_Phy__c;
            parentCase.Efft_Date_Physical_add_prov_Phy__c=addProv.Efft_Date_Physical_add_prov_Phy__c;
            
            parentCase.Current_Addr_Line_1_add_prov_Bill__c=addProv.Current_Addr_Line_1_add_prov_Bill__c;
            parentCase.Current_Addr_Line_2_add_prov_Bill__c=addProv.Current_Addr_Line_2_add_prov_Bill__c;
            parentCase.Current_City_add_prov_Bill__c=addProv.Current_City_add_prov_Bill__c;
            parentCase.Current_State_add_prov_Bill__c=addProv.Current_State_add_prov_Bill__c;
            parentCase.Current_Zip_add_prov_Bill__c=addProv.Current_Zip_add_prov_Bill__c;
            parentCase.Current_Phone_add_prov_Bill__c=addProv.Current_Phone_add_prov_Bill__c;
            parentCase.Current_Email_add_prov_Bill__c=addProv.Current_Email_add_prov_Bill__c;
            parentCase.Current_Fax_add_prov_Bill__c=addProv.Current_Fax_add_prov_Bill__c;
            parentCase.New_Addr_Line_1_add_prov_Bill__c=addProv.New_Addr_Line_1_add_prov_Bill__c;
            parentCase.New_Addr_Line_2_add_prov_Bill__c=addProv.New_Addr_Line_2_add_prov_Bill__c;
            parentCase.New_City_add_prov_Bill__c=addProv.New_City_add_prov_Bill__c;
            parentCase.New_State_add_prov_Bill__c=addProv.New_State_add_prov_Bill__c;
            parentCase.New_Zip_add_prov_Bill__c=addProv.New_Zip_add_prov_Bill__c;
            parentCase.New_Phone_add_prov_Bill__c=addProv.New_Phone_add_prov_Bill__c;
            parentCase.Billing_Address_Current_Phone_Ext__c=addProv.Billing_Address_Current_Phone_Ext__c;
            parentCase.New_Email_add_prov_Bill__c=addProv.New_Email_add_prov_Bill__c;
            parentCase.New_Fax_add_prov_Bill__c=addProv.New_Fax_add_prov_Bill__c;
            parentCase.Efft_Date_add_prov_Bill__c=addProv.Efft_Date_add_prov_Bill__c;
            parentCase.Comments_add_prov_Bill__c=addProv.Comments_add_prov_Bill__c;
        }
        try{ 
            insert parentCase;
            System.debug('parentCase 111====>>>>'+parentCase);            
        }catch (Exception ex){            
            String msg = String.valueOf(ex.getmessage());
            system.debug('### Exception Occured ###' + ex.getMessage());
            
        }
        
    }   
    
    public void npiChange(set <string> finalPfins){
        System.debug('parentId '+parentId);
        RecordType taxIdChangeRecType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE and DeveloperName = :CaseUtil.REC_TYP_NPI_ID]; 
        List<Case> npiChgCaseForInsert     =   new List<Case>();
        for( String npiChgPfin :  finalPfins )
        {
            system.debug(finalPfins +'finalPfins');
            npiChg = new Case();
            npiChg.MC_PFIN__c = npiChgPfin;
            npiChg.parentId=parentId;
            if (CaseMode == 'Add')
            {
                npiChg.MC_Add__c = true;           
            }
            if (CaseMode == 'Change')
            {
                npiChg.MC_Change__c = true;           
            }
            if (CaseMode == 'Delete')
            {
                npiChg.MC_Delete__c = true;           
            }
            npiChg.Status = caseInfo.Status;
            npiChg.Priority = caseInfo.Priority; 
            npiChg.Plan_ID__c = planId;
            npiChg.Govt_Programs__c = caseInfo.Govt_Programs__c;
            npiChg.Completing_the_form_for__c = typeOfProv;  
            npiChg.Corporate_Received_Date_Time__c = CaseInfo.Corporate_Received_Date_Time__c;
            npiChg.Name_Submitter__c = CaseInfo.Name_Submitter__c; 
            npiChg.Title_Submitter__c = CaseInfo.Title_Submitter__c;  
            npiChg.Telephone_Number_Submitter__c = CaseInfo.Telephone_Number_Submitter__c;  
            npiChg.Submitter_Phone_Ext__c = CaseInfo.Submitter_Phone_Ext__c;  
            npiChg.Email_Address_Submitter__c = CaseInfo.Email_Address_Submitter__c;  
            npiChg.Name_of_Provider_Group__c = caseInfo.Name_of_Provider_Group__c;
            npiChg.Billing_NPI_Number__c = BillNPI;  
            npiChg.Bill_NPI_Type__c = billNpiType;  
            npiChg.Tax_ID_Number__c = caseInfo.Tax_ID_Number__c;
            npiChg.Rendering_NPI__c = renderNPI;
            npiChg.Original_Creation_Date__c=System.now();  
            npiChg.RecordTypeId = taxIdChangeRecType.id; 
            npiChg.Name_Change__c = nameChgFlg;
            npiChg.NPI_Tax_Id_Change__c = npiChgFlg;
            npiChg.Office_Physical_Address_Telephone_Fax_Em__c = phyChgFlg; 
            npiChg.Billing_Address_Telephone_Fax_Email_Chan__c = billChgFlg;
            /* --was-- npiChg.Credentialing_Address_Telephone_Fax_Emai__c = crdChgFlg; */
            npiChg.Administrative_Address_Telephone_Fax_Ema__c= admChgFlg; 
            if(specialtyFlg || privilegesFlg || providerIDsFlg || othersFlg) 
            {         
                npiChg.Other_provider_Info__c=true;
            }
            npiChg.Remove_Provider_from_Group_Location__c=removeProvFlg;
            npiChg.Add_Provider_from_Group_Location__c=addProvFlg;
            system.debug('addNwkChgFlg=== '+addNwkChgFlg);
            if (addNwkChgFlg || rmNwrkChgFlg || reinPrvChgFlg || termPrvChgFlg)
            {
                npiChg.Network_Change__c=true;
            }
            if (nameChgFlg)
            {
                if (CaseMode == 'Change' || CaseMode == 'Delete')
                {
                    npiChg.First_Name_Current__c= nameChg.First_Name_Current__c;
                    npiChg.Last_Name_Current__c= nameChg.Last_Name_Current__c;
                    npiChg.Title_Current__c=nameChg.Title_Current__c;
                    npiChg.Middle_Initial_Current__c=nameChg.Middle_Initial_Current__c;
                    npiChg.Suffix_Current__c=suffixCur;
                    npiChg.Current_Practice_Name__c=nameChg.Current_Practice_Name__c;
                    npiChg.MC_Current_Group_Name__c = nameChg.MC_Current_Group_Name__c;
                }    
                npiChg.Last_Name_New__c=  nameChg.Last_Name_New__c;
                npiChg.First_Name_New__c= nameChg.First_Name_New__c;
                npiChg.Middle_Initial_New__c=nameChg.Middle_Initial_New__c;
                npiChg.Title_New__c= nameChg.Title_New__c;
                npiChg.New_Practice_Name__c=nameChg.New_Practice_Name__c;
                npiChg.MC_New_Group_Name__c = nameChg.MC_New_Group_Name__c;
                npiChg.Effective_Date_of_Change_Name__c=nameChg.Effective_Date_of_Change_Name__c;
                npiChg.Comments_Name_Change__c=nameChg.Comments_Name_Change__c;
                npiChg.Suffix_New__c=suffixNew;
            }
            if (npiChgFlg)
            {
                if (CaseMode == 'Change' || CaseMode == 'Delete')
                {
                    npiChg.Bill_NPI_Num_Current__c= npiChg.Bill_NPI_Num_Current__c; 
                    npiChg.Tax_ID_Num_Current__c = npiChg.Tax_ID_Num_Current__c;
                }   
                npiChg.New_Tax_ID_Number__c=npiChg.New_Tax_ID_Number__c;
                npiChg.New_Billing_NPI_Number__c=npiChg.New_Billing_NPI_Number__c;
                npiChg.Comments_NPI_Tax__c= npiChg.Comments_NPI_Tax__c;
                npiChg.Effective_Date_of_Change_NPI_Tax__c=npiChg.Effective_Date_of_Change_NPI_Tax__c;
            }if (phyChgFlg)
            {
                if (CaseMode == 'Change' || CaseMode == 'Delete')
                {
                    npiChg.Street_Address_Suite_No_Physical_current__c= phyAddrChg.Street_Address_Suite_No_Physical_current__c;
                    npiChg.Addr_Line_2_Phy_Curr__c=phyAddrChg.Addr_Line_2_Phy_Curr__c;
                    npiChg.City_Physical_Current__c=phyAddrChg.City_Physical_Current__c;
                    npiChg.State_Physical_Current__c=phyAddrChg.State_Physical_Current__c;
                    npiChg.Zip_Physical_Current__c=phyAddrChg.Zip_Physical_Current__c;
                    npiChg.Telephone_Physical_Current__c=phyAddrChg.Telephone_Physical_Current__c;
                    npiChg.Email_Physical_Current__c=phyAddrChg.Email_Physical_Current__c;
                    npiChg.Fax_Physical_Current__c=phyAddrChg.Fax_Physical_Current__c;
                }
                npiChg.Accepting_New_Patients__c=phyAddrChg.Accepting_New_Patients__c;
                npiChg.Street_Address_Suite_No_Physical_New__c=phyAddrChg.Street_Address_Suite_No_Physical_New__c;
                npiChg.Addr_Line_2_Phy_New__c=phyAddrChg.Addr_Line_2_Phy_New__c;
                npiChg.City_Physical_New__c=phyAddrChg.City_Physical_New__c;
                npiChg.State_Physical_New__c=phyAddrChg.State_Physical_New__c;
                npiChg.Zip_Physical_New__c=phyAddrChg.Zip_Physical_New__c;
                npiChg.Telephone_Physical_New__c=phyAddrChg.Telephone_Physical_New__c;
                npiChg.Physical_Address_New_Phone_Ext__c=phyAddrChg.Physical_Address_New_Phone_Ext__c;
                npiChg.Email_Physical_New__c=phyAddrChg.Email_Physical_New__c;
                npiChg.Fax_Physical_New__c=phyAddrChg.Fax_Physical_New__c;
                npiChg.Primary_Location_Physical__c=phyAddrChg.Primary_Location_Physical__c;
                npiChg.Supervising_Physician__c=phyAddrChg.Supervising_Physician__c;
                npiChg.Effective_Date_of_Change_Physical__c=phyAddrChg.Effective_Date_of_Change_Physical__c;
                npiChg.Open_24__c=phyAddrChg.Open_24__c;      
                npiChg.Comm_Phy__c=phyAddrChg.Comm_Phy__c;
                npiChg.Mon_Open__c=phyAddrChg.Mon_Open__c;
                npiChg.Tue_Open__c=phyAddrChg.Tue_Open__c;
                npiChg.Wed_Open__c=phyAddrChg.Wed_Open__c;
                npiChg.Thu_Open__c=phyAddrChg.Thu_Open__c;
                npiChg.Fri_Open__c=phyAddrChg.Fri_Open__c;
                npiChg.Sat_Open__c=phyAddrChg.Sat_Open__c;
                npiChg.Sun_Open__c=phyAddrChg.Sun_Open__c;
                npiChg.Mon_Close__c=phyAddrChg.Mon_Close__c;
                npiChg.Tue_Close__c=phyAddrChg.Tue_Close__c;
                npiChg.Wed_Close__c=phyAddrChg.Wed_Close__c;
                npiChg.Thu_Close__c=phyAddrChg.Thu_Close__c;
                npiChg.Fri_Close__c=phyAddrChg.Fri_Close__c;
                npiChg.Sat_Close__c=phyAddrChg.Sat_Close__c;
                npiChg.Sun_Close__c=phyAddrChg.Sun_Close__c;  
            }if (BillChgFlg)
            {
                if (CaseMode == 'Change' || CaseMode == 'Delete')
                { 
                    npiChg.Street_Address_Suite_No_Billing_Current__c= billAddrChg.Street_Address_Suite_No_Billing_Current__c;
                    npiChg.Addr_Line_2_Bill_Curr__c= billAddrChg.Addr_Line_2_Bill_Curr__c; 
                    npiChg.City_Billing_Current__c=billAddrChg.City_Billing_Current__c;
                    npiChg.State_Billing_Current__c=billAddrChg.State_Billing_Current__c;
                    npiChg.Zip_Billing_Current__c=billAddrChg.Zip_Billing_Current__c;
                    npiChg.Telephone_Billing_Current__c=billAddrChg.Telephone_Billing_Current__c;
                    npiChg.Email_Billing_Current__c=billAddrChg.Email_Billing_Current__c;
                    npiChg.Fax_Billing_Current__c=billAddrChg.Fax_Billing_Current__c;
                }
                npiChg.Street_Address_Suite_No_Billing_New__c=billAddrChg.Street_Address_Suite_No_Billing_New__c;
                npiChg.Addr_Line_2_Bill_New__c=billAddrChg.Addr_Line_2_Bill_New__c;
                npiChg.City_Billing_New__c=billAddrChg.City_Billing_New__c;
                npiChg.State_Billing_New__c=billAddrChg.State_Billing_New__c;
                npiChg.Zip_Billing_New__c=billAddrChg.Zip_Billing_New__c;
                npiChg.Telephone_Billing_New__c=billAddrChg.Telephone_Billing_New__c;
                npiChg.Billing_Address_New_Phone_Ext__c=billAddrChg.Billing_Address_New_Phone_Ext__c;
                npiChg.Email_Billing_New__c=billAddrChg.Email_Billing_New__c;
                npiChg.Fax_Billing_New__c=billAddrChg.Fax_Billing_New__c;
                npiChg.Effective_Date_of_Change_Billing__c=billAddrChg.Effective_Date_of_Change_Billing__c;
                npiChg.Comments_Billing__c=billAddrChg.Comments_Billing__c;
            }
            
            if (admChgFlg)
            {
                if (CaseMode == 'Change' || CaseMode == 'Delete')
                {
                    npiChg.Street_Address_Administrative_Current__c= admAddrChg.Street_Address_Administrative_Current__c;
                    npiChg.Addr_Line_2_Admin_Curr__c = admAddrChg.Addr_Line_2_Admin_Curr__c;
                    npiChg.City_Administrative_Current__c=admAddrChg.City_Administrative_Current__c;
                    npiChg.State_Administrative_Current__c=admAddrChg.State_Administrative_Current__c;
                    npiChg.Zip_Administrative_Current__c=admAddrChg.Zip_Administrative_Current__c;
                    npiChg.Telephone_Administrative_Current__c=admAddrChg.Telephone_Administrative_Current__c;
                    npiChg.Email_Administrative_Current__c=admAddrChg.Email_Administrative_Current__c;
                    npiChg.Fax_Administrative_Current__c=admAddrChg.Fax_Administrative_Current__c;
                }
                npiChg.Street_Address_Administrative_New__c=admAddrChg.Street_Address_Administrative_New__c;
                npiChg.Addr_Line_2_Admin_New__c= admAddrChg.Addr_Line_2_Admin_New__c;
                npiChg.City_Administrative_New__c=admAddrChg.City_Administrative_New__c;
                npiChg.State_Administrative_New__c=admAddrChg.State_Administrative_New__c;
                npiChg.Zip_Administrative_New__c=admAddrChg.Zip_Administrative_New__c;
                npiChg.Telephone_Administrative_New__c=admAddrChg.Telephone_Administrative_New__c;
                npiChg.Administrative_Change_New_Phone_Ext__c=admAddrChg.Administrative_Change_New_Phone_Ext__c;
                npiChg.Email_Administrative_New__c=admAddrChg.Email_Administrative_New__c;
                npiChg.Fax_Administrative_New__c=admAddrChg.Fax_Administrative_New__c;
                npiChg.Effective_Date_of_Change_Administrative__c=admAddrChg.Effective_Date_of_Change_Administrative__c;
                npiChg.Comments_Administrative__c=admAddrChg.Comments_Administrative__c;
                npiChg.Admin_Cont_Name__c=admAddrChg.Admin_Cont_Name__c;
            }if (specialtyFlg || privilegesFlg || providerIDsFlg || othersFlg)
            {
                npiChg.Comments_Other_Provider__c=otherProv.Comments_Other_Provider__c;
                npiChg.Effective_Date_of_Change_OP__c=otherProv.Effective_Date_of_Change_OP__c;
                if(specialtyFlg)
                {
                    npiChg.Specialty__c=otherProv.Specialty__c;
                    npiChg.Sub_Speciality__c=otherProv.Sub_Speciality__c;
                    npiChg.Specialty_Effective_Date__c=otherProv.Specialty_Effective_Date__c;
                    npiChg.Specialty_Certification_Date__c=otherProv.Specialty_Certification_Date__c;
                    npiChg.Specialty_OP_New__c=otherProv.Specialty_OP_New__c;
                    npiChg.Sub_Specialty_OP_New__c=otherProv.Sub_Specialty_OP_New__c;
                    npiChg.Specialty_E_Date_OP_New__c=otherProv.Specialty_E_Date_OP_New__c;
                    npiChg.Specialty_Cert_Date_OP_New__c=otherProv.Specialty_Cert_Date_OP_New__c;
                    npiChg.Provider_Type_Specialty__c =otherProv.Provider_Type_Specialty__c;
                    npiChg.Supervising_Physician__c =otherProv.Supervising_Physician__c;
                }
                if(privilegesFlg)
                {
                    npiChg.Ambulatory_Surgery_Center_Privileges_li__c=otherProv.Ambulatory_Surgery_Center_Privileges_li__c;
                    npiChg.Ambulatory_Surg_Cnt_OP_New__c=otherProv.Ambulatory_Surg_Cnt_OP_New__c;
                    npiChg.Hospital_Privileges_list_all__c= otherProv.Hospital_Privileges_list_all__c;        
                    npiChg.Hospital_Privileges_OP_New__c=otherProv.Hospital_Privileges_OP_New__c;
                    npiChg.Room_Rate_Type__c=otherProv.Room_Rate_Type__c;
                    npiChg.Room_Rate_Amount__c=otherProv.Room_Rate_Amount__c;
                }
                if(providerIDsFlg)
                {
                    npiChg.DEA__c=otherProv.DEA__c;
                    npiChg.DEA_Expiration_Date__c=otherProv.DEA_Expiration_Date__c;      
                    npiChg.License_OP_Current__c=otherProv.License_OP_Current__c;
                    npiChg.License_OP_New__c=otherProv.License_OP_New__c;
                    npiChg.Medicaid_Number__c=otherProv.Medicaid_Number__c;
                    npiChg.Medicare_Number__c=otherProv.Medicare_Number__c;
                }
                if(othersFlg)
                {
                    npiChg.Board_Certified__c=otherProv.Board_Certified__c;
                    npiChg.Board_Certified_OP_New__c=otherProv.Board_Certified_OP_New__c;
                    npiChg.Board_Certification_Expiration_Year__c=otherProv.Board_Certification_Expiration_Year__c;
                    npiChg.Languages_Spoken_or_Written__c=otherProv.Languages_Spoken_or_Written__c;
                    npiChg.Date_of_Birth__c=otherProv.Date_of_Birth__c;
                    npiChg.Ethnicity__c=otherProv.Ethnicity__c;
                    npiChg.Year_of_Graduation__c=otherProv.Year_of_Graduation__c;
                    npiChg.Residency_Hospital_Name__c=otherProv.Residency_Hospital_Name__c;       
                    npiChg.From__c=otherProv.From__c;
                    npiChg.To__c=otherProv.To__c;
                    npiChg.BackUp__c=otherProv.BackUp__c;
                    npiChg.Medical_School_Name__c=otherProv.Medical_School_Name__c;
                } 
            }if (removeProvFlg)
            {
                npiChg.Individual_Provider_Name__c = removeProv.Individual_Provider_Name__c;
                npiChg.Individual_s_Type_1_NPI__c = removeProv.Individual_s_Type_1_NPI__c;
                npiChg.Other_ID_Eg_Medicaid_API_LTSS_TPI__c = removeProv.Other_ID_Eg_Medicaid_API_LTSS_TPI__c;
                npiChg.Remove_From_All_Locations__c = removeProv.Remove_From_All_Locations__c;     
                npiChg.Reason_For_Leaving_Group_Location__c=removeProv.Reason_For_Leaving_Group_Location__c;
                npiChg.Effective_Date_Of_Termination__c=removeProv.Effective_Date_Of_Termination__c;    
                npiChg.Addr_Line_1_Remove_Provider__c=removeProv.Addr_Line_1_Remove_Provider__c;
                npiChg.Addr_Line_2_Remove_Provider__c=removeProv.Addr_Line_2_Remove_Provider__c;
                npiChg.City_Remove_Provider__c=removeProv.City_Remove_Provider__c;
                npiChg.State_Remove_Provider__c=removeProv.State_Remove_Provider__c;
                npiChg.Zip_Remove_Provider__c=removeProv.Zip_Remove_Provider__c;
                npiChg.Reason_For_Leaving_Group_Location_1__c=removeProv.Reason_For_Leaving_Group_Location_1__c;
                npiChg.Effective_Date_Of_Termination_1__c=removeProv.Effective_Date_Of_Termination_1__c;
                npiChg.Comments_Remove_Provider__c=removeProv.Comments_Remove_Provider__c;
                npiChg.Attestation__c = removeProv.Attestation__c;            
                npiChg.Add_Another_Location_For_Removal__c = removeProv.Add_Another_Location_For_Removal__c; //set value from form into object field
                npiChg.X2nd_Addr_Line_1_Remove_Provider__c=removeProv.X2nd_Addr_Line_1_Remove_Provider__c;
                npiChg.X2nd_Addr_Line_2_Remove_Provider__c=removeProv.X2nd_Addr_Line_2_Remove_Provider__c;
                npiChg.X2nd_City_Remove_Provider__c=removeProv.X2nd_City_Remove_Provider__c;
                npiChg.X2nd_State_Remove_Provider__c=removeProv.X2nd_State_Remove_Provider__c;
                npiChg.X2nd_Zip_Remove_Provider__c=removeProv.X2nd_Zip_Remove_Provider__c;
                npiChg.Reason_For_Leaving_Group_Location_2__c=removeProv.Reason_For_Leaving_Group_Location_2__c;
                npiChg.Effective_Date_Of_Termination_2__c=removeProv.Effective_Date_Of_Termination_2__c;    
            }
            if (addProvFlg)
            {   
                npiChg.Group_Name__c = addProv.Group_Name__c;
                npiChg.Group_Tax_ID__c = addProv.Group_Tax_ID__c;
                npiChg.Group_Provider_Type_Specialty__c = addProv.Group_Provider_Type_Specialty__c;
                npiChg.License_Number__c = addProv.License_Number__c;     
                npiChg.Gender__c=gender;
                npiChg.CAQH_Number__c=addProv.CAQH_Number__c;    
                npiChg.Other_Provider_Number__c=addProv.Other_Provider_Number__c;
                npiChg.Add_Provider_Supervising_Physician__c=addProv.Add_Provider_Supervising_Physician__c;
                npiChg.Networks__c=addProv.Networks__c;
                npiChg.Add_Provider_Accepting_New_Patients__c=addProv.Add_Provider_Accepting_New_Patients__c;
                npiChg.Provider_s_Name__c=addProv.Provider_s_Name__c;
                npiChg.Group_NPI__c=addProv.Group_NPI__c;
                npiChg.Group_PFIN__c=addProv.Group_PFIN__c;
                npiChg.Individual_NPI__c=addProv.Individual_NPI__c;
                npiChg.Add_Provider_Date_Of_Birth__c = addProv.Add_Provider_Date_Of_Birth__c;            
                npiChg.Indivudual_Type_Speciality__c = addProv.Indivudual_Type_Speciality__c;
                npiChg.Comp_Grid_Code_If_applicable__c=addProv.Comp_Grid_Code_If_applicable__c;
                npiChg.Designation_Code_If_applicable__c=addProv.Designation_Code_If_applicable__c;
                npiChg.Supervising_Physician_License__c=addProv.Supervising_Physician_License__c;
                npiChg.Add_Nwk_Eff_Date__c=addProv.Add_Nwk_Eff_Date__c;
                npiChg.Hospital_Affilitation__c=addProv.Hospital_Affilitation__c;
                
                npiChg.Site_Acce__c=addProv.Site_Acce__c;
                npiChg.Office_Reception_Area__c=addProv.Office_Reception_Area__c;
                npiChg.Exam_Room__c=addProv.Exam_Room__c;
                npiChg.Exterior__c=addProv.Exterior__c;
                npiChg.Scale__c=addProv.Scale__c;
                npiChg.Interior_Building__c=addProv.Interior_Building__c;
                npiChg.Parking_Accessbility__c=addProv.Parking_Accessbility__c;
                npiChg.Restroom__c=addProv.Restroom__c;
                npiChg.Exam_Table__c=addProv.Exam_Table__c;
                npiChg.Close_Proximity_to_Public_Transportation__c=addProv.Close_Proximity_to_Public_Transportation__c;
                
                npiChg.Current_Addr_Line_1_add_prov_Phy__c=addProv.Current_Addr_Line_1_add_prov_Phy__c;
                npiChg.Current_Addr_Line_2_add_prov_Phy__c=addProv.Current_Addr_Line_2_add_prov_Phy__c;
                npiChg.Current_City_add_prov_Phy__c=addProv.Current_City_add_prov_Phy__c;
                npiChg.Current_State_add_prov_Phy__c=addProv.Current_State_add_prov_Phy__c;
                npiChg.Current_Zip_add_prov_Phy__c=addProv.Current_Zip_add_prov_Phy__c;
                npiChg.Current_Phone_add_prov_Phy__c=addProv.Current_Phone_add_prov_Phy__c;
                npiChg.Current_Email_add_prov_Phy__c=addProv.Current_Email_add_prov_Phy__c;
                npiChg.Current_Fax_add_prov_Phy__c=addProv.Current_Fax_add_prov_Phy__c;
                npiChg.Accepting_New_Patients_add_prov_Phy__c=addProv.Accepting_New_Patients_add_prov_Phy__c;
                npiChg.New_Addr_Line_1_add_prov_Phy__c=addProv.New_Addr_Line_1_add_prov_Phy__c;
                npiChg.New_Addr_Line_2_add_prov_Phy__c=addProv.New_Addr_Line_2_add_prov_Phy__c;
                npiChg.New_City_add_prov_Phy__c=addProv.New_City_add_prov_Phy__c;
                npiChg.New_State_add_prov_Phy__c=addProv.New_State_add_prov_Phy__c;
                npiChg.New_Zip_add_prov_Phy__c=addProv.New_Zip_add_prov_Phy__c;
                npiChg.New_Phone_add_prov_Phy__c=addProv.New_Phone_add_prov_Phy__c;
                npiChg.Physical_Address_Current_Phone_Ext__c=addProv.Physical_Address_Current_Phone_Ext__c;
                npiChg.New_Email_add_prov_Phy__c=addProv.New_Email_add_prov_Phy__c;
                npiChg.New_Fax_add_prov_Phy__c=addProv.New_Fax_add_prov_Phy__c;
                npiChg.Primary_Location_add_prov_Phy__c=addProv.Primary_Location_add_prov_Phy__c;
                npiChg.Efft_Date_Physical_add_prov_Phy__c=addProv.Efft_Date_Physical_add_prov_Phy__c;
                
                npiChg.Current_Addr_Line_1_add_prov_Bill__c=addProv.Current_Addr_Line_1_add_prov_Bill__c;
                npiChg.Current_Addr_Line_2_add_prov_Bill__c=addProv.Current_Addr_Line_2_add_prov_Bill__c;
                npiChg.Current_City_add_prov_Bill__c=addProv.Current_City_add_prov_Bill__c;
                npiChg.Current_State_add_prov_Bill__c=addProv.Current_State_add_prov_Bill__c;
                npiChg.Current_Zip_add_prov_Bill__c=addProv.Current_Zip_add_prov_Bill__c;
                npiChg.Current_Phone_add_prov_Bill__c=addProv.Current_Phone_add_prov_Bill__c;
                npiChg.Current_Email_add_prov_Bill__c=addProv.Current_Email_add_prov_Bill__c;
                npiChg.Current_Fax_add_prov_Bill__c=addProv.Current_Fax_add_prov_Bill__c;
                npiChg.New_Addr_Line_1_add_prov_Bill__c=addProv.New_Addr_Line_1_add_prov_Bill__c;
                npiChg.New_Addr_Line_2_add_prov_Bill__c=addProv.New_Addr_Line_2_add_prov_Bill__c;
                npiChg.New_City_add_prov_Bill__c=addProv.New_City_add_prov_Bill__c;
                npiChg.New_State_add_prov_Bill__c=addProv.New_State_add_prov_Bill__c;
                npiChg.New_Zip_add_prov_Bill__c=addProv.New_Zip_add_prov_Bill__c;
                npiChg.New_Phone_add_prov_Bill__c=addProv.New_Phone_add_prov_Bill__c;
                npiChg.Billing_Address_Current_Phone_Ext__c=addProv.Billing_Address_Current_Phone_Ext__c;
                npiChg.New_Email_add_prov_Bill__c=addProv.New_Email_add_prov_Bill__c;
                npiChg.New_Fax_add_prov_Bill__c=addProv.New_Fax_add_prov_Bill__c;
                npiChg.Efft_Date_add_prov_Bill__c=addProv.Efft_Date_add_prov_Bill__c;
                npiChg.Comments_add_prov_Bill__c=addProv.Comments_add_prov_Bill__c;
            }
            
            if (addNwkChgFlg || rmNwrkChgFlg || reinPrvChgFlg || termPrvChgFlg)
            {
                npiChg.Term_PFIN_Num__c=networkChg.Term_PFIN_Num__c;
                npiChg.Comp_Grid_Code_If_applicable__c=networkChg.Comp_Grid_Code_If_applicable__c;
                npiChg.Designation_Code_If_applicable__c=networkChg.Designation_Code_If_applicable__c;
                if (addNwkChgFlg)
                {
                    npiChg.Add_PFIN_Num__c = npiChgPfin;
                    npiChg.Add_Nwk_Eff_Date__c=networkChg.Add_Nwk_Eff_Date__c;    
                    npiChg.Add_Nwk_Code__c = addNetwork;     
                }
                if (rmNwrkChgFlg)
                {
                    npiChg.Remove_Nwk_PFIN_Num__c = npiChgPfin; 
                    npiChg.Remove_Nwk_Code__c = removeNwkCode;  
                    npiChg.Remove_Network_Reason__c = removeNwkReason;
                    npiChg.Remove_Nwk_Eff_Date__c = networkChg.Remove_Nwk_Eff_Date__c;     
                }
                if (reinPrvChgFlg)
                {
                    //npiChg.Reinstate_PFIN_Num__c = networkChg.Reinstate_PFIN_Num__c;
                    npiChg.Reinstate_PFIN_Num__c = npiChgPfin;         
                    npiChg.Reinstate_Nwk_Code__c = networkChg.Reinstate_Nwk_Code__c;
                }
                if(termPrvChgFlg)
                {
                    //npiChg.Term_PFIN_Num__c=networkChg.Term_PFIN_Num__c;
                    npiChg.Term_PFIN_Num__c=npiChgPfin;
                    npiChg.Term_Reason__c = termReason;
                    npiChg.Terminate_Prov_Reason_Com__c = networkChg.Terminate_Prov_Reason_Com__c;
                    npiChg.Termin_Nwk_Eff_Date__c = networkChg.Termin_Nwk_Eff_Date__c;  
                }
            }
            npiChg.RecordTypeId = taxIdChangeRecType.id;
            if(parentCase.Id != null){
                npiChg.parentId = parentCase.Id;
            }
            system.debug('444444444444444'+npiChg);
            npiChgCaseForInsert.add( npiChg );
        }
        try{
            
            system.debug('444444444444444'+npiChgCaseForInsert.size());
            if(!npiChgCaseForInsert.isEmpty() )
            {
                System.debug('Before Insert '+npiChgCaseForInsert);
                insert npiChgCaseForInsert;
            }

        }catch (Exception ex){            
            String msg = String.valueOf(ex.getmessage());  
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Case Creation Failed');
            ApexPages.addmessage(myMsg);
            System.debug('What is the error message '+ex.getmessage()); 
        }
    }
    
    public boolean ValidatePhone(String phoneNum){
        if( phoneNum.length()>=2 && phoneNum.substring(0,1).equals('(') && phoneNum.substring(1,2).equals('1')  ) {
            return false;
        } else if(phoneNum.substring(0,1).equals('1')) {
            return false;
        }
        
        for(Integer i=0; i<phoneNum.length(); i++) {
            
            if( (phoneNum.charAt(i)>=65 && phoneNum.charAt(i)<=90) || (phoneNum.charAt(i)>=97 && phoneNum.charAt(i)<=122) ) {
                return false;
            }
            
        }
        String phoneRegex = '\\D*?(\\d\\D*?){10}'; 
        Pattern MyPattern = Pattern.compile(phoneRegex);
        Matcher MyMatcher = MyPattern.matcher(phoneNum); 
        if (!MyMatcher.matches()){
            return false;
        }        
        return true;
    }
    
    public boolean ValidateExtension(String phoneNum){
        String phoneRegex = '[0-9]{1,5}'; 
        Pattern MyPattern = Pattern.compile(phoneRegex);
        Matcher MyMatcher = MyPattern.matcher(phoneNum); 
        if (!MyMatcher.matches()){
            return false;
        }        
        return true;
    }
    
    public Boolean validateEmail(String email) {
        Boolean res = true; 
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#`\'~=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
        if (!MyMatcher.matches()) 
            res = false;         
        return res; 
    }
    
    public void resetFieldVal(){
        statusCheck.CS_Benefits__c = false;        
        statusCheck.CS_Case_Status_Check__c = false;        
        statusCheck.CS_Ecommerce__c = false;        
        statusCheck.CS_Claims__c = false;        
        statusCheck.CS_Contracting__c = false;        
        statusCheck.CS_Credentialing_Status_Check__c = false;        
        statusCheck.CS_Complaints__c = false;        
        statusCheck.CS_Network_Status_Check__c = false;        
        statusCheck.CS_Paper_Payment_Status_Check__c = false;        
        statusCheck.CS_Pre_determination_Check__c = false;        
        statusCheck.CS_Pre_authorization_Check__c = false;         
        statusCheck.CS_Retroactive_Claim_Check__c = false;
        statusCheck.CS_Fee_Schedule__c = false;
        statusCheck.CS_Claims_Project__c = false;
        statusCheck.CS_Retro_Requests__c = false;
        statusCheck.CS_Retro_Requests__c = false;
    }
    public Pagereference redirectPage()
    { 
        
        Integer endcount=10;
        system.debug('overAllPfinList'+overAllPfinList.size());
            if(overAllPfinList !=NULL && overAllPfinList.size()<1000)
            {
                endCount = overallPfinList.size();
            }
            listOfAllPfinsToDisplay = new List<String>();
            for(Integer count=0;count<endCount;count++)
            {
                listOfAllPfinsToDisplay.add(overAllPfinList[count]);
            }
            system.debug('listOfAllPfinsToDisplay'+listOfAllPfinsToDisplay.size());
            mccPageNumber=0;
            totalMccPageNumber = listOfAllPfinsToDisplay.size()/10;
            if(math.mod(listOfAllPfinsToDisplay.size(),10)>0)
            {
            totalMccPageNumber = totalMccPageNumber +1;
            }
            
        if (caseMode == 'Add'){
            if((isAdmin == false ) && (admChgFlg == true)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select administrative address in PFIN selection page to move forward');
                ApexPages.addmessage(myMsg);   
                return null;
            }
            else if((isBilling == false ) && (billChgFlg == true)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select billing address in PFIN selection page to move forward');
                ApexPages.addmessage(myMsg);   
                return null;
            }
            else if((isServiceLocation == false ) && (phyChgFlg == true)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select service location address in PFIN selection page to move forward');
                ApexPages.addmessage(myMsg);   
                return null;
            }
             // R4_Changes_PPN-17108 Start
             Integer OverAllPfincount =overAllPfinList.size();
        
            if(selectAllNonBillPfinsChecked  == true && specialtyFlg == true){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Specialty is an invalid selection while applying changes to all non-bill PFINs');
                ApexPages.addmessage(myMsg);   
                return null;
            }           
            
            // R4_Changes_PPN-17108
            if (billChgFlg || phyChgFlg ||  addProvFlg || admChgFlg || addNwkChgFlg || specialtyFlg)
            {
                nameChgFlg = false;
                npiChgFlg = false;
                removeProvFlg = false;
                rmNwrkChgFlg = false;
                termPrvChgFlg = false;
                privilegesFlg = false;
                providerIDsFlg = false;
                othersFlg = false;
                reinPrvChgFlg = false;
                benfChgFlg = false;
                caseCheckChgFlg = false;
                claimCheckChgFlg = false;
                contractCheckFlg = false;
                credCheckChgFlg = false;
                compCheckFlg = false;
                statusCheckFlg = false;
                netwrkCheckFlg = false;
                paperCheckFlg = false;
                preDeterCheckFlg = false;
                preAuthCheckFlg = false;
                retroCheckFlg = false;
                feeScheduleFlg = false;
                ClaimsProjectFlg = false;
                rosterCheckFlg = false;
                retroReqCheckFlg = false;
                eftCheckFlg = false;
                
                fetchAddressDetails();  
                /*
                * PPN-5342, AC #5
                * 5. Under Add Network section, the network code should display all the network codes in the Plan ID, excluding Networks in which the PFIN is already existing.
                */  
                AllExceptNetworksByPFINList =  createSelectOptionsFromList( allNetworksExceptUsedByPFIN( overAllPfinList, planId,CaseMode,selPFIN ), false );
                system.debug('here 1');
                System.debug(planId+'AllExceptNetworksByPFINList 111 ===>>>'+AllExceptNetworksByPFINList);
                return (new PageReference('/apex/DynamicRequestTypePage').setRedirect(false)); 
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one Request Category');
                ApexPages.addmessage(myMsg);   
                return null;
            }  
        }      
        if (caseMode == 'Change'){
            if((isAdmin == false ) && (admChgFlg == true)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select administrative address in PFIN selection page to move forward');
                ApexPages.addmessage(myMsg);   
                return null;
            }
            else if((isBilling == false ) && (billChgFlg == true)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select billing address in PFIN selection page to move forward');
                ApexPages.addmessage(myMsg);   
                return null;
            }
            else if((isServiceLocation == false ) && (phyChgFlg == true)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select service location address in PFIN selection page to move forward');
                ApexPages.addmessage(myMsg);   
                return null;
            }
              //R4_Changes_PPN-17108 Start
            Integer OverAllPfincount =overAllPfinList.size();
        
                if(selectAllNonBillPfinsChecked  == true && specialtyFlg == true){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Specialty is an invalid selection while applying changes to all non-bill PFINs');
                    ApexPages.addmessage(myMsg);   
                    return null;
                }           
            //R4_Changes_PPN-17108 Ends
            
            if (nameChgFlg || npiChgFlg || billChgFlg || phyChgFlg || admChgFlg || specialtyFlg || privilegesFlg || providerIDsFlg || othersFlg || reinPrvChgFlg ){  
                resetFieldVal();
                removeProvFlg = false;
                addNwkChgFlg = false;
                rmNwrkChgFlg = false;
                termPrvChgFlg = false;
                addProvFlg = false; 
                system.debug('phyChgFlg '+phyChgFlg ); 
                fetchAddressDetails();             
                AllExceptNetworksByPFINList =  createSelectOptionsFromList(allNetworksExceptUsedByPFIN( overAllPfinList, planId,CaseMode,selPFIN ), false);
                System.debug(AllExceptNetworksByPFINList+'AllExceptNetworksByPFINList===>>>222');
                system.debug('here 2');
                return Page.DynamicRequestTypePage; 
                
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one Request Category');
                ApexPages.addmessage(myMsg);   
                return null;
            }
        }
        if (caseMode == 'Delete') {
            if((isAdmin == false ) && (admChgFlg == true)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select administrative address in PFIN selection page to move forward');
                ApexPages.addmessage(myMsg);   
                return null;
            }
            else if((isServiceLocation == false ) && (phyChgFlg == true)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select service location address in PFIN selection page to move forward');
                ApexPages.addmessage(myMsg);   
                return null;
            }
            if (phyChgFlg || admChgFlg || removeProvFlg || rmNwrkChgFlg || termPrvChgFlg){
                nameChgFlg = false;
                npiChgFlg = false;
                specialtyFlg = false;
                privilegesFlg = false;
                providerIDsFlg = false;
                othersFlg = false; 
                addProvFlg = false;   
                billChgFlg = false;
                addNwkChgFlg = false;
                reinPrvChgFlg = false;
                /* --was-- crdChgFlg = false; */
                benfChgFlg = false;
                caseCheckChgFlg = false;
                claimCheckChgFlg = false;
                contractCheckFlg = false;
                credCheckChgFlg = false;
                compCheckFlg = false;
                statusCheckFlg = false;
                netwrkCheckFlg = false;
                paperCheckFlg = false;
                preDeterCheckFlg = false;
                preAuthCheckFlg = false;
                retroCheckFlg = false;
                feeScheduleFlg = false;
                ClaimsProjectFlg = false;
                rosterCheckFlg = false;
                retroReqCheckFlg = false; 
                eftCheckFlg = false;
                AllExceptNetworksByPFINList =  createSelectOptionsFromList(allNetworksExceptUsedByPFIN( overAllPfinList, planId,CaseMode,selPFIN ), false);
                System.debug('AllExceptNetworksByPFINList===>>>'+AllExceptNetworksByPFINList);
                system.debug('here 3');
                fetchAddressDetails();
                
                /*
                * PPN-5342, AC #3 & #8
                *3. Under Remove Network section, the network code should display all 
                the network codes related to the selected PFIN.
                8. Remove Network Reasons should be displayed per Plan ID.
                */                                     
                NetworksByPFINList = createSelectOptionsFromList(networkDescriptionsFromCodes(selPfin, planId), false);
                RemoveNetworkReasons = createSelectOptionsFromList(allRemoveNetworkReasons(planId), false);                                    
                
                return Page.DynamicRequestTypePage; 
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one Request Category');
                ApexPages.addmessage(myMsg);   
                return null;
            }  
        }      
        
        return null;
    }
    
    
    /* PPN- 14375 , PPN-14557 starts*/
    public Pagereference SaveInfo()
    {
        
        Set<String> finalPfins = new Set<String>();
        List<Case> listOfChildCases = new List<Case>(); 
        system.debug('### Inside Save ###' + listOfChildCases);               
            
        if(!Validate()){
            SetCaseAccVal();
        }else if (Validate()){
            return null;
        }
        system.debug('### Inside Save After ###');
        /*************************************************************
        * Below code added as part of PPN-14332,PPN-23432
        * Code to find whether user selected only bilpfin or bilPfin with 
        * all non bill pfins or bilPfin with selected non bill pfins
        *************************************************************/
        finalPfins  = getFinalPfins( acctId , selPFIN, overAllPfinList );
       
        if (npiChgFlg){
            system.debug(finalPfins +'finalPfins');
            npiChange(finalPfins);
        }else{
            if (nameChgFlg){                 
                
                RecordType nameChangeRecType        =   [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE and DeveloperName = :CaseUtil.REC_TYP_NM_CHG];    
                List<Case> nameChgCaseForInsert     =   new List<Case>();
                for( String nameChgPfin :  finalPfins )
                {
                    Case nameCh = new Case();
                    if (sObjName.endsWithIgnoreCase('Account')){
                        nameCh.Origin =accOrigin;
                        nameCh.ParentId = parentCase.Id;
                        if (actList.IsPersonAccount)
                            nameCh.AccountId = acctId;
                        else
                            nameCh.Case_Entity__c = acctId;
                        
                    }
                    if (sObjName.endsWithIgnoreCase('Case')) {                     
                        if (caseInfo.AccountId!=null){
                            nameCh.AccountId =caseInfo.AccountId; 
                        }else if (caseInfo.Case_Entity__c!=null){
                            nameCh.Case_Entity__c =caseInfo.Case_Entity__c; 
                        }
                        nameCh.ParentId = parentId;
                        nameCh.Origin = caseOrigin;
                    }
                    nameCh.MC_PFIN__c   =   nameChgPfin;
                    if (CaseMode == 'Add'){
                        nameCh.MC_Add__c = true;           
                    }
                    if (CaseMode == 'Change'){
                        nameCh.MC_Change__c = true;           
                    }
                    if (CaseMode == 'Delete'){
                        nameCh.MC_Delete__c = true;           
                    }
                    
                    nameCh.Status = caseInfo.Status;
                    nameCh.Priority = caseInfo.Priority;             
                    nameCh.Plan_ID__c = planId;               
                    nameCh.Govt_Programs__c = caseInfo.Govt_Programs__c;
                    nameCh.Completing_the_form_for__c = typeOfProv;
                    nameCh.Corporate_Received_Date_Time__c = CaseInfo.Corporate_Received_Date_Time__c;
                    nameCh.Name_Submitter__c = CaseInfo.Name_Submitter__c; 
                    nameCh.Title_Submitter__c = CaseInfo.Title_Submitter__c;  
                    nameCh.Telephone_Number_Submitter__c = CaseInfo.Telephone_Number_Submitter__c; 
                    nameCh.Submitter_Phone_Ext__c = CaseInfo.Submitter_Phone_Ext__c; 
                    nameCh.Email_Address_Submitter__c = CaseInfo.Email_Address_Submitter__c;  
                    nameCh.Name_of_Provider_Group__c = caseInfo.Name_of_Provider_Group__c;
                    nameCh.Tax_ID_Number__c = caseInfo.Tax_ID_Number__c;
                    nameCh.Rendering_NPI__c = renderNPI;
                    nameCh.Billing_NPI_Number__c = BillNPI;  
                    nameCh.Bill_NPI_Type__c = billNpiType;  
                    nameCh.Original_Creation_Date__c=System.now();  
                    nameCh.Suffix_Current__c = suffixCur;
                    nameCh.Suffix_New__c = suffixNew;
                    nameCh.RecordTypeId = nameChangeRecType.Id; 
                    
                    /* US-14375*/                   
                    nameCh.First_Name_Current__c= nameChg.First_Name_Current__c;
                    nameCh.Last_Name_Current__c= nameChg.Last_Name_Current__c;
                    nameCh.Middle_Initial_Current__c=nameChg.Middle_Initial_Current__c;
                    nameCh.Title_Current__c=nameChg.Title_Current__c;
                    nameCh.Current_Practice_Name__c=nameChg.Current_Practice_Name__c;
                    nameCh.MC_Current_Group_Name__c = nameChg.MC_Current_Group_Name__c;                   
                    nameCh.First_Name_New__c= nameChg.First_Name_New__c;
                    nameCh.Last_Name_New__c=  nameChg.Last_Name_New__c;
                    nameCh.Middle_Initial_New__c=nameChg.Middle_Initial_New__c;
                    nameCh.Title_New__c= nameChg.Title_New__c;
                    nameCh.New_Practice_Name__c=nameChg.New_Practice_Name__c;
                    nameCh.MC_New_Group_Name__c = nameChg.MC_New_Group_Name__c;
                    nameCh.Effective_Date_of_Change_Name__c=nameChg.Effective_Date_of_Change_Name__c;
                    nameCh.Comments_Name_Change__c=nameChg.Comments_Name_Change__c;
                    
                    nameChgCaseForInsert.add( nameCh );
                }
                try{
                    if(!nameChgCaseForInsert.isEmpty() )
                    {
                        listOfChildCases.addAll(nameChgCaseForInsert);
                    }
                }catch (Exception ex){            
                    String msg = String.valueOf(ex.getmessage());  
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Case Creation Failed');
                    ApexPages.addmessage(myMsg);
                }
                
            }
            
            
            if (billChgFlg)
            {
                List<Case> billChgCasesForInsert = new List<Case>();
                RecordType bAddrChangeRecType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE and DeveloperName = :CaseUtil.REC_TYP_BILL_ADD_CHG];
                for( String billChngPfin : finalPfins )
                {
                    Case billAddrChg1 = new Case();
                    if (sObjName.endsWithIgnoreCase('Account')){
                        billAddrChg1.Origin =accOrigin;
                        billAddrChg1.ParentId = parentCase.Id;
                        if (actList.IsPersonAccount)
                            billAddrChg1.AccountId = acctId;
                        else
                            billAddrChg1.Case_Entity__c = acctId;
                        
                    }
                    if (sObjName.endsWithIgnoreCase('Case')) {                     
                        if (caseInfo.AccountId!=null){
                            billAddrChg1.AccountId =caseInfo.AccountId; 
                        }else if (caseInfo.Case_Entity__c!=null){
                            billAddrChg1.Case_Entity__c =caseInfo.Case_Entity__c; 
                        }
                        billAddrChg1.ParentId = parentId;
                        billAddrChg1.Origin = caseOrigin;
                    }
                    
                    
                    billAddrChg1.MC_PFIN__c = billChngPfin;
                    if (CaseMode == 'Add'){
                        billAddrChg1.MC_Add__c = true;           
                    }
                    if (CaseMode == 'Change'){
                        billAddrChg1.MC_Change__c = true;           
                    }
                    if (CaseMode == 'Delete'){
                        billAddrChg1.MC_Delete__c = true;           
                    }
                    
                    billAddrChg1.Status = caseInfo.Status;
                    billAddrChg1.Priority = caseInfo.Priority;
                    billAddrChg1.Plan_ID__c = planId;       
                    billAddrChg1.Govt_Programs__c = caseInfo.Govt_Programs__c;
                    billAddrChg1.Completing_the_form_for__c = typeOfProv; 
                    billAddrChg1.Corporate_Received_Date_Time__c = CaseInfo.Corporate_Received_Date_Time__c;
                    billAddrChg1.Name_Submitter__c = CaseInfo.Name_Submitter__c; 
                    billAddrChg1.Title_Submitter__c = CaseInfo.Title_Submitter__c;  
                    billAddrChg1.Telephone_Number_Submitter__c = CaseInfo.Telephone_Number_Submitter__c;  
                    billAddrChg1.Submitter_Phone_Ext__c = CaseInfo.Submitter_Phone_Ext__c;  
                    billAddrChg1.Email_Address_Submitter__c = CaseInfo.Email_Address_Submitter__c;  
                    billAddrChg1.Name_of_Provider_Group__c = caseInfo.Name_of_Provider_Group__c;
                    billAddrChg1.Tax_ID_Number__c = caseInfo.Tax_ID_Number__c;
                    billAddrChg1.Rendering_NPI__c = renderNPI;
                    billAddrChg1.Billing_NPI_Number__c = billNPI;  
                    billAddrChg1.Bill_NPI_Type__c = billNpiType;  
                    billAddrChg1.Original_Creation_Date__c=System.now();  
                    billAddrChg1.RecordTypeId = bAddrChangeRecType.Id;
                    /* US-14375 */
                    
                    billAddrChg1.Street_Address_Suite_No_Billing_Current__c= billAddrChg.Street_Address_Suite_No_Billing_Current__c;
                    billAddrChg1.Addr_Line_2_Bill_Curr__c= billAddrChg.Addr_Line_2_Bill_Curr__c; 
                    billAddrChg1.City_Billing_Current__c=billAddrChg.City_Billing_Current__c;
                    billAddrChg1.State_Billing_Current__c=billAddrChg.State_Billing_Current__c;
                    billAddrChg1.Zip_Billing_Current__c=billAddrChg.Zip_Billing_Current__c;
                    billAddrChg1.Telephone_Billing_Current__c=billAddrChg.Telephone_Billing_Current__c;
                    billAddrChg1.Email_Billing_Current__c=billAddrChg.Email_Billing_Current__c;
                    billAddrChg1.Fax_Billing_Current__c=billAddrChg.Fax_Billing_Current__c;
                    
                    billAddrChg1.Street_Address_Suite_No_Billing_New__c=billAddrChg.Street_Address_Suite_No_Billing_New__c;
                    billAddrChg1.Addr_Line_2_Bill_New__c=billAddrChg.Addr_Line_2_Bill_New__c;
                    billAddrChg1.City_Billing_New__c=billAddrChg.City_Billing_New__c;
                    billAddrChg1.State_Billing_New__c=billAddrChg.State_Billing_New__c;
                    billAddrChg1.Zip_Billing_New__c=billAddrChg.Zip_Billing_New__c;
                    billAddrChg1.Telephone_Billing_New__c=billAddrChg.Telephone_Billing_New__c;
                    billAddrChg1.Billing_Address_New_Phone_Ext__c=billAddrChg.Billing_Address_New_Phone_Ext__c;
                    billAddrChg1.Email_Billing_New__c=billAddrChg.Email_Billing_New__c;
                    billAddrChg1.Fax_Billing_New__c=billAddrChg.Fax_Billing_New__c;
                    billAddrChg1.Effective_Date_of_Change_Billing__c=billAddrChg.Effective_Date_of_Change_Billing__c;
                    billAddrChg1.Comments_Billing__c=billAddrChg.Comments_Billing__c;
                    billChgCasesForInsert.add( billAddrChg1 );
                }
                try{
                    if( !billChgCasesForInsert.isEmpty() ){
                        listOfChildCases.addAll(billChgCasesForInsert);
                    }
                }catch (Exception ex){            
                    String msg = String.valueOf(ex.getmessage());  
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Case Creation Failed');
                    ApexPages.addmessage(myMsg);
                    
                }
                
            }
            
            if (phyChgFlg){
                List<Case> phyChgCasesForInsert = new List<Case>();
                RecordType pAddrChangeRecType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE and DeveloperName = :CaseUtil.REC_TYP_PHY_ADD_CHG];
                for( String phyChngPfin : finalPfins )
                {
                    Case phyAddrChg1 = new Case();
                    if (sObjName.endsWithIgnoreCase('Account')){
                        phyAddrChg1.Origin =accOrigin;
                        phyAddrChg1.ParentId = parentCase.Id;
                        if (actList.IsPersonAccount)
                            phyAddrChg1.AccountId = acctId;
                        else
                            phyAddrChg1.Case_Entity__c = acctId;
                        
                    }
                    if (sObjName.endsWithIgnoreCase('Case')) {                     
                        if (caseInfo.AccountId!=null){
                            phyAddrChg1.AccountId =caseInfo.AccountId; 
                        }else if (caseInfo.Case_Entity__c!=null){
                            phyAddrChg1.Case_Entity__c =caseInfo.Case_Entity__c; 
                        }
                        phyAddrChg1.ParentId = parentId;
                        phyAddrChg1.Origin = caseOrigin;
                    }
                    phyAddrChg1.MC_PFIN__c = phyChngPfin;
                    if (CaseMode == 'Add'){
                        phyAddrChg1.MC_Add__c = true;           
                    }
                    if (CaseMode == 'Change'){
                        phyAddrChg1.MC_Change__c = true;           
                    }
                    if (CaseMode == 'Delete'){
                        phyAddrChg1.MC_Delete__c = true;           
                    }
                    phyAddrChg1.Status = caseInfo.Status;
                    phyAddrChg1.Priority = caseInfo.Priority;
                    phyAddrChg1.Plan_ID__c = planId;
                    phyAddrChg1.Govt_Programs__c = caseInfo.Govt_Programs__c;
                    phyAddrChg1.Completing_the_form_for__c = typeOfProv;
                    phyAddrChg1.Corporate_Received_Date_Time__c = CaseInfo.Corporate_Received_Date_Time__c;
                    phyAddrChg1.Name_Submitter__c = CaseInfo.Name_Submitter__c; 
                    phyAddrChg1.Title_Submitter__c = CaseInfo.Title_Submitter__c;  
                    phyAddrChg1.Telephone_Number_Submitter__c = CaseInfo.Telephone_Number_Submitter__c;  
                    phyAddrChg1.Submitter_Phone_Ext__c = CaseInfo.Submitter_Phone_Ext__c;  
                    phyAddrChg1.Email_Address_Submitter__c = CaseInfo.Email_Address_Submitter__c;  
                    phyAddrChg1.Name_of_Provider_Group__c = caseInfo.Name_of_Provider_Group__c;
                    phyAddrChg1.Tax_ID_Number__c = caseInfo.Tax_ID_Number__c;
                    phyAddrChg1.Rendering_NPI__c = renderNPI;
                    phyAddrChg1.Billing_NPI_Number__c = billNPI;  
                    phyAddrChg1.Bill_NPI_Type__c = billNpiType;  
                    phyAddrChg1.Original_Creation_Date__c=System.now();  
                    phyAddrChg1.RecordTypeId = pAddrChangeRecType.Id;
                    phyAddrChg1.Accepting_New_Patients__c = phyNewPat;
                    /* US-14375 */
                    
                    phyAddrChg1.Street_Address_Suite_No_Physical_current__c= phyAddrChg.Street_Address_Suite_No_Physical_current__c;
                    phyAddrChg1.Addr_Line_2_Phy_Curr__c=phyAddrChg.Addr_Line_2_Phy_Curr__c;
                    phyAddrChg1.City_Physical_Current__c=phyAddrChg.City_Physical_Current__c;
                    phyAddrChg1.State_Physical_Current__c=phyAddrChg.State_Physical_Current__c;
                    phyAddrChg1.Zip_Physical_Current__c=phyAddrChg.Zip_Physical_Current__c;
                    phyAddrChg1.Telephone_Physical_Current__c=phyAddrChg.Telephone_Physical_Current__c;
                    phyAddrChg1.Email_Physical_Current__c=phyAddrChg.Email_Physical_Current__c;
                    phyAddrChg1.Fax_Physical_Current__c=phyAddrChg.Fax_Physical_Current__c; 
                    phyAddrChg1.Accepting_New_Patients__c=phyNewPat;
                    phyAddrChg1.Street_Address_Suite_No_Physical_New__c=phyAddrChg.Street_Address_Suite_No_Physical_New__c;
                    phyAddrChg1.Addr_Line_2_Phy_New__c=phyAddrChg.Addr_Line_2_Phy_New__c;
                    phyAddrChg1.City_Physical_New__c=phyAddrChg.City_Physical_New__c;
                    phyAddrChg1.State_Physical_New__c=phyAddrChg.State_Physical_New__c;
                    phyAddrChg1.Zip_Physical_New__c=phyAddrChg.Zip_Physical_New__c;
                    phyAddrChg1.Telephone_Physical_New__c=phyAddrChg.Telephone_Physical_New__c;
                    phyAddrChg1.Physical_Address_New_Phone_Ext__c=phyAddrChg.Physical_Address_New_Phone_Ext__c;
                    phyAddrChg1.Email_Physical_New__c=phyAddrChg.Email_Physical_New__c;
                    phyAddrChg1.Fax_Physical_New__c=phyAddrChg.Fax_Physical_New__c;
                    phyAddrChg1.Primary_Location_Physical__c=phyAddrChg.Primary_Location_Physical__c;
                    phyAddrChg1.Supervising_Physician__c=phyAddrChg.Supervising_Physician__c;
                    phyAddrChg1.Effective_Date_of_Change_Physical__c=phyAddrChg.Effective_Date_of_Change_Physical__c;
                    phyAddrChg1.HoursOfOperation__c = curHrs;
                    phyAddrChg1.Comm_Phy__c = phyAddrChg.Comm_Phy__c;
                    phyAddrChg1.Open_24__c=phyAddrChg.Open_24__c;      
                    phyAddrChg1.Comm_Phy__c=phyAddrChg.Comm_Phy__c;
                    phyAddrChg1.Mon_Open__c=phyAddrChg.Mon_Open__c;
                    phyAddrChg1.Tue_Open__c=phyAddrChg.Tue_Open__c;
                    phyAddrChg1.Wed_Open__c=phyAddrChg.Wed_Open__c;
                    phyAddrChg1.Thu_Open__c=phyAddrChg.Thu_Open__c;
                    phyAddrChg1.Fri_Open__c=phyAddrChg.Fri_Open__c;
                    phyAddrChg1.Sat_Open__c=phyAddrChg.Sat_Open__c;
                    phyAddrChg1.Sun_Open__c=phyAddrChg.Sun_Open__c;
                    phyAddrChg1.Mon_Close__c=phyAddrChg.Mon_Close__c;
                    phyAddrChg1.Tue_Close__c=phyAddrChg.Tue_Close__c;
                    phyAddrChg1.Wed_Close__c=phyAddrChg.Wed_Close__c;
                    phyAddrChg1.Thu_Close__c=phyAddrChg.Thu_Close__c;
                    phyAddrChg1.Fri_Close__c=phyAddrChg.Fri_Close__c;
                    phyAddrChg1.Sat_Close__c=phyAddrChg.Sat_Close__c;
                    phyAddrChg1.Sun_Close__c=phyAddrChg.Sun_Close__c;
                    
                    
                    phyChgCasesForInsert.add(phyAddrChg1);
                }
                try{
                    if( !phyChgCasesForInsert.isEmpty() ){
                    listOfChildCases.addAll(phyChgCasesForInsert);
                    }
                    
                }catch (Exception ex){          
                    String msg = String.valueOf(ex.getmessage());  
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Case Creation Failed');
                    ApexPages.addmessage(myMsg);
                    
                }
                
            }  
                      
            if (admChgFlg) { 
                RecordType aAddrChangeRecType   =   [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE and DeveloperName =:CaseUtil.REC_TYP_ADMIN_CHG];
                List<Case> admChgCasesForInsert =   new List<Case>();
                for( String admChgPfin : finalPfins )
                {
                    Case admAddrChg1 = new Case();
                    if (sObjName.endsWithIgnoreCase('Account')){
                        admAddrChg1.Origin =accOrigin;
                        admAddrChg1.ParentId = parentCase.Id;
                        if (actList.IsPersonAccount)
                            admAddrChg1.AccountId = acctId;
                        else
                            admAddrChg1.Case_Entity__c = acctId;
                        
                    }
                    if (sObjName.endsWithIgnoreCase('Case')) {                     
                        if (caseInfo.AccountId!=null){
                            admAddrChg1.AccountId =caseInfo.AccountId; 
                        }else if (caseInfo.Case_Entity__c!=null){
                            admAddrChg1.Case_Entity__c =caseInfo.Case_Entity__c; 
                        }
                        admAddrChg1.ParentId = parentId;
                        admAddrChg1.Origin = caseOrigin;
                    }
                    
                    admAddrChg1.MC_PFIN__c = admChgPfin;
                    if (CaseMode == 'Add'){
                        admAddrChg1.MC_Add__c = true;           
                    }
                    if (CaseMode == 'Change'){
                        admAddrChg1.MC_Change__c = true;           
                    }
                    if (CaseMode == 'Delete'){
                        admAddrChg1.MC_Delete__c = true;           
                    }
                    admAddrChg1.Status = caseInfo.Status;
                    admAddrChg1.Priority = caseInfo.Priority;
                    admAddrChg1.Plan_ID__c = planId;     
                    admAddrChg1.Govt_Programs__c = caseInfo.Govt_Programs__c;
                    admAddrChg1.Completing_the_form_for__c = CaseInfo.Completing_the_form_for__c;
                    admAddrChg1.Corporate_Received_Date_Time__c = CaseInfo.Corporate_Received_Date_Time__c;
                    admAddrChg1.Name_Submitter__c = CaseInfo.Name_Submitter__c; 
                    admAddrChg1.Title_Submitter__c = CaseInfo.Title_Submitter__c;  
                    admAddrChg1.Telephone_Number_Submitter__c = CaseInfo.Telephone_Number_Submitter__c;  
                    admAddrChg1.Submitter_Phone_Ext__c = CaseInfo.Submitter_Phone_Ext__c;  
                    admAddrChg1.Email_Address_Submitter__c = CaseInfo.Email_Address_Submitter__c;  
                    admAddrChg1.Name_of_Provider_Group__c = caseInfo.Name_of_Provider_Group__c;
                    admAddrChg1.Tax_ID_Number__c = caseInfo.Tax_ID_Number__c;
                    admAddrChg1.Rendering_NPI__c = renderNPI;
                    admAddrChg1.Billing_NPI_Number__c = billNPI;  
                    admAddrChg1.Bill_NPI_Type__c = billNpiType;  
                    admAddrChg1.Original_Creation_Date__c=System.now();  
                    admAddrChg1.RecordTypeId = aAddrChangeRecType.Id;
                    /* US-14375 */
                    admAddrChg1.Street_Address_Administrative_Current__c= admAddrChg.Street_Address_Administrative_Current__c;
                    admAddrChg1.Addr_Line_2_Admin_Curr__c = admAddrChg.Addr_Line_2_Admin_Curr__c;
                    admAddrChg1.City_Administrative_Current__c=admAddrChg.City_Administrative_Current__c;
                    admAddrChg1.State_Administrative_Current__c=admAddrChg.State_Administrative_Current__c;
                    admAddrChg1.Zip_Administrative_Current__c=admAddrChg.Zip_Administrative_Current__c;
                    admAddrChg1.Telephone_Administrative_Current__c=admAddrChg.Telephone_Administrative_Current__c;
                    admAddrChg1.Email_Administrative_Current__c=admAddrChg.Email_Administrative_Current__c;
                    admAddrChg1.Fax_Administrative_Current__c=admAddrChg.Fax_Administrative_Current__c;
                    
                    admAddrChg1.Street_Address_Administrative_New__c=admAddrChg.Street_Address_Administrative_New__c;
                    admAddrChg1.Addr_Line_2_Admin_New__c= admAddrChg.Addr_Line_2_Admin_New__c;
                    admAddrChg1.City_Administrative_New__c=admAddrChg.City_Administrative_New__c;
                    admAddrChg1.State_Administrative_New__c=admAddrChg.State_Administrative_New__c;
                    admAddrChg1.Zip_Administrative_New__c=admAddrChg.Zip_Administrative_New__c;
                    admAddrChg1.Telephone_Administrative_New__c=admAddrChg.Telephone_Administrative_New__c;
                    admAddrChg1.Administrative_Change_New_Phone_Ext__c=admAddrChg.Administrative_Change_New_Phone_Ext__c;
                    admAddrChg1.Email_Administrative_New__c=admAddrChg.Email_Administrative_New__c;
                    admAddrChg1.Fax_Administrative_New__c=admAddrChg.Fax_Administrative_New__c;
                    admAddrChg1.Effective_Date_of_Change_Administrative__c=admAddrChg.Effective_Date_of_Change_Administrative__c;
                    admAddrChg1.Comments_Administrative__c=admAddrChg.Comments_Administrative__c;
                    admAddrChg1.Admin_Cont_Name__c=admAddrChg.Admin_Cont_Name__c;
                    
                    admChgCasesForInsert.add( admAddrChg1 );
                }
                try{
                    if( !admChgCasesForInsert.isEmpty() ){
                    listOfChildCases.addAll(admChgCasesForInsert);
                    }
                    
                }catch (Exception ex){            
                    String msg = String.valueOf(ex.getmessage());  
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Case Creation Failed');
                    ApexPages.addmessage(myMsg);
                    
                } 
            } 
            if (specialtyFlg || privilegesFlg || providerIDsFlg || othersFlg ) 
            { 
                System.debug('<<<<<============ Inside other provider updates =============>>>>>>>> ');
                System.debug(specialtyFlg+'specialtyFlg====>>>>'+privilegesFlg+'privilegesFlg====>>>>'+providerIDsFlg+'providerIDsFlg====>>>>'+othersFlg+'othersFlg====>>>');
                List<Case> otherProvCasesforInsert  =   new List<Case>();
                RecordType aAddrChangeRecType       =   [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE  and DeveloperName =:CaseUtil.REC_TYP_OTHER_CHG];
                System.debug('####### caseInfo.AccountId #######' + caseInfo.AccountId);
                System.debug('####### ParentId#######' + parentCase.Id);
                
                for( String otherProvPfin : finalPfins )
                {
                   //PPN-23373
                    Case otherProvCase = new Case();
                    // Begin PPN-23908
                    if (sObjName.endsWithIgnoreCase('Account')) {
                        if (actList.IsPersonAccount) {
                            otherProvCase.AccountId = acctId;
                        } else {
                            otherProvCase.Case_Entity__c = acctId;
                        }
                        otherProvCase.Origin    = accOrigin;
                        otherProvCase.ParentId  = parentCase.Id;
                    }
                    if (sObjName.endsWithIgnoreCase('Case')) {                     
                        if (caseInfo.AccountId!=null){
                            otherProvCase.AccountId = caseInfo.AccountId; 
                        }else if (caseInfo.Case_Entity__c!=null){
                            otherProvCase.Case_Entity__c = caseInfo.Case_Entity__c; 
                        }
                        otherProvCase.ParentId  = parentId;
                        otherProvCase.Origin    = caseOrigin;
                    }
                    // End PPN-23908
                    
                    otherProvCase.MC_PFIN__c = otherProvPfin;
                    if (CaseMode == 'Add'){
                        otherProvCase.MC_Add__c = true;           
                    }
                    if (CaseMode == 'Change'){
                        otherProvCase.MC_Change__c = true;           
                    }
                    if (CaseMode == 'Delete'){
                        otherProvCase.MC_Delete__c = true;           
                    }
                    system.debug('caseInfo====>>>>'+caseInfo);
                    otherProvCase.Status = caseInfo.Status;
                    otherProvCase.Priority = caseInfo.Priority;
                    otherProvCase.Plan_ID__c = planId;    
                    otherProvCase.Govt_Programs__c = caseInfo.Govt_Programs__c;
                    otherProvCase.Completing_the_form_for__c = CaseInfo.Completing_the_form_for__c;   
                    otherProvCase.Corporate_Received_Date_Time__c = CaseInfo.Corporate_Received_Date_Time__c;
                    otherProvCase.Name_Submitter__c = CaseInfo.Name_Submitter__c; 
                    otherProvCase.Title_Submitter__c = CaseInfo.Title_Submitter__c;  
                    otherProvCase.Telephone_Number_Submitter__c = CaseInfo.Telephone_Number_Submitter__c;  
                    otherProvCase.Submitter_Phone_Ext__c = CaseInfo.Submitter_Phone_Ext__c;  
                    otherProvCase.Email_Address_Submitter__c = CaseInfo.Email_Address_Submitter__c;  
                    otherProvCase.Name_of_Provider_Group__c = caseInfo.Name_of_Provider_Group__c;
                    otherProvCase.Tax_ID_Number__c = caseInfo.Tax_ID_Number__c;
                    otherProvCase.Rendering_NPI__c = renderNPI;
                    otherProvCase.Billing_NPI_Number__c = billNPI;  
                    otherProvCase.Bill_NPI_Type__c = billNpiType;  
                    otherProvCase.Original_Creation_Date__c=System.now();  
                    otherProvCase.RecordTypeId = aAddrChangeRecType.Id;
                    otherProvCase.Comments_Other_Provider__c=otherProv.Comments_Other_Provider__c;
                    otherProvCase.Effective_Date_of_Change_OP__c=otherProv.Effective_Date_of_Change_OP__c;
                    system.debug( othersFlg+'######### specialtyFlg ######' + specialtyFlg);
                    if(specialtyFlg){
                        system.debug(othersFlg+'######### specialtyFlg1111111111 ######' + specialtyFlg);
                         system.debug('######### otherProv1111111111 ######' + otherProv);
                        otherProvCase.Specialty__c                              =   otherProv.Specialty__c;
                        otherProvCase.Sub_Speciality__c                         =   otherProv.Sub_Speciality__c;
                        otherProvCase.Specialty_Effective_Date__c               =   otherProv.Specialty_Effective_Date__c;
                        otherProvCase.Specialty_Certification_Date__c           =   otherProv.Specialty_Certification_Date__c;
                        otherProvCase.Specialty_OP_New__c                       =   otherProv.Specialty_OP_New__c;
                        otherProvCase.Sub_Specialty_OP_New__c                   =   otherProv.Sub_Specialty_OP_New__c;
                        otherProvCase.Specialty_E_Date_OP_New__c                =   otherProv.Specialty_E_Date_OP_New__c;
                        otherProvCase.Specialty_Cert_Date_OP_New__c             =   otherProv.Specialty_Cert_Date_OP_New__c;
                        otherProvCase.Provider_Type_Specialty__c                =   otherProv.Provider_Type_Specialty__c;
                        otherProvCase.Supervising_Physician__c                  =   otherProv.Supervising_Physician__c;
                        otherProvCase.Comments_Other_Provider__c                =   otherProv.Comments_Other_Provider__c;
                        otherProvCase.Effective_Date_of_Change_OP__c            =   otherProv.Effective_Date_of_Change_OP__c;
                                                 
                    }
                    if(privilegesFlg){
                        otherProvCase.Ambulatory_Surgery_Center_Privileges_li__c=otherProv.Ambulatory_Surgery_Center_Privileges_li__c;
                        otherProvCase.Ambulatory_Surg_Cnt_OP_New__c=otherProv.Ambulatory_Surg_Cnt_OP_New__c;
                        otherProvCase.Hospital_Privileges_list_all__c= otherProv.Hospital_Privileges_list_all__c;        
                        otherProvCase.Hospital_Privileges_OP_New__c=otherProv.Hospital_Privileges_OP_New__c;
                        otherProvCase.Room_Rate_Type__c=otherProv.Room_Rate_Type__c;
                        otherProvCase.Room_Rate_Amount__c=otherProv.Room_Rate_Amount__c;
                    }
                    if(providerIDsFlg){
                        otherProvCase.DEA__c=otherProv.DEA__c;
                        otherProvCase.DEA_Expiration_Date__c=otherProv.DEA_Expiration_Date__c;      
                        otherProvCase.License_OP_Current__c=otherProv.License_OP_Current__c;
                        otherProvCase.License_OP_New__c=otherProv.License_OP_New__c;
                        otherProvCase.Medicaid_Number__c=otherProv.Medicaid_Number__c;
                        otherProvCase.Medicare_Number__c=otherProv.Medicare_Number__c;
                    }
                    if(othersFlg){
                        System.debug('##########In side other provider flag#######');
                        otherProvCase.Board_Certified__c                        =   otherProv.Board_Certified__c;
                        otherProvCase.Board_Certified_OP_New__c                 =   otherProv.Board_Certified_OP_New__c;
                        otherProvCase.Board_Certification_Expiration_Year__c    =   otherProv.Board_Certification_Expiration_Year__c;
                        otherProvCase.Languages_Spoken_or_Written__c            =   otherProv.Languages_Spoken_or_Written__c;
                        otherProvCase.Date_of_Birth__c                          =   otherProv.Date_of_Birth__c;
                        otherProvCase.Ethnicity__c                              =   otherProv.Ethnicity__c;
                        otherProvCase.Year_of_Graduation__c                     =   otherProv.Year_of_Graduation__c;
                        otherProvCase.Residency_Hospital_Name__c                =   otherProv.Residency_Hospital_Name__c;       
                        otherProvCase.From__c                                   =   otherProv.From__c;
                        otherProvCase.To__c                                     =   otherProv.To__c;
                        otherProvCase.BackUp__c                                 =   otherProv.BackUp__c;
                        otherProvCase.Medical_School_Name__c                    =   otherProv.Medical_School_Name__c;
                    }
                    otherProvCasesforInsert.add( otherProvCase );
                }
                system.debug('####### otherProvCasesforInsert ######'+otherProvCasesforInsert.size());
                List<Case> finalProvCases = new List<Case>();
                try{
                    if( !otherProvCasesforInsert.isEmpty() ){                        
                        listOfChildCases.addAll(otherProvCasesforInsert);
                        otherProvCasesforValidation.addAll(otherProvCasesforInsert);
                    }
                }catch (Exception ex){            
                    String msg = String.valueOf(ex.getmessage());  
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Case Creation Failed');
                    ApexPages.addmessage(myMsg);
                    system.debug('######## Exception occured ####' + msg);
                } 
                System.debug('<<<<<============ End of inside other provider updates =============>>>>>>>> ');
            } 
            
            if (removeProvFlg) 
            { 
                List<Case> removeProvCasesForInsert =   new List<Case>();
                RecordType rmProvChgRecType         =   [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE  and DeveloperName =:CaseUtil.REC_TYP_PROV_GRP];
                for( String removeProvPfin : finalPfins )
                {
                    system.debug('remove-------------'+finalPfins);
                    Case removeProvCase = new Case();
                    if (sObjName.endsWithIgnoreCase('Account')){
                        removeProvCase.Origin =accOrigin;
                        removeProvCase.ParentId = parentCase.Id;
                        if (actList.IsPersonAccount)
                            removeProvCase.AccountId = acctId;
                        else
                            removeProvCase.Case_Entity__c = acctId;     
                    }
                    if (sObjName.endsWithIgnoreCase('Case')) {                     
                        if (caseInfo.AccountId!=null){
                            removeProvCase.AccountId =caseInfo.AccountId; 
                        }else if (caseInfo.Case_Entity__c!=null){
                            removeProvCase.Case_Entity__c =caseInfo.Case_Entity__c; 
                        }
                        removeProvCase.ParentId = parentId;
                        removeProvCase.Origin = caseOrigin;
                    }
                    removeProvCase.MC_PFIN__c = removeProvPfin;

                    if (CaseMode == 'Add'){
                        removeProvCase.MC_Add__c = true;           
                    }
                    if (CaseMode == 'Change'){
                        removeProvCase.MC_Change__c = true;           
                    }
                    if (CaseMode == 'Delete'){
                        removeProvCase.MC_Delete__c = true;           
                    }
                    removeProvCase.Status = caseInfo.Status;
                    removeProvCase.Priority = caseInfo.Priority;
                    removeProvCase.Plan_ID__c = planId;           
                    removeProvCase.Govt_Programs__c = caseInfo.Govt_Programs__c;
                    removeProvCase.Completing_the_form_for__c = CaseInfo.Completing_the_form_for__c;
                    removeProvCase.Corporate_Received_Date_Time__c = CaseInfo.Corporate_Received_Date_Time__c;
                    removeProvCase.Name_Submitter__c = CaseInfo.Name_Submitter__c; 
                    removeProvCase.Title_Submitter__c = CaseInfo.Title_Submitter__c;  
                    removeProvCase.Telephone_Number_Submitter__c = CaseInfo.Telephone_Number_Submitter__c;  
                    removeProvCase.Submitter_Phone_Ext__c = CaseInfo.Submitter_Phone_Ext__c;  
                    removeProvCase.Email_Address_Submitter__c = CaseInfo.Email_Address_Submitter__c;  
                    removeProvCase.Name_of_Provider_Group__c = caseInfo.Name_of_Provider_Group__c;
                    removeProvCase.Tax_ID_Number__c = caseInfo.Tax_ID_Number__c;
                    removeProvCase.Rendering_NPI__c = renderNPI;
                    removeProvCase.Billing_NPI_Number__c = billNPI;  
                    removeProvCase.Bill_NPI_Type__c = billNpiType;  
                    removeProvCase.Original_Creation_Date__c=System.now();  
                    removeProvCase.RecordTypeId = rmProvChgRecType.Id;
                    removeProvCase.Reason_For_Leaving_Group_Location__c = reasonLvlGrp;
                    removeProvCase.Reason_For_Leaving_Group_Location_1__c = reasonLvlGrp1;
                    removeProvCase.Reason_For_Leaving_Group_Location_2__c = reasonLvlGrp2;
                    /*  US-14375*/
                    removeProvCase.Individual_Provider_Name__c = removeProv.Individual_Provider_Name__c;
                    removeProvCase.Individual_s_Type_1_NPI__c = removeProv.Individual_s_Type_1_NPI__c;
                    removeProvCase.Other_ID_Eg_Medicaid_API_LTSS_TPI__c = removeProv.Other_ID_Eg_Medicaid_API_LTSS_TPI__c;
                    removeProvCase.Remove_From_All_Locations__c = removeProv.Remove_From_All_Locations__c;  
                    removeProvCase.Effective_Date_Of_Termination__c=removeProv.Effective_Date_Of_Termination__c;    
                    removeProvCase.Addr_Line_1_Remove_Provider__c=removeProv.Addr_Line_1_Remove_Provider__c;
                    removeProvCase.Addr_Line_2_Remove_Provider__c=removeProv.Addr_Line_2_Remove_Provider__c;
                    removeProvCase.City_Remove_Provider__c=removeProv.City_Remove_Provider__c;
                    removeProvCase.State_Remove_Provider__c=removeProv.State_Remove_Provider__c;
                    removeProvCase.Zip_Remove_Provider__c=removeProv.Zip_Remove_Provider__c;                    
                    removeProvCase.Effective_Date_Of_Termination_1__c=removeProv.Effective_Date_Of_Termination_1__c;
                    removeProvCase.Comments_Remove_Provider__c=removeProv.Comments_Remove_Provider__c;
                    removeProvCase.Attestation__c = removeProv.Attestation__c;            
                    removeProvCase.Add_Another_Location_For_Removal__c = removeProv.Add_Another_Location_For_Removal__c; //set value from form into object field
                    removeProvCase.X2nd_Addr_Line_1_Remove_Provider__c=removeProv.X2nd_Addr_Line_1_Remove_Provider__c;
                    removeProvCase.X2nd_Addr_Line_2_Remove_Provider__c=removeProv.X2nd_Addr_Line_2_Remove_Provider__c;
                    removeProvCase.X2nd_City_Remove_Provider__c=removeProv.X2nd_City_Remove_Provider__c;
                    removeProvCase.X2nd_State_Remove_Provider__c=removeProv.X2nd_State_Remove_Provider__c;
                    removeProvCase.X2nd_Zip_Remove_Provider__c=removeProv.X2nd_Zip_Remove_Provider__c;
                    removeProvCase.Effective_Date_Of_Termination_2__c=removeProv.Effective_Date_Of_Termination_2__c; 
                    
                    removeProvCasesForInsert.add( removeProvCase );
                }
                try{
                    if( !removeProvCasesForInsert.isEmpty() ){
                    listOfChildCases.addAll(removeProvCasesForInsert);
                    }
                    
                }catch (Exception ex){            
                    String msg = String.valueOf(ex.getmessage());  
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Case Creation Failed');
                    ApexPages.addmessage(myMsg);
                    
                }
            } 
            system.debug('prvo flag--'+addProvFlg);
            if (addProvFlg) { 
                system.debug('before new instance--'+addProv);
                List<Case> addProvCasesForInsert = new List<Case>();
                RecordType addProvChgRecType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE  and DeveloperName =:CaseUtil.REC_TYP_ADD_PROV_GRP];
                for( String addProvPfin : finalPfins )
                {
                    Case addProvChild = new Case();
                    if (sObjName.endsWithIgnoreCase('Account')){
                        addProvChild.Origin =accOrigin;
                        addProvChild.ParentId = parentCase.Id;
                        if (actList.IsPersonAccount)
                            addProvChild.AccountId = acctId;
                        else
                            addProvChild.Case_Entity__c = acctId;
                        
                    }
                    if (sObjName.endsWithIgnoreCase('Case')) {                     
                        if (caseInfo.AccountId!=null){
                            addProvChild.AccountId =caseInfo.AccountId; 
                        }else if (caseInfo.Case_Entity__c!=null){
                            addProvChild.Case_Entity__c =caseInfo.Case_Entity__c; 
                        }
                        addProvChild.ParentId = parentId;
                        addProvChild.Origin = caseOrigin;
                    }
                    addProvChild.MC_PFIN__c = addProvPfin;
                    if (CaseMode == 'Add'){
                        addProvChild.MC_Add__c = true;           
                    }
                    if (CaseMode == 'Change'){
                        addProvChild.MC_Change__c = true;           
                    }
                    if (CaseMode == 'Delete'){
                        addProvChild.MC_Delete__c = true;           
                    }
                    addProvChild.Status = caseInfo.Status;
                    addProvChild.Priority = caseInfo.Priority;
                    addProvChild.Plan_ID__c = planId;   
                    addProvChild.Govt_Programs__c = caseInfo.Govt_Programs__c;
                    addProvChild.Completing_the_form_for__c = typeOfProv;   
                    addProvChild.Name_Submitter__c = CaseInfo.Name_Submitter__c; 
                    addProvChild.Title_Submitter__c = CaseInfo.Title_Submitter__c;  
                    addProvChild.Telephone_Number_Submitter__c = CaseInfo.Telephone_Number_Submitter__c;  
                    addProvChild.Submitter_Phone_Ext__c = CaseInfo.Submitter_Phone_Ext__c;  
                    addProvChild.Corporate_Received_Date_Time__c = CaseInfo.Corporate_Received_Date_Time__c;
                    addProvChild.Email_Address_Submitter__c = CaseInfo.Email_Address_Submitter__c;  
                    addProvChild.Name_of_Provider_Group__c = caseInfo.Name_of_Provider_Group__c;
                    addProvChild.Tax_ID_Number__c = caseInfo.Tax_ID_Number__c;
                    addProvChild.Rendering_NPI__c = renderNPI;
                    addProvChild.Billing_NPI_Number__c = billNPI;    
                    addProvChild.Bill_NPI_Type__c = billNpiType;  
                    addProvChild.Gender__c = gender;
                    addProvChild.Original_Creation_Date__c=System.now();  
                    addProvChild.RecordTypeId = addProvChgRecType.Id;
                    system.debug('adprove record--'+addProv);
                    /* US-14375 */
                    addProvChild.Group_Name__c = addProv.Group_Name__c;
                    addProvChild.Group_Tax_ID__c = addProv.Group_Tax_ID__c;
                    addProvChild.Group_Provider_Type_Specialty__c = addProv.Group_Provider_Type_Specialty__c;
                    addProvChild.License_Number__c = addProv.License_Number__c;
                    addProvChild.CAQH_Number__c=addProv.CAQH_Number__c;    
                    addProvChild.Other_Provider_Number__c=addProv.Other_Provider_Number__c;
                    addProvChild.Add_Provider_Supervising_Physician__c=addProv.Add_Provider_Supervising_Physician__c;
                    addProvChild.Networks__c=addProv.Networks__c;
                    addProvChild.Gender__c=gender;
                    addProvChild.Add_Provider_Accepting_New_Patients__c=addProv.Add_Provider_Accepting_New_Patients__c;
                    addProvChild.Provider_s_Name__c=addProv.Provider_s_Name__c;
                    addProvChild.Group_NPI__c=addProv.Group_NPI__c;
                    addProvChild.Group_PFIN__c=addProv.Group_PFIN__c;
                    addProvChild.Individual_NPI__c=addProv.Individual_NPI__c;
                    addProvChild.Add_Provider_Date_Of_Birth__c = addProv.Add_Provider_Date_Of_Birth__c;            
                    addProvChild.Indivudual_Type_Speciality__c = addProv.Indivudual_Type_Speciality__c;
                    addProvChild.Comp_Grid_Code_If_applicable__c=addProv.Comp_Grid_Code_If_applicable__c;
                    addProvChild.Designation_Code_If_applicable__c=addProv.Designation_Code_If_applicable__c;
                    addProvChild.Supervising_Physician_License__c=addProv.Supervising_Physician_License__c;
                    addProvChild.Effective_Date__c=addProv.Effective_Date__c;
                    addProvChild.Hospital_Affilitation__c=addProv.Hospital_Affilitation__c;
                    
                    addProvChild.Site_Acce__c=addProv.Site_Acce__c;
                    addProvChild.Office_Reception_Area__c=addProv.Office_Reception_Area__c;
                    addProvChild.Exam_Room__c=addProv.Exam_Room__c;
                    addProvChild.Exterior__c=addProv.Exterior__c;
                    addProvChild.Scale__c=addProv.Scale__c;
                    addProvChild.Interior_Building__c=addProv.Interior_Building__c;
                    addProvChild.Parking_Accessbility__c=addProv.Parking_Accessbility__c;
                    addProvChild.Restroom__c=addProv.Restroom__c;
                    addProvChild.Exam_Table__c=addProv.Exam_Table__c;
                    addProvChild.Close_Proximity_to_Public_Transportation__c=addProv.Close_Proximity_to_Public_Transportation__c;
                    
                    addProvChild.Current_Addr_Line_1_add_prov_Phy__c=addProv.Current_Addr_Line_1_add_prov_Phy__c;
                    addProvChild.Current_Addr_Line_2_add_prov_Phy__c=addProv.Current_Addr_Line_2_add_prov_Phy__c;
                    addProvChild.Current_City_add_prov_Phy__c=addProv.Current_City_add_prov_Phy__c;
                    addProvChild.Current_State_add_prov_Phy__c=addProv.Current_State_add_prov_Phy__c;
                    addProvChild.Current_Zip_add_prov_Phy__c=addProv.Current_Zip_add_prov_Phy__c;
                    addProvChild.Current_Phone_add_prov_Phy__c=addProv.Current_Phone_add_prov_Phy__c;
                    addProvChild.Current_Email_add_prov_Phy__c=addProv.Current_Email_add_prov_Phy__c;
                    addProvChild.Current_Fax_add_prov_Phy__c=addProv.Current_Fax_add_prov_Phy__c;
                    addProvChild.Accepting_New_Patients_add_prov_Phy__c=addProv.Accepting_New_Patients_add_prov_Phy__c;
                    addProvChild.New_Addr_Line_1_add_prov_Phy__c=addProv.New_Addr_Line_1_add_prov_Phy__c;
                    addProvChild.New_Addr_Line_2_add_prov_Phy__c=addProv.New_Addr_Line_2_add_prov_Phy__c;
                    addProvChild.New_City_add_prov_Phy__c=addProv.New_City_add_prov_Phy__c;
                    addProvChild.New_State_add_prov_Phy__c=addProv.New_State_add_prov_Phy__c;
                    addProvChild.New_Zip_add_prov_Phy__c=addProv.New_Zip_add_prov_Phy__c;
                    addProvChild.New_Phone_add_prov_Phy__c=addProv.New_Phone_add_prov_Phy__c;
                    addProvChild.Physical_Address_Current_Phone_Ext__c=addProv.Physical_Address_Current_Phone_Ext__c;
                    addProvChild.New_Email_add_prov_Phy__c=addProv.New_Email_add_prov_Phy__c;
                    addProvChild.New_Fax_add_prov_Phy__c=addProv.New_Fax_add_prov_Phy__c;
                    addProvChild.Primary_Location_add_prov_Phy__c=addProv.Primary_Location_add_prov_Phy__c;
                    addProvChild.Efft_Date_Physical_add_prov_Phy__c=addProv.Efft_Date_Physical_add_prov_Phy__c;
                    
                    addProvChild.Current_Addr_Line_1_add_prov_Bill__c=addProv.Current_Addr_Line_1_add_prov_Bill__c;
                    addProvChild.Current_Addr_Line_2_add_prov_Bill__c=addProv.Current_Addr_Line_2_add_prov_Bill__c;
                    addProvChild.Current_City_add_prov_Bill__c=addProv.Current_City_add_prov_Bill__c;
                    addProvChild.Current_State_add_prov_Bill__c=addProv.Current_State_add_prov_Bill__c;
                    addProvChild.Current_Zip_add_prov_Bill__c=addProv.Current_Zip_add_prov_Bill__c;
                    addProvChild.Current_Phone_add_prov_Bill__c=addProv.Current_Phone_add_prov_Bill__c;
                    addProvChild.Current_Email_add_prov_Bill__c=addProv.Current_Email_add_prov_Bill__c;
                    addProvChild.Current_Fax_add_prov_Bill__c=addProv.Current_Fax_add_prov_Bill__c;
                    addProvChild.New_Addr_Line_1_add_prov_Bill__c=addProv.New_Addr_Line_1_add_prov_Bill__c;
                    addProvChild.New_Addr_Line_2_add_prov_Bill__c=addProv.New_Addr_Line_2_add_prov_Bill__c;
                    addProvChild.New_City_add_prov_Bill__c=addProv.New_City_add_prov_Bill__c;
                    addProvChild.New_State_add_prov_Bill__c=addProv.New_State_add_prov_Bill__c;
                    addProvChild.New_Zip_add_prov_Bill__c=addProv.New_Zip_add_prov_Bill__c;
                    addProvChild.New_Phone_add_prov_Bill__c=addProv.New_Phone_add_prov_Bill__c;
                    addProvChild.Billing_Address_Current_Phone_Ext__c=addProv.Billing_Address_Current_Phone_Ext__c;
                    addProvChild.New_Email_add_prov_Bill__c=addProv.New_Email_add_prov_Bill__c;
                    addProvChild.New_Fax_add_prov_Bill__c=addProv.New_Fax_add_prov_Bill__c;
                    addProvChild.Efft_Date_add_prov_Bill__c=addProv.Efft_Date_add_prov_Bill__c;
                    addProvChild.Comments_add_prov_Bill__c=addProv.Comments_add_prov_Bill__c;
                    addProvChild.Mon_Open_add_prov__c = addProv.Mon_Open_add_prov__c;
                    addProvChild.Mon_Close_add_prov__c= addProv.Mon_Close_add_prov__c;
                    addProvChild.Tue_Open_add_prov__c = addProv.Tue_Open_add_prov__c;                
                    addProvChild.Tue_Close_add_prov__c = addProv.Tue_Close_add_prov__c;
                    addProvChild.Wed_Open_add_prov__c = addProv.Wed_Open_add_prov__c;
                    addProvChild.Wed_Close_add_prov__c = addProv.Wed_Close_add_prov__c;               
                    addProvChild.Thu_Open_add_prov__c = addProv.Thu_Open_add_prov__c;
                    addProvChild.Thu_Close_add_prov__c = addProv.Thu_Close_add_prov__c;
                    addProvChild.Fri_Open_add_prov__c = addProv.Fri_Open_add_prov__c;
                    addProvChild.Fri_Close_add_prov__c = addProv.Fri_Close_add_prov__c;                
                    addProvChild.Sat_Open_add_prov__c = addProv.Sat_Open_add_prov__c;  
                    addProvChild.Sat_Close_add_prov__c = addProv.Sat_Close_add_prov__c;                  
                    addProvChild.Sun_Open_add_prov__c = addProv.Sun_Open_add_prov__c;        
                    addProvChild.Sun_Close_add_prov__c = addProv.Sun_Close_add_prov__c;
                    addProvChild.Comments_add_prov_phy__c = addProv.Comments_add_prov_phy__c;
                    addProvChild.Open_24_c_add_prov_phy__c = addProv.Open_24_c_add_prov_phy__c;
                    addProvCasesForInsert.add( addProvChild);
                }
                try{
                    if(!addProvCasesForInsert.isEmpty()){
                    listOfChildCases.addAll(addProvCasesForInsert);
                    otherProvCasesforValidation.addAll(addProvCasesForInsert);
                    }
                    
                }catch (Exception ex){            
                    String msg = String.valueOf(ex.getmessage());  
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Case Creation Failed');
                    ApexPages.addmessage(myMsg);
                    
                }
            }
            
            system.debug('#### ** networkChg.Terminate_Prov_Reason_Com__c ###' + networkChg.Terminate_Prov_Reason_Com__c); 
            string terminateProvReasonComment = networkChg.Terminate_Prov_Reason_Com__c; 
            
            if (addNwkChgFlg || rmNwrkChgFlg || reinPrvChgFlg || termPrvChgFlg)
            {
                List<Case> networkChgCaseForInsert     =   new List<Case>();
                RecordType netwrkChgRecType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE  and DeveloperName =:CaseUtil.REC_TYP_NWK_CHG];
                for( String networkChgPfin :  finalPfins )
                {
                        Case networkChg = new Case();
                        networkChg.MC_PFIN__c = networkChgPfin;
                        if (CaseMode == 'Add'){
                            networkChg.MC_Add__c = true;           
                        }
                        if (CaseMode == 'Change'){
                            networkChg.MC_Change__c = true;           
                        }
                        if (CaseMode == 'Delete'){
                            networkChg.MC_Delete__c = true;           
                        }
                    
                        if (sObjName.endsWithIgnoreCase('Account'))
                        {
                            networkChg.Origin =accOrigin;
                            networkChg.ParentId = parentCase.Id;
                            if (actList.IsPersonAccount)
                                networkChg.AccountId = acctId;
                            else
                                networkChg.Case_Entity__c = acctId;     
                        }
                        if (sObjName.endsWithIgnoreCase('Case')) 
                        {                     
                            if (caseInfo.AccountId!=null)
                            {
                                networkChg.AccountId =caseInfo.AccountId; 
                            }else if (caseInfo.Case_Entity__c!=null)
                            {
                                networkChg.Case_Entity__c =caseInfo.Case_Entity__c; 
                            }
                            networkChg.ParentId = parentId;
                            networkChg.Origin = caseOrigin;
                        }
                   
                        networkChg.Status = caseInfo.Status;
                        networkChg.Priority = caseInfo.Priority;
                        networkChg.Plan_ID__c = planId;               
                        networkChg.Govt_Programs__c = caseInfo.Govt_Programs__c;
                        networkChg.Completing_the_form_for__c = CaseInfo.Completing_the_form_for__c;  
                        networkChg.Corporate_Received_Date_Time__c = CaseInfo.Corporate_Received_Date_Time__c;
                        networkChg.Name_Submitter__c = CaseInfo.Name_Submitter__c; 
                        networkChg.Title_Submitter__c = CaseInfo.Title_Submitter__c;  
                        networkChg.Telephone_Number_Submitter__c = CaseInfo.Telephone_Number_Submitter__c;
                        networkChg.Submitter_Phone_Ext__c = CaseInfo.Submitter_Phone_Ext__c; 
                        networkChg.Email_Address_Submitter__c = CaseInfo.Email_Address_Submitter__c;  
                        networkChg.Name_of_Provider_Group__c = caseInfo.Name_of_Provider_Group__c;
                        networkChg.Tax_ID_Number__c = caseInfo.Tax_ID_Number__c;
                        networkChg.Rendering_NPI__c = renderNPI;
                        networkChg.Billing_NPI_Number__c = billNPI;  
                        networkChg.Bill_NPI_Type__c = billNpiType;  
                        networkChg.Original_Creation_Date__c=System.now(); 
                    if (addNwkChgFlg){
                        networkChg.Add_PFIN_Num__c = networkChgPfin;
                        networkChg.Add_Nwk_Eff_Date__c=networkChg.Add_Nwk_Eff_Date__c;    
                        networkChg.Add_Nwk_Code__c = addNetwork;     
                    }
                    if (rmNwrkChgFlg){
                        networkChg.Remove_Nwk_PFIN_Num__c = networkChgPfin; 
                        networkChg.Remove_Nwk_Code__c = removeNwkCode;  
                        networkChg.Remove_Network_Reason__c = removeNwkReason;
                        networkChg.Remove_Nwk_Eff_Date__c = networkChg.Remove_Nwk_Eff_Date__c;     
                    }
                    if (reinPrvChgFlg){
                        //networkChg.Reinstate_PFIN_Num__c = networkChg.Reinstate_PFIN_Num__c;
                        networkChg.Reinstate_PFIN_Num__c = networkChgPfin;         
                        networkChg.Reinstate_Nwk_Code__c = networkChg.Reinstate_Nwk_Code__c;
                    }
                    if(termPrvChgFlg){
                        networkChg.Term_PFIN_Num__c=networkChgPfin;
                        networkChg.Term_PFIN_Num__c=networkChg.Term_PFIN_Num__c;
                        networkChg.Term_Reason__c = termReason;
                        networkChg.Terminate_Prov_Reason_Com__c = terminateProvReasonComment;
                        networkChg.Termin_Nwk_Eff_Date__c = networkChg.Termin_Nwk_Eff_Date__c;  
                    }
                    networkChg.RecordTypeId = netwrkChgRecType.Id;
                    networkChgCaseForInsert.add(networkChg);   
                }
            System.debug('networkChgCaseForInsert===>>>'+networkChgCaseForInsert);
            
            
           if(!networkChgCaseForInsert.isEmpty())
           {
                try{
                   insert networkChgCaseForInsert;
                   ManualCaseCreationControllerSupoortCls.createNetworkRecords( networkChgCaseForInsert , hiddenJson , CaseMode);
                 }catch (Exception ex){            
                            String msg = String.valueOf(ex.getmessage());  
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Case Creation Failed');
                            ApexPages.addmessage(myMsg);
                            
                 }
           }
           }
                
            if(listOfChildCases!=null && listOfChildCases.size()>0) {
                insert listOfChildCases;
            }          
        }
        if (sobjName =='Case'){
            backwardUrl = '/'+parentId;
        }else{    
            backwardUrl = '/'+parentCase.Id;
            
        }
        System.debug('backwardUrl===>>>>'+backwardUrl);
        System.debug('<<================ Debugging Ends ===============>>'); 
        return (new PageReference(backwardUrl).setRedirect(true)); 
    }
    /* PPN-14375, PPN-14557 ends*/
    
    
    Public Pagereference pFINUrl(){
        PageReference pageRef;
        if (sobjName =='Pfin')
            pageRef= new PageReference('/apex/PFINSelected?urlPFIN='+selPFIN);     
        else
            pageRef= new PageReference('/apex/PFINSelection');     
        return pageRef.setRedirect(false);
    }
    public Pagereference requestUrl(){ 
        PageReference pageRef= new PageReference('/apex/ManualCaseCreation');     
        return pageRef.setRedirect(false);
    }
    
    public Pagereference prevUrl(){ 
        if (sobjName =='Case'){
            backwardUrl = '/'+parentId;
        }
        else if (sobjName =='Pfin'){
            backwardUrl = '/'+pfinaddrId;
        }else{        
            backwardUrl = '/'+acctId;
            
        }
        system.debug('prev backwardUrl'+backwardUrl);
        return (new PageReference(backwardUrl).setRedirect(true));
    }
    
    public List <CM_SPL_Addr__c> getAddressInfo()
    {
        List<CM_SPL_Addr__c> lstPfinNo;
        if (selPFIN!=null){
            lstPfinNo=[select CM_SPL_PFIN_No__c, CM_SPL_Addr_Type__c,CM_SPL_Addr_Line_1__c,CM_SPL_Add_Line_2__c,CM_SPL_State__c from CM_SPL_Addr__c where CM_SPL_PFIN_No__c =:selPFIN and CM_SPL_Prov__c=:acctId ORDER BY CM_SPL_PFIN_No__c limit 999];      
            if (lstPfinNo.size() < = 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No PFIN is Found for Account'));
                
            }   
            
        }   
        
        return lstPfinNo;
    }
    /** ppn-13772 Starts **/
    public void fetchAllAddress()
    {
        system.debug('fetchAllAddress+++');
        selectAllNonBillPfin=ApexPages.currentPage().getParameters().get('setPFIN');
        selectAllCheckBox=Boolean.valueOf(ApexPages.currentPage().getParameters().get('selectAllCheckBox'));
        system.debug(selectAllCheckBox +'CheckBox');
        selectAllNonBPFINOption =new List<SelectOption>();
        listOfAllNonBillPfins = new List<String>();
        listOfDisplayNonBillPfins = new List<String>();
        Set<String> setOfPfins = new Set<String>();
        String tempSelPFIN = selPFIN+'-'+accountName;
        
        if(selectAllCheckBox)
        {
            showAddGrid = false;
            showSelectAllPanel = true;
            system.debug(showSelectAllPanel +'showSelectAllPanel ');
            wrapList = new List<ServicePayeeLocation>();
            System.debug('What is selPFIN'+selPFIN+'billpfin'+selectAllNonBillPfin); 
            List<Account> listOfAccount = [Select Id,isPersonAccount, CM_Corporate_Entity_Code__c From Account Where Id =:acctId];
            List<Id> listOfAffiliatedIds = new list<Id>();
            if(!listOfAccount.isEmpty() && !listOfAccount[0].isPersonAccount)      
            {           
                for(Affiliations__c newAffiliation : [Select Id,CM_Affiliated_Provider_Name__c,Account__c,CM_Affiliated_Provider_Name__r.isPersonAccount,Account__r.isPersonAccount From Affiliations__c Where Account__c =:listOfAccount[0].Id OR CM_Affiliated_Provider_Name__c =:listOfAccount[0].Id])                
                {   
                    if(newAffiliation.Account__c == listOfAccount[0].Id && newAffiliation.CM_Affiliated_Provider_Name__r.isPersonAccount){       
                        listOfAffiliatedIds.add(newAffiliation.CM_Affiliated_Provider_Name__c);     
                    }       
                    if(newAffiliation.CM_Affiliated_Provider_Name__c == listOfAccount[0].Id && newAffiliation.Account__r.isPersonAccount){       
                        listOfAffiliatedIds.add(newAffiliation.Account__c);     
                    }       
                }       
            }
            
            if(!listOfAccount.isEmpty()){ 
                for(CM_SPL_Addr__c newAddress:[select CM_SPL_Prov__r.Name,CM_SPL_Prov__c,CM_SPL_PFIN_No__c,CM_SPL_Addr_Type__c,CM_SPL_Addr_Line_1__c,CM_SPL_Add_Line_2__c,CM_SPL_State__c from CM_SPL_Addr__c where ((Bill_PFIN__c =:selPFIN OR (CM_SPL_PFIN_No__c!=NULL AND CM_SPL_PFIN_No__c =:selPFIN)) AND CM_SPL_Prov__r.CM_Corporate_Entity_Code__c=:listOfAccount[0].CM_Corporate_Entity_Code__c AND (CM_SPL_Prov__c =:listOfAccount[0].Id OR CM_SPL_Prov__c In:listOfAffiliatedIds)) ORDER BY CM_SPL_PFIN_No__c])
                {
                    System.debug('What is in newAddress'+newAddress+'Boolean '+newAddress.CM_SPL_Prov__c+'acctId'+acctId+'set');
                    if( !listOfAccount.isEmpty() && (!listOfAccount[0].isPersonAccount || (listOfAccount[0].isPersonAccount && newAddress.CM_SPL_Prov__c==acctId)) && 
                       (((listOfAccount[0].CM_Corporate_Entity_Code__c=='IL1' || listOfAccount[0].CM_Corporate_Entity_Code__c=='OK1') && (newAddress.CM_SPL_Addr_Type__c =='Billing' || newAddress.CM_SPL_Addr_Type__c =='Service'))
                        || ((listOfAccount[0].CM_Corporate_Entity_Code__c=='TX1' || listOfAccount[0].CM_Corporate_Entity_Code__c=='MT1' || listOfAccount[0].CM_Corporate_Entity_Code__c=='NM1') && (newAddress.CM_SPL_Addr_Type__c =='Billing' || newAddress.CM_SPL_Addr_Type__c =='Service' || newAddress.CM_SPL_Addr_Type__c =='Administration'))))
                    {
                        System.debug('Coming Inside');
                        wrapList.add(new ServicePayeeLocation (newAddress));                       
                    }                    
                    setOfPfins.add(newAddress.CM_SPL_PFIN_No__c+'-'+newAddress.CM_SPL_Prov__r.Name);
                }
                 listOfDisplayWrapList = new List<ServicePayeeLocation>();
                 Integer endCount = 50;
                 if(wrapList.size()<50)
                 {
                     endCount = wrapList.size();
                 }
            for(Integer count=0;count<endCount;count++)
            {
                listOfDisplayWrapList.add(wrapList[count]);
            }
            wrapPageNumber=0;
            }
            for( String pfinSelectAll : setOfPfins)
            {
                system.debug('*** pfinSelectALL ***'+ pfinSelectALL);
                system.debug('*** tempSelPFIN ***' + tempSelPFIN);
                if(pfinSelectAll != tempSelPFIN )
                {
                    selectAllNonBPFINOption.add( new SelectOption( pfinSelectAll , pfinSelectAll ) );
                     listOfAllNonBillPfins.add(pfinSelectAll);
                     
                }
            }
            system.debug('******* selectAllNonBPFINOption Size*******' + selectAllNonBPFINOption.size());
        }
        else
        {
            system.debug('else block');
            showSelectAllPanel = false;
            showAddGrid = true;
            fetchAddress();
        }
        
        PFINNumberList = new List<String>();
        pageNumber=0;
        totalPageNumber = listOfAllNonBillPfins.size()/10;
        if(math.mod(listOfAllNonBillPfins.size(),10)>0)
        {
            totalPageNumber=totalPageNumber+1;
        }
        listOfDisplayNonBillPfins = new List<String>();
        if(listOfAllNonBillPfins !=NULL && listOfAllNonBillPfins.size()>11)
        {
            for(Integer count=0;count<10;count++)
            {
                listOfDisplayNonBillPfins.add(listOfAllNonBillPfins[count]);
            }
        }
        else
        {
            listOfDisplayNonBillPfins.addAll(listOfAllNonBillPfins);
        }
        system.debug('listOfDisplayNonBillPfins+++++'+listOfDisplayNonBillPfins);
    }
    public pageReference next()
    {
        if(listOfAllNonBillPfins.size()>(pageNumber+1)*10)
        {
            Integer startValue = ((pageNumber+1)*10);
            Integer endValue;
            if(listOfAllNonBillPfins.size()>=((pageNumber+2)*10))
            {
                endValue = (pageNumber+2)*10;
            }
            else
            {
                endValue = listOfAllNonBillPfins.size();
            }
            listOfDisplayNonBillPfins = new List<String>();
            for(Integer count=startValue;count<endValue;count++)
            {
                listOfDisplayNonBillPfins.add(listOfAllNonBillPfins[count]);
            }
            pageNumber=pageNumber+1;
        } 
        return NULL;       
    }
    public pageReference previous()
    {
        if(pageNumber>0)
        {
            Integer startValue = ((pageNumber-1)*10);
            Integer endValue = pageNumber*10;
            listOfDisplayNonBillPfins = new List<String>();
            for(Integer count=startValue;count<endValue;count++)
            {
                listOfDisplayNonBillPfins.add(listOfAllNonBillPfins[count]);
            }
            pageNumber=pageNumber-1;
        } 
        return NULL;       
    }
    public pageReference nextManual()
    {
        if(overAllPfinList.size()>(manualpageNumber+1)*10)
        {
            Integer startValue = ((manualpageNumber+1)*10);
            Integer endValue;
            if(overAllPfinList.size()>=((manualpageNumber+2)*10))
            {
                endValue = (manualpageNumber+2)*10;
            }
            else
            {
                endValue = overAllPfinList.size();
            }
            listOfAllPfinsToNavigate= new List<String>();
            for(Integer count=startValue;count<endValue;count++)
            {
                listOfAllPfinsToNavigate.add(overAllPfinList[count]);
            }
            manualpageNumber=manualpageNumber+1;
        } 
        return NULL;       
    }
    public pageReference previousManual()
    {
        if(manualpageNumber>0)
        {
            Integer startValue = ((manualpageNumber-1)*10);
            Integer endValue = manualpageNumber*10;
            listOfAllPfinsToNavigate= new List<String>();
            for(Integer count=startValue;count<endValue;count++)
            {
                listOfAllPfinsToNavigate.add(overAllPfinList[count]);
            }
            manualpageNumber=manualpageNumber-1;
        } 
        return NULL;       
    } 

 public pageReference nextMcc()
    {
        if(overAllPfinList.size()>(mccpageNumber+1)*10)
        {
            Integer startValue = ((mccpageNumber+1)*10);
            Integer endValue;
            if(overAllPfinList.size()>=((mccpageNumber+2)*10))
            {
                endValue = (mccpageNumber+2)*10;
            }
            else
            {
                endValue = overAllPfinList.size();
            }
            listOfAllPfinsToDisplay= new List<String>();
            for(Integer count=startValue;count<endValue;count++)
            {
                listOfAllPfinsToDisplay.add(overAllPfinList[count]);
            }
            mccpageNumber=mccpageNumber+1;
        } 
        return NULL;       
    }
    public pageReference previousMcc()
    {
        if(mccpageNumber>0)
        {
            Integer startValue = ((mccpageNumber-1)*10);
            Integer endValue = mccpageNumber*10;
            listOfAllPfinsToDisplay= new List<String>();
            for(Integer count=startValue;count<endValue;count++)
            {
                listOfAllPfinsToDisplay.add(overAllPfinList[count]);
            }
            mccpageNumber=mccpageNumber-1;
        } 
        return NULL;       
    }   
    public pageReference nextWrap()
    {
        if(wrapList.size()>(wrapPageNumber+1)*50)
        {
            Integer startValue = ((wrapPageNumber+1)*50);
            Integer endValue;
            if(wrapList.size()>=((wrapPageNumber+2)*50))
            {
                endValue = (wrapPageNumber+2)*50;
            }
            else            
            {
                endValue = wrapList.size();
            }
            listOfDisplayWrapList= new List<ServicePayeeLocation>();
            for(Integer count=startValue;count<endValue;count++)
            {
                listOfDisplayWrapList.add(wrapList[count]);
            }
            wrappageNumber=wrappageNumber+1;
        } 
        return NULL;       
    }
    public pageReference previousWrap()
    {
        if(wrappageNumber>0)
        {
            Integer startValue = ((wrapPageNumber-1)*50);
            Integer endValue = wrapPageNumber*50;
            listOfDisplayWrapList= new List<ServicePayeeLocation>();
            for(Integer count=startValue;count<endValue;count++)
            {
                listOfDisplayWrapList.add(wrapList[count]);
            }
            wrapPageNumber=wrapPageNumber-1;
        } 
        return NULL;       
    }
    
    /** PPN 13772 Ends **/
    /**PPN-14267 Code Start **/
    /**PPN-14267 Code Start **/
    /**PPN-15737 Code Start**/
   public void fetchAddressNonBillPfin()
    {
       
        system.debug('fetchAddressNonBillPfin++++++');
        selNonBillPFIN=ApexPages.currentPage().getParameters().get('setPFIN');
        //PPN-15773 Begin
        if(selPfin == NULL)
            selPfin = ApexPages.currentPage().getParameters().get('BillPFIN');
        //PPN-15773 End  
        system.debug('hii '+selNonBillPFIN);  
        showAddGrid = true;
        showSelectAllPanel = false;  
        if(PFINNumberList !=NULL && PFINNumberList.isEmpty())
        {      
            wrapList = new List<ServicePayeeLocation>();
        }
        Set<String> setOfPfins = new Set<String>();
        String selectedNonBillpfin;//Sujatha
        for(String newWrapper:PFINNumberList)
        {
            //setOfPfins.add(newWrapper); 
            //Sujatha To avoid duplicate
            if(newWrapper.contains('-'))
            {
                selectedNonBillpfin= newWrapper.split('-')[0];          
                setOfPfins.add(selectedNonBillpfin);            
            }
        }
        List<Account> listOfAccount = [Select Id, CM_Corporate_Entity_Code__c From Account Where Id =:acctId];
        if(selNonBillPfin != NULL && selNonBillPfin.contains('-')){
            selNonBillPfin = selNonBillPfin.split('-')[0];
        }
        if(selNonBillPfin !=NULL && (setOfPfins.isEmpty() || !setOfPfins.contains(selNonBillPfin)))
        {
         System.debug('Coming inside if loop'+selNonBillPfin);
         System.debug('Coming inside if loop'+selPfin);       
         for(CM_SPL_Addr__c newAddress:[select CM_SPL_PFIN_No__c,CM_SPL_Prov__c,CM_SPL_Prov__r.Name, CM_SPL_Addr_Type__c,CM_SPL_Addr_Line_1__c,CM_SPL_Add_Line_2__c,CM_SPL_State__c from CM_SPL_Addr__c where ((CM_SPL_PFIN_No__c = :selNonBillPfin AND Bill_PFIN__c=:selPfin AND CM_SPL_PFIN_No__c !=:selPfin AND CM_SPL_PFIN_No__c !=NULL AND CM_SPL_Prov__r.CM_Corporate_Entity_Code__c=:listOfAccount[0].CM_Corporate_Entity_Code__c)) ORDER BY CM_SPL_PFIN_No__c limit 999])
         {
             system.debug('**** should come here ***');
             if(!setOfPfins.contains(newAddress.CM_SPL_PFIN_No__c))
             {
                 PFINNumberList.add(newAddress.CM_SPL_PFIN_No__c+'-'+newAddress.CM_SPL_Prov__r.Name);
                 setOfPfins.add(newAddress.CM_SPL_PFIN_No__c);
             }
             isRenderRequestPage=true;
             if( !listOfAccount.isEmpty() && ((listOfAccount[0].CM_Corporate_Entity_Code__c=='IL1' || listOfAccount[0].CM_Corporate_Entity_Code__c=='OK1') && (newAddress.CM_SPL_Addr_Type__c =='Billing' || newAddress.CM_SPL_Addr_Type__c =='Service'))
                || ((listOfAccount[0].CM_Corporate_Entity_Code__c=='TX1' || listOfAccount[0].CM_Corporate_Entity_Code__c=='MT1' || listOfAccount[0].CM_Corporate_Entity_Code__c=='NM1') && (newAddress.CM_SPL_Addr_Type__c =='Billing' || newAddress.CM_SPL_Addr_Type__c =='Service' || newAddress.CM_SPL_Addr_Type__c =='Administration')))
             {System.debug('Coming inside wrap list add');
              wrapList.add(new ServicePayeeLocation (newAddress));
             }  
         }
         for(Integer index=0;index<wrapList.size();index++)
         {
             system.debug('wrapList[index].servicePayeeAddress.CM_SPL_PFIN_No__c'+wrapList[index].servicePayeeAddress.CM_SPL_PFIN_No__c);

             if(wrapList[index].servicePayeeAddress.CM_SPL_PFIN_No__c==selPFIN)
             {
                 System.debug('What is selpfin '+selPFIN+'='+wrapList[index].servicePayeeAddress.CM_SPL_PFIN_No__c);
                 wrapList.remove(index); 
                 index=index-1;   
             }
         }
        }
        
        if(PFINNumberList!=NULL && PFINNumberList.isEmpty() && wrapList !=NULL && wrapList.isEmpty())
        {
            fetchAddress();
        }
        Integer endCount = 10;
        if(wrapList !=NULL && wrapList.size()<10)
        {
            endCount = wrapList.size();
        }  
        listOfDisplayWrapList = new List<ServicePayeeLocation>();      
        for(Integer count=0;count<endCount;count++)
        {
            listOfDisplayWrapList.add(wrapList[count]);
        }
         
    }
   
   
    public void billPfinSelection()
    {
        selPFIN=ApexPages.currentPage().getParameters().get('setPFIN');
        fetchAddress();
    }    
    public void fetchAddress()
    {
        system.debug('fetchAddress coming');
        List<CM_SPL_Addr__c>addressRecordList = new List<CM_SPL_Addr__c>();
        selectAllNonBPFINOption =new List<SelectOption>();
        listOfAllNonBillPfins =new List<String>();
        showSelectAllPanel = false;
        List<Account> listOfAccount = [Select Id, CM_Corporate_Entity_Code__c From Account Where Id =:acctId];
        if(selPFIN != NULL && selPFIN.contains('-')){
            selPFIN = selPFIN.split('-')[0];
        }
        if(selPFIN !=NULL)
        { 
            addressRecordList=[select CM_SPL_Prov__r.Name,CM_SPL_PFIN_No__c, CM_SPL_Addr_Type__c,CM_SPL_Addr_Line_1__c,CM_SPL_Add_Line_2__c,CM_SPL_State__c from CM_SPL_Addr__c where (CM_SPL_PFIN_No__c =:selPFIN or Bill_PFIN__c =:selPFIN) and CM_SPL_Prov__c=:acctId ORDER BY CM_SPL_PFIN_No__c ];      
            wrapList = new List<ServicePayeeLocation>();
            for(CM_SPL_Addr__c addr :addressRecordList) 
            {
                isRenderRequestPage = true;               
                if( !listOfAccount.isEmpty() && ((listOfAccount[0].CM_Corporate_Entity_Code__c=='IL1' || listOfAccount[0].CM_Corporate_Entity_Code__c=='OK1') && (addr.CM_SPL_Addr_Type__c =='Billing' || addr.CM_SPL_Addr_Type__c =='Service'))
                   || ((listOfAccount[0].CM_Corporate_Entity_Code__c=='TX1' || listOfAccount[0].CM_Corporate_Entity_Code__c=='MT1' || listOfAccount[0].CM_Corporate_Entity_Code__c=='NM1') && (addr.CM_SPL_Addr_Type__c =='Billing' || addr.CM_SPL_Addr_Type__c =='Service' || addr.CM_SPL_Addr_Type__c =='Administration')))
                {
                    wrapList.add(new ServicePayeeLocation (addr));
                }   
            }
              listOfDisplayWrapList = new List<ServicePayeeLocation>();
              Integer endCount=0;
              if(wrapList.size()>=50)
              {
                  endCount = 50;   
              }
              else
              {
                  endCount = wrapList.size();
              }
            for(Integer count=0;count<endCount;count++)
            {
                listOfDisplayWrapList.add(wrapList[count]);
            }
            wrapPageNumber=0;
            System.debug('What is the size of wrapList '+wrapList.size());
            totalWrapPageNumber = wrapList.size()/50;
            if(math.mod(wrapList.size(),50)>0)
            {
                totalWrapPageNumber = totalWrapPageNumber+1;
            }
        }
        system.debug('listOfDisplayWrapList-----'+listOfDisplayWrapList);
       
    } 
    /** PPN-15737 Code End **/ 
    /*** PPN-14267 Code End ***/
    
    public class ServicePayeeLocation {
        public CM_SPL_Addr__c servicePayeeAddress {get;set;}
        public Boolean selectedAddr {get; set;}
        
        public ServicePayeeLocation (CM_SPL_Addr__c addr) {
            servicePayeeAddress =addr;
            selectedAddr = false;
        }
    }
    
    public void fetchUrlAddress(){
        selPFIN=ApexPages.currentPage().getParameters().get('urlPFIN');
        if (selPFIN == null && selPFIN==''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No PFIN is Found for Account'));        }
    }
    /**** PPN-14267 Code Start ***/    
    @RemoteAction
    Global static String[] populatePFIN(String value,string acctId)
    {        
        try
        {
            pFinNumList=new List<String>();
            String temp = null;            
            if(String.isNotBlank(value))
            {
                value= '%'+value+'%';
                List<CM_SPL_Addr__c> lstPfinNo=[select CM_SPL_Prov__r.Name,Bill_PFIN__c,CM_SPL_PFIN_No__c from CM_SPL_Addr__c where CM_SPL_Prov__c=:acctId AND Bill_PFIN__c LIKE:value AND Bill_PFIN__c !=NULL  ORDER BY Bill_PFIN__c];
                //Added Where condition for filtering only Bill Pfins                
                for(CM_SPL_Addr__c l:lstPfinNo)
                {
                    if (temp!=l.Bill_PFIN__c )
                    {
                        //pFinNumList.add(l.Bill_PFIN__c+'-'+l.CM_SPL_Prov__r.Name);
                        pFinNumList.add(l.Bill_PFIN__c);
                    }                   
                    temp = l.Bill_PFIN__c;
                }
            }
            System.debug('pFinNumList'+pFinNumList);
            return pFinNumList;
        }
        catch(Exception e)
        {
            System.debug('Message:='+e.getMessage()+'**Line Number='+e.getLineNumber());
        }
        return null;
    }
    /*** PPN-14267 Code End ***/
    //Method to pull the relevant non-Bill Pfins
    /******* PPN-14267 Code Start*******/
    @RemoteAction
    Global static String[] populateNonBillPFIN(String value,String acctId,String selPFIN)
    {  
        System.debug('Selected pfins'+selPFIN+'!!'); 
        Boolean isPersonAccount = false;
        List<Account> listOfAccount = [Select CM_Corporate_Entity_Code__c,isPersonAccount From Account Where Id=:acctId];
        if(!listOfAccount.isEmpty() && listOfAccount[0].isPersonAccount)
        {
            isPersonAccount = true;
        } 
        
        List<Id> listOfAffiliatedIds = new List<Id>();     
        if(!isPersonAccount)      
        {           
            for(Affiliations__c newAffiliation : [Select Id,CM_Affiliated_Provider_Name__c,Account__c,CM_Affiliated_Provider_Name__r.isPersonAccount,Account__r.isPersonAccount From Affiliations__c Where Account__c =:listOfAccount[0].Id OR CM_Affiliated_Provider_Name__c =:listOfAccount[0].Id])                
            {   
                if(newAffiliation.Account__c == listOfAccount[0].Id && newAffiliation.CM_Affiliated_Provider_Name__r.isPersonAccount){       
                    listOfAffiliatedIds.add(newAffiliation.CM_Affiliated_Provider_Name__c);     
                }       
                if(newAffiliation.CM_Affiliated_Provider_Name__c == listOfAccount[0].Id && newAffiliation.Account__r.isPersonAccount){       
                    listOfAffiliatedIds.add(newAffiliation.Account__c);     
                }       
            }       
        }   
        if(selPFIN !=NULL && selPFIN !='')
        {
            List<Id> listOfAccountIds = new List<Id>();
            try
            {
                List<String> listOfNonBillPfins=new List<String>();
                String temp = null;
                
                if(String.isNotBlank(value))
                {
                    value= '%'+value+'%';
                    List<CM_SPL_Addr__c> lstPfinNo=[select CM_SPL_PFIN_No__c,CM_SPL_Prov__c,CM_SPL_Prov__r.Name from CM_SPL_Addr__c 
                                                    where ( CM_SPL_PFIN_No__c LIKE:value AND CM_SPL_PFIN_No__c !=:selPFIN AND Bill_PFIN__c =:selPFIN 
                                                    AND CM_SPL_Prov__r.CM_Corporate_Entity_Code__c =:listOfAccount[0].CM_Corporate_Entity_Code__c 
                                                    AND (CM_SPL_Prov__c =: listOfAccount[0].Id OR CM_SPL_Prov__c In:listOfAffiliatedIds)) 
                                                    ORDER BY CM_SPL_PFIN_No__c];
                    
                    System.debug('*** What is the value of lstPfinNo size ****'+lstPfinNo.size());
                    for(CM_SPL_Addr__c l:lstPfinNo)    
                    {
                        if(temp!=l.CM_SPL_PFIN_No__c && ((isPersonAccount && l.CM_SPL_Prov__c==acctId) || (!isPersonAccount)))
                        {
                            listOfNonBillPfins.add(l.CM_SPL_PFIN_No__c+'-'+l.CM_SPL_Prov__r.Name);
                        }                   
                        temp = l.CM_SPL_PFIN_No__c;
                    }
                }
                return listOfNonBillPfins;
            }
            catch(Exception e)
            {
                System.debug('Message:='+e.getMessage()+'**Line Number='+e.getLineNumber());
            }
        }
        return null;
    }
    
    /******* PPN-14330 and PPN-14333 Code start*******/
    public static boolean checkNumberOfSelectedBfins(Id accountId, String selectedBfin, List<String> pfinWrapperList)
    {
        system.debug('****** Inside checkNumberOfSelectedBfins --> selPFIN  ****' + selectedBfin);
        system.debug('****** Inside checkNumberOfSelectedBfins --> pfinnumbers****' + pfinWrapperList);
        system.debug('****** Inside checkNumberOfSelectedBfins --> accountId ****' + accountId);
        Boolean isAllNonBfinsSelected = false;       
        // PPN-13808 Changes
        if(selectedBfin != NULL && pfinWrapperList.isEmpty())            
            isAllNonBfinsSelected = true;       
        return isAllNonBfinsSelected ;
    }
    
    /******* PPN-14330 and 14333 Code End*******/
    public PageReference selectChange() 
    { 
        //selPFIN = ''; 
        //Set<String> overAllPfinSet = new Set<String>();
        overAllPfinList= new List<String>();
        stringifiedPFINList = JSON.serializePretty(wrapList);
        System.debug('stringifiedPFINList===>>>'+stringifiedPFINList);
        /******* PPN-14330 and 14333 Code start*******/
        system.debug('****** selPFIN  ****' + selPFIN);
        system.debug('****** accountName ****' + accountName);
        system.debug('****** acctId *****' + acctId);
        system.debug('****** pfinnumberlist****' + pfinnumberlist);
        system.debug('****** Listofallnonbillfins ***');
        Boolean isAllNonBfins = checkNumberOfSelectedBfins(acctId , selPFIN, pfinnumberlist);
        system.debug('**** isAllNonBfins ****' + isAllNonBfins);
        if(isAllNonBfins){            
            overAllPfinList.add(selPFIN+'-'+accountName); 
        }
        if(!pfinnumberlist.isEmpty())
            overAllPfinList.addall(pfinnumberlist);
        else{
            if(selectAllNonBPFINOption != NULL)
            {
                for(SelectOption selectOpt : selectAllNonBPFINOption)
                {                
                    overAllPfinlist.add(selectOpt.getValue());
                }
                //overAllPfinlist.addall(overAllPfinSet);
            }
        }
        
         ManualpageNumber=0;
        totalWrapPageNumber = overAllPfinList.size()/10;
        if(math.mod(overAllPfinList.size(),10)>0)
        {
            totalWrapPageNumber = totalWrapPageNumber+1;
        }
        /******* PPN-14330 and 14333 Code End*******/
        
        if((wrapList !=NULL && !wrapList.isEmpty()) || isRenderRequestPage)
        {
            /******* PPN-13773 Code Starts*******/
            if(isAdmin == true) {
                admChgFlg=true;
            }
            else {
                admChgFlg=false;
            }
            if(isBilling==true) {
                billChgFlg=true;            
            }
            else {
                billChgFlg=false;
            }
            if(isServiceLocation==true)         {
                phyChgFlg=true;
            }
            else {
                phyChgFlg=false;
            }
            Integer endcount=10;
            set<String> setOfAllPfinsToNavigate = new Set<String>(); //Sujatha
            if(overAllPfinList !=NULL && overAllPfinList.size()<1000)
            {
                endCount = overallPfinList.size();
            }
            listOfAllPfinsToNavigate = new List<String>();
            for(Integer count=0;count<endCount;count++)
            {
                setOfAllPfinsToNavigate.add(overAllPfinList[count]);//To avoid duplicate
            }
            listOfAllPfinsToNavigate.addall(setOfAllPfinsToNavigate );
            system.debug('listOfAllPfinsToNavigate----'+listOfAllPfinsToNavigate);
            ManualPageNumber=0;
            /******* PPN-13773 Code Starts*******/
            PageReference pageref= new pagereference('/apex/ManualCaseCreation').setRedirect(false);        
            return pageRef;
        }
        else
        {          
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Choose PFIN'));  
            showData = false;
            return null;           
        }
    }
    /******* PPN-14267 Code End*******/
    public PageReference getPFINList() { 
        if (pFINList.size() > 0){
            showData = true;
            isDisabled = false;
        }else{             
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No PFIN is Found for Account'));
        }
        
        return null;
    }
    
    /**
    * Retrieve all available PFIN Numbers 
    * Determine the Account Business Entity or Person 
    * Fetch By Account ID
    * */
    public List<SelectOption> pFINList {
        get{
            if (acctId!=null && acctId!='' && !isBusinessError){
                pFINListVal     =   [select CM_SPL_PFIN_No__c from CM_SPL_Addr__c where CM_SPL_Prov__c = :acctId AND CM_SPL_Addr_Type__c='Service' ORDER BY CM_SPL_PFIN_No__c];
                pFINList = new List<SelectOption>();
                for(CM_SPL_Addr__c sAddr : pFINListVal)
                {   
                    if (sAddr.CM_SPL_PFIN_No__c!=null && sAddr.CM_SPL_PFIN_No__c!='')
                        pFINList.add(new SelectOption(sAddr.CM_SPL_PFIN_No__c,sAddr.CM_SPL_PFIN_No__c));
                }
                
            }
            return pFINList;
            
        }
        set;
    } 
    
    
    public List<SelectOption> npiOptions {
        get{
            
            try{
                provIdentificationList          =   [select CM_Issu_Ident_Nmbr__c from  CM_Provider_Identification__c where CM_Prvdr_Iden_Typ_Cd__c='NPI' and CM_PI_Prov__c= :acctId and CM_Corporate_Entity_Code__c=:planId];
                npiOptions = new List<SelectOption>();
                npiOptions.add(new SelectOption('','--None--'));
                if (provIdentificationList.size()>0){
                    for(CM_Provider_Identification__c npi : provIdentificationList)
                    {
                        npiOptions.add(new SelectOption(npi.CM_Issu_Ident_Nmbr__c,npi.CM_Issu_Ident_Nmbr__c));
                    }
                }
            }catch(Exception ex){
                System.debug('NPI not found'+ex.getMessage());
            }     
            return npiOptions; 
            
        }
        
        set;
    } 
    
    /**
    * Retrieve Provider Name to prepopulate Current Details
    * Get firstName,lastName,middleName,Suffix & PersonTitle  
    * Fetch By Account ID
    * */
    public account provName {
        get{
            if (actList.IsPersonAccount) {
                account provname =[select  FirstName, LastName, MiddleName,Suffix,PersonTitle from account where id=: acctId];
                nameChg.Last_Name_Current__c = provName.FirstName;
                nameChg.Middle_Initial_Current__c = provName.LastName;
                nameChg.First_Name_Current__c = provName.MiddleName;
                nameChg.Title_Current__c = provName.PersonTitle;
                nameChg.Suffix_Current__c = provName.Suffix;            
                return provname; 
            } 
            else
                return null;
        }
        set;
    } 
    
    
    
    
    /**
    * Fetch Address information to prepopulate Current Details
    * Determine the Account Business Entity or Person 
    * Fetch By PFIN Number and Account ID
    * */
    public void fetchAddressDetails(){
        
        setGovtCaseInd();
        String taxIdNum = '';
        Boolean nonbillpfinSelected = false;//Sujatha PPN-30093,PPN-34625
        String firstnonbillpfin; //Sujatha PPN-30093,PPN-34625
        String pfinNonBillpfin; //Sujatha PPN-30093,PPN-34625
        boolean checkAllnonbpfins;
        caseInfo.Name_of_Provider_Group__c = accountName;
        caseInfo.Rendering_NPI__c = '';
        
        
         //Sujatha PPN-30093,PPN-34625 Starts
          if(selPfin == NULL)
                selPfin = ApexPages.currentPage().getParameters().get('BillPFIN');            
                system.debug('billpfin '+ selPfin );
                system.debug('overAllPfinList size'+overAllPfinList.size());
                List<String> listofallnonbillpfins = new List<String>();
           if( !overAllPfinList.isempty())
           {
               for(String allnonbillpfinAndbfins : overAllPfinList)
               {                  
                   
                   if(allnonbillpfinAndbfins.contains('-'))
                   {
                       pfinNonBillpfin = allnonbillpfinAndbfins.split('-')[0];
                   }
                   else{
                       pfinNonBillpfin = allnonbillpfinAndbfins;
                   }                   
                       system.debug('pfinNonBillpfin '+pfinNonBillpfin );
                       
                   if(selPfin != null && pfinNonBillpfin != null && pfinNonBillpfin != selPfin)
                   {                   
                        listofallnonbillpfins.add(pfinNonBillpfin);
                   
                   } 
                   
               }
               system.debug('listofallnonbillpfins size'+listofallnonbillpfins.size());
           if(!listofallnonbillpfins.isempty() &&listofallnonbillpfins.size() ==1)
           {                       
                  for(String selctedOneNonBillpfin : listofallnonbillpfins)
                  {
                       nonbillpfinSelected = true;                      
                       firstnonbillpfin = selctedOneNonBillpfin ;
                  }
           }
               system.debug('firstnonbillpfin'+firstnonbillpfin);

           }
         //Sujatha PPN-30093,PPN-34625 Ends
        /** Added for PPN:14333 - Starts **/
        system.debug('overAllPfinList'+ overAllPfinList);
        pfinsSelectOption = new List<SelectOption>();
        if(!overAllPfinList.isEmpty()){
            for( String pfinStr : overAllPfinList )
            {
                pfinsSelectOption.add( new SelectOption( pfinStr, pfinStr) );
            }
        }
       
        system.debug('pfinsSelectOption'+ pfinsSelectOption);
        /** Added for PPN:14333 - Ends **/
        try
        {
            
            taxIdsSelectOption = new Set<SelectOption>();
            Set<string> theSelectedValue =new set<string>();
            List<string> theSelectdlistValue =new List<string>();
            strTaxNumber = '';
 
            for(SelectOption so: pfinsSelectOption){
                theSelectedValue.add(so.getValue());
            }

            system.debug('theSelectdlistValue'+theSelectedValue);
            system.debug('selPFIN'+selPFIN);
            AddrTaxId = [select CM_SPL_Prov_Tax_ID__c from CM_SPL_Addr__c where CM_SPL_PFIN_No__c =: selPFIN AND CM_SPL_Prov_Tax_ID__c !=''  LIMIT 1 ];
           
            if (AddrTaxId!=null && AddrTaxId.size()>0){
             system.debug('AddrTaxId'+AddrTaxId.get(0));
                ProvTaxId  = [select CM_PTI_Tax_Id__c from CM_Provider_Tax_Id__c where id=:AddrTaxId.get(0).CM_SPL_Prov_Tax_ID__c LIMIT 1]; 
                system.debug('ProvTaxId'+ProvTaxId);
                if (ProvTaxId!=null && ProvTaxId.size()>0){
                    taxIdNum = ProvTaxId.get(0).CM_PTI_Tax_Id__c;
                    system.debug('taxIdNum'+taxIdNum) ;
                    caseInfo.Tax_ID_Number__c = taxIdNum;
                }               
            }       
        }catch(DmlException ex){
            
        }    
        
        if (npiChgFlg){            
            npiChg.Tax_ID_Num_Current__c = taxIdNum;                
            npiChg.Bill_NPI_Num_Current__c = billNPI;
        }
        
        if (nameChgFlg){
            {
                if (actList.IsPersonAccount) {
                    account provname =[select  FirstName, LastName, MiddleName,Suffix,PersonTitle from account where id=: acctId];
                    nameChg.Last_Name_Current__c = provName.LastName;
                    nameChg.Middle_Initial_Current__c = provName.MiddleName;
                    nameChg.First_Name_Current__c = provName.FirstName;
                    nameChg.Title_Current__c = provName.PersonTitle;
                    nameChg.Suffix_Current__c = provName.Suffix;            
                }else{
                    nameChg.MC_Current_Group_Name__c =accountName;
                } 
                
            }
        }     
        
        /** Added for PPN:14407 - Starts **/
        if (billChgFlg){
            if (selPFIN!=null){                
                List<CM_SPL_Addr__c> billingAddr = [select CM_SPL_Addr_Line_1__c,CM_SPL_Add_Line_2__c,CM_SPL_Addr_Type__c,CM_SPL_City__c,CM_SPL_State__c,CM_SPL_Zip_CD__c,CM_SPL_Email__c,CM_SPL_Mobile_No__c,CM_SPL_Fax_No__c from CM_SPL_Addr__c where CM_SPL_PFIN_No__c = :selPFIN and Bill_PFIN__c = :selPFIN  and CM_SPL_Addr_Type__c='Billing' LIMIT 1];
                system.debug('billingAddr++++++'+billingAddr);
                if(billingAddr!=null && billingAddr.size()>0){
                    billAddrChg.Street_Address_Suite_No_Billing_Current__c = billingAddr.get(0).CM_SPL_Addr_Line_1__c;
                    billAddrChg.Addr_Line_2_Bill_Curr__c = billingAddr.get(0).CM_SPL_Add_Line_2__c;
                    billAddrChg.City_Billing_Current__c = billingAddr.get(0).CM_SPL_City__c;
                    billAddrChg.State_Billing_Current__c = billingAddr.get(0).CM_SPL_State__c;
                    billAddrChg.Zip_Billing_Current__c = billingAddr.get(0).CM_SPL_Zip_CD__c;
                    billAddrChg.Telephone_Billing_Current__c = billingAddr.get(0).CM_SPL_Mobile_No__c;
                    billAddrChg.Email_Billing_Current__c = billingAddr.get(0).CM_SPL_Email__c;
                    billAddrChg.Fax_Billing_Current__c   = billingAddr.get(0).CM_SPL_Fax_No__c;
                    
                }
                
            }     
        }                         
        if (phyChgFlg){
            if (selPFIN!=null){  
                system.debug('selPFIN******************'+selPFIN);
                // Sujatha PPN-30093,PPN-34625 Starts
                List<CM_SPL_Addr__c> serviceLocationAdd = new List<CM_SPL_Addr__c>();
                if(nonbillpfinSelected ==true){                       
                       serviceLocationAdd = [select CM_SPL_Addr_Line_1__c,CM_SPL_Add_Line_2__c,CM_SPL_Addr_Type__c,CM_SPL_City__c,CM_SPL_State__c,CM_SPL_Zip_CD__c,CM_SPL_Email__c,CM_SPL_Mobile_No__c,CM_SPL_Fax_No__c from CM_SPL_Addr__c where CM_SPL_PFIN_No__c = :firstnonbillpfin and  CM_SPL_Addr_Type__c='Service' LIMIT 1];
                       system.debug('NonBilPFIN Address******************'+serviceLocationAdd);

                }
                else{                
                       serviceLocationAdd = [select CM_SPL_Addr_Line_1__c,CM_SPL_Add_Line_2__c,CM_SPL_Addr_Type__c,CM_SPL_City__c,CM_SPL_State__c,CM_SPL_Zip_CD__c,CM_SPL_Email__c,CM_SPL_Mobile_No__c,CM_SPL_Fax_No__c from CM_SPL_Addr__c where CM_SPL_PFIN_No__c = :selPFIN and Bill_PFIN__c = :selPFIN and  CM_SPL_Addr_Type__c='Service' LIMIT 1];
                       system.debug('BilPFIN Address******************'+serviceLocationAdd);

                }
                //Sujatha PPN-30093,PPN-34625 Ends
                system.debug('serviceLocationAdd *****' +serviceLocationAdd);
                if(serviceLocationAdd!=null && serviceLocationAdd.size()>0){
                    system.debug('serviceLocationAdd ####coming' +serviceLocationAdd);
                    phyAddrChg.Street_Address_Suite_No_Physical_current__c = serviceLocationAdd.get(0).CM_SPL_Addr_Line_1__c;
                    phyAddrChg.Addr_Line_2_Phy_Curr__c = serviceLocationAdd.get(0).CM_SPL_Add_Line_2__c;
                    phyAddrChg.City_Physical_Current__c = serviceLocationAdd.get(0).CM_SPL_City__c;
                    phyAddrChg.State_Physical_Current__c = serviceLocationAdd.get(0).CM_SPL_State__c;
                    phyAddrChg.Zip_Physical_Current__c = serviceLocationAdd.get(0).CM_SPL_Zip_CD__c;
                    phyAddrChg.Telephone_Physical_Current__c = serviceLocationAdd.get(0).CM_SPL_Mobile_No__c;
                    phyAddrChg.Email_Physical_Current__c = serviceLocationAdd.get(0).CM_SPL_Email__c;
                    phyAddrChg.Fax_Physical_Current__c = serviceLocationAdd.get(0).CM_SPL_Fax_No__c;
                }
                
            }   
        }

        if (admChgFlg){
            if (selPFIN!=null){                
                List<CM_SPL_Addr__c> adminAdd = [select CM_SPL_Addr_Line_1__c,CM_SPL_Add_Line_2__c,CM_SPL_Addr_Type__c,CM_SPL_City__c,CM_SPL_State__c,CM_SPL_Zip_CD__c,CM_SPL_Email__c,CM_SPL_Mobile_No__c,CM_SPL_Fax_No__c from CM_SPL_Addr__c where CM_SPL_PFIN_No__c = :selPFIN and Bill_PFIN__c = :selPFIN and CM_SPL_Addr_Type__c='Administration' LIMIT 1];
                if(adminAdd!=null && adminAdd.size()>0){
                    admAddrChg.Street_Address_Administrative_Current__c = adminAdd.get(0).CM_SPL_Addr_Line_1__c;
                    admAddrChg.Addr_Line_2_Admin_Curr__c = adminAdd.get(0).CM_SPL_Add_Line_2__c;
                    admAddrChg.City_Administrative_Current__c = adminAdd.get(0).CM_SPL_City__c;
                    admAddrChg.State_Administrative_Current__c = adminAdd.get(0).CM_SPL_State__c;
                    admAddrChg.Zip_Administrative_Current__c = adminAdd.get(0).CM_SPL_Zip_CD__c;
                    admAddrChg.Telephone_Administrative_Current__c = adminAdd.get(0).CM_SPL_Mobile_No__c;
                    admAddrChg.Email_Administrative_Current__c = adminAdd.get(0).CM_SPL_Email__c;
                    admAddrChg.Fax_Administrative_Current__c = adminAdd.get(0).CM_SPL_Fax_No__c;
                }
                
            }   
            
        }
        /** Added for PPN:14407 - ends **/
    }
    
    /*
    * Supports User Story PPN-6320
    * 
    * Set Govt. Program Indicator to Case
    * 
    */  
    public void setGovtCaseInd(){
        List<CM_Network_Codes__c> getAllGovNetworkCodeList = 
            [
                select 
                Network_Code__c
                from 
                CM_Network_Codes__c 
                where
                Plan_id__c = :planId and Network_Code__c in :networkCodesByPFIN(selPFIN)
                and Government_Network_Indicator__c = true
            ];
        if (getAllGovNetworkCodeList.size() > 0)
            caseInfo.Govt_Programs__c = true;
    }
    
    /*
    * Code to support PPN-5342
    * Take in a String list and return a SelectOption list
    */    
    public List<SelectOption> createSelectOptionsFromList(List<String> listOfStrings, boolean includeADefaultNoneOption){
        List<SelectOption> listOfOptions = new List<SelectOption>(); 
        /*if(listOfStrings.size() < 1){
            listOfOptions.add(new SelectOption('None', '---None---'));
        }
        else{ }*/
            if(includeADefaultNoneOption){
                listOfOptions.add(new SelectOption('None', '--None--'));            
            } 
        
        // Updated below part of PPN-20974
        if(!listOfStrings.isEmpty())
        {
           for(String sVal: listOfStrings)
           {
                if(sVal != null){
                    listOfOptions.add(new SelectOption(sVal, sVal));            
                }
            }    
        }
        //listOfOptions.Sort();                                    
       
        return listOfOptions;
    }
    
    /*
    * Code to support PPN-5342,PPN-19365 and PPN-20974
    * Get all networks for a plan id
    */ 
    public List<String> allNetworksExceptUsedByPFIN(List<String> pfinsForQuery, String planId ,String caseMode, String selPfin)
    {
        //PPN-23432
        Set<String> finalPfinsForQuery      =   getFinalPfins( acctId , selPFIN, overAllPfinList );
        Set<String> tStringSet              =   new Set<String>();
        List<CM_Network_Codes__c> tNetworkCodesList =   new List<CM_Network_Codes__c>();
        
        if( caseMode =='Add' || caseMode == 'Change')
        { 
             tNetworkCodesList =    [SELECT id, Network_Code__c,Network_Description__c FROM CM_Network_Codes__c 
                                     WHERE Plan_id__c =:planId  order BY Network_Description__c  ];
        If(!tNetworkCodesList.IsEmpty())
        {
            for(CM_Network_Codes__c tnc: tNetworkCodesList)
            {            
                tStringSet.add(tnc.Network_Description__c);
            }
        }
        }else {
            /*
            * For loop is used to remove the concatenated account name from the pfin so it can be used in the SOQL below
            * EXAMPLE BEFORE: 0IL9988-John Smith     
            * EXAMPLE AFTER : 0IL9988
            */
            List<String> finalPfinsForQueryWithoutAcctName = new List<String>();
            for( String pfinStr : finalPfinsForQuery ) {
                if(pfinStr != null && pfinStr.contains('-')) {
                    Integer indexOfDash = pfinStr.indexOf('-');
                    finalPfinsForQueryWithoutAcctName.add( pfinStr.substring(0,indexOfDash) );
                }
            }
             //PPN-23432
            Set<String> networkCodes            =   new Set<String>();
            List<CM_Network__c> tNetworkList    = [ SELECT CM_Name__c,CM_Network__c,CM_Service_Payee_Location_Address__c FROM CM_Network__c 
                                                  WHERE CM_Service_Payee_Location_Address__c IN 
                                                  (SELECT id FROM CM_SPL_Addr__c WHERE CM_SPL_PFIN_no__C IN:finalPfinsForQueryWithoutAcctName AND CM_Corporate_Entity_Code__c=:planId) 
                                                   AND CM_Network_Status__c='Active' ORDER by CM_Network__c];
                for( CM_Network__c network : tNetworkList )   
                {
                     tStringSet.add( network.CM_Name__c );
                } 
            
            }
            
        return (new List<String>(tStringSet));                
    }   
    
    
    /*
    * Code to support PPN-5342
    * 
    * Get all Remove Network Reasons associated with a plan id
    */     
    public List<String> allRemoveNetworkReasons(String planId){
        List<String> tStringList = new List<String>();
        List<CM_Remove_Network_Reasons__c> tNetworkReasonCodesList = 
            [
                select 
                id, 
                inactive_reason_code__c, 
                inactive_reason_description__c 
                from 
                CM_Remove_Network_Reasons__c 
                where 
                plan_id__c = :planId
                order by
                inactive_reason_description__c 
            ]; 
        for(CM_Remove_Network_Reasons__c tnc: tNetworkReasonCodesList){            
            tStringList.add(tnc.inactive_reason_description__c);
        }
        return tStringList;                       
    }       
    
    /*
    * Code to support PPN-5342
    * 
    * Get all Networks associated with a single PFIN
    * 
    */  
    public List<String> networkCodesByPFIN(String pfinForQuery){
        List<String> tStringList = new List<String>();
        List<CM_Network__c> tNetworkList =                        
            [
                select 
                CM_Network__c, 
                CM_Service_Payee_Location_Address__c 
                from 
                CM_Network__c 
                where 
                CM_Service_Payee_Location_Address__c 
                in 
                (
                    select 
                    id 
                    from 
                    CM_SPL_Addr__c 
                    where 
                    ( CM_SPL_PFIN_no__C = :pfinForQuery OR Bill_PFIN__c = :pfinForQuery) 
                    and 
                    CM_SPL_Prov__c = :acctid 
                    and 
                    CM_Corporate_Entity_Code__c=:planId                                       
                )
                order by
                CM_Network__c
            ];
        
        for(CM_Network__c tnc: tNetworkList){            
            tStringList.add(tnc.CM_Network__c);
        }
        
        return tStringList;
    }
    
    /*
* Code to support PPN-5342
* 
* Get all Networks associated with a single PFIN
* 
*/     
    public List<String> networkDescriptionsFromCodes(String pfinForQuery, String stateVal){
        List<String> tStringList = new List<String>();
        List<CM_Network_Codes__c> tNetworkCodeList =                        
            [
                select 
                network_code__c,
                network_description__c
                from 
                cm_network_codes__c
                where                
                Network_code__c                
                in  
                :networkCodesByPFIN(pfinForQuery) 
                and 
                plan_id__c = :stateVal                  
                order by
                network_description__c
            ];
        for(CM_Network_Codes__c tnc: tNetworkCodeList){            
            tStringList.add(tnc.network_description__c);
        }
        
        return tStringList;
    }    
    
    
    /**
* Method to Validate the Request Category for exception
* Determine the error type
* Throws validation exception.
* */
    public boolean Validate(){        
        boolean error = false; 
        
        if (CaseInfo.Corporate_Received_Date_Time__c == null){
            CaseInfo.Corporate_Received_Date_Time__c.addError(Label.CorpReq);
            error = true;
        }
        
        if (CaseInfo.Corporate_Received_Date_Time__c != null && CaseInfo.Corporate_Received_Date_Time__c > Datetime.now() && !emailToCase ) {
            CaseInfo.Corporate_Received_Date_Time__c.addError(Label.CorpVal);
            error = true;
        }
        
        if (CaseInfo.Telephone_Number_Submitter__c!=null && (CaseInfo.Telephone_Number_Submitter__c.length()<10 || !ValidatePhone(CaseInfo.Telephone_Number_Submitter__c))){
            CaseInfo.Telephone_Number_Submitter__c.addError(Label.PhoneValErrMsg);
            error = true;
        }
        
        if (CaseInfo.Submitter_Phone_Ext__c!=null && !ValidateExtension(CaseInfo.Submitter_Phone_Ext__c)){
            CaseInfo.Submitter_Phone_Ext__c.addError('Invalid Extension number or format.');
            error = true;
        }
        
        if (CaseInfo.Submitter_Phone_Ext__c!=null && CaseInfo.Telephone_Number_Submitter__c==null){
            CaseInfo.Telephone_Number_Submitter__c.addError('Please enter Submitter Phone');
            error = true;
        }
        
        if (CaseInfo.Email_Address_Submitter__c!=null && !validateEmail(CaseInfo.Email_Address_Submitter__c)){
            CaseInfo.Email_Address_Submitter__c.addError('Please enter a valid Email Address.');
            error = true;
        }
        
        system.debug('** nameChgFlg **' + nameChgFlg );
        system.debug('** npiChgFlg  **' + npiChgFlg);
        system.debug('** phyChgFlg  **' + phyChgFlg);
        system.debug('** billChgFlg **' + billChgFlg);
        system.debug('** admChgFlg  **' + admChgFlg);
        system.debug('** removeProvFlg **' + billChgFlg);
        system.debug('** addProvFlg **' + admChgFlg);
        system.debug('** providerIDsFlg **' + providerIDsFlg);
        system.debug('** termPrvChgFlg **' + termPrvChgFlg);
        
        /* PPN-31087 Code Begin */
        if(termPrvChgFlg){
            system.debug('#### termReason ###' + termreason);
             if(termreason == 'None'){
                networkChg.addError('Term Reason cannot be blank');
                error = true;
            }
            else if(termreason == 'Other' && networkChg.Terminate_Prov_Reason_Com__c == NULL){
                networkChg.addError('Please enter Terminate Provider Other Reason Comments');
                error = true;
            }
        }
        /* PPN-31087 Code End*/
        
        if (npiChgFlg){
            if (npiChg.New_Tax_ID_Number__c!=null &&  !npiChg.New_Tax_ID_Number__c.isNumeric()){
                npiChg.New_Tax_ID_Number__c.addError(Label.TaxIdCharErrMsg);
                error = true;   
            }
             if (npiChg.New_Tax_ID_Number__c!=null && npiChg.New_Tax_ID_Number__c.length()<9 ){
                npiChg.New_Tax_ID_Number__c.addError(Label.TaxIdErrMsg);
                error = true;   
            }
            if (npiChg.New_Billing_NPI_Number__c!=null &&  !npiChg.New_Billing_NPI_Number__c.isNumeric()){
                npiChg.New_Billing_NPI_Number__c.addError(Label.BillingNPICharErrMsg);
                error = true;    
            }
            if (npiChg.New_Billing_NPI_Number__c!=null && npiChg.New_Billing_NPI_Number__c.length()<10 ){
                npiChg.New_Billing_NPI_Number__c.addError(Label.BillingNPIErrMsg);
                error = true;    
            }
            if (npiChg.Group_Tax_ID__c!=null &&  !npiChg.Group_Tax_ID__c.isNumeric()){
                npiChg.Group_Tax_ID__c.addError(Label.TaxIdCharErrMsg);
                error = true;   
            }
            if (npiChg.Group_Tax_ID__c!=null && npiChg.Group_Tax_ID__c.length()<9 ){
                npiChg.Group_Tax_ID__c.addError(Label.TaxIdErrMsg);
                error = true;   
            }
            
        }if (phyChgFlg){
            
            
            if (phyAddrChg.Physical_Address_New_Phone_Ext__c!=null && !ValidateExtension(phyAddrChg.Physical_Address_New_Phone_Ext__c)){
                phyAddrChg.Physical_Address_New_Phone_Ext__c.addError('Invalid Extension number or format.');
                error = true;
            }
            
            if (phyAddrChg.Physical_Address_New_Phone_Ext__c!=null && phyAddrChg.Telephone_Physical_New__c==null){
                phyAddrChg.Telephone_Physical_New__c.addError('Please enter New Phone Physical');
                error = true;
            }
                       
            // PPN-29257 starts
            if (phyAddrChg.Telephone_Physical_New__c!=null){
                string phyPhone = phyAddrChg.Telephone_Physical_New__c;
                system.debug('Pattern Matches----Phone'+ phyPhone );
                if((Pattern.matches(RegExp, phyPhone )== false)){
                phyAddrChg.Telephone_Physical_New__c.addError('Invalid Phone number or format.');
                error = true; 
                }
            }
                if(phyAddrChg.Fax_Physical_New__c!= null){
                    string phyFax = phyAddrChg.Fax_Physical_New__c;
                    system.debug('Pattern Matches----Phone'+ phyFax );
                    if((Pattern.matches(RegExp, phyFax )== false)){
                    phyAddrChg.Fax_Physical_New__c.addError(Label.FaxValErrMsg);
                    error = true; 
                    }
                }
             
            // PPN-29257 Ends
            
            if (phyAddrChg.Group_Tax_ID__c!=null &&  !phyAddrChg.Group_Tax_ID__c.isNumeric()){
                phyAddrChg.Group_Tax_ID__c.addError(Label.TaxIdCharErrMsg);
                error = true;   
            }
             if (phyAddrChg.Group_Tax_ID__c!=null && phyAddrChg.Group_Tax_ID__c.length()<9 ){
                phyAddrChg.Group_Tax_ID__c.addError(Label.TaxIdCharErrMsg);
                error = true;   
            }
            
        }if (billChgFlg){
             
            
            if (billAddrChg.Billing_Address_New_Phone_Ext__c!=null &&  !ValidateExtension(billAddrChg.Billing_Address_New_Phone_Ext__c)){
                billAddrChg.Billing_Address_New_Phone_Ext__c.addError('Invalid Extension number or format.');
                error = true;
            }
            
            if (billAddrChg.Billing_Address_New_Phone_Ext__c!=null && billAddrChg.Telephone_Billing_New__c==null){
                billAddrChg.Telephone_Billing_New__c.addError('Please enter New Phone Bill');
                error = true;
            }
             //PPN-29057 Starts
             system.debug('billing@@@@@@@@@@@@@@@@@@@inside VAlidate' + billAddrChg.Telephone_Billing_New__c);
            // PPN-29257 starts
             if(billAddrChg.Telephone_Billing_New__c!= null){
                string billPhone = billAddrChg.Telephone_Billing_New__c;
                system.debug('Pattern Matches----Phone'+ billPhone);
                if((Pattern.matches(RegExp, billPhone)== false)){
                billAddrChg.Telephone_Billing_New__c.addError('Invalid Phone number or format.');
                error = true; 
                }
            }
            if( billAddrChg.Fax_Billing_New__c!= null){
                string billFax = billAddrChg.Fax_Billing_New__c;
                system.debug('Pattern Matches----Phone'+ billFax);
                if((Pattern.matches(RegExp, billFax)== false)){
                billAddrChg.Fax_Billing_New__c.addError(Label.FaxValErrMsg);
                error = true; 
                }
            }
            
            // PPN-29257 Ends
            
            if (billAddrChg.Group_Tax_ID__c!=null &&  !billAddrChg.Group_Tax_ID__c.isNumeric()){
                billAddrChg.Group_Tax_ID__c.addError(Label.TaxIdCharErrMsg);
                error = true;   
            }
            if (billAddrChg.Group_Tax_ID__c!=null && billAddrChg.Group_Tax_ID__c.length()<9 ){
                billAddrChg.Group_Tax_ID__c.addError(Label.TaxIdErrMsg);
                error = true;   
            }
        }if (admChgFlg){
            
            if (admAddrChg.Administrative_Change_New_Phone_Ext__c!=null && !ValidateExtension(admAddrChg.Administrative_Change_New_Phone_Ext__c)){
                admAddrChg.Administrative_Change_New_Phone_Ext__c.addError('Invalid Extension number or format.');
                error = true;
            }
            
            if (admAddrChg.Administrative_Change_New_Phone_Ext__c!=null && admAddrChg.Telephone_Administrative_New__c==null){
                admAddrChg.Telephone_Administrative_New__c.addError('Please enter New Phone Admin');
                error = true;
            }
             //PPN-29057 Starts
             system.debug('Admin@@@@@@@@@@@@@@@@@@@inside VAlidate' + admAddrChg.Telephone_Administrative_New__c);
            // PPN-29257 starts
            if(admAddrChg.Telephone_Administrative_New__c!=null){
                string adminPhone = admAddrChg.Telephone_Administrative_New__c;
                system.debug('Pattern Matches----Phone'+ adminPhone);
                if((Pattern.matches(RegExp, adminPhone)== false)){
                admAddrChg.Telephone_Administrative_New__c.addError('Invalid Phone number or format.');
                error = true; 
                }
            }
            if(admAddrChg.Fax_Administrative_New__c!= null){
                string adminFax = admAddrChg.Fax_Administrative_New__c;
                system.debug('Pattern Matches----Phone'+ adminFax);
                if((Pattern.matches(RegExp, adminFax)== false)){
                admAddrChg.Fax_Administrative_New__c.addError(Label.FaxValErrMsg);
                error = true; 
                }
            }
            
            // PPN-29257 Ends
            if (admAddrChg.Group_Tax_ID__c!=null &&  !admAddrChg.Group_Tax_ID__c.isNumeric()){
                admAddrChg.Group_Tax_ID__c.addError(Label.TaxIdErrMsg);
                error = true;   
            }
            if (admAddrChg.Group_Tax_ID__c!=null && admAddrChg.Group_Tax_ID__c.length()<9 ){
                admAddrChg.Group_Tax_ID__c.addError(Label.TaxIdCharErrMsg);
                error = true;   
            }
        }


        if (removeProvFlg) {
            //PPN-7435 stars
            if (removeProv.Individual_s_Type_1_NPI__c!=null && removeProv.Individual_s_Type_1_NPI__c.length()<10){
                removeProv.Individual_s_Type_1_NPI__c.addError('Invalid NPI - Must be 10 digits');
                error = true;     
            }
            if (removeProv.Individual_s_Type_1_NPI__c!=null &&  !removeProv.Individual_s_Type_1_NPI__c.isNumeric()){
                removeProv.Individual_s_Type_1_NPI__c.addError('Invalid NPI - only numeric characters are allowed');
                error = true;     
            }
           //PPN-7435 ends

        } 
        if (addProvFlg){
            
            if (addProv.Billing_Address_Current_Phone_Ext__c!=null && !ValidateExtension(addProv.Billing_Address_Current_Phone_Ext__c)){
                addProv.Billing_Address_Current_Phone_Ext__c.addError('Invalid Extension number or format.');
                error = true;
            }
            
            if (addProv.Billing_Address_Current_Phone_Ext__c!=null && addProv.New_Phone_add_prov_Bill__c==null){
                addProv.New_Phone_add_prov_Bill__c.addError('Please enter Phone add prov Bill');
                error = true;
            }
            
             if (addProv.Physical_Address_Current_Phone_Ext__c!=null && !ValidateExtension(addProv.Physical_Address_Current_Phone_Ext__c)){
                addProv.Physical_Address_Current_Phone_Ext__c.addError('Invalid Extension number or format.');
                error = true;
            }
            
            if (addProv.Physical_Address_Current_Phone_Ext__c!=null && addProv.New_Phone_add_prov_Phy__c==null){
                addProv.New_Phone_add_prov_Phy__c.addError('Please enter Phone add prov Phy');
                error = true;
            }
            // PPN-24497: Service Addr Validation
            system.debug('***** Inside addProvFlg');
               //PPN-29057 Starts
            system.debug('add@@@@@@@@@@@@@@@@@@@inside VAlidate' + addProv.New_Phone_add_prov_Bill__c);
            // PPN-29257 starts
            if(addProv.New_Phone_add_prov_Bill__c!=null){
                string addProvphyPhone = addProv.New_Phone_add_prov_Bill__c;
                system.debug('Pattern Matches----Phone'+ addProvphyPhone);
                if((Pattern.matches(RegExp, addProvphyPhone)== false)){
                addProv.New_Phone_add_prov_Bill__c.addError('Invalid Phone number or format.');
                error = true; 
                }
            }       
            if(addProv.New_Phone_add_prov_Phy__c!=null){        
                string addProvbillPhone = addProv.New_Phone_add_prov_Phy__c;
                system.debug('Pattern Matches----Phone'+ addProvbillPhone);
                if((Pattern.matches(RegExp, addProvbillPhone)== false)){
                addProv.New_Phone_add_prov_Phy__c.addError('Invalid Phone number or format.');
                error = true; 
                }
            }
            if(addProv.New_Fax_add_prov_Phy__c!= null){
                string addProvphyFax = addProv.New_Fax_add_prov_Phy__c;
                system.debug('Pattern Matches----Phone'+ addProvphyFax);
                if((Pattern.matches(RegExp, addProvphyFax)== false)){
                addProv.New_Fax_add_prov_Phy__c.addError(Label.FaxValErrMsg);
                error = true; 
                }
            }
            if(addProv.New_Fax_add_prov_Bill__c!=null){
                string addProvbillFax = addProv.New_Fax_add_prov_Bill__c;
                system.debug('Pattern Matches----Phone'+ addProvbillFax);
                if((Pattern.matches(RegExp, addProvbillFax)== false)){
                addProv.New_Fax_add_prov_Bill__c.addError(Label.FaxValErrMsg);
                error = true; 
                }
            }
             
            // PPN-29257 Ends
           
             if (addProv.Group_Tax_ID__c!=null &&  !addProv.Group_Tax_ID__c.isNumeric()){
                addProv.Group_Tax_ID__c.addError(Label.TaxIdCharErrMsg);
                error = true;   
            }
            if (addProv.Group_Tax_ID__c!=null && addProv.Group_Tax_ID__c.length()<9 ){
                addProv.Group_Tax_ID__c.addError(Label.TaxIdErrMsg);
                error = true;   
            }
            if (addProv.Medicaid_Number__c != NULL && (addProv.Medicaid_Number__c.length() > 20 ||
                     !addProv.Medicaid_Number__c.isAlphaNumeric())){
                         addProv.Medicaid_Number__c.addError('Invalid Medicaid number');
                         error = true;
                }
                if (addProv.Medicare_Number__c != NULL && (addProv.Medicare_Number__c.length() > 12 ||
                     !addProv.Medicare_Number__c.isAlphaNumeric())){
                         addProv.Medicare_Number__c.addError('Invalid Medicare number');
                         error = true;
                }
                 if (addProv.Group_PFIN__c != NULL && (addProv.Group_PFIN__c.length() > 10 ||
                     !addProv.Group_PFIN__c.isAlphaNumeric())){
                         addProv.Group_PFIN__c.addError('Invalid Group PFIN entered');
                         error = true;
                }
                 if (addProv.Middle_Initial_New__c!= NULL && addProv.Middle_Initial_New__c.length() > 2){
                         addProv.Middle_Initial_New__c.addError('Invalid Middle Initial - should be 1 or 2 characters');
                         error = true;
                }
                //PPN-7435 Starts
                if (addProv.Individual_NPI__c !=null && addProv.Individual_NPI__c.length()<10){
                addProv.Individual_NPI__c.addError('Invalid NPI - Must be 10 digits');
                error = true;     
                }
                if (addProv.Individual_NPI__c !=null &&  !addProv.Individual_NPI__c.isNumeric()){
                addProv.Individual_NPI__c.addError('Invalid NPI - only numeric characters are allowed');
                error = true;     
                }
                if (addProv.Group_NPI__c !=null && addProv.Group_NPI__c.length()<10){
                addProv.Group_NPI__c.addError('Invalid NPI - Must be 10 digits');
                error = true;     
                }
                if (addProv.Group_NPI__c !=null &&  !addProv.Group_NPI__c.isNumeric()){
                addProv.Group_NPI__c.addError('Invalid NPI - only numeric characters are allowed');
                error = true;     
                }
                //PPN-7435 ends
                if (addProv.License_Number__c != NULL && (addProv.License_Number__c.length() > 9 || !addProv.License_Number__c.isAlphanumeric())){
                        addProv.License_Number__c.addError('Invalid License Number');
                        error = true;
                }
                if (addProv.License_OP_Current__c != NULL && (addProv.License_OP_Current__c.length() > 9 || !addProv.License_OP_Current__c.isAlphanumeric())){
                        addProv.License_OP_Current__c.addError('Invalid License Number');
                        error = true;
                }
                if (addProv.License_OP_New__c != NULL && (addProv.License_OP_New__c.length() > 9 || !addProv.License_OP_New__c.isAlphanumeric())){
                        addProv.License_OP_New__c.addError('Invalid License Number');
                       error = true;
                }
                if (addProv.Supervising_Physician_License__c != NULL && (addProv.Supervising_Physician_License__c.length() > 9 ||
                     !addProv.Supervising_Physician_License__c.isAlphaNumeric())){
                         addProv.Supervising_Physician_License__c.addError('Invalid License Number');
                         error = true;
                }          
            
        }   
        if(providerIDsFlg){            
               if(otherProv.License_Number__c != NULL && (otherProv.License_Number__c.length() > 9 || !otherProv.License_Number__c.isAlphanumeric())){
                    otherProv.License_Number__c.addError('Invalid License Number');
                    error = true; 
                }
                if(otherProv.License_OP_Current__c != NULL && (otherProv.License_OP_Current__c.length() > 9 || !otherProv.License_OP_Current__c.isAlphanumeric())){
                        otherProv.License_OP_Current__c.addError('Invalid License Number');
                        error = true; 
                }
                if(otherProv.License_OP_New__c != NULL && (otherProv.License_OP_New__c.length() > 9 || !otherProv.License_OP_New__c.isAlphanumeric())){
                        otherProv.License_OP_New__c.addError('Invalid License Number');
                        error = true; 
                }
                if(otherProv.Supervising_Physician_License__c != NULL && (otherProv.Supervising_Physician_License__c.length() > 9 ||
                     !otherProv.Supervising_Physician_License__c.isAlphaNumeric())){
                         otherProv.Supervising_Physician_License__c.addError('Invalid License Number');
                         error = true;
                } 
                //PPN-7994 starts
                 if(otherProv.Medicaid_Number__c != NULL && (otherProv.Medicaid_Number__c.length() > 20 ||
                     !otherProv.Medicaid_Number__c.isAlphaNumeric())){
                         otherProv.Medicaid_Number__c.addError('Invalid Medicaid number');
                         error = true;
                }
                if(otherProv.Medicare_Number__c != NULL && (otherProv.Medicare_Number__c.length() > 12 ||
                     !otherProv.Medicare_Number__c.isAlphaNumeric())){
                         otherProv.Medicare_Number__c.addError('Invalid Medicare number');
                         error = true;
                }
                if(otherProv.Group_PFIN__c != NULL && (otherProv.Group_PFIN__c.length() > 10 ||
                     !otherProv.Group_PFIN__c.isAlphaNumeric())){
                         otherProv.Group_PFIN__c.addError('Invalid Group PFIN entered');
                         error = true;
                }
                 if(otherProv.Middle_Initial_New__c!= NULL && otherProv.Middle_Initial_New__c.length() > 2){
                         otherProv.Middle_Initial_New__c.addError('Invalid Middle Initial - should be 1 or 2 characters');
                         error = true;
                }
                //PPN-7994 ends
                           
        }    
        return error;
    }

    public class WrapperClassDisplay
    {
        public String pfinNumber{get;set;}
        public Case newCase{get;set;}
        public String selectedOption{get;set;}
        public Boolean isFirstPfin{get;set;}
    }
    
    /***********************************************************************
    * Below code is to get final pfins based on user selection
    * scenario 1 : user selects only bill pfin , method returns only bill pfin
    * Scenario 2 : user selects bill pfin  and cherry pick of non bill pfins, 
    *              method returns only seletced non bill pfins
    * Scenario 3 : user selects bill pfin and all non bill pfins , method will return 
    *              set of both bill and non bill pfin pfins
    *              PPN-23432
    *************************************************************************/
    public Set<String> GetFinalPfins( Id acctId, String selPFIN, List<String> overAllPfinList )
    {
        boolean isAllBilPfinsSelected = checkNumberOfSelectedBfins( acctId , selPFIN, overAllPfinList );
        Set<String> finalPfins  =   new Set<String>();
          if(   !String.isBlank(selPFIN) 
           && !overAllPfinList.isEmpty() 
           && isAllBilPfinsSelected == false
          )
        {
            for(Integer i=0;i<overAllPfinList.size();i++)
            {
                finalPfins.add(overAllPfinList [i]);
            }
            System.debug('111111****=====>>>>>');
            
        }else if( !String.isBlank(selPFIN) 
                 && !overAllPfinList.isEmpty() 
                 && isAllBilPfinsSelected == true
                ){
                    
                    for(Integer i=0;i<overAllPfinList.size();i++)
                    {
                        finalPfins.add(overAllPfinList[i]);
                    }                  
                    finalPfins.add(selPFIN); 
                    System.debug('22222222*****=====>>>>>');
                    
                }else if(!String.isBlank(selPFIN) && overAllPfinList.isEmpty())
                {  
                    System.debug('3333333333*****=====>>>>>');
                    finalPfins.add(selPFIN);
                }
        return finalPfins;
    }
    
    
}