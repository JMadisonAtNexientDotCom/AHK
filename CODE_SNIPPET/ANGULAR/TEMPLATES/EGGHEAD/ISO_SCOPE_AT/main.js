
//https://egghead.io/lessons/angularjs-isolate-scope-attribute-binding
//The "@" sign stringifies expression.

var app = angular.module("drinkApp",[]);

app.controller("appCtrl", function($scope){
	$scope.ctrlFlavor = "blackberry";
});

//@2:21
app.directive("drink", function(){
	return{
		scope:{
			flavor:"@"
		},
		template:'<div>{{flavor}}</div>'
	};
});

//@1:11 of video
//This is the way to do the same thing WITHOUT "@" symbol.
/*
app.directive("drink", function(){
	return{
		scope:{},
		template:'<div>{{flavor}}</div>',
		link: function(scope, element, attrs){
			scope.flavor = attrs.flavor;
		}
	};
});
*/