package spittr.web;
import static org.junit.Assert.assertEquals;
import org.junit.Test;
/**45678901234567890123456789012345678901234567890123456789012345678901234567890
-------------------------------------HEADER-------------------------------------
Page 141 of Spring In Action 4Th Edition:
@author JMadison
@created 2015.08.20
-----------------------------------------------------------------------------**/
public class HomeControllerTest {
	@Test
	public void testHomePage() throws Exception{
		HomeController controller = new HomeController();
		assertEquals("home",controller.home());
	}
}