/**
 * Helper class for OpportunityStageTracker --- 
 * @author Samir
 * @date  09/07/2014(mm/dd/yy)
 * @version 1.0
 */

global class HelperOSTTrigger {
    private static final String stageSeen = '1-Seen';
    private static final String stageTried = '2-Tried';
    private static final String stageShortlisted = '3-Shortlisted';
    private static final String stageBought = '4-Bought';
    
    /**
     * An asynchronous method to process logic for inserting requried recrds to the OpportunityStageTracker.
     **/
    @future
    public static void updateOST(Set<Id> oppId){//Id oppId){
        List<Opportunity> listOpps = [SELECT Name,StageName,OwnerId,Availability_Status__c from Opportunity where Id in :oppId];
        for(Opportunity opportunity : listOpps){            
 //           Opportunity opportunity = [SELECT Name,StageName,OwnerId,Availability_Status__c from Opportunity where Id = :oppId];  
            if(opportunity.Availability_Status__c){ //Only Opportunites that are 'OPEN' needs to be considered.
                String productId = getProductId(opportunity);
                if(productId != null)
                    processOST(productId, opportunity);
            }
        }
    }
    
    /**
     * method to process logic for inserting requried records to the OpportunityStageTracker.
     **/
    private static void processOST(String productId, Opportunity opportunity){
        //Create OSTs for all stages including and prior to Bought Or Lost, but NOT of Lost.
        if(opportunity.StageName == 'Lost' || opportunity.StageName == 'Bought'){
            if(checkOSTDupe(productId, opportunity.Id,stageBought)){
                if(opportunity.StageName == 'Bought')// record only the Bought Status and not the Lost Ones.
                    createOSTRecord(productId, opportunity.Id,stageBought,opportunity.OwnerId);
                
                //Create records for all subsequent stages prior to Bought Or Lost.
                if(checkOSTDupe(productId, opportunity.Id,stageShortlisted))
                    createOSTRecord(productId, opportunity.Id,stageShortlisted,opportunity.OwnerId);
                
                if(checkOSTDupe(productId, opportunity.Id,stageTried))
                    createOSTRecord(productId, opportunity.Id,stageTried,opportunity.OwnerId);
                
                if(checkOSTDupe(productId, opportunity.Id,stageSeen))
                    createOSTRecord(productId, opportunity.Id,stageSeen,opportunity.OwnerId);
            }
        }
        
        //Create OSTs for all stages including and prior to 'Shortlisted'.
        if(opportunity.StageName == 'Shortlisted' ){
            if(checkOSTDupe(productId, opportunity.Id,stageShortlisted)){
                if(checkOSTDupe(productId, opportunity.Id,stageShortlisted))
                   createOSTRecord(productId, opportunity.Id,stageShortlisted,opportunity.OwnerId);
                
                //Create records for all subsequent stages prior to Shortlisted.
                if(checkOSTDupe(productId, opportunity.Id,stageTried))
                    createOSTRecord(productId, opportunity.Id,stageTried,opportunity.OwnerId);
                
                if(checkOSTDupe(productId, opportunity.Id,stageSeen))
                    createOSTRecord(productId, opportunity.Id,stageSeen,opportunity.OwnerId);
                
            }
        }
        
        //Create OSTs for all stages including and prior to 'Tried'.
        if(opportunity.StageName == 'Tried' ){
            if(checkOSTDupe(productId, opportunity.Id,stageTried)){
                createOSTRecord(productId, opportunity.Id,stageTried,opportunity.OwnerId);
                
                //Create records for all subsequent stages prior to Tried.
                if(checkOSTDupe(productId, opportunity.Id,stageSeen))
                    createOSTRecord(productId, opportunity.Id,stageSeen,opportunity.OwnerId);
            }
        }
        
        //Create OSTs for stage 'Seen'.
        if(opportunity.StageName == 'Seen' ){
            if(checkOSTDupe(productId, opportunity.Id,stageSeen))
                createOSTRecord(productId, opportunity.Id,stageSeen,opportunity.OwnerId);
        }
    }
    
    /**
     * method to iinsert requried recrds to the OpportunityStageTracker.
     **/
    private static void createOSTrecord(String productId, String opportunityId, String stage, String ownerId){
        try{
                OpportunityStageTracker__c ost = new OpportunityStageTracker__c();
                ost.Opportunity2__c = opportunityId;
                ost.Product2__c =  productId;
                ost.Stage__c = stage;
                ost.OwnerId = ownerId;
                insert ost;
        }catch(Exception e){
                System.debug('FAILED TO INSERT TRACKER FOR  ...'+ opportunity.Name);
        }
    }    

    /**
     * method to retrieve product Id from line items in the opportunity.
     **/
    private static String getProductId(Opportunity opportunity){
        try{
        List<Opportunity> listOpps = [SELECT (SELECT PriceBookEntry.Product2.Id from OpportunityLineItems) from Opportunity where Id = :opportunity.Id];
        if(listOpps != null && listOpps.size()>0 && listOpps.get(0) != null && listOpps.get(0).OpportunityLineItems[0] != null)
            return listOpps.get(0).OpportunityLineItems[0].PriceBookEntry.Product2.Id;
        else
            return null;
        }
        catch(Exception e){
        System.debug('FAILED TO INSERT TRACKER BCOZ THERE IS NO OPPLINEITEM LINKED TO PRODUCT  ...');
        return null;
        }
    }
    
    /**
     * method to check if there exists a duplicate entry for the same opportunity and stage.
     **/
    private static Boolean checkOSTDupe(String productId,String opportunityId, String stage){
        List<OpportunityStageTracker__c> listOST = [Select Id from OpportunityStageTracker__c where Product2__c = :productId and Opportunity2__c = :opportunityId and Stage__c = :stage];
        if (listOST.size() == 0)
            return TRUE;//No records available for this opportunity & stage
        return false;
    }

}