global class IpadSyncSOAPWebservice {
    webService static Id createRemoteSession(String customerName,String ipadusername, String product,String session,String sessionId) {
        
        RemoteSessionData__c sessionData = new RemoteSessionData__c();
        sessionData.Customer_Name__c= customerName;
        sessionData.Ipad_Username__c= ipadusername;
        sessionData.Product__c= product;
        sessionData.SessionID__c=session;
        insert sessionData;
        return sessionData.Id;
    }
    
    /*webService static Id login(String username,String password) {
        RemoteSessionData__c sessionData = new RemoteSessionData__c();
        sessionData.Customer_Name__c= customerName;
        sessionData.Ipad_Username__c= ipadusername;
        sessionData.Product__c= product;
        sessionData.SessionID__c=session;
        insert sessionData;
        return sessionData.Id;
    }*/
    
       
}