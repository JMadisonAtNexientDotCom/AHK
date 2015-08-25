package spittr;

import java.util.Date;
import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;
/**45678901234567890123456789012345678901234567890123456789012345678901234567890
-------------------------------------HEADER-------------------------------------
Page 144-145 of Spring In Action: 4Th Edition.
@author JMadison
@created 2015.08.20
-----------------------------------------------------------------------------**/
public class Spittle {
	private final Long   id       ;
	private final String message  ;
	private final Date   time     ;
	private       Double latitude ;
	private       Double longitude;
	
	public Spittle(String message, Date time){
		this(message, time, null, null);
	}
		
	public Spittle(
			String message, Date time, Double longitude, Double latitude){
		this.id        = null;
		this.message   = message;
		this.time      = time;
		this.longitude = longitude;
		this.latitude  = latitude;
	}

	public Long getId() {
		return id;
	}

	public String getMessage() {
		return message;
	}

	public Date getTime() {
		return time;
	}

	public Double getLatitude() {
		return latitude;
	}

	public Double getLongitude() {
		return longitude;
	}
	
	@Override
	public boolean equals(Object that) {
	return EqualsBuilder.reflectionEquals(this, "id", "time");
	}
	
	/** "In general, any field used in the equals method must be \
	 *   used in the hashCode method."
	 *   https://commons.apache.org/proper/commons-lang/
	 *   javadocs/api-2.6/org/apache/commons/lang/builder/HashCodeBuilder.html **/
	@Override
	public int hashCode() {
	return HashCodeBuilder.reflectionHashCode(this, "id", "time");

	}
}//CLASS::END