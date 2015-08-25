package spittr.data;
import java.util.List;
import spittr.Spittle;

/** Page 144 of spring in action. **/
public interface SpittleRepository {
	
	/**Gets a list of spittles:
	 * Usage: Get the 20 most recent spittle entries:
	 *        spittleRepository.findSpittles(Long.MAX_VALUE, 20);
	 * @param max  :Maximum spittle ID to return.
	 * @param count:How many spittle entries to return
	 *              starting from that maximum ID as anchor.
	 * @return */
	List<Spittle> findSpittles(long max, int count);
}
