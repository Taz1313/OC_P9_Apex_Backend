@isTest
private class TeamOrderTotalsCalculatorTest {
    
    @isTest
    static void sumOrdersWithOrderedStatusTest() {
        // Crée 3 comptes et 3 commandes pour chaque compte
        List<Account> accounts = TestDataFactory.createAccounts(3);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, 3, 100, 1);

        for(Order order : orders) {
            order.Status = 'Ordered'; 
        }

        update orders;


        // Vérification de la somme des commandes dans l'état "Ordered"
        TeamOrderTotalsCalculator calculator = new TeamOrderTotalsCalculator();
        decimal expectedSum = 3 * 300;
        System.assertEquals(expectedSum, calculator.sumOrders);
    }
    
    @isTest
    static void sumOrdersTestWithNoOrders() {
        // Crée 3 comptes et 3 commandes pour chaque compte
        List<Account> accounts = TestDataFactory.createAccounts(3);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, 3, 100, 1);

        update orders;

        // Vérification de la somme des commandes dans l'état "Draft"
        TeamOrderTotalsCalculator calculator = new TeamOrderTotalsCalculator();
        System.assertEquals(null, calculator.sumOrders);
    }
}