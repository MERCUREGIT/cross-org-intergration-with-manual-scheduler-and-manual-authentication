@isTest
public without sharing class HttpServiceConnectorTest {

    @testSetup static void setup() {
        List<Lead> leads = new List<Lead>();
        for (Integer i=0;i<10;i++) {
            leads.add(new Lead(lastname='Test '+i, Company='Company '+i, Email='test'+i+'@test.com'));
        }
        insert leads;
    }
    @isTest static void startSyncRecordsTest(){
    Test.setMock(HttpCalloutMock.class, new MockHTTPCallOutLeadRecordsFromParentOrg());
    list<lead> leads = [SELECT Id, Name,Company,Email,LeadSource FROM Lead];
    test.startTest();
        HttpServiceConnector.syncRecords(JSON.serialize(leads),'');
    test.stopTest();
    //child ran with success
   } 
}