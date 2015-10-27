$scope.callService = function()
{
	serviceURL = "http://j1clone01-madnamespace.rhcloud.com/api/NinjaRestService/getNextNinja";
	spinnerService.show('html5spinner'); //<--where is ref to spinnerService?
	$http.get(serviceURL).success( onResponded );
};//FUNC::END