@isTest
public class OrderTriggerHandlerTest {
    
    @isTest
    static void calculateAmountWithShipmentCostTest() {
        // Crée une liste de commandes avec des coûts d'expédition renseignés
        List<Order> orders = [SELECT Id, TotalAmount 
                              FROM Order 
                              WHERE Id IN :TestDataFactory.createOrdersForAccounts(TestDataFactory.createAccounts(1), 1, 100, 1)];
        
        for (Order order : orders) {
            // Définit le coût d'expédition (50 ou 0)
            order.ShipmentCost__c = 50;
            
            // Récupère la liste des lignes de commande de cette commande
            List<OrderItem> items = [SELECT Quantity, UnitPrice FROM OrderItem WHERE OrderId = :order.Id];
        
            // Met à jour les lignes de commande (par exemple, en changeant la quantité ou le prix unitaire)
            for (OrderItem item : items) {
                item.Quantity = 2;
                item.UnitPrice = 200;
            }
            update items;
		}

        // Appele la méthode à tester
        OrderTriggerHandler.calculateAmount(orders);

        
        // Vérifie que le montant net est correctement calculé en soustrayant le coût d'expédition
        for (Order order : orders) {
            System.debug(order.TotalAmount - order.ShipmentCost__c);          
            System.debug(order.NetAmount__c);
            System.assertEquals(order.TotalAmount - order.ShipmentCost__c, order.NetAmount__c);
        }
    }
    
    @isTest
    static void calculateAmountWithoutShipmentCostTest() {
                // Crée une liste de commandes avec des coûts d'expédition renseignés
        List<Order> orders = [SELECT Id, TotalAmount 
                              FROM Order 
                              WHERE Id IN :TestDataFactory.createOrdersForAccounts(TestDataFactory.createAccounts(1), 1, 100, 1)];
        
        for (Order order : orders) {
            // Définit le coût d'expédition (50 ou 0)
            order.ShipmentCost__c = 0;
            
            // Récupère la liste des lignes de commande de cette commande
            List<OrderItem> items = [SELECT Quantity, UnitPrice FROM OrderItem WHERE OrderId = :order.Id];
        
            // Met à jour les lignes de commande (par exemple, en changeant la quantité ou le prix unitaire)
            for (OrderItem item : items) {
                item.Quantity = 2;
                item.UnitPrice = 200;
            }
            update items;
		}

        // Appele la méthode à tester
        OrderTriggerHandler.calculateAmount(orders);

        
        // Vérifie que le montant net est correctement calculé en soustrayant le coût d'expédition
        for (Order order : orders) {
            System.debug(order.TotalAmount - order.ShipmentCost__c);
            System.debug(order.NetAmount__c);
            System.assertEquals(order.TotalAmount - order.ShipmentCost__c, order.NetAmount__c);
        }
    }
    
    @isTest
    private static void updateAccountCAWithOrderTest() {
        // Créer un compte et une liste de commandes associées
        List<Account> accounts = TestDataFactory.createAccounts(1);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, 1, 100, 1);

        // Mettre à jour la liste de commandes pour déclencher le déclencheur UpdateAccountCA
        Test.startTest();
        update orders;
        Test.stopTest();
        
        // Vérifier que le champ Chiffre_d_affaire__c du compte a été mis à jour correctement
        Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :accounts[0].Id AND Name = :accounts[0].Name];
        Decimal expectedCA = 0;
        for (Order order : orders){
            	expectedCA = expectedCA + order.TotalAmount; 
        }

        System.assertEquals(expectedCA, updatedAccount.Chiffre_d_affaire__c);
    }
    
        @isTest
    private static void updateAccountCATestWithNoOrderTest() {
        // Créer un compte et une liste de commandes associées
        List<Account> accounts = TestDataFactory.createAccounts(1);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, 0, 0, 0);

        // Mettre à jour la liste de commandes pour déclencher le déclencheur UpdateAccountCA
        Test.startTest();
        update orders;
        Test.stopTest();
        
        // Vérifier que le champ Chiffre_d_affaire__c du compte a été mis à jour correctement
        Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :accounts[0].Id AND Name = :accounts[0].Name];
        Decimal expectedCA = null;
        for (Order order : orders){
            	expectedCA = expectedCA + order.TotalAmount; 
        }

        System.assertEquals(expectedCA, updatedAccount.Chiffre_d_affaire__c);
    }
}