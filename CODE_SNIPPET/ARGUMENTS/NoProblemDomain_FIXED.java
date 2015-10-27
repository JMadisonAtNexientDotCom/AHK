//@Author: JMadison
//VERSION #2
public static void main(String[] args){
	CakeFactory.make(3,2,1,1);
};

public class Cake {
	public Object contents;
}

public class CakeFactory{

	public static Cake make (int eggs, int flour, int oil, int sugar){
																									
		Bowl mixingBowl = new Bowl();
		mixingBowl.addEggs (eggs);
		mixingBowl.addFlour(flour);
		mixingBowl.addOil  (oil);
		mixingBowl.addSugar(sugar)
		mixingBowl.Mix();
		
		Pan cakePan = new Pan();
		cakePan.pour(mixingBowl.getBatter() );
		
		Oven myOven = new Oven();
		
    output = myOven.bake(cakePan);		
		return output;																
	}
}

public class Oven{
	
	public Cake bake(Pan cakePan){
		this.openDoor();
		this.insertPan( cakePan );
		this.closeDoor();
		this.wait();
		Cake output = this.removePan();
		return output;
	}
}


