/**
* This trigger is to update the Total number of interactions per Campaign.
**/

trigger triggerinteractionCampaignCount on Interaction__c (before update,after insert,after update) {

      // Campaign campaign=new Campaign();
       
        if(Trigger.isUpdate && Trigger.isBefore){
        System.debug('Before update trigger-----------------------------------');
        //Set<Id> listIntId = Trigger.oldMap.keySet();
        List<Campaign> updateCampaignList= new List<Campaign>();
        Set<Campaign> mySet = new Set<Campaign>();
        for(Interaction__C interaction: Trigger.old){
          if(interaction.Campaign__c!=null){
                 Campaign campaign=new Campaign();        
                 campaign= [select id,Total_No_Interactions__c from Campaign where Id  =: interaction.Campaign__c limit 1];
                  System.debug('Campaign object before --------------------'+campaign+'-------------');
                 if(campaign!=null && campaign.Total_No_Interactions__c>=0){
                 campaign.Total_No_Interactions__c=campaign.Total_No_Interactions__c-1;
                 
                 mySet.add(campaign);
                   }   
           }
          }
           updateCampaignList.addAll(mySet);   
          update updateCampaignList;
       }
        if(Trigger.isInsert || (Trigger.isUpdate && Trigger.isAfter)){
         System.debug('Afterv update trigger-----------------------------------');
        List<Campaign> updateCampaignList= new List<Campaign>();
        Set<Campaign> mySet = new Set<Campaign>();
        
        for(Interaction__C interaction: Trigger.new){
          if(interaction.Campaign__c!=null){
                 Campaign campaign1= new Campaign();        
                 campaign1= [select id,Total_No_Interactions__c from Campaign where Id  =: interaction.Campaign__c limit 1];
                  System.debug('Campaign object  after --------------------'+campaign1+'-------------');
                 if(campaign1!=null && campaign1.Total_No_Interactions__c>=0){
                 System.debug('Campaign object detail--------------------'+campaign1+'-------------');
                 campaign1.Total_No_Interactions__c=campaign1.Total_No_Interactions__c+1;
                 mySet.add(campaign1);
                 }     
           }
          }
          updateCampaignList.addAll(mySet);     
          update updateCampaignList;
      }
      }