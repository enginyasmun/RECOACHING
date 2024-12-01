public with sharing class PalindromeClass {
    public static boolean isPalindrome(string s) {
    //     // Convert the string to lowercase to handle case sensitivity
    //     s = s.toLowerCase();
        
    //     // Loop from the start of the string to the middle
    //     for (Integer i = 0; i < s.length() / 2; i++) {
    //         // Compare the character at position i with the character at the mirrored position from the end
    //         if (s.charAt(i) != s.charAt(s.length() - 1 - i)) {
    //             return false;
    //         }
    //     }
        
    //     // If the loop completes without returning false, it's a palindrome
    //     return true;
    // }
    


      // Convert the string to lowercase to handle case sensitivity
    //   s = s.toLowerCase();
    
      // Initialize two pointers, one at the beginning and one at the end of the string
      Integer left = 0;
      Integer right = s.length() - 1;
      
      // Loop until the pointers meet in the middle
      while (left < right) {
          // If the characters at the pointers do not match, it's not a palindrome
          if (s.charAt(left) != s.charAt(right)) {
              return false;
          }
          // Move the pointers towards the center
          left++;
          right--;
      }
      
      // If we complete the loop without returning false, it's a palindrome
      return true;
  }
  
  
  
}