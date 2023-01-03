public class OrderTriggerHandler {
    
    public static void updateAccountCA(List<Order> newOrders) {
            // Création d'un map qui va stocker les Id des comptes et le montant total des commandes associées
            Map<Id, Decimal> mapAccountAmount = new Map<Id, Decimal>();
        
            // On parcourt les commandes mises à jour
            for(Order ord : newOrders) {
                // On ajoute l'Id du compte et le montant total de la commande dans le map
                if (ord.TotalAmount != null && ord.AccountId != null) {
                    mapAccountAmount.put(ord.AccountId, ord.TotalAmount);
                }
            }
            // On récupère la liste des comptes dont l'Id est présent dans le map
            List<Account> listAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :mapAccountAmount.keySet() ];
            
            // On parcourt cette liste de comptes
            for(Account acc : listAccount){
                // Vérifiez que Chiffre_d_affaire__c et le montant total des commandes associées sont non nulls avant de les utiliser
                if (acc.Chiffre_d_affaire__c != null && mapAccountAmount.get(acc.Id) != null) {
                    // Ajoutez le montant total des commandes associées au chiffre d'affaire du compte
                    acc.Chiffre_d_affaire__c = acc.Chiffre_d_affaire__c + mapAccountAmount.get(acc.Id);
                } else if (mapAccountAmount.get(acc.Id) != null) {
                    // Si Chiffre_d_affaire__c est null, affectez-lui la valeur du montant total des commandes associées
                    acc.Chiffre_d_affaire__c = mapAccountAmount.get(acc.Id);
                }
            }

            // On met à jour la liste de comptes dans la base de données
            update listAccount;
	}
    
        
    
    public static void calculateAmount(List<Order> newOrders) {
        for (Order newOrder : newOrders) {
            
            // Vérifiez que TotalAmount et ShipmentCost__c sont des valeurs non null avant de les utiliser
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