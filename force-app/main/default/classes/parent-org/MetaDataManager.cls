/**
 * <h1> MetaData Manager</h1>
 * <p>This class manages the update of the metadata on the parent org</p>
 * @author ngum buka fon
 * @since 10/02/2023
 * 
 */

public without sharing class MetaDataManager{
    // @future

    /**
     * This function updates the last run time of the paex job
     * 
     * @param dt Date time object for the last time the job ran
     * 
     * 
     */
    public static Metadata.DeployContainer performAsyncUpdate(Datetime dt){
       list<Apex_Parent_To_Child_Last_Import_Time__mdt> metaList = [Select MasterLabel, DeveloperName, last_run__c FROM Apex_Parent_To_Child_Last_Import_Time__mdt];
            Metadata.CustomMetadata mdata = new Metadata.CustomMetadata();
            mdata.fullname = 'Apex_Parent_To_Child_Last_Import_Time.last_org_run';
            mdata.label = metaList[0].MasterLabel;
            Metadata.CustomMetadataValue instance = new Metadata.CustomMetadataValue();
            instance.field = 'Last_Run__c';
            instance.value=dt;
            mdata.values.add(instance);
            Metadata.DeployContainer container  = new Metadata.DeployContainer();
            container.addMetadata(mdata);
            return container;
    }
}