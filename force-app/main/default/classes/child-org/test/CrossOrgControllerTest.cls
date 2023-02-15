@istest
public without sharing class CrossOrgControllerTest {
    @testSetup
    static void setup() {
        List<Lead> leads = new List<Lead>();
        for (Integer i=0;i<10;i++) {
            leads.add(new Lead(lastname='Test '+i, Company='Company '+i, Email='test'+i+'@test.com'));
        }
        insert leads;
    }

    @isTest
    static void getRecordsTest(){
        list<lead> leads =     CrossOrgController.getRecords();
        System.assertEquals(10, leads.size());
    }
    
}