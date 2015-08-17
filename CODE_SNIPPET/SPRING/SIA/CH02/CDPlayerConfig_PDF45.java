package soundsystem;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

//page 45 of SIA-PDF: Without @ComponentScan, you must MANUALLY
//configure your beans. We do this with the @Bean annotation.
//Version THREE(3) of CDPlayerConfig

@Configuration
public class CDPlayerConfig{
	
	//page 44:
	@Bean(name="lonelyHeartsClubBand")
	public CompactDisc sgtPeppers(){
		return new SgtPeppers();
	}
	
	//page 45:
	//NOTE: Both cdPlayer() and anotherCDPlayer() will
	//use the SAME instance of sgtPeppers() because:
	//1: The call is intercepted by spring to make sure this happens.
	//2: Beans by default are SINGLETONS in spring.
	//////////////////////////////////////////////////////////////////
	@Bean
	public CDPlayer cdPlayer(){
		return new CDPlayer(sgtPeppers());
	}
	
	@Bean
	public CDPlayer anotherCDPlayer(){
		return new CDPlayer(sgtPeppers());
	}
	//////////////////////////////////////////////////////////////////

}//CLASS:CDPlayerConfig:END