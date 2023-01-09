public class OrderTriggerHandler {
    
    public static void updateAccountCA(List<Id> accountsId) {
        // Récupération de la liste des comptes avec leurs commandes en statut 'Ordered'            
        List<Account> accounts = [SELECT Id, Chiffre_d_affaire__c, (SELECT Id, AccountId, TotalAmount FROM Orders WHERE Status = 'Ordered') FROM Account WHERE Id IN : accountsId];
        
        // Pour chaque compte avec une commande en statut 'Ordered', affectation du chiffre d'affaires au compte en ajoutant le TotalAmount
        for(Account accountUpdate : accounts){
            Decimal accountCA = 0;

            for(Order orders : accountUpdate.orders) {
                if (orders.TotalAmount != null) {
                    accountCA = accountCA + orders.TotalAmount;
                }
            }
            accountUpdate.Chiffre_d_affaire__c = accountCA;
        }
        update accounts;
	}
    
    public static void calculateAmount(List<Order> newOrders) {
        for (Order newOrder : newOrders) {
            
            // Vérifie que TotalAmount et ShipmentCost__c sont des valeurs non
            if (newOrder.ShipmentCost__c != null) {
                // Calcul le montant net en soustrayant le coût d'expédition au montant total de la commande
                newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
            } else {
                // Si l'un des champs est null, le montant net est égal au montant total
                newOrder.NetAmount__c = newOrder.TotalAmount;
            }
        }
    }
}