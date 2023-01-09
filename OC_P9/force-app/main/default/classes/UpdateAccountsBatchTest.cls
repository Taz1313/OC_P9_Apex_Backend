@isTest
public class UpdateAccountsBatchTest {

    @isTest
    static void updateCAFor200AccountsBatchTest() {
        // Créez une liste de comptes
        List<Account> accounts = TestDataFactory.createAccounts(200);
        List<Id> accountsIds = new List<Id>();
        for (Account a : accounts) {
            accountsIds.add(a.Id);
        }
        
        // Créez une liste de commandes
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, 1, 150, 1);
        
        // Passage au statut 'Ordered' pour chaque commandes
        for (Order order : orders) {
            order.Status = 'Ordered';
        }
        update orders;
    
        // Lancement du batch
        Test.startTest();       
        UpdateAccountsBatch batchUpdateAccountCA = new UpdateAccountsBatch();
        Id batchId = Database.executeBatch(batchUpdateAccountCA);
        Test.stopTest();
        
        // Verifie que le CA corresponde bien
        Decimal totalCA;
        List<AggregateResult> aggregateResults = [SELECT SUM(Chiffre_d_affaire__c) FROM Account WHERE ID IN :accounts];
        if (!aggregateResults.isEmpty()) {
            totalCA = (Decimal)aggregateResults[0].get('expr0');
        }
        System.assertEquals(30000, totalCA);
    }
}