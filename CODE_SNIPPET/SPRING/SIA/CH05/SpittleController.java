package spittr.web;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import spittr.data.SpittleRepository;
/**45678901234567890123456789012345678901234567890123456789012345678901234567890
-------------------------------------HEADER-------------------------------------
Page 146-147 of Spring In Action. 4Th Edition.
@author JMadison
@created 2015.08.20
-----------------------------------------------------------------------------**/
public class SpittleController {
	
	private SpittleRepository spittleRepository;
	
	@Autowired
	public SpittleController(
			SpittleRepository spittleRepository){
		this.spittleRepository = spittleRepository;
	}
	
	@RequestMapping(method=RequestMethod.GET)
	public String spittles(Model model){
		model.addAttribute(
			spittleRepository.findSpittles(Long.MAX_VALUE, 20));
		return "spittles";
	}
}//CLASS::END