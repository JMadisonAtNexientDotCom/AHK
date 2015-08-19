//BookPage125 of SpringInAction4ThEdition
package concert;
public aspect CriticAspect {

	public CriticAspect() {}
	
	//NOTE: Reason this point cut expression does NOT appear in "quotes"
	//is because this is NOT a class. This is an "ASPECT" This .java file
	//is only valid when using the AspectJ extension to java language.
	pointcut performance() : execution(* perform(..));
	
	afterReturning() : performance() {
		System.out.println(criticismEngine.getCriticism());
	}
	
	private CriticismEngine criticismEngine;
		
	public void setCriticismEngine(CriticismEngine criticismEngine) {
		this.criticismEngine = criticismEngine;
	}
}//aspect