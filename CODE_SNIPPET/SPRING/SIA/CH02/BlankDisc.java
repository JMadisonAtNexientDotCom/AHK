package soundsystem;

/** From PDF-Page:51 of Spring In Action:4Th Edition
 *  @author jmadison **/
public class BlankDisc implements CompactDisc{
	private String title;
	private String artist;
	
	public BlankDisc(String title, String artist){
		this.title  = title;
		this.artist = artist;
	}
	
	public void play(){
		System.out.println("Playing " + title + " by " + artist);
	}
}