package danaStuff;
public class DanaHelloWorld {
	
	public static void main(String[] args)
	{
		System.out.println("hello World");
	}
	
}

/*
//how to run on command line:
//WITH NO PACKAGE:
//keyword "package" will NOT exist in your class file.
//AKA: The line: "package;" is invalid. If no package,
//do NOT use the package keyword.

javac DanaHelloWorld.java;
java -cp . DanaHelloWorld;

//WITH a package called: danaStuff;
C:\                 > cd C:\MYCODE\danaStuff     //change dir to where code is
C:\MYCODE\danaStuff > javac DanaHelloWorld.java  //compile .java file.
C:\MYCODE\danaStuff > cd..                       //back up one directory
C:\MYCODE           > java -cp danaStuff; danaStuff.DanaHelloWorld //RUN IT!
*/