public  class SioHelpers
    {
        public class ArgumentException extends Exception {}

        public static Pattern Vowels = Pattern.compile('[AEIOUaeiou]');

        /// <summary>
        /// Collapses on adjacent repeating letters in a string into one single character.
        /// 
        /// EXAMPLE:
        /// Hello -> Helo
        /// Bobby - > Boby
        /// </summary>
        /// <param name="value">value to collapse adjacent characters</param>
        /// <returns>Collapsed string</returns>
        public static string CollapseAdjacentRepeating(string value)
        {
            String sb = '';

            String prev = ' ';
            boolean first = true;
            for(Integer i=0;i<value.length();i++)
            {
                String c = value.substring(i,i+1);
                if (c != prev || first)
                {
                    sb+=c;
                    first = false;
                }
                prev = c;
            }

            return sb
                ;
        }

        /// <summary>
        /// Checks if a character is a vowel.
        /// 
        /// Should be faster than regex.
        /// </summary>
        /// <param name="c">Character to check</param>
        /// <returns>true if it is a vowel</returns>
        public static boolean IsVowel(String c)
        {
            String char1 = c.toLowerCase().substring(0,1);
    
            switch on char1
            {
                when 'a','e','i','o','u'{ return true;}
                when else {return false;}
            }
        }


        /// <summary>
        /// Reverses the order of a string
        /// </summary>
        /// <param name="value">String to reverse</param>
        /// <returns>Reversed string</returns>
        public static string ReverseString(string value)
        {
            
            return value.reverse();
        }


        /// <summary>
        /// Compute Levenhstein Distance
        /// 
        /// Translating pseudocode from wiki
        /// http://en.wikipedia.org/wiki/Levenshtein_distance
        /// </summary>
        /// <param name="s1"></param>
        /// <param name="s2"></param>
        /// <returns></returns>
        public static integer LevenshteinDistance(string s1, string s2)
        {
            if (s1 == null || s2 == null)
            {
                throw new ArgumentException('Neither string can be null for Levenshtein Distance calculations.');
            }

            integer s1L = s1.Length();
            integer s2L = s2.Length();

            List<List<integer>> d = new List<List<Integer>>();
            for(integer i = 0; i <= s1L; ++i)
            {
                List<integer> di = new List<integer>();
                for(integer j = 0; j <= s2L; ++j)
                {
                    di.add(0);
                }
                d.add(di);
            }

            for (integer i = 1; i <= s1L; i++)
            {
                d[i][0] = i; // deletion
            }

            for (integer j = 1; j <= s2L; j++)
            {
                d[0][j] = j; // insertion
            }
            
            system.debug(d);

            for (integer j = 1; j <= s2L; j++)
            {
                for (integer i = 1; i <= s1L; i++)
                {
                    if (s1.charat(i-1) == s2.charat(j-1))
                    {
                        d[i][j] = d[i - 1][j - 1];
                    }
                    else
                    {
                        integer deletion = d[i - 1][j] + 1;
                        integer insertion = d[i][j - 1] + 1;
                        integer substitution = d[i - 1][j - 1] + 1;

                        integer min1 = Math.Min(deletion, insertion);
                        integer min2 = Math.Min(min1, substitution);

                        d[i][j] = min2;
                    }
                }
            }
            system.debug(d);

            return d[s1L - 1][s2L - 1];
        }


        /// <summary>
        /// Compute Hamming Distance.
        /// Can only be used on strings of equal length
        /// </summary>
        /// <param name="s1">String 1 to compare</param>
        /// <param name="s2">String 2 to compare</param>
        /// <returns>the calculated distance. 
        /// Values are 0 and up. 
        /// -1 is returned if the strings are NOT of equal length 
        /// (use LevenshteinDistance for unequal length strings)</returns>
        public static integer HammingDistance(string s1, string s2)
        {
            if (s1 == null || s2 == null)
            {
                throw new ArgumentException('Neither string can be null for Hamming Distance calculations.');
            }

            if (s1.Length() != s2.Length())
            {
                //throw new ArgumentException("Strings must be of equal length to accurately Calculate Hamming Distance.");
                //for now, let's return -1 instead of throwing an error
                return -1;
            }


            s1 = s1.ToLowercase();
            s2 = s2.ToLowercase();

            integer val = 0;
            for (integer i = 0; i < s1.Length(); i++)
            {
                //val += (s1[i] != s2[i]) ? 1 : 0;

                //incrementing is probably faster
                if (s1.charat(i) != s2.charat(i))
                {
                    val++;
                }
            }

            return val;
        }


        /// <summary>
        /// Calculates the Dice Coefficient (similarity) of two strings.
        /// 
        /// http://en.wikipedia.org/wiki/Dice%27s_coefficient
        /// 
        /// </summary>
        /// <param name="s1">First string to calculate the Dice Coefficient of</param>
        /// <param name="s2">Second string to calculate the Dice Coefficient of</param>
        /// <returns>the calculated coefficient</returns>
        public static double DiceCoefficient(string s1, string s2)
        {
            s1 = s1.ToLowercase();
            s2 = s2.ToLowercase();

            List<string> s1BiGrams = NGram.GenerateNGram(s1, 2, true);
            List<string> s2BiGrams = NGram.GenerateNGram(s2, 2, true);

            //intersecting members
            List<string> intersects =new List<String>();
            for(integer i=0;i<s1BiGrams.size();i++){
                if(s2BiGrams.contains(s1BiGrams[i])) {
                    intersects.add(s1BiGrams[i]);
                }
            }

            //(2 x IntersectingCNT) / (total added bigrams)
            return (double)(2 * intersects.size()) / (double)(s2BiGrams.size() + s1BiGrams.size());
        }
    }
