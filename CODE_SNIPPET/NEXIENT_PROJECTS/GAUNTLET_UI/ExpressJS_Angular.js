'use strict';

angular.module('gauntletApp.submitted', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
	$routeProvider.when('/submitted', {
		templateUrl: 'submitted/submitted.html',
		controller: 'SubmittedCtrl',
		controllerAs: 'ctrl',
	});
}])

.controller('SubmittedCtrl', [
	"$location", "metadataService", "examDataService", "tokenService", 
	function($location, metadataService, examDataService, tokenService) {

		var self = this;

		self.metadata = metadataService.getMetadata();

		self.beginClick = function() {
			$location.path("/exam"); //TODO: Go somewhere meaningful.
		};
}]);
