package soundsystem;
import org.springframework.stereotype.Component;

//from page 35 of SpringInAction4Th Edition PDF.

@Component
public class SgtPeppers implements CompactDisc{
	private String title = "Sgt. Pepper's Lonely Hears Club Band";
	private String artist = "artist";
	
	public void play(){
	  //we need to follow the example exactly here, because the
		//junit test code can actually test for output printed to console.
		System.out.println("Playing " + title + " by " + artist);
	}
}