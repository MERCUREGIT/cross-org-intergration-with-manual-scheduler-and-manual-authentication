/**
 * <h1> CrossOrgController class, manages the  ... </h1>
 * @author ngum buka fon nyuydze
 * @since 06/02/2023
 */

public without sharing class CrossOrgController {
  public List<string> ids;
  public list<lead> leads {get; set;}
  public string leadList {get; set;}
  public CrossOrgController(ApexPages.StandardSetController controller) {
    this.ids = new List<String>();
    List<sObject> records = (List<sObject>) controller.getSelected();
    for (sObject record_i : records) {
        this.ids.add(record_i.Id);
    }
    this.leads = [SELECT Id, Name,Company,Email,LeadSource,LastName FROM Lead WHERE  id in :this.ids ];
    this.leadList = JSON.serialize(leads);
} 


   @AuraEnabled(Cacheable=true)
   public static list<lead> getRecords(){
      list<lead> recordsToSync = new list<lead>();
      try {
        Apex_Parent_To_Child_Last_Import_Time__mdt lastBatchRunTime = Apex_Parent_To_Child_Last_Import_Time__mdt.getInstance('last_org_run');
          set<lead> recentlyCreatedOrUpdatedLead;
          Datetime lastRun = lastBatchRunTime.last_run__c;
          recentlyCreatedOrUpdatedLead = new Set<Lead>([SELECT Id, Name,Company,Email,LeadSource,LastName FROM Lead WHERE  CreatedDate>=:lastRun ]);
          recentlyCreatedOrUpdatedLead.addAll([SELECT  Id, Name,Company,Email,LeadSource,LastName FROM Lead WHERE LastModifiedDate>=:lastRun ]);
          recordsToSync = new list<lead>(recentlyCreatedOrUpdatedLead);
      } catch (Exception e) {
          System.debug('The following exception has occurred: ' + e.getMessage());
      }
    return recordsToSync;
   }

   @AuraEnabled
   public static string manuallySyncRecords(string jsonStrings){
      try {
        System.debug('Records Manaully synched on the child org');
        HttpServiceConnector.startSyncRecords(jsonStrings);
        return '{"success":true}';
      } catch (Exception e) {
        system.debug(e.getStackTraceString());
        system.debug(e.getMessage());
        return '{"success":false}';
      }
   }

   public PageReference manuallySyncRecords(){
    try {
      string jsonStrings = JSON.serialize(this.leads);
      System.debug('Records Manaully synched on the child org');
      HttpServiceConnector.startSyncRecords(jsonStrings);
    
    } catch (Exception e) {
      system.debug(e.getStackTraceString());
      system.debug(e.getMessage());
    }
    return this.navigateToUrl('https://wise-koala-bhzgyy-dev-ed.trailblaze.lightning.force.com/lightning/o/Lead/list?filterName=Recent');
 }
  public PageReference navigateToUrl(string url){
    Pagereference  pg = new Pagereference(url);
    pg.setRedirect(true);
    return pg;
 }
 public PageReference navigateBackward(){
  return this.navigateToUrl('https://wise-koala-bhzgyy-dev-ed.trailblaze.lightning.force.com/lightning/o/Lead/list?filterName=Recent');
 }
}