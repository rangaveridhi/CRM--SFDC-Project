trigger CampaignMemberCreation on Contact (after insert,before update) {

if(Trigger.isInsert){

List<CampaignMember> campaignMemList=  new List<CampaignMember>();

for(Contact con: Trigger.new){        

  if(con.Campaign__c!=null){       
                 System.debug('Campaign and Profile Id after insert---------------'+con.Campaign__c+'----'+con.Id);      
              //CampaignMember c = new CampaignMember(CampaignID = con.Campaign__c,ContactId=con.Id,Status='Opt-In');
              
              List<CampaignMember> listC = [SELECT ContactId FROM CampaignMember where ContactId=:con.Id and CampaignId=:con.Campaign__c];
              if(listC != null && listC.size()>0){
              System.debug('TRIGGER FOR CONTACT UPDATE FIRED . CAMPAIGN MEMEBER ALREADY EXISTS.');
               
               }
               else{
                   System.debug('TRIGGER FOR CONTACT UPDATE FIRED . CAMPAIGN GETTING UPSERTED.');
                     CampaignMember campaign = new CampaignMember();
                    campaign.CampaignID = con.Campaign__c;
                    campaign.ContactId=con.Id;
                   campaign.Status='Opt-In';
                   campaignMemList.add(campaign);
                   
                   }
   
   
  }
  }
  insert campaignMemList; 
}

if(Trigger.isUpdate){

//Contact cona= Trigger.old;


for(Contact con: Trigger.new){        
  if(con.Campaign__c!=null){       
                 System.debug('Campaign and Profile Id after update---------------'+con.Campaign__c+'----'+con.Id);      
              //CampaignMember c = new CampaignMember(CampaignID = con.Campaign__c,ContactId=con.Id,Status='Opt-In');
              CampaignMember c1 = new CampaignMember();
               c1.CampaignID = con.Campaign__c;
              c1.ContactId=con.Id;
              c1.Status='Opt-In';
              
              
              
              List<CampaignMember> listC = [SELECT ContactId FROM CampaignMember where ContactId=:con.Id and CampaignId=:con.Campaign__c];
              // campaignMember.Campaign.Id = acct.Campaign__c;
              // campaignMember.Contact.Id=stdController.getId();
               if(listC != null && listC.size()>0){
               System.debug('TRIGGER FOR CONTACT UPDATE FIRED . CAMPAIGN MEMEBER ALREADY EXISTS.');
               
               }
               
               else{
                   System.debug('TRIGGER FOR CONTACT UPDATE FIRED . CAMPAIGN GETTING UPSERTED.');
                   upsert c1; 
                   }
   
  }
  }
}
}