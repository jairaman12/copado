/*******************************************
@Author Sreekanth K / Avinash KR ( Cognizant )
@Date   02/08/2017
@Description methods and properties related to test code coverage for ILW2Ccontroller 
********************************************/
@isTest
public class TestW2CaseController {
    
    @testSetup static void prepareData() 
    {   
        GlobalSettings__c gs  =  new GlobalSettings__c();
        gs.name         =  'PFFileRecieved';
        gs.PFFileRecieved__c  =  false;
        gs.Record_Type_Names__c  =  'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        List<Web2Case__c> w2cList   =   new List<Web2Case__c>();
        Web2Case__c w2c         =   new Web2Case__c();
        w2c.Name                =   'CaptchaPrivateKey';
        w2c.CaseObjectValues__c =   '6LfkKxkUAAAAAGDfThUtKMPgV-T9qJAsUj9losTx'; 
        w2cList.add( w2c );
        
        Web2Case__c w2c1            =   new Web2Case__c();
        w2c1.Name                   =   'CaptchaPublicKey';
        w2c1.CaseObjectValues__c    =   '6LfkKxkUAAAAAPNtG_UB6LGrxqLKEdWiuVAXnDUi'; 
        w2cList.add( w2c1 );
        
        Web2Case__c w2c2            =   new Web2Case__c();
        w2c2.Name                   =   'isCaptchaEnabled';
        w2c2.CaseObjectValues__c    =   'true'; 
        w2cList.add( w2c2 );
        
        insert w2cList;
        
        
        
        List<RoleAndPlanId_Settings__c> lst = new List<RoleAndPlanId_Settings__c>();
        
        RoleAndPlanId_Settings__c rp    =   new RoleAndPlanId_Settings__c( Name='Illinois_Supervisor',PlanId__c='IL1',Role_Id__c='00E3C000000DkwsUAC' );
        lst.add(rp);
        RoleAndPlanId_Settings__c rp1   =   new RoleAndPlanId_Settings__c( Name='Montana_Supervisor',PlanId__c='MS1',Role_Id__c='00E3C000000DkwtUAC' );
        lst.add(rp1);
        RoleAndPlanId_Settings__c rp2   =   new RoleAndPlanId_Settings__c( Name='New_Mexico_Supervisor',PlanId__c='NM1',Role_Id__c='00E3C000000DkwuUAC' );
        lst.add(rp2);
        RoleAndPlanId_Settings__c rp3   =   new RoleAndPlanId_Settings__c( Name='Oklahoma_Supervisor',PlanId__c='OK1',Role_Id__c='00E3C000000DkwvUAC' );
        lst.add(rp3);
        RoleAndPlanId_Settings__c rp4   =   new RoleAndPlanId_Settings__c( Name='Texas_Supervisor',PlanId__c='TX1',Role_Id__c='00E3C000000Dkx1UAC' );
        lst.add(rp4);
        
        insert lst;
    }
    
    public static testMethod void testW2Case_Test1()
    { 
    
        Account acct        =   new Account( Name = 'Default Account',CM_Corporate_Entity_Code__c='IL1');
        insert acct;

        Account acct1       =   new Account( Name= 'test Account',Tax_Id__c = '123345667' ,NPI__c = '43652148716',CM_Corporate_Entity_Code__c='IL1' );
        insert acct1;
        
        CM_Provider_Tax_Id__c taxIdTst    = new CM_Provider_Tax_Id__c(CM_PTI_Prov_Name_From__r =acct1,CM_PTI_Tax_Id__c='123345667',CM_Corporate_Entity_Code__c='IL1',CM_PTI_Tax_Shared_Ind__c=false  );
         insert taxIdTst;
        CM_Provider_Identification__c npiTst    = new CM_Provider_Identification__c(CM_PI_Prov__c =acct1.Id,CM_Prvdr_Iden_Typ_Cd__c = 'NPI', CM_Issu_Ident_Nmbr__c='43652148716',CM_Corporate_Entity_Code__c='IL1'  ); 
         insert npiTst;
        Rec_Id__c rec       =   new Rec_Id__c();
        rec.Def_Acc_Id__c    =   acct.Id;
        rec.Name            =   'Default Account';
        insert rec;

        Test.startTest();      
        W2Ccontroller con =   new W2Ccontroller();
        con.planId          =   'IL1';
        con.npiTaxIdChg     =   true;  
        con.nameSub         =   'test';
        con.titleSub        =   'test1';
        con.telNumbSub      =   'test sub1';
        con.emailAddrSub    =   'bcbs.com';
        con.nameOfProvGrp   =   'Test Group';
        con.taxIDNumber     =   '123345667';
        con.rendNpi         =   '12345678';
        con.billNPINum      =   '43652148716';
        con.compFormFor     =   'testcomp';
        con.billNPItype     =   'Type1';
        
        con.indProvName     =   'test provider';
        con.indType1NPI     =   '1111111111';
        con.otherId         =   '1233333333';
        con.remFrmAllLoc    =   true;
        con.strAddProvGrp   =   'test group';
        con.strAdd1ProvGrp  =   'test group1';
        con.cityProvGrp     =   'city group';
        con.stateProvGrp    =   'state prov grp';
        con.zipProvGrp      =   '60656';
        con.reasonleavgrp   =   'retirement';
        con.effDateofTrmProvGrp =  Date.Today();
        con.commProvGrp     =   'test comments';
        con.attProvGrp      =   true;
        con.strAddProvGrp1  =   'test provGrp1';
        con.strAdd1ProvGrp1 =   'test address';
        con.cityProvGrp1    =   'test city';
        con.stateProvGrp1   =   'Illinois';
        con.zipProvGrp1     =   '60601';
        con.reasonleavgrp1  =   'test reason';
        con.effDateofTrmProvGrp1    =   Date.Today();
        con.slaDays         =   '14';
        con.captchaPublicKey    =   '6LfkKxkUAAAAAPNtG_UB6LGrxqLKEdWiuVAXnDUi';
        con.useCaptcha      =   True;       
        
        
        
        con.nmChg           =   true;
        con.billAddrChg     =   true;
        con.credAddrChg     =   true;
        con.adminAddrChg    =   true;
        con.phyAddrChg      =   true;
        con.otherProvInfo   =   true;
        con.npiTaxIdChg     =   true;
        
        con.addLocProvGrp   =   false;
        con.remFrmAllLoc    =   false;
        
        con.lnameCur        =   'Test lastname';
        con.fnameNew        =   'test name1';
        con.lnameNew        =   'Test lastname1';
        con.midInitialCur   =   'midname';
        con.midInitialNew   =   'midname1';
        con.titleCur        =   'test title';
        con.titleNew        =   'test title1';
        
        con.suffixCur       =   'mr';
        con.suffixNew       =   'mrs';
        con.curPracName     =   'Physician';
        con.NewPracName     =   'Physician1';
        con.effDateofNameChg    =   Date.Today();
        con.commentNameChg      =   'test comment';
       
        con.newBillNPINum   =   '43652148717';
        con.newTaxIDNum     =   '123345668';
        con.effDateofNPIChg =   Date.today();
        con.commentNPITax   =   'test comment';
        con.taxIDNumCur     =   '123456789';
        con.billNPINumCur   =   '638746321874';
        
        con.StrAddrPhyCur   =   '300 E Randolph st';
        con.StrAddr2PhyCur  =   '300 E Randolph st1';
        con.cityPhyCur      =   'Chicago';
        con.statePhyCur     =   'IL';
        con.zipPhyCur       =   '60651';
        con.telPhyCur       =   '1234567890';
        con.emailPhyCur     =   'test@bcbs.com';
        con.faxPhyCur       =   '63248762138';
        con.primaryLocPhy   =   '300 E Randolph st22';
        
        con.strAddrPhyNew   =   '300 Randolph st34';
        con.strAddr2PhyNew  =   '300 Randolph st33';
        con.cityPhyNew      =   'Texas';    
        con.statePhyNew     =   'TX';
        con.zipPhyNew       =   '12345';
        con.telPhyNew       =   '1234567891';
        con.emailPhyNew     =   'test1@bcbs.com';
        con.faxPhyNew       =   '123467893';
        con.effDateofChgPhy =   Date.Today()+1;
        con.supervisingPhy  =   'test';
        con.acceptNewPat    =   'test pattern';
        con.commentPhy      =   'test Physical';
        
        con.monOpen         =   '09:00 AM';
        con.monClose        =   '10:00 PM';
        con.tueOpen         =   '09:00 AM';
        con.tueClose        =   '10:00 PM';
        con.wedOpen         =   '09:00 AM';
        con.wedClose        =   '10:00 PM';
        con.thuOpen         =   '09:00 AM';
        con.thuClose        =   '10:00 PM';
        con.friOpen         =   '09:00 AM';
        con.friClose        =   '10:00 PM';
        con.satOpen         =   '09:00 AM';
        con.satClose        =   '10:00 PM';
        con.sunOpen         =   '09:00 AM';
        con.sunClose        =   '10:00 PM'; 
        
        con.strAddrCredCur  =   'test addr1';
        con.strAddr2CredCur =   'test addr2';
        con.cityCredCur     =   'Chicago';
        con.stateCredCur    =   'IL';
        con.zipCredCur      =   '60651';
        con.telCredCur      =   '5374321123';
        con.emailCredCur    =   'test@test.com';
        con.faxCredCur      =   '1234567890';
        con.credConNm       =   'test con name';
    
        con.strAddrCredNew  =   'test addr11';
        con.strAddr2CredNew =   'test addr22';
        con.cityCredNew     =   'Chicago';
        con.stateCredNew    =   'IL';
        con.zipCredNew      =   '60651';
        con.telCredNew      =   '1234567890';
        con.emailCredNew    =   'test@test.com';
        con.faxCredNew      =   '1234567890';
        con.effDateofCredChg=   Date.Today()+2;
        con.commentCred     =   'afdhkjsadksaj';
        con.open24Phy       =   true;
        
        con.strAddrBillCur  =   'test address1';
        con.strAddr2BillCur =   'test address2';
        con.cityBillCur     =   'Chicago';
        con.stateBillCur    =   'IL';
        con.zipBillCur      =   '60561';
        con.telBillCur      =   '1234456590';
        con.emailBillCur    =   'test@test.com';
        con.faxBillCur      =   '1234567890';

        con.strAddrBillNew  =   'test Address11';
        con.strAddr2BillNew =   'test address22';
        con.cityBillNew     =   'Chicago';
        con.stateBillNew    =   'IL';
        con.zipBillNew      =   '60561';
        con.telBillNew      =   '1234567823';
        con.emailBillNew    =   'test@test.com';
        con.faxBillNew      =   '1234567823';
        con.effDateofChgBill=   Date.Today()+3;
        con.commentBill     =   'test 123';
    
        con.strAddrAdmCur   =   'test address 3';
        con.strAddr2AdmCur  =   'test address 4';
        con.cityAdmCur      =   'Chicago';
        con.stateAdmCur     =   'IL';
        con.zipAdmCur       =   '60561';
        con.telAdmCur       =   '7216343186';
        con.emailAdmCur     =   'test@test.com';
        con.faxAdmCur       =   '1232455789';
        con.admConNm        =   '1232455789';
    
        con.strAddrAdmNew   =   'test address 33';
        con.strAddr2AdmNew  =   'test address 44';
        con.cityAdmNew      =   'Chicago';
        con.stateAdmNew     =   'IL';
        con.zipAdmNew       =   '60561';
        con.telAdmNew       =   '1234567895';
        con.emailAdmNew     =   'test@test.com';
        con.faxAdmNew       =   '1234567890';
        con.effDateofChgAdm =   Date.Today()+5;
        con.commentAdm      =   'Test comments';
    
        con.hospPrivListAll =   'test hospital';
        con.ambSurCenterPriv=   'test hospital priv';
        con.licenseOPCur    =   '1234553444';
        con.specialty       =   'Gen Med';
        con.subSpecialtyCur =   'Family Helth care';
        con.speffdateCur    =   Date.Today();
        con.spcerdateCur    =   Date.Today();
        con.boardCertified  =   'Yes';
        con.ProvideLactationServices='Yes';
        con.commentOther    =   'test comments';
        con.effDateofChgOth =   Date.Today()+7;

        con.hospPrivListAllNew  =   'test hospital123';     
        con.ambSurCenterPrivNew =   'test hospital priv123';
        con.licenseOPNew    =       '12345534445';
        con.specialtyNew    =       'Gen Med';
        con.subSpecialtyNew =       'Family Helth care';
        con.speffdateNew    =       Date.Today()+10;
        con.spcerdateNew    =       Date.Today()+10;
        con.boardCertifiedNew=      'Yes'; 
        con.ProvideLactationServicesNew='Yes'; 
        con.langSpokenWritten=      'test';
        con.medSchoolName   =       'Boston medical school';
        con.yearOfGrad      =       Date.Today();
        con.ethnicity       =       'American Indian or Alaskan Native';
        con.resHospName     =       'test hospital';
        con.fromOther       =       Date.Today()+10;
        con.toOther         =       Date.Today()+30;
        con.dEA             =       'sadkjsfdsafdsa';
        con.dateOfBirth     =       Date.newInstance(1970, 01, 05 );
        con.dEAExpirationDate=      Date.newInstance(2020, 01, 05 );
      
        con.caseNumber      =       '123456';
        con.saveProvInfo();
        con.assignAccount();
        con.resetAdmChg();
        con.resetNameChg();
        con.resetOtherPrvChg();
        con.resetBillChg();
        con.resetCredChg();
        con.resetOffPhyChg();
        con.resetProvGrp();
        con.resetAdLoc();
        con.resetAdLoc2();

        Test.stopTest();  
    }

    public static testMethod void testW2Case_Test2()
    {
        Account acct1       = new Account( Name= 'test Account',Tax_Id__c = '123345667',CM_Corporate_Entity_Code__c='IL1' );
        insert acct1;

        Account acct2       = new Account(  FirstName= 'Phy',LastName = 'Smith',Tax_Id__c = '123345667',CM_Corporate_Entity_Code__c='IL1',RecordTypeId =Utils.getRecordTypeId('Account','Physician') );
        insert acct2;
    CM_Provider_Tax_Id__c taxId1Tst    = new CM_Provider_Tax_Id__c(CM_PTI_Prov_Name_From__r =acct1,CM_Corporate_Entity_Code__c='IL1',CM_PTI_Tax_Shared_Ind__c=false  );
         insert taxId1Tst;
        CM_Provider_Identification__c npi1Tst    = new CM_Provider_Identification__c(CM_PI_Prov__c =acct2.Id,CM_Prvdr_Iden_Typ_Cd__c = 'NPI', CM_Issu_Ident_Nmbr__c='436521487163',CM_Corporate_Entity_Code__c='IL1'  ); 
         insert npi1Tst;
        Rec_Id__c rec       =   new Rec_Id__c();
        rec.Name            =   'Default Account';
        rec.Def_Acc_Id__c    =   '0013C000005Q1HK';
        insert rec;

        Test.startTest();      
        W2Ccontroller con =   new W2Ccontroller();
        con.planId          =   'IL1';        
        con.nmChg           =   true;
        con.compFormFor     =   'testcomp';
        con.emailAddrSub    =   'test@bcbs.com';
        con.nameSub         =   'test';
        con.titleSub        =   'test1';
        con.telNumbSub      =   'test sub1';
        con.nameOfProvGrp   =   'Test Group';
        Blob bodyBlob=Blob.valueOf('nmattachmentbody');
        if(bodyBlob.size()>0)
        {
            /*
             * commented out because we were not able to deploy to Dry Run without this change. SF kept reporting compile error, even after
             * recompiling on UAT and DR.
             */ 
           // con.nmAttach.body        =   bodyBlob;
          //  con.nmAttach1.body        =   bodyBlob;
        }
      
        
        con.taxIDNumber     =   '12334566743234';
        con.rendNpi         =   '12345678';
        con.billNPINum      =   '436521487163';
        
        con.billNPItype     =   'Type1';
        con.fnameCur        =   'test name';
        con.fnameNew        =   'test name1';
        con.lnameCur        =   'Test lastname';
        con.lnameNew        =   'Test lastname1';
        con.midInitialCur   =   'midname';
        con.midInitialNew   =   'midname1';
        con.titleCur        =   'test title';
        con.titleNew        =   'test title1';
         con.suffixCur      =   'mr';
        con.suffixNew       =   'mrs';
        con.curPracName     =   'Physician';
        con.NewPracName     =   'Physician1';
        con.effDateofNameChg=   Date.Today();
        con.commentNameChg  =   'test comment';
        con.open24Phy       =   true;
       
        con.saveProvInfo();
        con.assignAccount();
        con.caseNumber      =  con.parentCase.Id; 
        Test.stopTest();  
    }

    public static testMethod void testW2Case_Test3()
    {
        Account acct1       = new Account( Name= 'test Account',Tax_Id__c = '123345667',CM_Corporate_Entity_Code__c='MT1' );
        insert acct1;

        Account acct2       = new Account(  FirstName= 'Phy',LastName = 'Smith',Tax_Id__c = '123345667',CM_Corporate_Entity_Code__c='MT1',RecordTypeId =Utils.getRecordTypeId('Account','Physician') );
        insert acct2;
        CM_Provider_Tax_Id__c taxId1Tst    = new CM_Provider_Tax_Id__c(CM_PTI_Prov_Name_From__r =acct1,CM_PTI_Tax_Id__c='1672145667',CM_Corporate_Entity_Code__c='MT1',CM_PTI_Tax_Shared_Ind__c=false  );
        insert taxId1Tst;
        CM_Provider_Identification__c npi1Tst    = new CM_Provider_Identification__c(CM_PI_Prov__c =acct2.Id,CM_Prvdr_Iden_Typ_Cd__c = 'NPI', CM_Issu_Ident_Nmbr__c='436521487163',CM_Corporate_Entity_Code__c='MT1'  ); 
        insert npi1Tst;

        Account acct        =   new Account( Name = 'Default Account',CM_Corporate_Entity_Code__c='MT1');
        insert acct;

        Rec_Id__c rec       =   new Rec_Id__c();
        rec.Def_Acc_Id__c    =   acct.Id;
        rec.Name            =   'Default Account';
        insert rec; 

        Test.startTest();      
        W2Ccontroller con =   new W2Ccontroller();
        con.planId          =   'MT1';
        
        con.nmChg           =   true;
        con.billAddrChg     =   true;
        con.credAddrChg     =   true;
        con.adminAddrChg    =   true;
        con.phyAddrChg      =   true;
        con.otherProvInfo   =   true;
        con.npiTaxIdChg     =   true;
        
        con.addLocProvGrp   =   true;
        con.remFrmAllLoc    =   true;
        
        con.compFormFor     =   'testcomp';
        con.emailAddrSub    =   'test@bcbs.com';
        con.nameSub         =   'test';
        con.titleSub        =   'test1';
        con.telNumbSub      =   'test sub1';
        con.nameOfProvGrp   =   'Test Group';
    
        con.taxIDNumber     =   '1672145667';
        con.rendNpi         =   '12345678';
        con.billNPINum      =   '43652148716';
        
        con.billNPItype     =   'Type1';
        con.fnameCur        =   'test name';
        con.fnameNew        =   'test name1';
        con.lnameCur        =   'Test lastname';
        con.lnameNew        =   'Test lastname1';
        con.midInitialCur   =   'midname';
        con.midInitialNew   =   'midname1';
        con.titleCur        =   'test title';
        con.titleNew        =   'test title1';
         con.suffixCur      =   'mr';
        con.suffixNew       =   'mrs';
        con.curPracName     =   'Physician';
        con.NewPracName     =   'Physician1';
        con.effDateofNameChg=   Date.Today();
        con.commentNameChg  =   'test comment';
        con.open24Phy       =   true;      
        con.caseNumber      =   '123456';

        con.saveProvInfo();
        con.assignAccount();
        con.resetAdmChg();
        con.resetNameChg();
        con.resetOtherPrvChg();

        Test.stopTest();  
    }
}