//@Author: JMadison
//VERSION #1:
public static void main(String[] args){
	HeatTreatedSugarFlourMixtureFactory.make(3,2,1,1);
};

public class HeatTreatedSugarFlourMixture {
	public Object contents;
}

public class HeatTreatedSugarFlourMixtureFactory{

	public static HeatTreatedSugarFlourMixture make
																			(int eggs, int flour, int oil, int sugar){
																									
		MixtureSubstanceContainer container = new MixtureSubstanceContainer();
		container.addEggs (eggs);
		container.addFlour(flour);
		container.addOil  (oil);
		container.addSugar(sugar)
		container.aggrivateMixture();
		
		MixtureSubstanceHeatResistantContainer heatedContainer = 
																	new MixtureSubstanceHeatResistantContainer();
		heatedContainer.populate(container.getAggrivatedContents() );
		
		EnclosedHeatingCompartment mixtureHeatTreater = 
																							 new EnclosedHeatingCompartment();
		
    output = mixtureHeatTreater.performHeatTreatment(heatedContainer);		
		return output;																
	}
}

public class EnclosedHeatingCompartment{
	
	public HeatTreatedSugarFlourMixture performHeatTreatment
											 (MixtureSubstanceHeatResistantContainer heatedContainer){
		this.openDoor();
		this.insertContainer( heatedContainer );
		this.closeDoor();
		this.wait();
		HeatTreatedSugarFlourMixture output = this.ejectContainer();
		return output;
	}
}


