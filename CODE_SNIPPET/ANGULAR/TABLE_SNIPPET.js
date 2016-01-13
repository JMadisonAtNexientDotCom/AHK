//Use a simple string for search filter:
$scope.SEARCH_STRING = "";

//Use an object for search filter:
$scope.SEARCH_OBJ = {};
$scope.SEARCH_OBJ.WHATEVER_KEY = "";

//Controls Sorting Order:
$scope.IS_TABLE_FLIPPED = false;
$scope.SORT_KEY = "WHATEVER_KEY";

$scope.FLIP_THE_TABLE = function(){
	$scope.IS_TABLE_FLIPPED = !$scope.IS_TABLE_FLIPPED;
}