public without sharing class filePreviewAndDownloadController {
    @AuraEnabled(cacheable=true)
        public static Map<ID, String> getRelatedFilesByRecordId(String recordId) {
            // Get record file IDs        
            List<ContentDocumentLink> files = [SELECT ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = '0016800000H6XrKAAV'];
            List<ID> fileIDs = new List<ID>();
            for (ContentDocumentLink docLink : files) {
                fileIDs.add(docLink.ContentDocumentId);
            }
     
            List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
                FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
            Map<ID, String> mapIdTitle = new Map<ID, String>();
            for (ContentVersion docLink : docs) {
                mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
            }
            System.debug('mapIdTitle=' + mapIdTitle);
            return mapIdTitle;
        }

        @AuraEnabled(cacheable=true)
        public static String getLoginURL(){
            String baseURL = System.URL.getSalesforceBaseUrl().toExternalForm();
            User userRecord = [Select Id, AccountId, ContactId FROM User Where Id = :UserInfo.getUserId()];
            if(userRecord.ContactId != null){
                baseUrl = getExperienceURL();
            }
            return baseUrl;
        }

        public static String getExperienceURL(){
            String baseUrl = Network.getLoginUrl(Network.getNetworkId());
            baseURL =  baseURL.replace('/s/login', '');
            baseURL =  baseURL.replace('/s/Login', '');
            baseURL =  baseURL.replace('/login', '');
            baseURL =  baseURL.replace('/Login', '');
            return baseURL;
        }
    
    
}