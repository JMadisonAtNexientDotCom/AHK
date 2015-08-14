package soundsystem;
import org.springframework.stereotype.Component;

//from page 34 of SpringInAction4Th Edition PDF.

@Component
public class SgtPeppers implements CompactDisc{
	private String title = "Sgt. Pepper's Lonely Hears Club Band";
	private String artist = "artist";
	
	public void play(){
			System.out.println("playing the sgt pepper track.");
			System.out.println("artist==" + artist);
			System.out.println("title==" + title);
	}
}