package soundsystem;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

//page 46 of SIA-PDF: An alternate way to do cdPlayer() method.
//Version FOUR(4) of CDPlayerConfig

@Configuration
public class CDPlayerConfig{
	
	//page 44:
	@Bean(name="lonelyHeartsClubBand")
	public CompactDisc sgtPeppers(){
		return new SgtPeppers();
	}
	
	//OLD WAY:
	//@Bean
	//public CDPlayer cdPlayer(){
	//	return new CDPlayer(sgtPeppers());
	//}
	
	//page 46: Alternate way to do cdPlayer() method
	//that may be easier to [comprehend/digest]
	//"This approach to referring to other beans is usually the best choice
	// because it doesn't depend on the CompactDisc bean being declared in the same
	// configuration class."
	@Bean
	public CDPlayer cdPlayer(CompactDisc compactDisc){
		return new CDPlayer(compactDisc);
	}
	
	/* ********************************************************
	  //If you wanted to inject a CompactDisc via setter method
	  //It might look like this:
	@Bean
	public CDPlayer cdPlayer(CompactDisc compactDisc){
		CDPlayer cdPlayer = new CDPlayer(compactDisc);
		cdPlayer.setCompactDisc(compactDisc);
		return cdPlayer;
	}
	******************************************************** */
	
	@Bean
	public CDPlayer anotherCDPlayer(){
		return new CDPlayer(sgtPeppers());
	}
	

}//CLASS:CDPlayerConfig:END