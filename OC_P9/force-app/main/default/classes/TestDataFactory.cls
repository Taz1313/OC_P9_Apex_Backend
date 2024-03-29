@isTest
public class TestDataFactory {
    
    // Création de comptes
    public static List<Account> createAccounts (Integer nbAccount){
        List<Account> accounts = new List<Account>();
        for (Integer i = 0 ; i<nbAccount ; i++){
            Account account = new Account (Name = 'name '+i);
            accounts.add(account);
        }
        insert accounts;
        return accounts;
    }
    
   // Création de commandes pour les comptes crées
   public static List<Order> createOrdersForAccounts(List<Account> accounts, Integer nbOrder, Integer unitPrice, Integer quantity) {
        List<Contract> contracts = new List<Contract>();
        List<Order> orders = new List<Order>();
        for (Account account : accounts) {
            Contract contract = new Contract(
                AccountId=account.id, 
                Status='Draft',
                ContractTerm=5
            );
            contracts.add(contract);

            for (Integer k = 0; k < nbOrder; k++) {
                Order order = new Order(
                    AccountId=account.id,
                    ContractId=contract.id,
                    Status='Draft',
                    EffectiveDate=Date.today(),
                    Pricebook2Id=Test.getStandardPricebookId()
                    );
                orders.add(order);
            }
        }
        insert contracts;
        insert orders;
		// Création de Product2, PricebookEntry, OrderItems et activate Orders
        Product2 product = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        insert product;
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = product.Id,
            UnitPrice = unitPrice,
            IsActive = true
        );
        insert pbe;
        List<OrderItem> items = new List<OrderItem>();
        OrderItem item;
        for (Order order : orders) {
            item = new OrderItem (
                OrderId=order.Id,
                PricebookEntryId=pbe.Id,
                Quantity=quantity,
                UnitPrice=unitPrice
            );
            items.add(item);
        }
        insert items;
       
        // Mettre à jour la liste des commandes pour ne retourner que les commandes créées dans ce test unitaire
        orders = [SELECT Id, AccountId, TotalAmount, NetAmount__c FROM Order WHERE Id IN :orders];

        return orders;
    }
}