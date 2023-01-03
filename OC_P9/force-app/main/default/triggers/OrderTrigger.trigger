trigger OrderTrigger on Order (before update, after update) {
    if (Trigger.isBefore) {
        OrderTriggerHandler.calculateAmount(Trigger.new);
    } else if (Trigger.isAfter) {
        OrderTriggerHandler.updateAccountCA(Trigger.new);
    }
}