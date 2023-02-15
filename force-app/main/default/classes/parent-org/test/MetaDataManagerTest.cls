@isTest public without sharing class MetaDataManagerTest {
    @IsTest
    static void testDeployment() {
        Datetime dt = System.now();
        Metadata.DeployContainer container = MetaDataManager.performAsyncUpdate(dt);
        List<Metadata.Metadata> contents = container.getMetadata();
        System.assertEquals(1, contents.size());
        System.assertEquals('Apex_Parent_To_Child_Last_Import_Time.last_org_run', contents[0].fullName);
    }
}