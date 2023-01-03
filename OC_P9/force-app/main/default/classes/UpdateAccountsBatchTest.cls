@isTest
public class UpdateAccountsTest {
    
    @isTest
    static void createOrdersTest() {
        // Créez une liste de comptes
        List<Account> accounts = TestDataFactory.createAccounts(1);
        
        // Créez une liste de commandes
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, 101, 10, 1);
        
        // Met à jour la liste de commandes pour déclencher le trigger
        Test.startTest();
        update orders;
        Test.stopTest();

        // Vérifie que le nombre de commandes créées est égal à 101
        System.assertEquals(orders.size(), 101);
    }
    
    @isTest
    static void noUpdateForNoOrdersTest() {
        // Créez une liste de comptes
        List<Account> accounts = TestDataFactory.createAccounts(1);
        
        // Créez une liste de commandes
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, 0, 0, 0);
        
        // Met à jour la liste de commandes pour déclencher le trigger
        Test.startTest();
        update orders;
        Test.stopTest();

        // Vérifiez que le nombre de commandes créées est égal à 0
        System.assertEquals(orders.size(), 0);
    }
}