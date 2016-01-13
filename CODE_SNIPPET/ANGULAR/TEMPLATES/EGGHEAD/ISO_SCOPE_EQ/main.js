var app = angular.module("drinkApp",[]);

app.controller("AppCtrl", function($scope){
	$scope.ctrlFlavor = "blackBerry";
});

app.directive("drink", function(){
	return{
		scope:{
			flavor:"="
		},
		template:'<input type="text" ng-model="flavor">'
	}
});