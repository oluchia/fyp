package ie.nuigalway.oanyabuike;

import java.util.ArrayList;
import java.util.List;

/**
 * Hello world!
 *
 */
public class Module
{
    private String moduleName;
    private int id;
    private List<Student> studentList;
    private List<String> coursesList;

    public Module() {
        studentList = new ArrayList<Student>();
        coursesList = new ArrayList<String>();
    }

    public String getModuleName() {
        return moduleName;
    }

    public void setModuleName(String moduleName) {
        this.moduleName = moduleName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public List<Student> getStudentList() {
        return studentList;
    }

    public void setStudentList(List<Student> studentList) {
        this.studentList = studentList;
    }

    public List<String> getCoursesList() {
        return coursesList;
    }

    public void setCoursesList(List<String> coursesList) {
        this.coursesList = coursesList;
    }
}
