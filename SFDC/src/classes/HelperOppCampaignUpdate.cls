/**
 * Helper class for updating Opportunities with the same Campaign as that of its Interaction. --- 
 * @author Samir
 * @date  09/14/2014(mm/dd/yy)
 * @version 1.0
 */

global class HelperOppCampaignUpdate {
    
    /**
     * An asynchronous method to update the Opportunity's Campaign with that of its Interaction.
    **/
    //@future
    public static void updateCampaign(Opportunity opp){
        System.debug('BEFOREUPDATE  ');
        
        List<Interaction__c> listInteractions = [SELECT Id,Campaign__c from Interaction__c where Id= :opp.Interaction__c];
        
        if(listInteractions != null && listInteractions.get(0).Campaign__c != null){
            opp.CampaignId = listInteractions.get(0).Campaign__c;
            System.debug('BEFOREUPDATE  '+ listInteractions.get(0).Campaign__c);
            try{
                update opp;
            }catch(Exception e){
                System.debug('Exception while updating Opportunitys Campaign  '+ e);
            }
            
        }
    }    
}