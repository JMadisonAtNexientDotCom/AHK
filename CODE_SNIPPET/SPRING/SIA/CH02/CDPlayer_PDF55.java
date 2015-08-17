package soundsystem;
//import org.springframework.beans.factory.annotation.AutoWired; //<<Wrong. W is NOT capital
import org.springframework.beans.factory.annotation.Autowired;

import soundsystem.CompactDisc;
import soundsystem.MediaPlayer;

/** From page 55 of Spring In Action, 4Th Edition. PDF. 
       CHANGES:
 *     1. The @Component is removed from this version.
       2. No constructor. Just a SETTER called "setCompactDisc"
       VERSION TWO(2)
	    (NOT THE BOOK, page numbering is DIFFERENT in book. 
			
			//EXAMPLE OF HOW TO WIRE UP IN Beans.xml:
			<bean id="cdPlayer"
					class="soundsystem.CDPlayer" >
				<property name="compactDisc" ref="compactDisc" />
			</bean>
**/
public class CDPlayer implements MediaPlayer{
	private CompactDisc compactDisc;
	
	//USING SETTER instead of CONSTRUCTOR:
	@Autowired
	public void setCompactDisc(CompactDisc compactDisc){
		this.compactDisc = compactDisc;
	}
	
	public void play(){
		compactDisc.play();
	}
}