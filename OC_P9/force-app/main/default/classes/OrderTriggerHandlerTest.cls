@isTest
public class OrderTriggerHandlerTest {
    
    @isTest
    static void calculateAmountWithShipmentCostTest() {
        // Crée une liste de commandes avec des coûts d'expédition renseignés
        List<Order> orders = [SELECT Id, TotalAmount 
                              FROM Order 
                              WHERE Id IN :TestDataFactory.createOrdersForAccounts(TestDataFactory.createAccounts(1), 1, 100, 5)];
        
        for (Order order : orders) {
            // Définit le coût d'expédition (50 ou 0)
            order.ShipmentCost__c = 50;
		}

        // Appele la méthode à tester
        OrderTriggerHandler.calculateAmount(orders);

        
        // Vérifie que le montant net est correctement calculé en soustrayant le coût d'expédition
        for (Order order : orders) {
            System.assertEquals(order.TotalAmount - order.ShipmentCost__c, order.NetAmount__c);
        }
    }
    
    @isTest
    static void calculateAmountWithoutShipmentCostTest() {
                // Crée une liste de commandes avec des coûts d'expédition renseignés
        List<Order> orders = [SELECT Id, TotalAmount 
                              FROM Order 
                              WHERE Id IN :TestDataFactory.createOrdersForAccounts(TestDataFactory.createAccounts(1), 1, 100, 5)];
        
        for (Order order : orders) {
            // Définit le coût d'expédition (50 ou 0)
            order.ShipmentCost__c = 0;
		}

        // Appele la méthode à tester
        OrderTriggerHandler.calculateAmount(orders);

        
        // Vérifie que le montant net est correctement calculé en soustrayant le coût d'expédition
        for (Order order : orders) {
            System.assertEquals(order.TotalAmount, order.NetAmount__c);
        }
    }
    

    @isTest
    private static void updateAccountCAWith200OrderAndOrderedStatusTest() {
        // Créez une liste de comptes
        List<Account> account = TestDataFactory.createAccounts(1);
        
        // Créez une liste de commandes
        List<Order> orders = TestDataFactory.createOrdersForAccounts(account, 200, 100, 1);
        
        for(Order order : orders) {
            order.Status = 'Ordered'; 
        }

        Test.startTest();
        update orders;
        Test.stopTest();

        Account accountUpdated = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE ID =:account[0].Id];
        System.assertEquals(20000, accountUpdated.Chiffre_d_affaire__c);             
    }

    @isTest
    private static void updateAccountCAWith200OrderAndDraftStatusTest() {
        // Créez une liste de comptes
        List<Account> account = TestDataFactory.createAccounts(1);
        
        // Créez une liste de commandes
        List<Order> orders = TestDataFactory.createOrdersForAccounts(account, 200, 100, 1);
        
        Test.startTest();
        update orders;
        Test.stopTest();

        Account accountUpdated = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE ID =:account[0].Id];
        System.assertEquals(0, accountUpdated.Chiffre_d_affaire__c);        
    }
}
