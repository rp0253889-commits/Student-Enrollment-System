trigger SECMS_EnrollmentTrigger on Enrollment__c (before insert, before update) {
    if (Trigger.isBefore) {
        SECMS_EnrollmentService.populateDefaults(Trigger.new);
        SECMS_EnrollmentService.preventDuplicateEnrollments(Trigger.new);
    }
}
