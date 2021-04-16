/**************************************************************************************************
Apex Class Name  : OMNIUserRecalculationScheduler
Version          : 1.0  
Functionality    : This is an scheduler class for the batch OMNIUserRecalculation
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Laxman Vattam              Sep 8, 2017       		Code Logic For PPN-5272
***************************************************************************************************/
global class OMNIUserRecalculationScheduler implements Schedulable{

    global void execute(SchedulableContext sc) {
        OMNIUserRecalculation b1 = new OMNIUserRecalculation();
        ID batchprocessid = Database.executeBatch(b1,100);           
    }
}