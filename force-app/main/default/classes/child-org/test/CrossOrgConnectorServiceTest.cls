@isTest
public without sharing class CrossOrgConnectorServiceTest {

    @istest
    static void syncRecordsTest(){
        // create a requeste context
        
        RestRequest request = new RestRequest();
        string body = '[{"Id":"00QDn000004ot2zMAA","LastName":"Test", "Name":"fon nyuyde","Company":"test","Email":"ngumbukafon@mercury-cm.com"},{"Id":"00QDn000004otnQMAQ","LastName":"Test","Name":"fon nyuyde","Company":"mercury-tech","Email":"ngumon@mercury-cm.com"},{"Id":"00QDn000004otnQMAQ","LastName":"Test","Name":"fon nyuyde","Company":"mercury-tech","Email":"ngumon@mercury-cm.com"}]';
        request.requestBody = Blob.valueOf(body);
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json'); 
        RestContext.request = request;
        // test for creation of records
        CrossOrgWEBSERVICE.getRecordsTosync();
        list<lead> leads =  [SELECT name, lastname, company, email FROM Lead];
        System.assertEquals(3, leads.size());
        // test for duplicates, in case identical records are been sent
        CrossOrgWEBSERVICE.getRecordsTosync();
        leads =  [SELECT name, lastname, company, email FROM Lead];
        System.assertEquals(3, leads.size());
    }
    @istest
    static void syncRecordsExceptionTest(){
        RestRequest request = new RestRequest();
        string body = '["Id":"00QDn000004ot2zMAA","LastName":"Test", "Name":"fon nyuyde","Company":"test","Email":"ngumbukafon@mercury-cm.com"},{"Id":"00QDn000004otnQMAQ","LastName":"Test","Name":"fon nyuyde","Company":"mercury-tech","Email":"ngumon@mercury-cm.com"},{"Id":"00QDn000004otnQMAQ","LastName":"Test","Name":"fon nyuyde","Company":"mercury-tech","Email":"ngumon@mercury-cm.com"}]';
        request.requestBody = Blob.valueOf(body);
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json'); 
        RestContext.request = request;
        CrossOrgWEBSERVICE.getRecordsTosync();
        list<lead> leads =  [SELECT name, lastname, company, email FROM Lead];
        System.assertEquals(0, leads.size());
    }
}