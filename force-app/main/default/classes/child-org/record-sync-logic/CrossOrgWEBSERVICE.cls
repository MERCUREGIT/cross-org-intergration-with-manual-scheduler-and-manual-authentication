/**
 * @author ngum buka fon nyuydze
 * @since 06/02/2023
 */



@RestResource(urlMapping='/child/sync-records/v1/*')
global without sharing class CrossOrgWEBSERVICE {
    @HttpPost
    global static String getRecordsTosync() {
        list<lead> recordsToSync= new list<lead>();
        try {
            RestRequest request = RestContext.request;
            CrossOrgWEBSERVICE.syncRecords(request.requestBody.toString());
            return 'child ran with success';

        } catch (Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            return 'The following exception has occurred: ' + e.getMessage();
        }
    }
    global static void syncRecords(string jsonString){
        list<lead> listOfRecords = (list<lead>)JSON.deserializeStrict(jsonString, list<lead>.class);
        list<lead> recordsToCreateOrUpdate = new list<lead>();
        set<string> nameAndEmailsToSync = new set<String>();
        map<String,lead> mapEmailToLeadToSync = new map<string,lead>();
        map<String,lead> mapNameToLeadToSync = new map<string,lead>();

        for(lead instance : listOfRecords){
            nameAndEmailsToSync.add(instance.LastName);
            nameAndEmailsToSync.add(instance.Email);
        }
        list<lead> existingLeadRecords = [SELECT id, name, lastname, company, leadsource, email  FROM lead WHERE Email in :nameAndEmailsToSync OR LastName in :nameAndEmailsToSync];

        for (Lead instance : existingLeadRecords) {
            mapNameToLeadToSync.put(instance.LastName, instance);
            mapEmailToLeadToSync.put(instance.Email, instance);
        }

        for(lead instance : listOfRecords){            
            if(mapEmailToLeadToSync.containsKey(instance.Email) && mapNameToLeadToSync.containsKey(instance.LastName)){
                lead existingLeadRecord = mapEmailToLeadToSync.get(instance.Email);
                if(existingLeadRecord.LastName == instance.LastName && existingLeadRecord.Email==instance.email){

                    recordsToCreateOrUpdate.add(new lead(id=existingLeadRecord.id, LastName=instance.LastName, Company=instance.company, Email= instance.email,LeadSource=instance.LeadSource));
                }
            }else{
                System.debug('Inexisting record');
                recordsToCreateOrUpdate.add(
                    new lead(LastName=instance.LastName, Company=instance.company, Email= instance.email,LeadSource=instance.LeadSource  )
                );
            }
        }
        upsert recordsToCreateOrUpdate;
    }
}


