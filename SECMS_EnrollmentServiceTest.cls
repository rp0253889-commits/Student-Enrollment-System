@IsTest
private class SECMS_EnrollmentServiceTest {
    @IsTest
    static void testEnrollmentDefaultsAndInstructorAssignment() {
        Student__c student = new Student__c(
            Name = 'Test Student',
            Email__c = 'student1@student.edu',
            Student_Status__c = 'Pending'
        );
        insert student;

        Course__c course = new Course__c(
            Name = 'Apex Fundamentals',
            Category__c = 'Technical',
            Duration__c = 30,
            Course_Fee__c = 5000
        );
        insert course;

        Instructor__c instructor = new Instructor__c(
            Name = 'Instructor A',
            Instructor_Code__c = 'INSTR_A',
            Expertise__c = 'Technical',
            Email__c = 'instructorA@student.edu'
        );
        insert instructor;

        Enrollment__c enrollment = new Enrollment__c(
            Student__c = student.Id,
            Course__c = course.Id,
            Enrollment_Status__c = 'Requested'
        );
        Test.startTest();
        insert enrollment;
        Test.stopTest();

        Enrollment__c result = [
            SELECT Enrollment_Date__c, Instructor__c, Total_Amount__c
            FROM Enrollment__c WHERE Id = :enrollment.Id
        ];

        System.assertEquals(Date.today(), result.Enrollment_Date__c);
        System.assertEquals(instructor.Id, result.Instructor__c);
        System.assertEquals(5000, result.Total_Amount__c);
    }

    @IsTest
    static void testDuplicateEnrollment() {
        Student__c student = new Student__c(
            Name = 'Duplicate Student',
            Email__c = 'student2@student.edu'
        );
        insert student;

        Course__c course = new Course__c(
            Name = 'Salesforce Basics',
            Category__c = 'Non-Technical',
            Course_Fee__c = 1000
        );
        insert course;

        insert new Enrollment__c(
            Student__c = student.Id,
            Course__c = course.Id,
            Enrollment_Status__c = 'Requested'
        );

        Enrollment__c duplicate = new Enrollment__c(
            Student__c = student.Id,
            Course__c = course.Id,
            Enrollment_Status__c = 'Requested'
        );

        Test.startTest();
        Database.SaveResult sr = Database.insert(duplicate, false);
        Test.stopTest();

        System.assertEquals(false, sr.isSuccess());
    }
}
