/**
 * @author ngum buka fon nyuydze
 * @since 06/02/2023
 */

public without sharing class CrossOrgConnectorService {
    @InvocableMethod(label='Get Parent Records' description='Fetch records from parent org')
    public static void start() {
        HttpServiceConnector.getAndUpsertRecords();
    }
}