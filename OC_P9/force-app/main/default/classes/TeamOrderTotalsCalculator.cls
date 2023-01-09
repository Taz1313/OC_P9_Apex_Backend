public class TeamOrderTotalsCalculator {
    
    // Méthode qui retourne la somme de tous les champs "TotalAmount" de tous les enregistrements de la table "Order" avec le statut "Ordered"
    public decimal sumOrders {
        
        get {
            AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE Status = 'Ordered'];
            // On convertit le résultat en décimal et on le retourne
            return (decimal)groupedResults.get('total');
        }
        set;
    }
}