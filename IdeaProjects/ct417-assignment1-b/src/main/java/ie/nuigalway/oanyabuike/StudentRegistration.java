package ie.nuigalway.oanyabuike;

import org.joda.time.DateTime;

import java.util.ArrayList;
import java.util.List;

/**
 * Hello world!
 *
 */
public class StudentRegistration {

    public static void main(String[] args) {

        List<CourseProgramme> courseList = new ArrayList<CourseProgramme>();

        CourseProgramme cs = new CourseProgramme("Computer Science & IT (BSc)", new DateTime(2012, 3, 5, 0, 0), new DateTime(2022, 5, 31, 0, 0));
        CourseProgramme da = new CourseProgramme("Data Analytics and Information Systems (MSc)", new DateTime(2012, 3, 5, 0, 0), new DateTime(2022, 5, 31, 0, 0));

        courseList.add(cs);
        courseList.add(da);

        Student oa = new Student("Oluchi Anyabuike", 20, new DateTime(), "99000911");
        Student ap = new Student("Alice Perry", 20, new DateTime(), "99001911");

        Module m1 = new Module("Machine Learning & Data Mining", 401);
        Module m2 = new Module("Software Engineering III", 402);
        Module m3 = new Module("Tools for Data Analytics", 403);
        Module m4 = new Module("Systems Modelling & Simulation", 404);

        cs.addModule(m1);
        cs.addModule(m2);
        da.addModule(m3);
        da.addModule(m4);

        cs.addStudent(oa);
        da.addStudent(ap);

        for (CourseProgramme cp : courseList) {
            System.out.println("Course: " + cp.getCourseName() + "\tStart date: " + cp.getStartDate() + "\tEnd date: " + cp.getEndDate());

            System.out.println("Modules: ");

            for (Module m : cp.getModuleList()) {
                System.out.println("CT" + m.getId() + "\t" + m.getModuleName());
            }

            System.out.println();
            System.out.println("Students: ");

            for (Student s : cp.getStudentList()) {
                System.out.println(s.getName() + " " + s.getId());

                System.out.println("Assigned modules: ");

                for (Module m : s.getModules()) {
                    System.out.println("CT" + m.getId() + "\t" + m.getModuleName());
                }

                System.out.println("Registered courses: ");
                for (CourseProgramme courseProgramme : s.getCourses()) {
                    System.out.println( courseProgramme.getCourseName());
                }

                System.out.println();
            }

        }
    }
}
