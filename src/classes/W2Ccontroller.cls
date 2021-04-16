/**
* @Author Provider Intake Team
* @@Description -Web Form to Case Controller for Creating Parent and Child Case based on the Case received from Provider
* @Date 10/11/2016
* *
*******************************************************
S.No        ModifiedBy          Description   Modified Date
1.          Jacquline           US# 14013     21-03-2018
2.          Sujatha             PPN 19364     29-06-2018
3.          Andrew              PPN 14244     05-11-2018
4.          Sreekanth           PPN 34681     05/10/2019
*******************************************************/
public class W2Ccontroller {
    
    public Case parentCase = new Case();
    
    /*
    * Define Member variables for Case Information           
    */ 
    public String priority = null;
    public String origin = null;
    
    /*
    * Define Member variables for Provider Indentity Info           
    */    
    public String nameSub{set; get;}
    //PPN-20007
    public String firstnameSub{set; get;}
    public String titleSub{set; get;}
    public String telNumbSub{set; get;}
    public String emailAddrSub{set; get;}
    public String nameOfProvGrp{set; get;}
    public String taxIDNumber{set; get;}
    public String rendNpi{set; get;}
    public String billNPINum{set; get;}
    public String compFormFor{set; get;}
    public String billNPItype{set; get;}   
    public String planId{set;get;}
    
    /*
     * Added below variables part of PPN-34681
     */
    public String  submitterPhoneExt                { set; get; }   
    public string currPhysicalAddressPhoneExt      { set; get; }   
    public string newphysicalAddressPhoneExt       { set; get; } 
    public string currBillingAddressPhoneExt       { set; get; }   
    public string newBillingAddressPhoneExt        { set; get; }   
    public string curCredentialingChangePhoneExt   { set; get; }   
    public string newCredentialingChangePhoneExt   { set; get; }  
    public string newAdminAddressChangePhoneExt    { set; get; }
    public string curAdminAddressChangePhoneExt    { set; get; }
    
    /*
    * Define Member variables for Request Category Selection          
    */   
    public boolean nmChg{set;get;}
    public boolean npiTaxIdChg{set;get;}
    public boolean billAddrChg{set;get;}
    public boolean credAddrChg{set;get;}
    public boolean adminAddrChg{set;get;}
    public boolean phyAddrChg{set;get;}
    public boolean otherProvInfo{set;get;}
    public boolean removeProvGrpLoc{set;get;}
    
    
    
    /*
    * Define Member variables for Name Change Request Category
    */    
    public String fnameCur{set;get;}
    public String lnameCur{set;get;}
    public String fnameNew{set;get;}
    public String lnameNew{set;get;}
    public String midInitialCur{set;get;}
    public String midInitialNew{set;get;}
    public String titleCur{set;get;}
    public String titleNew{set;get;}
    
    public String suffixCur{set;get;}
    public String suffixNew{set;get;}
    public String curPracName{set;get;}
    public String NewPracName{set;get;}    
    public Date effDateofNameChg{set;get;}
    public String commentNameChg{set;get;}
    
    /*
    * Define Member variables for NPI Change Request Category
    */    
    public String newBillNPINum{set;get;}
    public String newTaxIDNum{set;get;}    
    public Date effDateofNPIChg{set;get;}
    public String commentNPITax{set;get;}
    public String taxIDNumCur {set;get;} 
    public String billNPINumCur {set;get;} 
    
    /*
    * Define Member variables for Office Physical Address Change Request Category
    */
    public String StrAddrPhyCur{set;get;}
    public String StrAddr2PhyCur{set;get;}
    public String cityPhyCur{set;get;}
    public String statePhyCur{set;get;}    
    public String zipPhyCur{set;get;}
    public String telPhyCur{set;get;}
    public String emailPhyCur{set;get;}
    public String faxPhyCur{set;get;}
    public String primaryLocPhy{set;get;}
    
    public String strAddrPhyNew{set;get;}
    public String strAddr2PhyNew{set;get;}
    public String cityPhyNew{set;get;}
    public String statePhyNew{set;get;}    
    public String zipPhyNew{set;get;}
    public String telPhyNew{set;get;}
    public String emailPhyNew{set;get;}
    public String faxPhyNew{set;get;}
    public Date effDateofChgPhy{set;get;}
    public String supervisingPhy{set;get;}
    public String acceptNewPat{set;get;}
    public String commentPhy{set;get;}
    public boolean open24Phy{set;get;}
    
    /*
    * Define Member variables for Office Physical Address Hours of Operation Change
    */
    public String monOpen{set;get;}
    public String monClose{set;get;}
    public String tueOpen{set;get;}
    public String tueClose{set;get;}
    public String wedOpen{set;get;}
    public String wedClose{set;get;}
    public String thuOpen{set;get;}
    public String thuClose{set;get;}
    public String friOpen{set;get;}
    public String friClose{set;get;}
    public String satOpen{set;get;}
    public String satClose{set;get;}
    public String sunOpen{set;get;}
    public String sunClose{set;get;}
    
    /* PPN: 12236 and PPN: 14013
    * Define Member variables for Office Physical Address "ADA and Treating Categories" Change
    */
    Public String acordnceWithADA{get;set;}
    
    Public boolean siteAccessible {get;set;}
    Public boolean parkAccesbility {get;set;}
    Public boolean extBuilding{get;set;}
    Public boolean intBuilding{get;set;}
    Public boolean examRoom {get;set;}
    Public boolean examTable{get;set;}
    Public boolean offRecpArea {get;set;}
    Public boolean clsProxmty2PublcTransprt{get;set;}
    Public boolean restroom{get;set;}
    Public boolean scale {get;set;}
    
    
    
    Public boolean homeBound {get;set;}
    Public boolean homeless {get;set;}
    Public boolean blndnesOrVsualyImprd{get;set;}
    Public boolean chroncIlness{get;set;}
    Public boolean srMentalIlness {get;set;}
    Public boolean coOccrDisordr{get;set;}
    Public boolean hivOrAids{get;set;}
    Public boolean phyDisablty{get;set;}
    Public boolean deafOrHrdHear{get;set;}
    
    /*
    * Define Member variables for Credentialling Address Change
    */ 
    public String strAddrCredCur{set;get;}
    public String strAddr2CredCur{set;get;}
    public String cityCredCur{set;get;}
    public String stateCredCur{set;get;}
    public String zipCredCur{set;get;}
    public String telCredCur{set;get;}
    public String emailCredCur{set;get;}
    public String faxCredCur{set;get;}
    public String credConNm{set;get;}
    
    public String strAddrCredNew{set;get;}
    public String strAddr2CredNew{set;get;}
    public String cityCredNew{set;get;}
    public String stateCredNew{set;get;}
    public String zipCredNew{set;get;}
    public String telCredNew{set;get;}
    public String emailCredNew{set;get;}
    public String faxCredNew{set;get;}
    public Date effDateofCredChg{set;get;}
    public String commentCred{set;get;}
    
    /*
    * Define Member variables for Billing Address Current Change
    */ 
    public String strAddrBillCur{set;get;}
    public String strAddr2BillCur{set;get;}
    public String cityBillCur{set;get;}
    public String stateBillCur{set;get;}
    public String zipBillCur{set;get;}
    public String telBillCur{set;get;}
    public String emailBillCur{set;get;}
    public String faxBillCur{set;get;}
    
    /*
    * Define Member variables for Billing Address New Change 
    */ 
    public String strAddrBillNew{set;get;}
    public String strAddr2BillNew{set;get;}
    public String cityBillNew{set;get;}
    public String stateBillNew{set;get;}
    public String zipBillNew{set;get;}
    public String telBillNew{set;get;}
    public String emailBillNew{set;get;}
    public String faxBillNew{set;get;}
    public Date effDateofChgBill{set;get;}
    public String commentBill{set;get;}
    
    /*
    * Define Member variables for Administrative Address Current Change
    */
    public String strAddrAdmCur{set;get;}
    public String strAddr2AdmCur{set;get;}
    public String cityAdmCur{set;get;}
    public String stateAdmCur{set;get;}
    public String zipAdmCur{set;get;}
    public String telAdmCur{set;get;}
    public String emailAdmCur{set;get;}
    public String faxAdmCur{set;get;}
    public String admConNm{set;get;}    
    
    /*
    * Define Member variables for Administrative Address New Change
    */
    public String strAddrAdmNew {set;get;}
    public String strAddr2AdmNew {set;get;}
    public String cityAdmNew{set;get;}
    public String stateAdmNew{set;get;}
    public String zipAdmNew{set;get;}
    public String telAdmNew{set;get;}
    public String emailAdmNew{set;get;}
    public String faxAdmNew{set;get;}
    public Date effDateofChgAdm{set;get;}
    public String commentAdm{set;get;}
    
    /*
    * Define Member variables for Other Provider Info Current 
    */
    public String hospPrivListAll{set; get;}
    public String ambSurCenterPriv{set; get;}
    public String licenseOPCur{set; get;}
    public String specialty{set; get;}
    public String subSpecialtyCur{set; get;}
    public Date speffdateCur{set; get;}
    public Date spcerdateCur{set; get;} 
    public String boardCertified{set; get;}  
    //PPN-19364
    public String ProvideLactationServices{set;get;}  
    public String commentOther{set;get;}
    public Date effDateofChgOth{set;get;}
    
    /*
    * Define Member variables for Other Provider Info New 
    */
    public String hospPrivListAllNew{set; get;}  
    public String ambSurCenterPrivNew{set; get;}
    public String licenseOPNew{set; get;}
    public String specialtyNew{set; get;}
    public String subSpecialtyNew{set; get;}
    public Date speffdateNew{set; get;}
    public Date spcerdateNew{set; get;} 
    public String boardCertifiedNew{set; get;}
    //PPN-19364  
    public String ProvideLactationServicesNew{set;get;}         
    public String langSpokenWritten{set; get;}
    public String medSchoolName{set; get;}
    public Date yearOfGrad{set; get;}
    public String ethnicity{set; get;}
    public String resHospName{set; get;}
    public Date fromOther{set; get;}
    
    
    /*
    * Define Member variables for Remove Provider from Group/Location 
    */
    public string indProvName{set; get;}
    public string indType1NPI{set; get;}
    public string otherId{set; get;}
    public Boolean remFrmAllLoc{set; get;}
    public string reasonleavgrpAll{set; get;}
    public Date effDateofTrmProvGrpAll{set;get;}
    public string strAddProvGrp{set; get;}
    public string strAdd1ProvGrp{set; get;}
    public string cityProvGrp{set; get;}
    public string stateProvGrp{set; get;}
    public string zipProvGrp{set; get;}
    public string reasonleavgrp{set; get;}
    public Date effDateofTrmProvGrp{set;get;}
    public string commProvGrp{set; get;}
    public Boolean attProvGrp{set; get;}
    public Boolean addLocProvGrp{set; get;} //added to track "Add another location for removal” check box
    public string strAddProvGrp1{set; get;}
    public string strAdd1ProvGrp1{set; get;}
    public string cityProvGrp1{set; get;}
    public string stateProvGrp1{set; get;}
    public string zipProvGrp1{set; get;}
    public string reasonleavgrp1{set; get;}
    public Date effDateofTrmProvGrp1{set;get;}
    public Boolean excelAttached{ set; get;}  //added to track whether Excel spreadsheet was attached to Remove Provider section
    
    public Date toOther{set; get;}
    public String dEA{set; get;}
    public Date dateOfBirth{set; get;}
    public Date dEAExpirationDate{set; get;}
    
    public String caseNumber{set;get;}  
    public String slaDays{set;get;}  
    
    /*
    * Define variables for use with Captcha
    */ 
    public String isCaptchaEnabled{set;get;}
    public String captchaPublicKey{set;get;}
    public Boolean useCaptcha{set;get;}
    /*
    * Set Govt. Program  
    */
    public boolean govtPrg = false;
    /*
    * Retreives Web Case related Custom Object Values 
    */    
    Web2Case__c webOrgVal = Web2Case__c.getValues('Origin');
    Web2Case__c webPrtyVal = Web2Case__c.getValues('Priority');
    Web2Case__c slaMT = Web2Case__c.getValues('MT_SLA');
    Web2Case__c sla = Web2Case__c.getValues('SLA_Days');
    
    Map<Integer, Case> mapChildCase = new Map<Integer, Case>();
    
    //Add attachment variables to support multiple attachments on each request type
    //ppn-14244
    /*
     * added because we were not able to deploy to Dry Run without this change. SF kept reporting compile error, even after
     * recompiling on UAT and DR.
     * 
    public Attachment nmAttach{set; get;}
    */
    public Attachment nmAttach1{set; get;}
    public Attachment nmAttach2{set; get;}
    public Attachment nmAttach3{set; get;}
    public Attachment nmAttach4{set; get;}
    public Attachment nmAttach5{set; get;}
    
    public Attachment npiAttach1{set; get;}
    public Attachment npiAttach2{set; get;}
    public Attachment npiAttach3{set; get;}
    public Attachment npiAttach4{set; get;}    
    public Attachment npiAttach5{set; get;}
    
    public Attachment phyAttach1{set; get;}
    public Attachment phyAttach2{set; get;}
    public Attachment phyAttach3{set; get;}
    public Attachment phyAttach4{set; get;}
    public Attachment phyAttach5{set; get;}
    
    
    public Attachment billAttach1{set; get;}
    public Attachment billAttach2{set; get;}
    public Attachment billAttach3{set; get;}
    public Attachment billAttach4{set; get;}
    public Attachment billAttach5{set; get;}
    
    public Attachment credAttach1{set; get;}
    public Attachment credAttach2{set; get;}
    public Attachment credAttach3{set; get;}
    public Attachment credAttach4{set; get;}
    public Attachment credAttach5{set; get;}
    
    public Attachment admAttach1{set; get;}
    public Attachment admAttach2{set; get;}
    public Attachment admAttach3{set; get;}
    public Attachment admAttach4{set; get;}
    public Attachment admAttach5{set; get;}
    
    public Attachment otherAttach1{set; get;}
    public Attachment otherAttach2{set; get;}
    public Attachment otherAttach3{set; get;}
    public Attachment otherAttach4{set; get;}
    public Attachment otherAttach5{set; get;}
    
    public Attachment removeGrpAttach1{set; get;}
    public Attachment removeGrpAttach2{set; get;}
    public Attachment removeGrpAttach3{set; get;}
    public Attachment removeGrpAttach4{set; get;}
    public Attachment removeGrpAttach5{set; get;}
    
    List<CM_SPL_Addr__c> addr;
    
    
    
    
    private void initForTesting()
    {
        firstnameSub = 'First'; 
        nameSub = 'Last';
        telNumbSub = '9992223333';
        titleSub = 'Test Title';
        emailAddrSub = 'test@test.com';
        nameOfProvGrp = 'Test Prov Grp';
        taxIdNumber = '999999999';
        billNPINum = '1111111111';    
        
    }
    
    //Initialize All Attachment variables.
    //PPN-14244
    private void initAttachments()
    {
        nmAttach1 = new Attachment();
        nmAttach2 = new Attachment();
        nmAttach3 = new Attachment();
        nmAttach4 = new Attachment();
        nmAttach5 = new Attachment();
        
        npiAttach1 = new Attachment();
        npiAttach2 = new Attachment();
        npiAttach3 = new Attachment();
        npiAttach4 = new Attachment();    
        npiAttach5 = new Attachment();
        
        phyAttach1 = new Attachment();
        phyAttach2 = new Attachment();
        phyAttach3 = new Attachment();
        phyAttach4 = new Attachment();
        phyAttach5 = new Attachment();
        
        
        billAttach1 = new Attachment();
        billAttach2 = new Attachment();
        billAttach3 = new Attachment();
        billAttach4 = new Attachment();
        billAttach5 = new Attachment();
        
        credAttach1 = new Attachment();
        credAttach2 = new Attachment();
        credAttach3 = new Attachment();
        credAttach4 = new Attachment();
        credAttach5 = new Attachment();
        
        admAttach1 = new Attachment();
        admAttach2 = new Attachment();
        admAttach3 = new Attachment();
        admAttach4 = new Attachment();
        admAttach5 = new Attachment();
        
        otherAttach1 = new Attachment();
        otherAttach2 = new Attachment();
        otherAttach3 = new Attachment();
        otherAttach4 = new Attachment();
        otherAttach5 = new Attachment();
        
        removeGrpAttach1 = new Attachment();
        removeGrpAttach2 = new Attachment();
        removeGrpAttach3 = new Attachment();
        removeGrpAttach4 = new Attachment();
        removeGrpAttach5 = new Attachment();  
    }
    
    
    public W2Ccontroller(){
        
        //initForTesting();
        
        //Initialize all attachment variables
        //PPN-14244
        initAttachments();
        
        System.debug('Anand');
        
        /*
        * Initialize Captcha configurations
        */
        setUpCaptcha();    
        
        /*
        *  Default to false for Remove Provider, Excel Attached
        */ 
        excelAttached = false; 
        
        /**
        * Reset "ADA" & "Treating Categories" - PPN:12236,14013
        * */
        acordnceWithADA = 'No';
        resetADA();
        resetTreatingCatgries();
    }  
    
    /*
    * saveProvInfo method is invoked when Submit Button is clicked in DemographicUpdate Webform 
    */  
    public Pagereference saveProvInfo(){   
        system.debug('siteAccessible'+siteAccessible ); 
        PageReference pageRef= new PageReference('/confirm');       
        if (this.useCaptcha){
            if(!(new reCaptcha()).verify()){
                String message = 'Captcha process encountered an error';              
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, message));            
                return page.captchaFail;                        
            }   
        }        
        
        try {
            
            if (webPrtyVal!=null || webOrgVal!=null){
                priority = webPrtyVal.CaseObjectValues__c;
                origin = webOrgVal.CaseObjectValues__c;
            }
            
            createParentCase();          
            insert parentCase;
        }catch(Exception ex){
            System.debug('The following exception has occurred in createParentCase: ' + ex.getMessage());
        }
        
        try{
            
            createChildCase(parentCase);     
            insert mapChildCase.values();             
            doFileAttachment();
            Case cNum =[select id, CaseNumber from Case where id=:parentCase.id];
            caseNumber= cNum.CaseNumber;
            
            System.debug('*****Case Number*****'+ cNum.CaseNumber);             
            if (parentCase.Plan_ID__c=='MT1'){
                slaDays = slaMT.CaseObjectValues__c;
            }else{
                slaDays = sla.CaseObjectValues__c;
            }
            
            pageRef.getParameters().put('caseNumber', caseNumber); 
            pageRef.getParameters().put('slaDays', slaDays); 
            pageRef.getParameters().put('planId', planId); 
            
            
        }catch(Exception ex){
            System.debug('The following exception has occurred in createChildCase: ' + ex.getMessage());
        }
        
        return pageRef;
    }
    
    
    //Set attatchment bodies to null
    //PPN-14244
    private void setAttachmentBodyToNull(Attachment a1, Attachment a2, Attachment a3, Attachment a4, Attachment a5)
    {
        a1.Body = null;
        a2.Body = null;
        a3.Body = null;
        a4.Body = null;
        a5.Body = null;
    }
    
    //Set attatchment bodies to null
    //PPN-14244
    public void resetNPIChg()
    {      
        newBillNPINum='';
        newTaxIDNum='';   
        effDateofNPIChg=null;
        commentNPITax='';
        taxIDNumCur= '';
        billNPINumCur=''; 
        setAttachmentBodyToNull(npiAttach1, npiAttach2, npiAttach3, npiAttach4,npiAttach5);
    }
    
    public void resetBillChg()
    {        
        strAddrBillCur='';
        strAddr2BillCur='';
        cityBillCur='';
        stateBillCur='';
        zipBillCur='';
        telBillCur='';
        emailBillCur='';
        faxBillCur='';
        strAddrBillNew='';
        
        strAddr2BillNew='';
        cityBillNew='';
        stateBillNew='';
        zipBillNew='';
        telBillNew='';
        emailBillNew='';
        faxBillNew='';
        effDateofChgBill=null;
        commentBill='';
        setAttachmentBodyToNull(billAttach1, billAttach2, billAttach3, billAttach4,billAttach5);      
    }
    public void resetCredChg()
    {
        strAddrCredCur='';
        strAddr2CredCur='';
        cityCredCur='';
        stateCredCur='';
        zipCredCur='';
        telCredCur='';
        emailCredCur='';
        faxCredCur='';
        credConNm='';
        
        strAddrCredNew='';
        strAddr2CredNew='';
        cityCredNew='';
        stateCredNew='';
        zipCredNew='';
        telCredNew='';
        emailCredNew='';
        faxCredNew='';
        effDateofCredChg=null;
        commentCred=''; 
        setAttachmentBodyToNull(credAttach1, credAttach2, credAttach3, credAttach4, credAttach5);    
    }
    public void resetOffPhyChg()
    {        
        StrAddrPhyCur='';
        StrAddr2PhyCur='';
        cityPhyCur='';
        statePhyCur='';    
        zipPhyCur='';
        telPhyCur='';
        currPhysicalAddressPhoneExt =   null;
        newphysicalAddressPhoneExt  =   null;
        emailPhyCur='';
        faxPhyCur='';
        primaryLocPhy='';
        strAddrPhyNew='';
        strAddr2PhyNew='';
        cityPhyNew='';
        statePhyNew='';   
        zipPhyNew='';
        telPhyNew='';
        emailPhyNew='';
        faxPhyNew='';
        effDateofChgPhy=null;
        supervisingPhy='';
        acceptNewPat='';
        commentPhy='';
        open24Phy=false;   
        setAttachmentBodyToNull(phyAttach1, phyAttach2, phyAttach3, phyAttach4,phyAttach5);  
    }
    
    public void resetHours(){
        monOpen='';
        tueOpen='';
        wedOpen='';
        thuOpen='';
        friOpen='';
        satOpen='';
        sunOpen='';
        monClose='';
        tueClose='';
        wedClose='';
        thuClose='';
        friClose='';
        satClose='';
        sunClose='';     
    }
    public void resetAdmChg(){        
        strAddrAdmCur='';
        strAddr2AdmCur='';
        cityAdmCur='';
        stateAdmCur='';
        zipAdmCur='';
        telAdmCur='';
        emailAdmCur='';
        faxAdmCur='';
        admConNm='';    
        
        strAddrAdmNew='';
        strAddr2AdmNew='';
        cityAdmNew='';
        stateAdmNew='';
        zipAdmNew='';
        telAdmNew='';
        emailAdmNew='';
        faxAdmNew='';
        effDateofChgAdm=null;
        commentAdm='';  
        setAttachmentBodyToNull(admAttach1, admAttach2, admAttach3, admAttach4,admAttach5);   
        
    }
    public void resetNameChg(){        
        fnameCur='';
        lnameCur='';
        fnameNew='';
        lnameNew='';
        midInitialCur='';
        midInitialNew='';
        titleCur='';
        titleNew='';    
        suffixCur='';
        suffixNew='';
        curPracName='';
        NewPracName='';    
        effDateofNameChg=null;
        commentNameChg='';     
        setAttachmentBodyToNull(nmAttach1, nmAttach2, nmAttach3, nmAttach4,nmAttach5);    
    }
    
    public void resetOtherPrvChg(){        
        hospPrivListAll='';
        ambSurCenterPriv='';
        licenseOPCur='';
        specialty='';
        subSpecialtyCur='';
        speffdateCur=null;
        spcerdateCur=null; 
        boardCertified=''; 
        //PPN-19364
        ProvideLactationServices='';
        commentOther='';
        effDateofChgOth=null;
        
        hospPrivListAllNew=''; 
        ambSurCenterPrivNew='';
        licenseOPNew='';
        specialtyNew='';
        subSpecialtyNew='';
        speffdateNew=null;
        spcerdateNew=null; 
        boardCertifiedNew='';
        //PPN-19364 
        ProvideLactationServicesNew='';         
        langSpokenWritten='';
        medSchoolName='';
        yearOfGrad=null;
        ethnicity='';
        resHospName='';
        fromOther=null;    
        setAttachmentBodyToNull(otherAttach1, otherAttach2, otherAttach3, otherAttach4, otherAttach5);  
        
    }
    public void resetProvGrp(){
        indProvName = '';
        indType1NPI = '';
        otherId = '';
        remFrmAllLoc = false;      
        commProvGrp = '';
        attProvGrp = false;
        addLocProvGrp = false;        
        resetAdLoc();
        resetAdLoc2();
        setAttachmentBodyToNull(removeGrpAttach1, removeGrpAttach2, removeGrpAttach3, removeGrpAttach4,removeGrpAttach5); 
        excelAttached = false;        
    }
    
    public void resetAdLoc(){
        strAddProvGrp = '';
        strAdd1ProvGrp = '';
        cityProvGrp = '';
        stateProvGrp = '';
        zipProvGrp = '';
        reasonleavgrp = '';
        effDateofTrmProvGrp = null;
        
        
    }
    public void resetAdLoc2(){
        strAddProvGrp1 = '';
        strAdd1ProvGrp1 = '';
        cityProvGrp1 = '';
        stateProvGrp1 = '';
        zipProvGrp1 = '';
        reasonleavgrp1 = '';
        effDateofTrmProvGrp1=null;
    }
    
    /**
    * Reset "ADA" & "Treating Categories" - PPN:12236,14013
    * */
    public void resetADA(){
        
        siteAccessible = false;
        parkAccesbility = false;
        extBuilding = false;
        intBuilding = false;
        examRoom  = false;
        examTable = false;
        offRecpArea  = false;
        clsProxmty2PublcTransprt = false;
        restroom = false;
        scale  = false;
    }
    
    public void resetTreatingCatgries(){
        homeBound  = false;
        homeless  = false;
        blndnesOrVsualyImprd = false;
        chroncIlness = false;
        srMentalIlness  = false;
        coOccrDisordr = false;
        hivOrAids = false;
        phyDisablty = false;
        deafOrHrdHear = false;
    }
    
    public void resetFields(){        
        if(!nmChg)
            resetNameChg();
        if(!npiTaxIdChg)
            resetNPIChg();
        if(!PhyAddrChg)
            resetOffPhyChg();
        if(!BillAddrChg)
            resetBillChg();
        if(!CredAddrChg)
            resetCredChg();
        if(!AdminAddrChg)
            resetAdmChg();
        if(!OtherProvInfo)            
            resetOtherPrvChg(); 
        if(!removeProvGrpLoc)            
            resetProvGrp();
    }
    
    /**
    * Create Master Case with Demographic Provider Information and Work Item based on Request Category Selection
    * */
    public void createParentCase(){     
        
        System.debug('Add another location for removal = ' + addLocProvGrp);
        
        /**
        * If the Remove Provider section has an Excel spreadsheet attached, set the excelAttached variable to true,
        * otherwise it will be committed as false.
        */
        if(removeGrpAttach1.Body != null){             
            excelAttached = true;         
        }        
        
        checkHrs();      
        if (!addLocProvGrp){            
            resetAdLoc2();
        }if (remFrmAllLoc){
            addLocProvGrp = false;
            resetAdLoc();
            resetAdLoc2();
        }if (!remFrmAllLoc){
            reasonleavgrpAll = '';
            effDateofTrmProvGrpAll=null;   
        }
        parentCase.Plan_ID__c = planId;
        assignAccount();
        setGovtCaseInd();
        parentCase.Govt_Programs__c = govtPrg;
        parentCase.Priority = priority;
        parentCase.Plan_Id_Validation_By_Pass__c = true;
        parentCase.Origin = origin;
        parentCase.Completing_the_form_for__c=compFormFor;
        parentCase.Email_Address_Submitter__c=emailAddrSub;
        parentCase.First_Name_Web__c = firstnameSub;//PPN-20007
        parentCase.Name_Submitter__c = firstnameSub + ' ' + nameSub;
        parentCase.Title_Submitter__c = titleSub;
        parentCase.Telephone_Number_Submitter__c = telNumbSub;
        System.debug('submitterPhoneExt====>>>>'+submitterPhoneExt);
        parentCase.Submitter_Phone_Ext__c = submitterPhoneExt;
        System.debug('parentCase.Submitter_Phone_Ext__c ====>>>>'+parentCase.Submitter_Phone_Ext__c ); 
        parentCase.Name_of_Provider_Group__c = nameOfProvGrp;
        parentCase.Tax_ID_Number__c = taxIDNumber;
        parentCase.Rendering_NPI__c = rendNpi;
        parentCase.Billing_NPI_Number__c = billNPINum;  
        parentCase.Bill_NPI_Type__c=billNPItype;  
        parentCase.Original_Creation_Date__c=System.now();
        
        parentCase.Name_Change__c = nmChg;
        parentCase.NPI_Tax_Id_Change__c = npiTaxIdChg;
        parentCase.Office_Physical_Address_Telephone_Fax_Em__c = PhyAddrChg; 
        parentCase.Billing_Address_Telephone_Fax_Email_Chan__c = BillAddrChg;
        parentCase.Credentialing_Address_Telephone_Fax_Emai__c = CredAddrChg;
        parentCase.Administrative_Address_Telephone_Fax_Ema__c= AdminAddrChg;           
        parentCase.Other_provider_Info__c=OtherProvInfo;
        
        if (nmChg){
            parentCase.Name_Change__c = nmChg;
            parentCase.First_Name_Current__c= fnameCur;
            parentCase.First_Name_New__c= fnameNew;
            parentCase.Last_Name_Current__c= lnameCur;
            parentCase.Last_Name_New__c= lnameNew;
            parentCase.Middle_Initial_Current__c=midInitialCur;
            parentCase.Middle_Initial_New__c=midInitialNew;
            parentCase.Title_Current__c=titleCur;
            parentCase.Suffix_Current__c=suffixCur;
            parentCase.Current_Practice_Name__c=curPracName;
            parentCase.Title_New__c=titleNew;
            parentCase.New_Practice_Name__c=newPracName;
            parentCase.Effective_Date_of_Change_Name__c=effDateofNameChg;
            parentCase.Comments_Name_Change__c=commentNameChg;
            parentCase.Suffix_New__c=suffixNew;
            
        }if (npiTaxIdChg){
            parentCase.NPI_Tax_Id_Change__c = npiTaxIdChg;
            parentCase.Bill_NPI_Num_Current__c= billNPINumCur; 
            parentCase.Tax_ID_Num_Current__c = taxIDNumCur;
            parentCase.New_Tax_ID_Number__c=newTaxIDNum;
            parentCase.New_Billing_NPI_Number__c=newBillNPINum;
            parentCase.Comments_NPI_Tax__c=commentNPITax;
            parentCase.Effective_Date_of_Change_NPI_Tax__c=effDateofNPIChg;        
        }if (PhyAddrChg){
            parentCase.Office_Physical_Address_Telephone_Fax_Em__c = PhyAddrChg;
            parentCase.Street_Address_Suite_No_Physical_current__c= strAddrPhyCur;
            parentCase.Addr_Line_2_Phy_Curr__c=strAddr2PhyCur;
            parentCase.City_Physical_Current__c=cityPhyCur;
            parentCase.State_Physical_Current__c=statePhyCur;
            parentCase.Zip_Physical_Current__c=zipPhyCur;
            parentCase.Telephone_Physical_Current__c=TelPhyCur;
            parentCase.Email_Physical_Current__c=emailPhyCur;
            parentCase.Fax_Physical_Current__c=faxPhyCur;
            parentCase.Accepting_New_Patients__c=AcceptNewPat;
            parentCase.Street_Address_Suite_No_Physical_New__c=strAddrPhyNew;
            parentCase.Addr_Line_2_Phy_New__c=strAddr2PhyNew;
            parentCase.City_Physical_New__c=cityPhyNew;
            parentCase.State_Physical_New__c=statePhyNew;
            parentCase.Zip_Physical_New__c=zipPhyNew;
            parentCase.Telephone_Physical_New__c=telPhyNew;
            parentCase.Email_Physical_New__c=emailPhyNew;
            parentCase.Fax_Physical_New__c=faxPhyNew;
            parentCase.Primary_Location_Physical__c=PrimaryLocPhy;
            parentCase.Supervising_Physician__c=SupervisingPhy;
            parentCase.Effective_Date_of_Change_Physical__c=effDateofChgPhy;
            parentCase.Open_24__c=open24Phy;      
            parentCase.Comm_Phy__c=commentPhy;
            parentCase.Mon_Open__c=monOpen;
            parentCase.Tue_Open__c=tueOpen;
            parentCase.Wed_Open__c=wedOpen;
            parentCase.Thu_Open__c=thuOpen;
            parentCase.Fri_Open__c=friOpen;
            parentCase.Sat_Open__c=satOpen;
            parentCase.Sun_Open__c=sunOpen;
            parentCase.Mon_Close__c=monClose;
            parentCase.Tue_Close__c=tueClose;
            parentCase.Wed_Close__c=wedClose;
            parentCase.Thu_Close__c=thuClose;
            parentCase.Fri_Close__c=friClose;
            parentCase.Sat_Close__c=satClose;
            parentCase.Sun_Close__c=sunClose; 
            //parentCase.Physical_Address_Current_Phone_Ext__c    =   String.valueOf(currPhysicalAddressPhoneExt); 
            //parentCase.Physical_Address_New_Phone_Ext__c        =   String.valueOf(newphysicalAddressPhoneExt); 
            parentCase.Physical_Address_Current_Phone_Ext__c = currPhysicalAddressPhoneExt; 
            parentCase.Physical_Address_New_Phone_Ext__c  =   newphysicalAddressPhoneExt; 
            System.debug('currPhysicalAddressPhoneExt===>>>'+currPhysicalAddressPhoneExt);
            System.debug('newphysicalAddressPhoneExt===>>>'+newphysicalAddressPhoneExt);
            
        /**
        * Adding ADA and Treating Categories Section PPN:12236 & 14013
        * */
            
            if(acordnceWithADA=='Yes')
            {
                parentCase.Site_Acce__c=siteAccessible;
                parentCase.Parking_Accessbility__c=parkAccesbility;
                parentCase.Exterior__c=extBuilding;
                parentCase.Interior_Building__c=intBuilding;
                parentCase.Exam_Room__c=examRoom;
                parentCase.Exam_Table__c=examTable;
                parentCase.Office_Reception_Area__c=offRecpArea;
                parentCase.Close_Proximity_to_Public_Transportation__c=clsProxmty2PublcTransprt;
                parentCase.Restroom__c=restroom;
                parentCase.Scale__c=scale; 
                parentCase.Homebound__c=homeBound;
                parentCase.Homeless__c=homeless;
                parentCase.Blindness_or_Visually_Impaired__c=blndnesOrVsualyImprd;
                parentCase.Chronic_Illness__c=chroncIlness;
                parentCase.Serious_Mental_Illness__c=srMentalIlness;
                parentCase.Co_Occurring_Disorders__c=coOccrDisordr;
                parentCase.HIV_AIDS__c=hivOrAids;
                parentCase.Physical_Disabilities__c=phyDisablty;
                parentCase.Deafness_Or_Hard_Of_Hearing__c=deafOrHrdHear; 
            }
            else{
                resetADA();
                resetTreatingCatgries();
            }
        }if (BillAddrChg){   
            parentCase.Billing_Address_Telephone_Fax_Email_Chan__c = BillAddrChg;
            parentCase.Street_Address_Suite_No_Billing_Current__c= strAddrBillCur;
            parentCase.Addr_Line_2_Bill_Curr__c= strAddr2BillCur; 
            parentCase.City_Billing_Current__c=cityBillCur;
            parentCase.State_Billing_Current__c=stateBillCur;
            parentCase.Zip_Billing_Current__c=zipBillCur;
            parentCase.Telephone_Billing_Current__c=TelBillCur;
            parentCase.Email_Billing_Current__c=emailBillCur;
            parentCase.Fax_Billing_Current__c=faxBillCur;
            parentCase.Street_Address_Suite_No_Billing_New__c=strAddrBillNew;
            parentCase.Addr_Line_2_Bill_New__c=strAddr2BillNew;
            parentCase.City_Billing_New__c=cityBillNew;
            parentCase.State_Billing_New__c=stateBillNew;
            parentCase.Zip_Billing_New__c=zipBillNew;
            parentCase.Telephone_Billing_New__c=telBillNew;
            parentCase.Email_Billing_New__c=emailBillNew;
            parentCase.Fax_Billing_New__c=faxBillNew;
            parentCase.Effective_Date_of_Change_Billing__c=EffDateofChgBill;
            parentCase.Comments_Billing__c=CommentBill;
            parentCase.Billing_Address_Current_Phone_Ext__c     =  currBillingAddressPhoneExt;
            parentCase.Billing_Address_New_Phone_Ext__c         =  newBillingAddressPhoneExt;
            
        }if(CredAddrChg){ 
            parentCase.Credentialing_Address_Telephone_Fax_Emai__c = CredAddrChg;
            parentCase.Street_Address_Suite_Credential_Current__c= StrAddrCredCur;
            parentCase.Addr_Line_2_Cred_Curr__c= StrAddr2CredCur;
            parentCase.City_Credential_Current__c=cityCredCur;
            parentCase.State_Credential_Current__c=stateCredCur;
            parentCase.Zip_Credential_Current__c=zipCredCur;
            parentCase.Telephone_Credential_Current__c=telCredCur;
            parentCase.Email_Credential_Current__c=emailCredCur;
            parentCase.Fax_Credential_Current__c=faxCredCur;
            parentCase.Street_Address_Suite_Credential_New__c=strAddrCredNew;
            parentCase.Addr_Line_2_Cred_New__c= StrAddr2CredNew;
            parentCase.City_Credential_New__c=cityCredNew;
            parentCase.State_Credential_New__c=stateCredNew;
            parentCase.Zip_Credential_New__c=zipCredNew;
            parentCase.Telephone_Credential_New__c=TelCredNew;
            parentCase.Email_Credential_New__c=emailCredNew;
            parentCase.Fax_Credential_New__c=faxCredNew;
            parentCase.Effective_Date_of_Change_Credential__c=effDateofCredChg;
            parentCase.Comments_Credential__c=commentCred;
            parentCase.Cred_Cont_Name__c=credConNm;
            parentCase.Credentialing_Change_New_Phone_Ext__c        =  curCredentialingChangePhoneExt;
            parentCase.Credentialing_Change_Current_Phone_Ext__c    =  newCredentialingChangePhoneExt;
            System.debug('curCredentialingChangePhoneExt=====>>>>'+curCredentialingChangePhoneExt);
             System.debug('newCredentialingChangePhoneExt=====>>>>'+newCredentialingChangePhoneExt);
        }if (adminAddrChg){      
            parentCase.Administrative_Address_Telephone_Fax_Ema__c= adminAddrChg;
            parentCase.Street_Address_Administrative_Current__c= strAddrAdmCur;
            parentCase.Addr_Line_2_Admin_Curr__c= strAddr2AdmCur;
            parentCase.City_Administrative_Current__c=cityAdmCur;
            parentCase.State_Administrative_Current__c=stateAdmCur;
            parentCase.Zip_Administrative_Current__c=zipAdmCur;
            parentCase.Telephone_Administrative_Current__c=telAdmCur;
            parentCase.Email_Administrative_Current__c=emailAdmCur;
            parentCase.Fax_Administrative_Current__c=faxAdmCur;
            parentCase.Street_Address_Administrative_New__c=StrAddrAdmNew;
            parentCase.Addr_Line_2_Admin_New__c= strAddr2AdmNew;
            parentCase.City_Administrative_New__c=cityAdmNew;
            parentCase.State_Administrative_New__c=stateAdmNew;
            parentCase.Zip_Administrative_New__c=zipAdmNew;
            parentCase.Telephone_Administrative_New__c=telAdmNew;
            parentCase.Email_Administrative_New__c=emailAdmNew;
            parentCase.Fax_Administrative_New__c=faxAdmNew;
            parentCase.Effective_Date_of_Change_Administrative__c=effDateofChgAdm;
            parentCase.Comments_Administrative__c=commentAdm;
            parentCase.Admin_Cont_Name__c=admConNm;
            parentCase.Administrative_Change_New_Phone_Ext__c       =  newAdminAddressChangePhoneExt;
            parentCase.Administrative_Change_Current_Phone_Ext__c   =  curAdminAddressChangePhoneExt;
             System.debug('newAdminAddressChangePhoneExt=====>>>>'+newAdminAddressChangePhoneExt);
            System.debug('curAdminAddressChangePhoneExt=====>>>>'+curAdminAddressChangePhoneExt);
            
        }if (OtherProvInfo){               
            parentCase.Other_provider_Info__c=OtherProvInfo;     
            parentCase.Hospital_Privileges_list_all__c= hospPrivListAll;        
            parentCase.Ambulatory_Surgery_Center_Privileges_li__c=ambSurCenterPriv;
            parentCase.License_OP_Current__c=licenseOPCur;
            parentCase.Specialty__c=Specialty; 
            parentCase.Sub_Speciality__c=subSpecialtyCur; 
            parentCase.Specialty_Effective_Date__c=speffdateCur;
            parentCase.Specialty_Certification_Date__c=spcerdateCur;    
            parentCase.Board_Certified__c=boardCertified;
            //PPN-19364
            parentCase.Provide_Lactation_Services__c=ProvideLactationServices;
            parentCase.Comments_Other_Provider__c=commentOther;
            parentCase.Effective_Date_of_Change_OP__c=effDateofChgOth;    
            
            parentCase.Hospital_Privileges_OP_New__c=hospPrivListAllNew;
            parentCase.Ambulatory_Surg_Cnt_OP_New__c=ambSurCenterPrivNew;
            parentCase.License_OP_New__c=licenseOPNew;
            parentCase.Specialty_OP_New__c=specialtyNew;
            parentCase.Sub_Specialty_OP_New__c=subSpecialtyNew;
            parentCase.Specialty_E_Date_OP_New__c=speffdateNew;
            parentCase.Specialty_Cert_Date_OP_New__c=spcerdateNew;
            parentCase.Board_Certified_OP_New__c=boardCertifiedNew;
            //PPN-19364
            parentCase.Provide_Lactation_Services_New__c=ProvideLactationServicesNew;
            
            parentCase.Languages_Spoken_or_Written__c=langSpokenWritten;
            parentCase.DEA__c=dEA;
            parentCase.Date_of_Birth__c=DateOfBirth;
            parentCase.DEA_Expiration_Date__c=dEAExpirationDate;      
            parentCase.Medical_School_Name__c=medSchoolName;
            parentCase.Year_of_Graduation__c=yearOfGrad;
            parentCase.Residency_Hospital_Name__c=resHospName;       
            parentCase.Ethnicity__c=ethnicity;
            parentCase.From__c=fromOther;
            parentCase.To__c=toOther;
        }if (removeProvGrpLoc){   
            parentCase.Remove_Provider_from_Group_Location__c=removeProvGrpLoc;
            parentCase.Individual_Provider_Name__c = indProvName;
            parentCase.Individual_s_Type_1_NPI__c = indType1NPI;
            parentCase.Other_ID_Eg_Medicaid_API_LTSS_TPI__c = otherId;
            parentCase.Remove_From_All_Locations__c = remFrmAllLoc;     
            parentCase.Reason_For_Leaving_Group_Location__c=reasonleavgrpAll;
            parentCase.Effective_Date_Of_Termination__c=effDateofTrmProvGrpAll;    
            parentCase.Addr_Line_1_Remove_Provider__c=strAddProvGrp;
            parentCase.Addr_Line_2_Remove_Provider__c=strAdd1ProvGrp;
            parentCase.City_Remove_Provider__c=cityProvGrp;
            parentCase.State_Remove_Provider__c=stateProvGrp;
            parentCase.Zip_Remove_Provider__c=zipProvGrp;
            parentCase.Reason_For_Leaving_Group_Location_1__c=reasonleavgrp;
            parentCase.Effective_Date_Of_Termination_1__c=effDateofTrmProvGrp;
            parentCase.Comments_Remove_Provider__c=commProvGrp;
            parentCase.Attestation__c = attProvGrp;
            
            System.debug('Add another location for removal = ' + addLocProvGrp);           
            parentCase.Add_Another_Location_For_Removal__c = addLocProvGrp; //set value from form into object field
            
            parentCase.X2nd_Addr_Line_1_Remove_Provider__c=strAddProvGrp1;
            parentCase.X2nd_Addr_Line_2_Remove_Provider__c=strAdd1ProvGrp1;
            parentCase.X2nd_City_Remove_Provider__c=cityProvGrp1;
            parentCase.X2nd_State_Remove_Provider__c=stateProvGrp1;
            parentCase.X2nd_Zip_Remove_Provider__c=zipProvGrp1;
            parentCase.Reason_For_Leaving_Group_Location_2__c=reasonleavgrp1;
            parentCase.Effective_Date_Of_Termination_2__c=effDateofTrmProvGrp1; 
            
            System.debug('excelAttached = ' + excelAttached);              
            parentCase.Excel_Attached__c = excelAttached;  //set value from form into object field  
        }
        
    }
    
    public void checkHrs(){ 
        if (open24Phy){           
            resetHours();
            
        }
        
    }
    
    
    /**
    * Create Child Case based on selection of Request Category 
    * */
    public void createChildCase(Case parentCase){    
        checkHrs();        
        RecordType nameChangeRecType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE and DeveloperName = :CaseUtil.REC_TYP_NM_CHG];
        RecordType taxIdChangeRecType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE and DeveloperName = :CaseUtil.REC_TYP_NPI_ID];
        RecordType pAddrChangeRecType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE and DeveloperName = :CaseUtil.REC_TYP_PHY_ADD_CHG];
        RecordType bAddrChangeRecType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE and DeveloperName = :CaseUtil.REC_TYP_BILL_ADD_CHG];
        RecordType cAddrChangeRecType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE and DeveloperName = :CaseUtil.REC_TYP_CRED_CHG];
        RecordType aAddrChangeRecType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE  and DeveloperName =:CaseUtil.REC_TYP_ADMIN_CHG];
        RecordType otherChangeRecType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE  and DeveloperName =:CaseUtil.REC_TYP_OTHER_CHG];  
        RecordType RemProvfrmGrpLocRecType = [Select Id From RecordType  Where SobjectType = :CaseUtil.OBJ_TYPE  and DeveloperName =:CaseUtil.REC_TYP_PROV_GRP];   
        //PPN-19364
        try{
            if (npiTaxIdChg && (nmChg || PhyAddrChg || BillAddrChg || CredAddrChg ||AdminAddrChg || OtherProvInfo || removeProvGrpLoc)){
                resetFields();        
                mapChildCase.put(2,new case(Govt_Programs__c=parentCase.Govt_Programs__c,AccountId=parentCase.AccountId,ParentId=parentCase.id,RecordTypeId =taxIdChangeRecType.id,Original_Creation_Date__c=System.now(),Origin=parentCase.Origin,Plan_ID__c=parentCase.Plan_ID__c,Plan_Id_Validation_By_Pass__c=true,Priority = parentCase.Priority,Completing_the_form_for__c=compFormFor,Email_Address_Submitter__c=emailAddrSub,Name_Submitter__c = parentCase.Name_Submitter__c,First_Name_Web__c = firstnameSub,Title_Submitter__c = titleSub,Telephone_Number_Submitter__c = telNumbSub,Name_of_Provider_Group__c = nameOfProvGrp,Tax_ID_Number__c = taxIDNumber,Rendering_NPI__c = rendNpi,Billing_NPI_Number__c = billNPINum,Bill_NPI_Type__c=billNPItype,NPI_Tax_Id_Change__c = npiTaxIdChg,Tax_ID_Num_Current__c = taxIDNumCur,New_Tax_ID_Number__c=newTaxIDNum,Bill_NPI_Num_Current__c = billNPINumCur,New_Billing_NPI_Number__c=newBillNPINum,Comments_NPI_Tax__c=commentNPITax,Effective_Date_of_Change_NPI_Tax__c=effDateofNPIChg
                                            ,Name_Change__c = nmChg,First_Name_Current__c= fnameCur,First_Name_New__c= fnameNew,Last_Name_Current__c= lnameCur,Last_Name_New__c= lnameNew,Middle_Initial_Current__c=midInitialCur,Middle_Initial_New__c=midInitialNew,Title_Current__c=titleCur,Suffix_Current__c=suffixCur,Current_Practice_Name__c=curPracName,Title_New__c=titleNew,New_Practice_Name__c=newPracName,Effective_Date_of_Change_Name__c=effDateofNameChg,Comments_Name_Change__c=commentNameChg,Suffix_New__c=suffixNew
                                            ,Office_Physical_Address_Telephone_Fax_Em__c = PhyAddrChg,Street_Address_Suite_No_Physical_current__c= strAddrPhyCur,Addr_Line_2_Phy_Curr__c= StrAddr2PhyCur,City_Physical_Current__c=cityPhyCur,State_Physical_Current__c=statePhyCur,Zip_Physical_Current__c=zipPhyCur,Telephone_Physical_Current__c=TelPhyCur,Email_Physical_Current__c=emailPhyCur,Fax_Physical_Current__c=faxPhyCur,Accepting_New_Patients__c=AcceptNewPat,Street_Address_Suite_No_Physical_New__c=strAddrPhyNew,Addr_Line_2_Phy_New__c= StrAddr2PhyNew,City_Physical_New__c=cityPhyNew,State_Physical_New__c=statePhyNew,Zip_Physical_New__c=zipPhyNew,Telephone_Physical_New__c=telPhyNew,Email_Physical_New__c=emailPhyNew,Fax_Physical_New__c=faxPhyNew,Primary_Location_Physical__c=PrimaryLocPhy,Supervising_Physician__c=SupervisingPhy,Effective_Date_of_Change_Physical__c=effDateofChgPhy,Comm_Phy__c=commentPhy,Open_24__c=open24Phy,Mon_Open__c=monOpen,Tue_Open__c=tueOpen,Wed_Open__c=wedOpen,Thu_Open__c=thuOpen,Fri_Open__c=friOpen,Sat_Open__c=satOpen,Sun_Open__c=sunOpen,Mon_Close__c=monClose,Tue_Close__c=tueClose,Wed_Close__c=wedClose,Thu_Close__c=thuClose,Fri_Close__c=friClose,Sat_Close__c=satClose,Sun_Close__c=sunClose
                                            ,Billing_Address_Telephone_Fax_Email_Chan__c = BillAddrChg,Street_Address_Suite_No_Billing_Current__c= strAddrBillCur,Addr_Line_2_Bill_Curr__c= StrAddr2BillCur,City_Billing_Current__c=cityBillCur,State_Billing_Current__c=stateBillCur,Zip_Billing_Current__c=zipBillCur,Telephone_Billing_Current__c=TelBillCur,Email_Billing_Current__c=emailBillCur,Fax_Billing_Current__c=faxBillCur,Street_Address_Suite_No_Billing_New__c=strAddrBillNew,Addr_Line_2_Bill_New__c= StrAddr2BillNew,City_Billing_New__c=cityBillNew,State_Billing_New__c=stateBillNew,Zip_Billing_New__c=zipBillNew,Telephone_Billing_New__c=telBillNew,Email_Billing_New__c=emailBillNew,Fax_Billing_New__c=faxBillNew,Effective_Date_of_Change_Billing__c=EffDateofChgBill,Comments_Billing__c=CommentBill
                                            ,Credentialing_Address_Telephone_Fax_Emai__c = CredAddrChg,Street_Address_Suite_Credential_Current__c= StrAddrCredCur,Addr_Line_2_Cred_Curr__c= StrAddr2CredCur,City_Credential_Current__c=cityCredCur,State_Credential_Current__c=stateCredCur,Zip_Credential_Current__c=zipCredCur,Telephone_Credential_Current__c=telCredCur,Email_Credential_Current__c=emailCredCur,Fax_Credential_Current__c=faxCredCur,Street_Address_Suite_Credential_New__c=strAddrCredNew,Addr_Line_2_Cred_New__c= StrAddr2CredNew,City_Credential_New__c=cityCredNew,State_Credential_New__c=stateCredNew,Zip_Credential_New__c=zipCredNew,Telephone_Credential_New__c=TelCredNew,Email_Credential_New__c=emailCredNew,Fax_Credential_New__c=faxCredNew,Effective_Date_of_Change_Credential__c=effDateofCredChg,Comments_Credential__c=commentCred,Cred_Cont_Name__c=credConNm
                                            ,Administrative_Address_Telephone_Fax_Ema__c= adminAddrChg,Street_Address_Administrative_Current__c= strAddrAdmCur,Addr_Line_2_Admin_Curr__c= StrAddr2AdmCur,City_Administrative_Current__c=cityAdmCur,State_Administrative_Current__c=stateAdmCur,Zip_Administrative_Current__c=zipAdmCur,Telephone_Administrative_Current__c=telAdmCur,Email_Administrative_Current__c=emailAdmCur,Fax_Administrative_Current__c=faxAdmCur,Street_Address_Administrative_New__c=StrAddrAdmNew,Addr_Line_2_Admin_New__c= StrAddr2AdmNew,City_Administrative_New__c=cityAdmNew,State_Administrative_New__c=stateAdmNew,Zip_Administrative_New__c=zipAdmNew,Telephone_Administrative_New__c=telAdmNew,Email_Administrative_New__c=emailAdmNew,Fax_Administrative_New__c=faxAdmNew,Effective_Date_of_Change_Administrative__c=effDateofChgAdm,Comments_Administrative__c=commentAdm,Admin_Cont_Name__c=admConNm         
                                            ,Other_provider_Info__c=OtherProvInfo,Hospital_Privileges_list_all__c= hospPrivListAll,Languages_Spoken_or_Written__c=langSpokenWritten,Ambulatory_Surgery_Center_Privileges_li__c=ambSurCenterPriv,License_OP_Current__c=licenseOPCur,Specialty__c=Specialty,Sub_Speciality__c=subSpecialtyCur,Specialty_Effective_Date__c=speffdateCur,Specialty_Certification_Date__c=spcerdateCur,Comments_Other_Provider__c=commentOther,Effective_Date_of_Change_OP__c=effDateofChgOth,DEA__c=dEA,Date_of_Birth__c=DateOfBirth,DEA_Expiration_Date__c=dEAExpirationDate,Board_Certified__c=boardCertified,Provide_Lactation_Services__c=ProvideLactationServices,Medical_School_Name__c=medSchoolName,Residency_Hospital_Name__c=resHospName,Year_of_Graduation__c=yearOfGrad,Ethnicity__c=ethnicity,From__c=fromOther,To__c=toOther,Hospital_Privileges_OP_New__c=hospPrivListAllNew,Ambulatory_Surg_Cnt_OP_New__c=ambSurCenterPrivNew,License_OP_New__c=licenseOPNew,Specialty_OP_New__c=specialtyNew,Sub_Specialty_OP_New__c=subSpecialtyNew,Specialty_E_Date_OP_New__c=speffdateNew,Specialty_Cert_Date_OP_New__c=spcerdateNew,Board_Certified_OP_New__c=boardCertifiedNew,Provide_Lactation_Services_New__c=ProvideLactationServicesNew
                                            ,Remove_Provider_from_Group_Location__c=removeProvGrpLoc,Individual_Provider_Name__c = indProvName,Individual_s_Type_1_NPI__c = indType1NPI,Other_ID_Eg_Medicaid_API_LTSS_TPI__c = otherId,Remove_From_All_Locations__c = remFrmAllLoc,Addr_Line_1_Remove_Provider__c=strAddProvGrp,Addr_Line_2_Remove_Provider__c=strAdd1ProvGrp,City_Remove_Provider__c=cityProvGrp,State_Remove_Provider__c=stateProvGrp,Zip_Remove_Provider__c=zipProvGrp,Reason_For_Leaving_Group_Location_1__c=reasonleavgrp,Effective_Date_Of_Termination_1__c=effDateofTrmProvGrp,Comments_Remove_Provider__c=commProvGrp,Attestation__c = attProvGrp,Add_Another_Location_For_Removal__c = addLocProvGrp,X2nd_Addr_Line_1_Remove_Provider__c=strAddProvGrp1,X2nd_Addr_Line_2_Remove_Provider__c=strAdd1ProvGrp1,X2nd_City_Remove_Provider__c=cityProvGrp1,X2nd_State_Remove_Provider__c=stateProvGrp1,X2nd_Zip_Remove_Provider__c=zipProvGrp1,Reason_For_Leaving_Group_Location_2__c=reasonleavgrp1,Effective_Date_Of_Termination_2__c=effDateofTrmProvGrp1,Reason_For_Leaving_Group_Location__c=reasonleavgrpAll,Effective_Date_Of_Termination__c=effDateofTrmProvGrpAll, Excel_Attached__c = excelAttached,Site_Acce__c=siteAccessible,Parking_Accessbility__c=parkAccesbility
                                            ,Exterior__c=extBuilding,Interior_Building__c=intBuilding,Exam_Room__c=examRoom,Exam_Table__c=examTable,Office_Reception_Area__c=offRecpArea,Close_Proximity_to_Public_Transportation__c=clsProxmty2PublcTransprt,
                                            Restroom__c=restroom,Scale__c=scale,Homebound__c=homeBound,Homeless__c=homeless,Blindness_or_Visually_Impaired__c=blndnesOrVsualyImprd,Chronic_Illness__c=chroncIlness,Serious_Mental_Illness__c=srMentalIlness,
                                            Co_Occurring_Disorders__c=coOccrDisordr,HIV_AIDS__c=hivOrAids,Physical_Disabilities__c=phyDisablty,Deafness_Or_Hard_Of_Hearing__c=deafOrHrdHear,
                                            Submitter_Phone_Ext__c = submitterPhoneExt,
                                            Physical_Address_Current_Phone_Ext__c       =  currPhysicalAddressPhoneExt,
                                            Physical_Address_New_Phone_Ext__c           =  newphysicalAddressPhoneExt,
                                            Billing_Address_New_Phone_Ext__c            =  newBillingAddressPhoneExt,
                                            Billing_Address_Current_Phone_Ext__c        =  currBillingAddressPhoneExt,
                                            Credentialing_Change_New_Phone_Ext__c       =  newCredentialingChangePhoneExt,
                                            Credentialing_Change_Current_Phone_Ext__c   =  curCredentialingChangePhoneExt,
                                            Administrative_Change_New_Phone_Ext__c      =  newAdminAddressChangePhoneExt,
                                            Administrative_Change_Current_Phone_Ext__c  =  curAdminAddressChangePhoneExt
                                           ));
            }   
            else
            {
                resetFields(); 
                if (nmChg)
                    mapChildCase.put(1,new case(Govt_Programs__c=parentCase.Govt_Programs__c,Case_Entity__c=parentCase.Case_Entity__c,AccountId=parentCase.AccountId,ParentId=parentCase.id,RecordTypeId =nameChangeRecType.id,Original_Creation_Date__c=System.now(),Origin=parentCase.Origin,Plan_ID__c=parentCase.Plan_ID__c,Plan_Id_Validation_By_Pass__c=true,Priority = parentCase.Priority,Completing_the_form_for__c=compFormFor,Email_Address_Submitter__c=emailAddrSub,Name_Submitter__c = parentCase.Name_Submitter__c,First_Name_Web__c = firstnameSub,Title_Submitter__c = titleSub,Telephone_Number_Submitter__c = telNumbSub,Name_of_Provider_Group__c = nameOfProvGrp,Tax_ID_Number__c = taxIDNumber,Rendering_NPI__c = rendNpi,Billing_NPI_Number__c = billNPINum,Bill_NPI_Type__c=billNPItype,Name_Change__c = nmChg,First_Name_Current__c= fnameCur,First_Name_New__c= fnameNew,Last_Name_Current__c= lnameCur,Last_Name_New__c= lnameNew,Middle_Initial_Current__c=midInitialCur,Middle_Initial_New__c=midInitialNew,Title_Current__c=titleCur,Suffix_Current__c=suffixCur,Current_Practice_Name__c=curPracName,Title_New__c=titleNew,New_Practice_Name__c=newPracName,Effective_Date_of_Change_Name__c=effDateofNameChg,Comments_Name_Change__c=commentNameChg,Suffix_New__c=suffixNew));
                if (npiTaxIdChg)
                    mapChildCase.put(2,new case(Govt_Programs__c=parentCase.Govt_Programs__c,Case_Entity__c=parentCase.Case_Entity__c,AccountId=parentCase.AccountId,ParentId=parentCase.id,RecordTypeId =taxIdChangeRecType.id,Original_Creation_Date__c=System.now(),Origin=parentCase.Origin,Plan_ID__c=parentCase.Plan_ID__c,Plan_Id_Validation_By_Pass__c=true,Priority = parentCase.Priority,Completing_the_form_for__c=compFormFor,Email_Address_Submitter__c=emailAddrSub,Name_Submitter__c = parentCase.Name_Submitter__c,First_Name_Web__c = firstnameSub,Title_Submitter__c = titleSub,Telephone_Number_Submitter__c = telNumbSub,Name_of_Provider_Group__c = nameOfProvGrp,Tax_ID_Number__c = taxIDNumber,Rendering_NPI__c = rendNpi,Billing_NPI_Number__c = billNPINum,Bill_NPI_Type__c=billNPItype,NPI_Tax_Id_Change__c = npiTaxIdChg,Tax_ID_Num_Current__c = taxIDNumCur,New_Tax_ID_Number__c=newTaxIDNum,Bill_NPI_Num_Current__c = billNPINumCur,New_Billing_NPI_Number__c=newBillNPINum,Comments_NPI_Tax__c=commentNPITax,Effective_Date_of_Change_NPI_Tax__c=effDateofNPIChg)); 
                if (PhyAddrChg)
                    mapChildCase.put(3,new case(Govt_Programs__c=parentCase.Govt_Programs__c,Case_Entity__c=parentCase.Case_Entity__c,AccountId=parentCase.AccountId,ParentId=parentCase.id,RecordTypeId =pAddrChangeRecType.id,Original_Creation_Date__c=System.now(),Origin=parentCase.Origin,Plan_ID__c=parentCase.Plan_ID__c,Plan_Id_Validation_By_Pass__c=true,Priority = parentCase.Priority,Completing_the_form_for__c=compFormFor,Email_Address_Submitter__c=emailAddrSub,Name_Submitter__c = parentCase.Name_Submitter__c,First_Name_Web__c = firstnameSub,Title_Submitter__c = titleSub,Telephone_Number_Submitter__c = telNumbSub,Name_of_Provider_Group__c = nameOfProvGrp,Tax_ID_Number__c = taxIDNumber,Rendering_NPI__c = rendNpi,Billing_NPI_Number__c = billNPINum,Bill_NPI_Type__c=billNPItype,Office_Physical_Address_Telephone_Fax_Em__c = PhyAddrChg,Street_Address_Suite_No_Physical_current__c= strAddrPhyCur,Addr_Line_2_Phy_Curr__c= StrAddr2PhyCur,City_Physical_Current__c=cityPhyCur,State_Physical_Current__c=statePhyCur,Zip_Physical_Current__c=zipPhyCur,Telephone_Physical_Current__c=TelPhyCur,Email_Physical_Current__c=emailPhyCur,Fax_Physical_Current__c=faxPhyCur,Accepting_New_Patients__c=AcceptNewPat,Street_Address_Suite_No_Physical_New__c=strAddrPhyNew,Addr_Line_2_Phy_New__c= StrAddr2PhyNew,City_Physical_New__c=cityPhyNew,State_Physical_New__c=statePhyNew,Zip_Physical_New__c=zipPhyNew,Telephone_Physical_New__c=telPhyNew,Email_Physical_New__c=emailPhyNew,Fax_Physical_New__c=faxPhyNew,Primary_Location_Physical__c=PrimaryLocPhy,Supervising_Physician__c=SupervisingPhy,Effective_Date_of_Change_Physical__c=effDateofChgPhy,Comm_Phy__c=commentPhy,Open_24__c=open24Phy,Mon_Open__c=monOpen,Tue_Open__c=tueOpen,Wed_Open__c=wedOpen,Thu_Open__c=thuOpen,Fri_Open__c=friOpen,Sat_Open__c=satOpen,Sun_Open__c=sunOpen,Mon_Close__c=monClose,Tue_Close__c=tueClose,Wed_Close__c=wedClose,Thu_Close__c=thuClose,Fri_Close__c=friClose,Sat_Close__c=satClose,Sun_Close__c=sunClose,Site_Acce__c=siteAccessible,Parking_Accessbility__c=parkAccesbility
                                                ,Exterior__c=extBuilding,Interior_Building__c=intBuilding,Exam_Room__c=examRoom,Exam_Table__c=examTable,Office_Reception_Area__c=offRecpArea,Close_Proximity_to_Public_Transportation__c=clsProxmty2PublcTransprt,Restroom__c=restroom,Scale__c=scale,
                                                Homebound__c=homeBound,Homeless__c=homeless,Blindness_or_Visually_Impaired__c=blndnesOrVsualyImprd,Chronic_Illness__c=chroncIlness,Serious_Mental_Illness__c=srMentalIlness,Co_Occurring_Disorders__c=coOccrDisordr,HIV_AIDS__c=hivOrAids,
                                                Physical_Disabilities__c=phyDisablty,Deafness_Or_Hard_Of_Hearing__c=deafOrHrdHear,
                                                Submitter_Phone_Ext__c = submitterPhoneExt,
                                                Physical_Address_Current_Phone_Ext__c   =  currPhysicalAddressPhoneExt,
                                                Physical_Address_New_Phone_Ext__c       =  newphysicalAddressPhoneExt
                                               ));  
                if(BillAddrChg)
                    mapChildCase.put(4,new case(Govt_Programs__c=parentCase.Govt_Programs__c,Case_Entity__c=parentCase.Case_Entity__c,AccountId=parentCase.AccountId,
                                                ParentId=parentCase.id,RecordTypeId =bAddrChangeRecType.id,Original_Creation_Date__c=System.now(),Origin=parentCase.Origin,Plan_ID__c=parentCase.Plan_ID__c,
                                                Plan_Id_Validation_By_Pass__c=true,Priority = parentCase.Priority,Completing_the_form_for__c=compFormFor,Email_Address_Submitter__c=emailAddrSub,Name_Submitter__c = parentCase.Name_Submitter__c,
                                                First_Name_Web__c = firstnameSub,Title_Submitter__c = titleSub,Telephone_Number_Submitter__c = telNumbSub,Name_of_Provider_Group__c = nameOfProvGrp,Tax_ID_Number__c = taxIDNumber,Rendering_NPI__c = rendNpi,
                                                Billing_NPI_Number__c = billNPINum,Bill_NPI_Type__c=billNPItype,Billing_Address_Telephone_Fax_Email_Chan__c = BillAddrChg,Street_Address_Suite_No_Billing_Current__c= strAddrBillCur,Addr_Line_2_Bill_Curr__c= StrAddr2BillCur,
                                                City_Billing_Current__c=cityBillCur,State_Billing_Current__c=stateBillCur,Zip_Billing_Current__c=zipBillCur,Telephone_Billing_Current__c=TelBillCur,Email_Billing_Current__c=emailBillCur,Fax_Billing_Current__c=faxBillCur,
                                                Street_Address_Suite_No_Billing_New__c=strAddrBillNew,Addr_Line_2_Bill_New__c= StrAddr2BillNew,City_Billing_New__c=cityBillNew,State_Billing_New__c=stateBillNew,Zip_Billing_New__c=zipBillNew,Telephone_Billing_New__c=telBillNew,
                                                Email_Billing_New__c=emailBillNew,Fax_Billing_New__c=faxBillNew,Effective_Date_of_Change_Billing__c=EffDateofChgBill,Comments_Billing__c=CommentBill,
                                                Billing_Address_New_Phone_Ext__c        =   newBillingAddressPhoneExt,
                                                Billing_Address_Current_Phone_Ext__c    =   currBillingAddressPhoneExt,
                                                Submitter_Phone_Ext__c = submitterPhoneExt
                                               )); 
                if(CredAddrChg)
                    mapChildCase.put(5,new case(Govt_Programs__c=parentCase.Govt_Programs__c,Case_Entity__c=parentCase.Case_Entity__c,AccountId=parentCase.AccountId,ParentId=parentCase.id,RecordTypeId =cAddrChangeRecType.id,Original_Creation_Date__c=System.now(),Origin=parentCase.Origin,
                                                Plan_ID__c=parentCase.Plan_ID__c,Plan_Id_Validation_By_Pass__c=true,Priority = parentCase.Priority,Completing_the_form_for__c=compFormFor,Email_Address_Submitter__c=emailAddrSub,Name_Submitter__c = parentCase.Name_Submitter__c,First_Name_Web__c = firstnameSub,
                                                Title_Submitter__c = titleSub,Telephone_Number_Submitter__c = telNumbSub,Name_of_Provider_Group__c = nameOfProvGrp,Tax_ID_Number__c = taxIDNumber,Rendering_NPI__c = rendNpi,Billing_NPI_Number__c = billNPINum,Bill_NPI_Type__c=billNPItype,
                                                Credentialing_Address_Telephone_Fax_Emai__c = CredAddrChg,Street_Address_Suite_Credential_Current__c= StrAddrCredCur,Addr_Line_2_Cred_Curr__c= StrAddr2CredCur,City_Credential_Current__c=cityCredCur,State_Credential_Current__c=stateCredCur,
                                                Zip_Credential_Current__c=zipCredCur,Telephone_Credential_Current__c=telCredCur,Email_Credential_Current__c=emailCredCur,Fax_Credential_Current__c=faxCredCur,Street_Address_Suite_Credential_New__c=strAddrCredNew,Addr_Line_2_Cred_New__c= StrAddr2CredNew,
                                                City_Credential_New__c=cityCredNew,State_Credential_New__c=stateCredNew,Zip_Credential_New__c=zipCredNew,Telephone_Credential_New__c=TelCredNew,Email_Credential_New__c=emailCredNew,Fax_Credential_New__c=faxCredNew,Effective_Date_of_Change_Credential__c=effDateofCredChg,
                                                Comments_Credential__c=commentCred,Cred_Cont_Name__c=credConNm,
                                                Submitter_Phone_Ext__c = submitterPhoneExt,
                                                Credentialing_Change_New_Phone_Ext__c       =  newCredentialingChangePhoneExt,
                                                Credentialing_Change_Current_Phone_Ext__c   =  curCredentialingChangePhoneExt
                                               ));
                if (AdminAddrChg)
                    mapChildCase.put(6,new case(Govt_Programs__c=parentCase.Govt_Programs__c,Case_Entity__c=parentCase.Case_Entity__c,AccountId=parentCase.AccountId,ParentId=parentCase.id,RecordTypeId =aAddrChangeRecType.id,Original_Creation_Date__c=System.now(),Origin=parentCase.Origin,
                                                Plan_ID__c=parentCase.Plan_ID__c,Plan_Id_Validation_By_Pass__c=true,Priority = parentCase.Priority,Completing_the_form_for__c=compFormFor,Email_Address_Submitter__c=emailAddrSub,Name_Submitter__c = parentCase.Name_Submitter__c,
                                                First_Name_Web__c = firstnameSub,Title_Submitter__c = titleSub,Telephone_Number_Submitter__c = telNumbSub,Name_of_Provider_Group__c = nameOfProvGrp,Tax_ID_Number__c = taxIDNumber,Rendering_NPI__c = rendNpi,Billing_NPI_Number__c = billNPINum,
                                                Bill_NPI_Type__c=billNPItype,Administrative_Address_Telephone_Fax_Ema__c= adminAddrChg,Street_Address_Administrative_Current__c= strAddrAdmCur,Addr_Line_2_Admin_Curr__c= StrAddr2AdmCur,City_Administrative_Current__c=cityAdmCur,State_Administrative_Current__c=stateAdmCur,
                                                Zip_Administrative_Current__c=zipAdmCur,Telephone_Administrative_Current__c=telAdmCur,Email_Administrative_Current__c=emailAdmCur,Fax_Administrative_Current__c=faxAdmCur,Street_Address_Administrative_New__c=StrAddrAdmNew,Addr_Line_2_Admin_New__c= StrAddr2AdmNew,
                                                City_Administrative_New__c=cityAdmNew,State_Administrative_New__c=stateAdmNew,Zip_Administrative_New__c=zipAdmNew,Telephone_Administrative_New__c=telAdmNew,Email_Administrative_New__c=emailAdmNew,Fax_Administrative_New__c=faxAdmNew,Effective_Date_of_Change_Administrative__c=effDateofChgAdm,
                                                Comments_Administrative__c=commentAdm,Admin_Cont_Name__c=admConNm,
                                                Submitter_Phone_Ext__c = submitterPhoneExt,
                                                Administrative_Change_New_Phone_Ext__c      =  newAdminAddressChangePhoneExt,
                                                Administrative_Change_Current_Phone_Ext__c  =  curAdminAddressChangePhoneExt 
                                               ));
                //PPN-19364
                if(OtherProvInfo)
                    mapChildCase.put(7,new case(Govt_Programs__c=parentCase.Govt_Programs__c,Case_Entity__c=parentCase.Case_Entity__c,AccountId=parentCase.AccountId,ParentId=parentCase.id,RecordTypeId =otherChangeRecType.id,Original_Creation_Date__c=System.now(),Origin=parentCase.Origin,Plan_ID__c=parentCase.Plan_ID__c,Plan_Id_Validation_By_Pass__c=false,Priority = parentCase.Priority,Completing_the_form_for__c=compFormFor,Email_Address_Submitter__c=emailAddrSub,Name_Submitter__c = parentCase.Name_Submitter__c,First_Name_Web__c = firstnameSub,Title_Submitter__c = titleSub,Telephone_Number_Submitter__c = telNumbSub,Name_of_Provider_Group__c = nameOfProvGrp,Tax_ID_Number__c = taxIDNumber,Rendering_NPI__c = rendNpi,Billing_NPI_Number__c = billNPINum,Bill_NPI_Type__c=billNPItype,Other_provider_Info__c=OtherProvInfo,Hospital_Privileges_list_all__c= hospPrivListAll,Languages_Spoken_or_Written__c=langSpokenWritten,Ambulatory_Surgery_Center_Privileges_li__c=ambSurCenterPriv,License_OP_Current__c=licenseOPCur,Specialty__c=Specialty,Sub_Speciality__c=subSpecialtyCur,Specialty_Effective_Date__c=speffdateCur,Specialty_Certification_Date__c=spcerdateCur,Comments_Other_Provider__c=commentOther,Effective_Date_of_Change_OP__c=effDateofChgOth,DEA__c=dEA,Date_of_Birth__c=DateOfBirth,DEA_Expiration_Date__c=dEAExpirationDate,Board_Certified__c=boardCertified,Provide_Lactation_Services__c=ProvideLactationServices,Medical_School_Name__c=medSchoolName,Residency_Hospital_Name__c=resHospName,Year_of_Graduation__c=yearOfGrad,Ethnicity__c=ethnicity,From__c=fromOther,To__c=toOther,Hospital_Privileges_OP_New__c=hospPrivListAllNew,Ambulatory_Surg_Cnt_OP_New__c=ambSurCenterPrivNew,License_OP_New__c=licenseOPNew,Specialty_OP_New__c=specialtyNew,Sub_Specialty_OP_New__c=subSpecialtyNew,Specialty_E_Date_OP_New__c=speffdateNew,Specialty_Cert_Date_OP_New__c=spcerdateNew,Board_Certified_OP_New__c=boardCertifiedNew,Provide_Lactation_Services_New__c=ProvideLactationServicesNew));
                if(removeProvGrpLoc)           
                    mapChildCase.put(8,new case(Govt_Programs__c=parentCase.Govt_Programs__c,Case_Entity__c=parentCase.Case_Entity__c,AccountId=parentCase.AccountId,ParentId=parentCase.id,RecordTypeId =RemProvfrmGrpLocRecType.id,Original_Creation_Date__c=System.now(),Origin=parentCase.Origin,Plan_ID__c=parentCase.Plan_ID__c,Plan_Id_Validation_By_Pass__c=false,Priority = parentCase.Priority,Completing_the_form_for__c=compFormFor,Email_Address_Submitter__c=emailAddrSub,Name_Submitter__c = parentCase.Name_Submitter__c,First_Name_Web__c = firstnameSub,Title_Submitter__c = titleSub,Telephone_Number_Submitter__c = telNumbSub,Name_of_Provider_Group__c = nameOfProvGrp,Tax_ID_Number__c = taxIDNumber,Rendering_NPI__c = rendNpi,Billing_NPI_Number__c = billNPINum,Bill_NPI_Type__c=billNPItype,Remove_Provider_from_Group_Location__c=removeProvGrpLoc,Individual_Provider_Name__c = indProvName,Individual_s_Type_1_NPI__c = indType1NPI,Other_ID_Eg_Medicaid_API_LTSS_TPI__c = otherId,Remove_From_All_Locations__c = remFrmAllLoc,Addr_Line_1_Remove_Provider__c=strAddProvGrp,Addr_Line_2_Remove_Provider__c=strAdd1ProvGrp,City_Remove_Provider__c=cityProvGrp,State_Remove_Provider__c=stateProvGrp,Zip_Remove_Provider__c=zipProvGrp,Reason_For_Leaving_Group_Location_1__c=reasonleavgrp,Effective_Date_Of_Termination_1__c=effDateofTrmProvGrp,Comments_Remove_Provider__c=commProvGrp,Attestation__c = attProvGrp,Add_Another_Location_For_Removal__c =addLocProvGrp,X2nd_Addr_Line_1_Remove_Provider__c=strAddProvGrp1,X2nd_Addr_Line_2_Remove_Provider__c=strAdd1ProvGrp1,X2nd_City_Remove_Provider__c=cityProvGrp1,X2nd_State_Remove_Provider__c=stateProvGrp1,X2nd_Zip_Remove_Provider__c=zipProvGrp1,Reason_For_Leaving_Group_Location_2__c=reasonleavgrp1,Effective_Date_Of_Termination_2__c=effDateofTrmProvGrp1,Reason_For_Leaving_Group_Location__c=reasonleavgrpAll,Effective_Date_Of_Termination__c=effDateofTrmProvGrpAll, Excel_Attached__c = excelAttached));                                                        
            }
            
            
        }Catch(Exception ex){
            System.debug('The following exception has occurred while assigning values to child case: ' + ex.getMessage());
        }
    }
    
    
    private void setUpCaptcha(){
        
    /*
    * Get Captcha flag value from Web2Case custom setting,
    * set value in controller variable
    */
        Web2Case__c cs_isCaptchaEnabled = (Web2Case__c.getValues('isCaptchaEnabled'));
        
        if (cs_isCaptchaEnabled !=null){
            this.isCaptchaEnabled = cs_isCaptchaEnabled.CaseObjectValues__c;   
            //System.debug('Is captcha enabled? = '  + this.isCaptchaEnabled);
        }
        
    /*
    * Initialize the W2Ccontroller useCaptcha variable, based on CaptchaFlag value.
    * This will be used on the client side to determine whether or not to include Captcha presentation
    */
        this.useCaptcha = isCaptchaEnabled.equalsIgnoreCase('Yes');        
        System.debug('What is useCaptcha value? = '  + this.useCaptcha);
        
        
    /*
    * Get Captcha Public Key value from Web2Case custom setting,
    * set value in controller variable
    */
        if(this.useCaptcha){             
            Web2Case__c cs_captchaPublicKey = (Web2Case__c.getValues('CaptchaPublicKey'));
            
            if (cs_captchaPublicKey !=null){
                this.captchaPublicKey = cs_captchaPublicKey.CaseObjectValues__c;       
            }                   
        }
    }    
    
    
    //Load all non-null attachment bodies to temp attachment list
    //PPN-14244    
    private List<Attachment> loadAttachmentList(Attachment a1, Attachment a2,Attachment a3,Attachment a4,Attachment a5)
    {
        List<Attachment> tempList = new List<Attachment>();
        List<Attachment> returnList = new List<Attachment>();
        tempList.add(a1);
        tempList.add(a2);
        tempList.add(a3);
        tempList.add(a4);
        tempList.add(a5);
        
        for(Attachment ta: tempList)
        {
            if(ta.Body != null)
            {
                returnList.add(ta);
            }
        }
        
        
        return returnList;
    }
 
    //Process list of attachments add parent ID based on request type
    //PPN-14244 
    private List<Attachment> addToFullAttachmentList
        (
            List<Attachment> listToProcess, 
            Map<Integer, Case> mapOfChildCases,
            Boolean isNPISelected,
            Integer trueChoice,
            Integer falseChoice
        )
    {
        
        List<Attachment> returnList = new List<Attachment>();
        
        
        for(Attachment ta: listToProcess)
        {
            ta.ParentId = (isNPISelected==true)?mapChildCase.get(trueChoice).Id:mapChildCase.get(falseChoice).Id;
            returnList.add(ta);
        }
        
        return returnList;
    }    
    
    
    /**
    * Attach File based on selection of Request Category
    * */
    public void doFileAttachment(){
        List<Attachment> listAtt = new List<Attachment>();

    //Load request type specific attachment lists
    //PPN-14244         
        List<Attachment> nmList = loadAttachmentList(nmAttach1, nmAttach2, nmAttach3, nmAttach4, nmAttach5);
        List<Attachment> npiList = loadAttachmentList(npiAttach1, npiAttach2, npiAttach3, npiAttach4, npiAttach5);
        List<Attachment> phyList = loadAttachmentList(phyAttach1, phyAttach2, phyAttach3, phyAttach4, phyAttach5);
        List<Attachment> billList = loadAttachmentList(billAttach1, billAttach2, billAttach3, billAttach4, billAttach5);
        List<Attachment> credList = loadAttachmentList(credAttach1, credAttach2, credAttach3, credAttach4, credAttach5);
        List<Attachment> admList = loadAttachmentList(admAttach1, admAttach2, admAttach3, admAttach4, admAttach5);
        List<Attachment> otherList = loadAttachmentList(otherAttach1, otherAttach2, otherAttach3, otherAttach4, otherAttach5);
        List<Attachment> removeGrpList = loadAttachmentList(removeGrpAttach1, removeGrpAttach2, removeGrpAttach3, removeGrpAttach4, removeGrpAttach5);
        
        try{
            
            if(nmChg || npiTaxIdChg || PhyAddrChg || BillAddrChg || CredAddrChg ||AdminAddrChg || OtherProvInfo || removeProvGrpLoc){
                
                //Attach request type specific attachment list to full attachment list
                //PPN-14244 
                listAtt.addAll(addToFullAttachmentList(nmList, mapChildCase, npiTaxIdChg, 2, 1));
                listAtt.addAll(addToFullAttachmentList(npiList, mapChildCase, npiTaxIdChg, 2, 2));
                listAtt.addAll(addToFullAttachmentList(phyList, mapChildCase, npiTaxIdChg, 2, 3));
                listAtt.addAll(addToFullAttachmentList(billList, mapChildCase, npiTaxIdChg, 2, 4));
                listAtt.addAll(addToFullAttachmentList(credList, mapChildCase, npiTaxIdChg, 2, 5));
                listAtt.addAll(addToFullAttachmentList(admList, mapChildCase, npiTaxIdChg, 2, 6));
                listAtt.addAll(addToFullAttachmentList(otherList, mapChildCase, npiTaxIdChg, 2, 7)); 
                listAtt.addAll(addToFullAttachmentList(removeGrpList, mapChildCase, npiTaxIdChg, 2, 8));
                
            }
        }catch(Exception ex){
            System.debug('The following exception has occurred during File Attachment: ' + ex.getMessage());
        }
        
        if(listAtt.size() > 0){            
            try{
                insert listAtt;                
            }catch(Exception ex){
                System.debug('The following exception has occurred inserting file attachments: ' + ex.getMessage());
            }
            
        }
    }
    
    
    
    /*
    * Supports User Story PPN-6320
    * 
    * Set Govt. Program Indicator to Case
    * 
    */  
    public void setGovtCaseInd(){
        if (billNPINum!=null){
            try{
                List<CM_Provider_Identification__c> npiList;
                npiList = [select CM_PI_Prov__c from CM_Provider_Identification__c where CM_Prvdr_Iden_Typ_Cd__c='NPI' and CM_Issu_Ident_Nmbr__c= :billNPINum];
                if (npiList.size()>0 && npiList!=null){  
                    addr = [select CM_SPL_PFIN_No__c from CM_SPL_Addr__c where CM_SPL_Prov__c = :npiList.get(0).CM_PI_Prov__c and CM_SPL_Addr_Type__c='Service' LIMIT 1];
                }   
            }catch(Exception ex){
                System.debug('Exception:'+ex.getMessage());
            }     
        }
        List<CM_Network_Codes__c> getAllGovNetworkCodeList;
        try{
            if (addr.size()>0 && addr!=null){ 
                getAllGovNetworkCodeList = 
                    [
                        select 
                        Network_Code__c
                        from 
                        CM_Network_Codes__c 
                        where
                        Plan_id__c = :planId and Network_Code__c in :networkCodesByPFIN(addr.get(0).CM_SPL_PFIN_No__c)
                        and Government_Network_Indicator__c = true
                    ];
            }   
            if (getAllGovNetworkCodeList.size() > 0 && getAllGovNetworkCodeList!=null){
                govtPrg = true;
            }
        }catch(Exception ex){
            System.debug('Fetch Network Error'+ex.getMessage()+'Line '+ex.getLineNumber());
        }
    }   
    
    /*
    * 
    * 
    * Get all Networks associated with a PFIN
    * 
    */  
    public List<String> networkCodesByPFIN(String pfin){
        List<String> networkCodeList = new List<String>();
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
                    CM_SPL_PFIN_no__C = :pfin
                )
                order by
                CM_Network__c
            ];
        
        for(CM_Network__c tnc: tNetworkList){            
            networkCodeList.add(tnc.CM_Network__c);
        }
        
        return networkCodeList;
    }
    
    /**
    * Assign Account to the case based on the Tax ID and NPI Id matching rules
    * */
    public void assignAccount(){
        
        boolean accassigned = false;
        
        if (billNPINum!=null && taxIDNumber!=null){ 
            
            List<CM_Provider_Tax_Id__c> accTaxId= [select id,CM_PTI_Prov_Name_From__r.CM_Corporate_Entity_Code__c,CM_PTI_Prov_Name_From__r.IsPersonAccount,CM_PTI_Prov_Name_From__c,CM_PTI_Prov_Name_To__c,CM_PTI_Tax_Id__c,CM_PTI_Tax_Shared_Ind__c from CM_Provider_Tax_Id__c where CM_PTI_Tax_Id__c=:taxIDNumber];
            List<CM_Provider_Identification__c> accNPI= [select id,CM_PI_Prov__r.CM_Corporate_Entity_Code__c,CM_PI_Prov__r.IsPersonAccount,CM_PI_Prov__c,CM_Issu_Ident_Nmbr__c,CM_Prvdr_Iden_Typ_Cd__c from CM_Provider_Identification__c where CM_Issu_Ident_Nmbr__c=:billNPINum];
            
            if (accTaxId.size()==1 && accNPI.isempty())
            {  
                if(  accTaxId[0].CM_PTI_Prov_Name_From__r.CM_Corporate_Entity_Code__c==parentCase.Plan_ID__c)
                {
                    
                    if(accTaxId[0].CM_PTI_Prov_Name_From__r.IsPersonAccount)
                        
                        parentCase.AccountId    =   accTaxId[0].CM_PTI_Prov_Name_From__c;                                    
                    else 
                        parentCase.Case_Entity__c=accTaxId[0].CM_PTI_Prov_Name_From__c;
                }
            }
            else if (accTaxId.isempty() && accNPI.size()==1)            
            {    
                
                if(accNPI[0].CM_PI_Prov__r.CM_Corporate_Entity_Code__c ==parentCase.Plan_ID__c)   
                {   
                    
                    if(accNPI[0].CM_PI_Prov__r.IsPersonAccount)
                        parentCase.AccountId    =   accNPI[0].CM_PI_Prov__c;
                    
                    else 
                        parentCase.Case_Entity__c=accNPI[0].CM_PI_Prov__c;
                }
            }
            else if (accTaxId.size()>=1 && accNPI.size()>=1){ 
                
                for(CM_Provider_Tax_Id__c t:accTaxId)
                {
                    if(accassigned)
                        break;
                    
                    for(CM_Provider_Identification__c n:accNPI)
                    {         
                        if(accassigned)
                            break;
                        
                        if(  (t.CM_PTI_Prov_Name_From__r.CM_Corporate_Entity_Code__c==parentCase.Plan_ID__c)&&(n.CM_PI_Prov__r.CM_Corporate_Entity_Code__c==parentCase.Plan_ID__c) )
                        {        
                            
                            
                            if(t.CM_PTI_Prov_Name_From__c==n.CM_PI_Prov__c){
                                {
                                    if( t.CM_PTI_Tax_Shared_Ind__c){
                                        
                                        if(t.CM_PTI_Prov_Name_From__r.IsPersonAccount){
                                            
                                            if(parentCase.AccountId!=null || parentCase.Case_Entity__c!=null ){
                                                accassigned = true;
                                                
                                            }
                                            
                                            parentCase.AccountId    =   t.CM_PTI_Prov_Name_From__c;
                                            parentCase.Case_Entity__c= t.CM_PTI_Prov_Name_To__c;
                                            
                                        }
                                        else 
                                        {  if(parentCase.AccountId!=null || parentCase.Case_Entity__c!=null ){
                                            accassigned = true;
                                        }
                                         parentCase.Case_Entity__c= t.CM_PTI_Prov_Name_From__c;
                                         
                                        }
                                    }
                                    else
                                    {
                                        if(t.CM_PTI_Prov_Name_From__r.IsPersonAccount){
                                            
                                            if(parentCase.AccountId!=null || parentCase.Case_Entity__c!=null ){
                                                accassigned = true;
                                            }
                                            parentCase.AccountId    =   t.CM_PTI_Prov_Name_From__c;
                                        }
                                        else 
                                        {
                                            if(parentCase.AccountId!=null || parentCase.Case_Entity__c!=null ){
                                                accassigned = true;
                                            }
                                            parentCase.Case_Entity__c= t.CM_PTI_Prov_Name_From__c;
                                            
                                        }
                                    }     
                                }
                            }
                        } 
                    }
                }                     
            }
        }
        
        if(accassigned) {
            parentCase.AccountId    =   null;
            parentCase.Case_Entity__c= null;
            
        }
        
    }
}