// https://egghead.io/lessons/angularjs-understanding-isolate-scope

var app = angular.module('choreApp', []);

app.controller("ChoreCtrl", function ($scope){
  $scope.logChore = function(chore){
    alert(chore + " is done");
  }
});


//@5:30 of Video: {chore:chore}
app.directive("kid", function(){
  return {
    restrict: "E",
    scope:{ 
      done:"&"
    }, 
    template: ' <input type="text" ng-model="chore">'                 +
              ' {{chore}} '                                           +
              ' <div class="button" ng-click="done({chore:chore})"> ' +
              ' IM done! (This button might have no boarder)'         +
              ' </div> '
  };
});