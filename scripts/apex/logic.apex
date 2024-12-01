

// String palCheck = 'token';
// String reversePal = palCheck.reverse();

// if (palCheck == reversePal) {
//     System.debug('Yes! This is a plindrome');
// }else {
//     System.debug('No! This is not a palindrome');
// }



// String str = 'Times';
// String reversedStr = '';

// // Loop through the string from the end to the beginning
// for (Integer i = str.length() - 1; i >= 0; i--) {
//     reversedStr += str.substring(i, i + 1);
// }

// System.debug(reversedStr); // Output will be 'semiT'


String normalString = 'RacecaR';
String reversedString = '';

// Option 1

// reversedString = normalString.reverse();
// System.debug(reversedString);

// Option 2 

for (Integer i = normalString.length()-1; i >=0 ; i--) {
    
    reversedString += normalString.substring(i, i+1);

}

System.debug(reversedString);