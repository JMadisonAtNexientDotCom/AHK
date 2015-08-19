package org.gbouallet;
import java.awt.event.KeyEvent;
import org.junit.Assert;
//import org.junit.Test;

//A test that will alleviate the pain of non-printable characters in JUnit tests.
//SOURCE: http://stackoverflow.com/questions/21418265/non-printable-characters-in-eclipse-junit-view
public class NonPrintableEqualsTest {

	/*
	@Test
	public void test() {
	    assertNonPrintableEquals(
	            "I am expecting this value on one line.\r\nAnd this value on this line",
	            "I am expecting this value on one line.\nAnd this value on this line");
	}
	*/

	public static void assertNonPrintableEquals(String string1,
	        String string2) {
	    Assert.assertEquals(replaceNonPrintable(string1),
	            replaceNonPrintable(string2));
	
	}
	
	public static String replaceNonPrintable(String text) {
	    StringBuffer buffer = new StringBuffer(text.length());
	    for (int i = 0; i < text.length(); i++) {
	        char c = text.charAt(i);
	        if (isPrintableChar(c)) {
	            buffer.append(c);
	        } else {
	            buffer.append(String.format("\\u%04x", (int) c));
	        }
	    }
	    return buffer.toString();
	}
	
	public static boolean isPrintableChar(char c) {
	    Character.UnicodeBlock block = Character.UnicodeBlock.of(c);
	    return (!Character.isISOControl(c)) && c != KeyEvent.CHAR_UNDEFINED
	            && block != null && block != Character.UnicodeBlock.SPECIALS;
	}
}