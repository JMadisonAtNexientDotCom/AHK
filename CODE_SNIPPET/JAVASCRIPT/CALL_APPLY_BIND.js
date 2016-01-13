//Timestamps apply to video "JavaScript call apply and bind" by techsith
//URL: https://www.youtube.com/watch?v=c0mLRpw-9rI
//Changed some of the variable names to keep it all in same file.

//Call, apply, or bind:
var res; //results.

//Call #1 :@2:20-5:34-6:09: --------------------------------------------------//
var obj = {num:2}; //@2:20
var oneArgFN = function(a){
	return this.num + a;
};

res = oneArgFN.call(obj, 3); //function_name.call(obj, function_arguments)
console.log("oneArgFN.call results: " + res); //expect 5

//call #2: Multiple Arguments: @6:21-7:02. -----------------------------------//
var obj = {num:2};
var multiArgFN = function(a, b, c){
	return this.num + a + b + c;
};

res = multiArgFN.call(obj, 1,2,3);
console.log("multiArgFN.call results: " + res); //expect 8

////apply(...) : @7:50-8:27 :-------------------------------------------------//
var arr = [1,2,3];
res = multiArgFN.apply(obj, arr);
console.log("multiArgFN.apply results: " + res); //expect 8


// BIND: @10:11-13:59 :-------------------------------------------------------//
var boundFN = multiArgFN.bind(obj);
res = boundFN(10,10,10); 
console.log("boundFN results: " + res); //expect 32

//BONUS:
res = boundFN.apply(null,[5,5,5]);
console.log("boundFN.apply results: " + res); //expect 17

//@12:33-13:10:
//boundFN:
// > [[TargetFunction]] : function(a,b,c)
// > [[BoundThis]] : Object
// > [[BoundArgs]] :Array[0]

//13:59--END: Summary.