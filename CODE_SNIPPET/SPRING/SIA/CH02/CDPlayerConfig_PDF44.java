package soundsystem;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

//page 44 of SIA-PDF: Without @ComponentScan, you must MANUALLY
//configure your beans. We do this with the @Bean annotation.
//Version 2 of CDPlayerConfig

@Configuration
public class CDPlayerConfig{
	
	@Bean(name="lonelyHeartsClubBand")
	public CompactDisc sgtPeppers(){
		return new SgtPeppers();
	}

}//CLASS:CDPlayerConfig:END


