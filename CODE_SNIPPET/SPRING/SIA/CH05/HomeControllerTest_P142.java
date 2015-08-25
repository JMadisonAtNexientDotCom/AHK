package spittr.web;
import org.junit.Test;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request
													.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result
													.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.setup
													.MockMvcBuilders.*;

/**45678901234567890123456789012345678901234567890123456789012345678901234567890
-------------------------------------HEADER-------------------------------------
Page 142 of Spring In Action 4Th Edition:
Version 02 from book. Listing 5.6.
@author JMadison
@created 2015.08.20
-----------------------------------------------------------------------------**/
public class HomeControllerTest {
	@Test
	public void testHomePage() throws Exception{
		HomeController controller = new HomeController();
		MockMvc mockMvc =
			standaloneSetup(controller).build();
		mockMvc.perform(get("/"))
				.andExpect(view().name("home"));
	}
}