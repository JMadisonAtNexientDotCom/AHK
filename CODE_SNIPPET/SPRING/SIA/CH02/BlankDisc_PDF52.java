package soundsystem;
import java.util.List;
import soundsystem.CompactDisc;

/**
 * From PDF-Page:52 of Spring In Action:4Th Edition
 * VERSION TWO(2)
 * @author jmadison
 *
 */
public class BlankDisc implements CompactDisc{
	private String title;
	private String artist;
	private List<String> tracks;
	
	public BlankDisc(String title, String artist, List<String> tracks){
		this.title  = title;
		this.artist = artist;
		this.tracks = tracks;
	}
	
	public void play(){
		System.out.println("Playing " + title + " by " + artist);
		for (String track : tracks){
			System.out.println("-Track: " + track);
		}
	}
}
