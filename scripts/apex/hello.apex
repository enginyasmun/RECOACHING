// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

// string tempvar = 'Enter_your_name_here';
// System.debug('Hello World!');
// System.debug('My name is ' + tempvar);

// Boolean x = PalindromeClass.isPalindrome('Racecar');
// System.debug(x);



// String clientId = '3MVG9JJwBBbcN47Jsvjrus_jsoeL5wh5.xskm5KyeMxM4dcjm48fHTpoJY7j7AQ1RP9GgV0uO74rz3YFysscL';  // Your Client ID
// String clientSecret = 'FF66271E675D5C9BA6D01295B8B8131C08E583D2927A4726CF504D5ED22A482C';  // Your Client Secret
// String tokenEndpointUrl = 'https://sidemo2024.my.salesforce.com/services/oauth2/token';  // The endpoint from Postman

// String instanceUrl = 'https://littlecake-dev-ed.develop.my.salesforce.com/';

// AccessTokenService.getAccountsFromConnectedOrg(clientId, clientSecret, tokenEndpointUrl, instanceUrl);



// String givenString = 'Hey';
// String reversedString = '';

// for (Integer i = givenString.length() - 1; i >= 0; i--){
//     reversedString += givenString.subString(i,i+1);

// }

// System.debug(reversedString);


List<Integer> intList = new List<Integer>{1, 2, 2, 2, 3, 3, 4, 5, 6, 7, 9, 5, 2, 3, 45};

List<Integer> noDuplicateList = new List<Integer>();

for (Integer i = 0; i < intList.size(); i++) {
    if (! noDuplicateList.contains(intList[i]) ) {
        noDuplicateList.add(intList[i]);
    }
}

System.debug(noDuplicateList);