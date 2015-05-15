/**
 * Helper class for RFMAnalysis --- 
 * @author Samir
 * @date  09/25/2014(mm/dd/yy)
 * @version 1.0
 */
global class HelperRFMAnalysis {
    private static Integer recencyScore;
    private static Integer frequencyScore;
    private static Long monetaryScore;
    private static Integer frequencyCount;
    private static Integer accompaniedFrequencyCount;
    
//    @future //Removing this as this helper is now being alled from BATCH APEX
    public static void updateRFMAnalysis(Set<Id> listContacts){
//        System.debug('INSIDE FUTURE ANALYSIS FOR RFM');
        for(Id contactId : listContacts){
            getRFMScore(contactId);
            doRFMAnalysis(contactId);
        }    
//        System.debug('DONE');
        
    }
    
    
    private static void doRFMAnalysis(Id contactId) {
        RFMAnalysis__c rfmanalysis = new RFMAnalysis__c();
        rfmanalysis.Contact__c = contactId;
        rfmanalysis.ContactId__c = String.valueOf(contactId);
        rfmanalysis.Recency_Score__c = recencyScore;
        rfmanalysis.Frequency_Score__c = frequencyScore;
        rfmanalysis.Monetary_Score__c = monetaryScore;
        rfmanalysis.RFM_Score__c = recencyScore + frequencyScore + monetaryScore ;
        try{
            System.debug('Before Insert');
            upsert rfmanalysis ContactId__c;
        }catch(Exception e){
            System.debug('Exception' + e.getMessage());
        }
        System.debug('RFM TOTAL'+ recencyScore + '   '+ frequencyScore + '   '+ monetaryScore + '   ');

    }  
    
/**
 * method to calculate Recency Score of a Profile
 **/
    private static void getRFMScore(Id contactId){
        recencyScore = 0;
        frequencyScore = 0;
        frequencyCount = 0;
        accompaniedFrequencyCount = 0;
        monetaryScore = 0;
        Decimal tms = 0;
        //Get all 'Bought' opportunities having CloseDate within 2 years for this Contact.
        List<Opportunity> listOpps = [Select Id,Name,CloseDate, (SELECT PriceBookEntry.Product2.Name,PriceBookEntry.UnitPrice from OpportunityLineItems) from Opportunity where StageName='Bought' AND CloseDate = LAST_N_DAYS:730  AND opportunity.Contact__c = :contactId];
        for(Opportunity opp : listOpps){
            calculateRecencyScore(opp);
            if(opp!=null && opp.OpportunityLineItems!=null && null != opp.OpportunityLineItems[0].PriceBookEntry.UnitPrice)//2 points are to be given for eack Lakh. OR 1 point for 50K.
                tms += opp.OpportunityLineItems[0].PriceBookEntry.UnitPrice / 50000;
        }
          
        //Get all 'Bought' opportunities having CloseDate within 2 years where this Contact is an Accompaniment.  
        List<Opportunity> listAccompaniedOpps = [Select Id,Name ,CloseDate, (SELECT PriceBookEntry.Product2.Name,PriceBookEntry.UnitPrice from OpportunityLineItems) from Opportunity where StageName='Bought' AND CloseDate = LAST_N_DAYS:730 AND Interaction__c IN (Select Interaction__c from Accompaniment__c where Relation__r.Related_Contact__c=:contactId)];
        for(Opportunity opp : listAccompaniedOpps){
            calculateAccompaniedRecencyScore(opp);
            if(opp!=null && opp.OpportunityLineItems!=null && null != opp.OpportunityLineItems[0].PriceBookEntry.UnitPrice)//1 monetary point to be given for eack Lakh.
                tms += opp.OpportunityLineItems[0].PriceBookEntry.UnitPrice / 100000;
        }       
        
        //Calculate Frequency Score
        calculateFrequencyScore();
        calculateAccompaniedFrequencyScore();
       
        //Calculate Monetary Score
        if(tms != 0)
            monetaryScore = Math.roundToLong(tms);
    }
    

/**
 * method to calculate Recency Score of a Profile Bought Opportunity
 **/
    private static void calculateFrequencyScore(){
        if(frequencyCount >=3)
            frequencyScore+=100;
        else if(frequencyCount == 2)
            frequencyScore+=70;
        else if(frequencyCount == 1)
            frequencyScore+=50;
    }

/**
 * method to calculate Recency Score of an Accompaniment for Bought Opportunity
 **/
    private static void calculateAccompaniedFrequencyScore(){
        if(accompaniedFrequencyCount >=3)
            frequencyScore+=50;
        else if(accompaniedFrequencyCount == 2)
            frequencyScore+=35;
        else if(accompaniedFrequencyCount == 1)
            frequencyScore+=25;
    }


/**
 * method to calculate Recency Score of a Profile Bought Opportunity
 **/
    private static void calculateRecencyScore(Opportunity opp){
            if(null != opp.CloseDate){
                System.debug('Closed date In teh RFM Analaysis Class---'+opp.CloseDate);
                if(opp.CloseDate > (Date.today() - 90)){
                    recencyScore += 100;
                    frequencyCount += 1;
                }                    
                else if(opp.CloseDate > (Date.today() - 180)){
                    recencyScore += 90;
                    frequencyCount += 1;
                }
                else if(opp.CloseDate > (Date.today() - 270)){
                    recencyScore += 80;
                    frequencyCount += 1;
                }
                else if(opp.CloseDate > (Date.today() - 365)){
                    recencyScore += 70;
                    frequencyCount += 1;
                }
                else if(opp.CloseDate > (Date.today() - 450)){
                    recencyScore += 55;
                    frequencyCount += 1;
                }
                else if(opp.CloseDate > (Date.today() - 540)){
                    recencyScore += 40;
                    frequencyCount += 1;
                }
                else if(opp.CloseDate > (Date.today() - 730)){
                    recencyScore += 25;
                    frequencyCount += 1;
                }
            }
    }

/**
 * method to calculate Recency Score of an Accompaniment for Bought Opportunity
 **/
    private static void calculateAccompaniedRecencyScore(Opportunity opp){
            if(null != opp.CloseDate){
                System.debug('Closed date In teh RFM Analaysis Class Accm---'+opp.CloseDate);
                if(opp.CloseDate > (Date.today() - 90)){
                    recencyScore += 50;
                    accompaniedFrequencyCount += 1;
                }    
                else if(opp.CloseDate > (Date.today() - 180)){
                    recencyScore += 45;
                    accompaniedFrequencyCount += 1;
                }    
                else if(opp.CloseDate > (Date.today() - 270)){
                    recencyScore += 40;
                    accompaniedFrequencyCount += 1;
                }    
                else if(opp.CloseDate > (Date.today() - 365)){
                    recencyScore += 35;
                    accompaniedFrequencyCount += 1;
                }    
                else if(opp.CloseDate > (Date.today() - 450)){
                    recencyScore += 27;
                    accompaniedFrequencyCount += 1;
                }    
                else if(opp.CloseDate > (Date.today() - 540)){
                    recencyScore += 20;
                    accompaniedFrequencyCount += 1;
                }    
                else if(opp.CloseDate > (Date.today() - 730)){
                    recencyScore += 12;
                    accompaniedFrequencyCount += 1;
                }    
            }
    }

}