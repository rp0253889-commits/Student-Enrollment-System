public with sharing class SECMS_EnrollmentService {
    public static void populateDefaults(List<Enrollment__c> enrollments) {
        Set<Id> courseIds = new Set<Id>();
        for (Enrollment__c e : enrollments) {
            if (e.Course__c != null) courseIds.add(e.Course__c);
        }
        if (courseIds.isEmpty()) return;

        Map<Id, Course__c> courses = new Map<Id, Course__c>([
            SELECT Id, Category__c, Course_Fee__c
            FROM Course__c
            WHERE Id IN :courseIds
        ]);

        Map<String, Instructor__c> instructorsByCode = new Map<String, Instructor__c>();
        for (Instructor__c i : [
            SELECT Id, Instructor_Code__c
            FROM Instructor__c
            WHERE Instructor_Code__c IN ('INSTR_A','INSTR_B','INSTR_C')
        ]) {
            instructorsByCode.put(i.Instructor_Code__c, i);
        }

        for (Enrollment__c e : enrollments) {
            Course__c c = courses.get(e.Course__c);
            if (e.Enrollment_Date__c == null) e.Enrollment_Date__c = Date.today();
            if (c != null && e.Total_Amount__c == null) e.Total_Amount__c = c.Course_Fee__c;

            if (c != null && e.Instructor__c == null) {
                String code;
                if (c.Category__c == 'Technical') code = 'INSTR_A';
                else if (c.Category__c == 'Language') code = 'INSTR_B';
                else if (c.Category__c == 'Non-Technical') code = 'INSTR_C';

                if (code != null && instructorsByCode.containsKey(code)) {
                    e.Instructor__c = instructorsByCode.get(code).Id;
                }
            }
        }
    }

    public static void preventDuplicateEnrollments(List<Enrollment__c> enrollments) {
        Set<Id> studentIds = new Set<Id>();
        Set<Id> courseIds = new Set<Id>();

        for (Enrollment__c e : enrollments) {
            if (e.Student__c != null && e.Course__c != null) {
                studentIds.add(e.Student__c);
                courseIds.add(e.Course__c);
            }
        }
        if (studentIds.isEmpty() || courseIds.isEmpty()) return;

        for (Enrollment__c existing : [
            SELECT Id, Student__c, Course__c, Enrollment_Status__c
            FROM Enrollment__c
            WHERE Student__c IN :studentIds
            AND Course__c IN :courseIds
            AND Enrollment_Status__c IN ('Requested','Approved','Completed')
        ]) {
            for (Enrollment__c incoming : enrollments) {
                if (existing.Student__c == incoming.Student__c &&
                    existing.Course__c == incoming.Course__c &&
                    existing.Id != incoming.Id) {
                    incoming.addError('The student is already enrolled or has a pending enrollment for this course.');
                }
            }
        }
    }
}
