//AHK SHORTCUT: [?svs]
//Egghead.io - AngularJS - $scope vs. scope
//John Lindquist
// https://www.youtube.com/watch?v=NnB2NBtoeAY
var app = angular.module("app", []);

//@6:01: Longhaded way to inject dependencies.
app.controller("MyCtrl", ['$scope', '$http', function(a, b){
	console.log(a);
	console.log(b);
}]);

app.directive("myDirective", function(){
	return{
		link: function(scope, element, attrs){
			console.log("scope==" + scope);
		}
	};
});

//So... $scope is a provider that is dependency injected.
//And "scope" is... just a variable that by convention
//is storing a reference to $scope?