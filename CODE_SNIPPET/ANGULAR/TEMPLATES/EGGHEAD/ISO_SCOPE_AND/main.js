

var app = angular.module("phoneApp",[]);

app.controller("AppCtrl",function($scope){
	$scope.callHome = function(message){
		alert(message);
	};
});

app.directive("phone",function(){
	return{
		scope:{
			dial:"&"
		},
		//NOTE: {message:value}, NOT:{{message:value}}
		//An OBJECT, not a binding.
		template:'<input type="text" ng-model="value">' +
		         '<div class="button" ng-click="dial({message:value})"> Call Home! </div>'
	};
});