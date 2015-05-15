trigger trig_ProfileStatusUpdate on Interaction__c (after update,after insert) {

    if(Trigger.isInsert){
        
        Contact contacts=new Contact();
        Set<Id> listIntId = Trigger.newMap.keySet();
        List<Contact> updateContactList = new List<Contact>();
        
       // List<Contact> conList= [select id,Profile_Status__c from contact where Id in :];
        
        List<Interaction__C> listInteractions=[select id,Contact__C from Interaction__C where Id in :listIntId];
        
        if(listInteractions!=null && listInteractions.size()>0){
         Set<Id> listContact= new Set<Id>();
        for(Interaction__c inteList : listInteractions){
             listContact.add(inteList.Contact__c);
        }
        List<Contact> conList= [select id,Profile_Status__c from contact where Id in :listContact];
               
            if(conList!=null){
               for(Contact con : conList){
                        con.Profile_Status__c='interacted';
                        con.lastInteractionDate__c= Date.Today();
                        updateContactList.add(con);
                }
            }
         update updateContactList;
        }
                     
      
     }
        
        
        
        
     if(Trigger.isUpdate){
        //Update all the related Opportunities Campaigns to the interaction's Campaign
    //@author Samir
    //@date 12/09/2014
      Set<Id> listIntId = new Set<Id>();
      for(Interaction__C inte: Trigger.new){
      listIntId.add(inte.Id);
      }
     
         //   System.debug('List of Ids=============='+listIntId);
            List<Interaction__c> listInteractions = [SELECT Campaign__c, (SELECT Id,Name from Opportunities__r) from Interaction__c where Id in :listIntId];
            String campaignId = '';
            if(listInteractions!=null && listInteractions.size()>0){
            campaignId = listInteractions.get(0).Campaign__c;
            List<Opportunity> listOpps = listInteractions.get(0).Opportunities__r;
            System.debug('LIST OF OPPS' + listOpps.size() + 'CID '+campaignId);
        
            for(Opportunity opp : listOpps){
                if(campaignId != null){
                    opp.CampaignId = campaignId;    
                    try{
                        update opp;
                    }catch(Exception e){
                        System.debug('Exception while updating Opportunitys Campaign' + opp.Name + ' for Campaign from Interaction');
                    }
                }    
            }
            }
           
        }    
    
 }