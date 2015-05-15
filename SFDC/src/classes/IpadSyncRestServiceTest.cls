@isTest
private class IpadSyncRestServiceTest{

    static testMethod void testwebservicepost() {

        //do request
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = 'services/apexrest/RemoteSessionData__c';  
        RemoteSessionData__c remotedata= new RemoteSessionData__c();
        RemoteSessionData__c remotedata1= new RemoteSessionData__c();
        IpadSyncRestService.RSDWrapper rsdwr= new IpadSyncRestService.RSDWrapper();
        List<RemoteSessionData__c> remotelist=new List<RemoteSessionData__c>();
        remotedata.Customer_Name__c='testcustomer';
        remotedata.SessionID__c='100000';
        remotelist.add(remotedata);
        remotelist.add(remotedata1);
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
       // RestContext.request.addHeader(rsdwr);

        rsdwr=IpadSyncRestService.doPost(remotelist);
       // req.addParameter('SyncIpadDataList', remotelist);
        //req.addParameter('time', '1390296387');
        //req.addParameter('hash', '1wer2547');

     

       // String results = StoreController.getAccounts();

    }
}