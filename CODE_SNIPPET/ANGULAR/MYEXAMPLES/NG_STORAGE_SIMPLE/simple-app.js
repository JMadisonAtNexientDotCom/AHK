

<!DOCTYPE html>
<html>
<head lang="en">
	<meta charset="utf-,8">
	<title>AHK:[/ngStorage]</title>
</head>
<body>


<div ng-app="exampleStore">
    <div ng-controller="MainCtrl">
        <p>{{test}}</p>
        <label>Local Storage Bound:</label> <input type="text" ng-model="test">
				<button data-ng-click="clearTest()">Clear Value from LC</button>
        <p><i>Change the value in the textbox and refresh the page!</i></p>
    </div>
</div>

<script src="angular.js"></script>
<script src="simple-ctrl.js"></script>

</body>
</html>

