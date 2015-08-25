import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

@Configuration
@EnableWebMvc
public class WebConfig {
	//Minimal configuration: Page 137 of SIA
	//1: No view resolver configured.
	//2: Component scanning not enabled.
	//3: DispatcherServlet will handle all requests. No routing.
}
