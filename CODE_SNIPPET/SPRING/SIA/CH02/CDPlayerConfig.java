
package soundsystem;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

//page 36 of SIA-PDF: @ComponentScan will make spring scan any packages
//that this class lives with for @component annotations.

@Configuration
@ComponentScan
public class CDPlayerConfig{

}