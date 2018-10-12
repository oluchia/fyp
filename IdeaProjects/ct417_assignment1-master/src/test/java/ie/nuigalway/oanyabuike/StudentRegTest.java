package ie.nuigalway.oanyabuike;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

/**
 * Unit test for simple App.
 */
public class StudentRegTest
{
    /**
     * Rigorous Test :-)
     */

    private Student s;

    @Test
    public void testGetUsername() {
        s = new Student();
        s.setAge(20);
        s.setName("Oluchi");

        assertEquals(s.getUsername(), "Oluchi20");
    }

    @Test
    public void shouldAnswerWithTrue()
    {
        assertTrue( true );
    }
}
