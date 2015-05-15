@RestResource(urlMapping='/RemoteSessionData__c/*')
global with sharing class IpadSyncRestService {

   /* @HttpGet
    global static RemoteSessionData__c doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String sessionId= req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        System.debug('session id-----------------'+sessionid);
        RemoteSessionData__C result = [SELECT Id, Product__c FROM RemoteSessionData__c WHERE ID = :sessionId];
        return result;
    }
  
  
    global static String doPost(String customerName,String ipadusername, String product,String session) {
        RemoteSessionData__c sessionData = new RemoteSessionData__c();
        RestRequest req = RestContext.request;
      //  req.addHeader('Authorization', '00DQ000000GK3pW!ARIAQMtLf_cPFOogDA4N3Y8Li2OVyem7WqkHy_WxuI4mDTSnhYpgzkhWF5FS8UnH3xvuMmRpvlcWxPjl.LjwQJwn.imYp5HU');
        sessionData.Customer_Name__c= customerName;
        sessionData.Ipad_Username__c= ipadusername;
        sessionData.Product__c= product;
        sessionData.SessionID__c=session;
        insert sessionData;
        return sessionData.Id;
    }*/
    @HttpPost
    global static RSDWrapper doPost(List<RemoteSessionData__c> SyncIpadDataList) {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        RSDWrapper response = new RSDWrapper();
        
        try {
            insert SyncIpadDataList;
            response.rsdList = SyncIpadDataList;
            response.status = 'Success';
            response.message = 'Your Ipad data have been created successfully';
        }
        catch(Exception exc) {
            res.StatusCode = 500;
            response.rsdList= null;
            response.status = 'Error';
            response.message = 'Your request failed with the following error: ' + exc.getMessage();
        }
        
        return response;
        
        
    }



 global class RSDWrapper {
        public List<RemoteSessionData__c> rsdList;
        public String status;
        public String message;
        
        public RSDWrapper(){
            rsdList = new List<RemoteSessionData__c>();
        }
    }


    
}