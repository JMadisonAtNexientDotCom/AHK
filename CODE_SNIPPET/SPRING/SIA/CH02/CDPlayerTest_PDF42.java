package soundsystem;
import static org.junit.Assert.*;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.junit.contrib.java.lang.system.StandardOutputStreamLog;
//NOTE: For StandarOutputStreamLog, you need a .Jar file that is not part of core JUnit library.
//http://mvnrepository.com/artifact/com.github.stefanbirkner/system-rules/1.2.0
//http://stefanbirkner.github.io/system-rules/index.html#SystemErrAndOutRule

/** 2nd version of CDPlayerTest. Transcribed from book.
    From Page 42 of SpringInAction 4Th Edition PDF.
    Listing 2.2.5 : Verifying automatic configuration **/
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes=CDPlayerConfig.class)
public class CDPlayerTest {
	
	/** This was really annoying to find import for. **/
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
		String n = System.lineSeparator();
		assertEquals("Playing Sgt. Pepper's Lonely Hearts Club Band" + " by The Beatles" + n, log.getLog());
	}
}