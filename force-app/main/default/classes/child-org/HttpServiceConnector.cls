/**
 * @author ngum buka fon nyuydze
 * @since 06/02/2023
 */

public with sharing class HttpServiceConnector {
    @future(callout=true)
    public static void getAndUpsertRecords(){
        Http httpService = new Http();
        string userToken = Helper.authenticate();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('https://wise-koala-bhzgyy-dev-ed.trailblaze.my.salesforce.com/services/apexrest/sync-records/v1/');
        req.setHeader('Authorization', 'Bearer '+userToken);
        HttpResponse res = httpService.send(req);
        string jsonString = res.getBody();
        list<lead> listOfRecords = (list<lead>)JSON.deserializeStrict(jsonString, list<lead>.class);
        list<lead> recordsToCreateOrUpdate = new list<lead>();
        list<string> nameAndEmailsToSync = new List<String>();
        map<String,lead> mapNameEmailToLeadToSync = new map<string,lead>();
        map<id,lead> mapNameToLeadToSync = new map<id,lead>();

        for(lead instance : listOfRecords){
            nameAndEmailsToSync.add(instance.Name);
            nameAndEmailsToSync.add(instance.Email);
        }
        list<lead> existingLeadRecords = [SELECT id, name, lastname, company, leadsource, email  FROM lead WHERE email in :nameAndEmailsToSync and name in :nameAndEmailsToSync];

        for (Lead instance : existingLeadRecords) {
            mapNameEmailToLeadToSync.put(instance.Name, instance);
            mapNameEmailToLeadToSync.put(instance.Email, instance);
        }

        for(lead instance : listOfRecords){
            if(mapNameEmailToLeadToSync.containsKey(instance.Email) && mapNameEmailToLeadToSync.containsKey(instance.Name)){
                lead existingLeadRecordByEmail = mapNameEmailToLeadToSync.get(instance.Email);
                lead existingLeadRecordByName = mapNameEmailToLeadToSync.get(instance.Email);
                if(existingLeadRecordByEmail.name == instance.Name && existingLeadRecordByEmail.Email==instance.email){
                    recordsToCreateOrUpdate.add(
                        new lead(id=existingLeadRecordByEmail.id, LastName=instance.LastName, Company=instance.company, Email= instance.email,LeadSource=instance.LeadSource  )
                    );
                }else if(existingLeadRecordByName.name == instance.Name && existingLeadRecordByName.Email==instance.email){
                    recordsToCreateOrUpdate.add(
                        new lead(id=existingLeadRecordByName.id, LastName=instance.LastName, Company=instance.company, Email= instance.email,LeadSource=instance.LeadSource)
                    );
                }
            }else{
                recordsToCreateOrUpdate.add(
                    new lead(LastName=instance.LastName, Company=instance.company, Email= instance.email,LeadSource=instance.LeadSource  )
                );
            }
        }
        upsert recordsToCreateOrUpdate;
    }
}