package spittr.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import static org.springframework.web.bind.annotation.RequestMethod.GET;

/**45678901234567890123456789012345678901234567890123456789012345678901234567890
-------------------------------------HEADER-------------------------------------
Page 143 of Spring In Action
@author JMadison
@created 2015.08.20
-----------------------------------------------------------------------------**/
@Controller
@RequestMapping({"/", "/homepage"})
public class HomeController {
	
	@RequestMapping(method=GET)
	public String home(){
		return "home";
	}
}