package soundsystem;
import org.springframework.beans.factory.annotation.AutoWired;
import org.springframework.stereotype.Component;

/** From page 40 of Spring In Action, 4Th Edition. PDF. 
	   (NOT THE BOOK, page numbering is DIFFERENT in book. **/
@Component
public class CDPlayer implements MediaPlayer{
	private CompactDisc cd;
	
	@AutoWired
	public CDPlayer(CompactDisc cd){
		this.cd = cd;
	}
	
	public void play(){
		cd.play();
	}
}