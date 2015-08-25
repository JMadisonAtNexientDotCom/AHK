import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.ComponentScan.Filter;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
/**45678901234567890123456789012345678901234567890123456789012345678901234567890
-------------------------------------HEADER-------------------------------------
RootConfig from page 138 of Spring In Action, 4Th Edition:
@author JMadison
@created 2015.XX.XX
-----------------------------------------------------------------------------**/
@Configuration
@ComponentScan(basePackages={"spitter"},
	excludeFilters={
		@Filter(type=FilterType.ANNOTATION, value=EnableWebMvc.class)
	})
public class RootConfig {

}
