package spittr;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.servlet.view.InternalResourceView;
import static org.mockito.Mockito.*;
import static org.hamcrest.CoreMatchers.hasItems;
import static org.springframework.test.web.servlet.request
													.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result
													.MockMvcResultMatchers.view;
import static org.springframework.test.web.servlet.result
													.MockMvcResultMatchers.model;
//Getting reeeeaaally annoying trying to find these imports!
import static org.springframework.test.web.servlet.setup.MockMvcBuilders
                                                               .standaloneSetup;
import spittr.config.WebConfig;
import spittr.data.SpittleRepository;
import spittr.web.SpittleController;
/**45678901234567890123456789012345678901234567890123456789012345678901234567890
-------------------------------------HEADER-------------------------------------
Page 145-146 of Spring In Action: 4Th Edition.
No mention of the actual file name for this test.
Thought it might be inlined*... But never did an inlined* test before.
So I followed the [convention/precedent] established by HomeControllerTest.java
//
ALSO: Source code had duplicate line typo in it. Which makes me unsure
      of this example in general. But I guess if I really understand what
      I am supposed to be doing, that shouldn't be a problem.
//
 *inlined: NOT in the strict sense of compiler optimization.
           I mean that the test code was included in the body
           of the class it was testing.
//
@author JMadison
@created 2015.08.20
-----------------------------------------------------------------------------**/
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(classes=WebConfig.class)
public class SpittleTest {

	@Test
	public void shouldShowRecentSpittles() throws Exception{
		List<Spittle> expectedSpittles = createSpittleList(20);
		SpittleRepository mockRepository =
			mock(SpittleRepository.class);
		when(mockRepository.findSpittles(Long.MAX_VALUE, 20))
			.thenReturn(expectedSpittles);
		
		SpittleController controller =
				new SpittleController(mockRepository);
		MockMvc mockMvc = standaloneSetup(controller).setSingleView(
				new InternalResourceView("/WEB-INF/views/spittles.jsp"))
				.build();
		
		mockMvc.perform(get("/spittles"))
			.andExpect(view().name("spittles"))
			.andExpect(model().attributeExists("spittleList"))
			.andExpect(model().attribute("spittleList",
				hasItems(expectedSpittles.toArray() )));
	}//END::FUNC
	
	private List<Spittle> createSpittleList(int count){
		List<Spittle> spittles = new ArrayList<Spittle>();
		for(int i=0; i < count; i++){
			spittles.add(new Spittle("Spittle " + i, new Date() ));
		}
		return spittles;
	}//END::FUNC
	
}//END::CLASS