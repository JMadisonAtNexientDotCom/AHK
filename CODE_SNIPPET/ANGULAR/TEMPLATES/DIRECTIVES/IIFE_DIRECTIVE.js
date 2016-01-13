//DIRECTIVE TEMPLATE:
"use strict";
(function() { //<--Encapsulate in IIFEE to prevent leakage into global scope.
  angular.module('NAME_OF_PARENT_APP_DIRECTIVE_BELONGS_TO')
    .directive("DIRECTIVE_NAME", [function() {
      return {
        restrict: "MECA", //M:Comment, E:Element, C:Class, A:Attribute
        scope: { //shadows prototype inherited scope, creating isolated scope.
          VAR_______________WITH_2WAY_BINDING: "=", 
          VAR__EXPRESSION_CONVERTED_TO_STRING: "@",
          VAR_EVAL_EXPRESSION_ON_PARENT_SCOPE: "&"
        },
        templateUrl: "RELATIVE/PATH/TO/DIRECTIVE_NAME.html",
        //How does transclude + isolated scope make sense?
        transclude: true,
        controller: ["$scope","$INJECTABLE02", "$INJECTABLE03",
        function($scope, $INJECTABLE02, $INJECTABLE03) {
        }]//<--controller ==+==================================================+
      };  //<--return       |                                                  |
    }]);  //<--.directive   |                                                  |
})();     //<--IIFE ========+==================================================+