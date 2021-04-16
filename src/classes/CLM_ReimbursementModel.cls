public class CLM_ReimbursementModel { 
	// Agreement Plans Start
    public static final String NEW_MEXICO_PLAN = 'New Mexico';
    public static final String OKLAHOMA_PLAN = 'Oklahoma';
    public static final String Illinois_PLAN = 'Illinois';
    public static final String Montana_PLAN = 'Montana';
    public static final String Texas_PLAN = 'Texas';
    // Agreement Plans End
    
    // Record Types Start
    public static Id facilityRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Facility').getRecordTypeId();
    public static Id ASCRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('ASC').getRecordTypeId();
    public static Id ANCRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Non-ASC Ancillary').getRecordTypeId();
    public static Id medicalRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Medical Group').getRecordTypeId();
    public static Id professionalRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Professional').getRecordTypeId();
    // Record Types End
    
    // Provider Service Types Start
    public static final String FACILITY_REHAB = 'Facility-Rehab';
    public static final String FACILITY_ACUTE_CARE = 'Facility -Acute Care';
    public static final String FACILITY_BEHAVIORAL_HEALTH = 'Facility-Behavioral Health';
    
    public static final String BIRTHING_CENTER = 'Birthing Center';
    public static final String DME_W_POWER_MOBILITY = 'DME w/ Power Mobility';
    public static final String DME_WO_POWER_MOBILITY = 'DME w/o Power Mobility';
    public static final String LAB = 'Lab';
    public static final String Ambulance = 'Ambulance';
    public static final String DIALYSIS = 'Dialysis';
    public static final String HOME_HEALTH = 'Home Health';
    public static final String HOSPICE = 'Hospice';
    public static final String SNF = 'SNF';
    public static final String DME = 'DME';
    public static final String HOME_INFUSION = 'Home Infusion';
    public static final String HOME_HEALTH_AND_HOSPICE = 'Home Health and Hospice';
 
    public static final String FACILITY_LTAC  = 'Facility-LTAC';
    public static final String MG_ANESTHESIA  = 'MG-Anesthesia';
    public static final String MG_BEHAVIORAL  = 'MG-Behavioral';
    public static final String MG_CHIROPRACTIC  = 'MG-Chiropractic';
    public static final String MG_PCP  = 'MG-PCP';
    
    public static final String PROF_ANESTHESIA  = 'Prof-Anesthesia';
    public static final String PROF_BEHAVIORAL  = 'Prof-Behavioral';
    public static final String PROF_CHIROPRACTIC  = 'Prof-Chiropractic';
    public static final String PROF_PCP  = 'Prof-PCP';
    
    public static final String FACILITY_PSYCH = 'Psych';
    public static final String FACILITY_RTC = 'RTC';
    
    
    // Provider Service Types End
    
    // Provider Networks Start
    // NM Provider Networks
    public static final String NM_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK =  'NM Medicare Advantage HMO Provider Network';
    public static final String NM_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK =  'NM Medicare Advantage PPO Provider Network';
    public static final String NM_MEDICAID_PROVIDER_NETWORK =  'NM Medicaid Provider Network';
    
    //OK Provider Networks
    public static final String OK_BCBS_MEDICARE_ADVANTAGE_HMO_PROVIDER_NETWORK = 'OK BCBS Medicare Advantage HMO Provider network';
    public static final String OK_BCBS_MEDICARE_ADVANTAGE_PPO_PROVIDER_NETWORK = 'OK BCBS Medicare Advantage PPO Provider network';
    public static final String OK_BLUE_ADVANTAGE_PPO_PROVIDER_NETWORK = 'OK Blue Advantage PPO Provider Network';
    public static final String OK_BLUELINES_HMO_PROVIDER_NETWORK ='OK BlueLincs HMO Provider Network';
    public static final String OK_BLUECHOICE_PPO_PROVIDER_NETWORK = 'OK Blue Choice PPO Provider Network';
    public static final String OK_BLUE_PREFERRED_PPO_PROVIDER_NETWORK = 'OK Blue Preferred PPO Provider Network';
    public static final String OK_BLUETRADITIONAL_PROVIDER_NETWORK = 'OK BlueTraditional Provider Network';
    public static final String OK_BLUE_PLAN65_SELECT_PROVIDER_NETWORK = 'OK Blue Plan65 Select Provider Network';
    
    //IL Provider Networks
    public static final String IL_Medicare_Advantage_HMO_Provider_Network = 'IL Medicare Advantage HMO Provider Network';
    public static final String IL_Medicare_Advantage_PPO_Provider_Network = 'IL Medicare Advantage PPO Provider Network';
    
    //MT Provider Networks
    public static final String MT_Medicare_Advantage_HMO_Provider_Network = 'MT Medicare Advantage HMO Provider Network';
    public static final String MT_Medicare_Advantage_PPO_Provider_Network = 'MT Medicare Advantage PPO Provider Network';
    
    //Texas Provider Networks
    public static final String TX_CHIP_Provider_Network = 'CHIP Provider Network';
    public static final String TX_STAR_Kids_Provider_Network = 'STAR Kids Provider Network';
    public static final String TX_STAR_Medicaid_Provider_Network = 'STAR Medicaid Provider Network';
    public static final String TX_STAR_Plus_Provider_Network = 'STAR Plus Provider Network';
    
    // Provider Networks End 
}