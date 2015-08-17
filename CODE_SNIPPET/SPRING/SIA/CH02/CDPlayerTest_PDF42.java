package soundsystem;
import static org.junit.Assert.*;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
/** 2nd version of CDPlayerTest. Transcribed from book.
    From Page 42 of SpringInAction 4Th Edition PDF.
    Listing 2.2.5 : Verifying automatic configuration **/
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes=CDPlayerConfig.class)
public class CDPlayerTest {
	
	@Rule
	public final StandardOutputStreamLog log =
		new StandardOutputStreamLog();
		
	@Autowired
	private MediaPlayer player;
	
	@Autowired
	private CompactDisc cd;
	
	@Test
	public void cdShouldNotBeNull() {
		assertNotNull(cd);
	}
	
	@Test
	public void play() {
		player.play();
		assertEquals(
		"Playing Sgt. Pepper's Lonely Hearts Club Band" +
		" by The Beatles\n",
		log.getLog());
	}
}




