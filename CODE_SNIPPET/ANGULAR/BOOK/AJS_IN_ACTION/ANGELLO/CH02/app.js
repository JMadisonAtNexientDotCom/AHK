var myModule = angular.module("Angello", []);

myModule.directive ('story'        , function(){

  //Return DDO (Directive Definition Object) Page: 18 of AIA.
	return{
		scope:true,
		replace:true,
		template:'<div><h4>{{story.title}}</h4><p>{{story.description}}</p></div>'
	};

});//Directive

//Page 17 is calling this the "AngelloHelper Service" Yet it is in
//A factory....
myModule.factory   ('AngelloHelper', function(){
	var buildIndex = function(source, property){
		var tempArray = [];
		var len = source.length; //Because book doesn't know how to for-loop!
		for(var i = 0; i < len; ++i){
		  //reverse lookup? Say... source[i] == cookies.
			//cookies.property = source[i] ??
			tempArray[source[i][property]] = source[i];
		}
		
		return tempArray;
	};
		
	//Return object with all utility methods:
	return {
		buildIndex: buildIndex
	};
});//factory


myModule.service   ('AngelloModel' , function(){
	var service = this;
	stories = [
		{
			title      : 'First Story',
			description: 'Our first story.',
			criteria   : 'Criteria Pending',
			status     : 'To Do',
			type       : 'Feature',
			reporter   : 'Lukas Reubbelke',
			assignee   : 'Brian Ford'
		},{
			title      : 'Second Story',
			description: 'Do Something.',
			criteria   : 'Criteria Pending',
			status     : 'Back Log',
			type       : 'Feature',
			reporter   : 'Lukas Reubbelke',
			assignee   : 'Brian Ford'
		},{
			title      : 'Another Story',
			description: 'Just one more.',
			criteria   : 'Criteria Pending',
			status     : 'Code Review',
			type       : 'Enhancement',
			reporter   : 'Lukas Reubbelke',
			assignee   : 'Brian Ford'
		}];
		
		service.getStories = function(){
			return stories;
		};

});//service

//Page 16 forgot to put dependency inside array?
myModule.controller('MainCtrl', function(AngelloModel){
	var main = this; //referenced as main in both .js controller and .html
	                 //making it easier to connect the dots.
	
	main.stories = AngelloModel.getStories();
	console.log("main.stories==[" + main.stories + "]");

	main.createStory = function(){
		main.stories.push({
			title      : 'New Story',
			description: 'Description Pending',
			criteria   : 'Criteria Pending',
			status     : 'Put Status Here',
			type       : 'Put Type Here',
			reporter   : 'Reporter Pending',
			assignee   : 'Assignee Pending'
		});
	};//END FUNCTION.
		

});//controller

