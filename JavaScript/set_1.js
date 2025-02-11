// set 1 :


//remove dups from array 
const removeDups = (arr) => arr.reduce((acc, item) => acc.includes(item) ? acc : [...acc, item], []);
console.log("remove dups from [1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9] : ");   
console.log(removeDups([1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9])); // [1,2,3,4,5,6,7,8,9]


//verify id number 

//the algorithm is as follows:
function isValidId(n) {
    if(n>=1000000000) return false; 
    const numToArr = (n) => n.toString().padStart(9,0).split('').map(Number); //convert number to array of digits, padd with 0s
    const doubleEveryOther = (arr) => arr.map((item,index) => index % 2 === 1 ? item * 2 : item)
                                     .map(item => item > 9 ? item.toString().split('').map(Number) : item)
                                     .flat(); 
    return doubleEveryOther(numToArr(n)).reduce((acc, item) => acc + item) % 10 === 0;
}

console.log(isValidId(222920134)); //random id number that is valid 



//fizz buzz 

