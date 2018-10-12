package ie.nuigalway.oanyabuike;

import java.util.ArrayList;
import java.util.List;

/**
 * Hello world!
 *
 */
public class Student
{

    private String name;
    private int age;
    private String dateOfBirth;
    private int id;
    private String userName;
    private List<String> courses;
    private List<String> modules;


    public Student() {
        courses = new ArrayList<String>();
        modules = new ArrayList<String>();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public List<String> getCourses() {
        return courses;
    }

    public void setCourses(List<String> courses) {
        this.courses = courses;
    }

    public List<String> getModules() {
        return modules;
    }

    public void setModules(List<String> modules) {
        this.modules = modules;
    }

    protected String getUsername() {
        return name + "" + String.valueOf(age);
    }
}
