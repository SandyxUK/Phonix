/*
* --1 Translate first characters of name: MAC → MCC, KN → N, K → C, PH → FF, PF → FF, SCH → SSS
--2 Translate last characters of name: EE → Y, IE → Y, DT, RT, RD, NT, ND → D
--3 First character of key = first character of name.
4 Translate remaining characters by following rules, incrementing by one character each time:
EV → AF else A, E, I, O, U → A
Q → G, Z → S, M → N
KN → N else K → C
SCH → SSS, PH → FF
H → If previous or next is nonvowel, previous.
W → If previous is vowel, previous.
Add current to key if current is not same as the last key character.
-- 6 If last character is S, remove it.
-- 7 If last characters are AY, replace with Y.
-- 8 If last character is A, remove it.
* */


/// <summary>
/// The New York State Identification and Intelligence System Phonetic Code, 
/// commonly known as NYSIIS.
/// It is used to index words that are pronounced similarly.
/// 
/// </summary>
/// <example>
/// Looking for someone's information in a database of people. 
/// You think that the person's name sounds like "John Smith", 
/// but it is in fact spelled "Jon Smyth"
/// You can index the database using the NYSIIS algorithm, 
/// then when you go to search use the NYSIIS algorithm again on the input. 
/// Both "John Smith" and "Jon Smyth" are indexed as "JAN SNATH"
/// </example>
public class NysiiSc extends PhoneticEncoder implements ISimilarity
{
    public class NotImplementedException extends Exception {}
    public static string GenerateNysiisKey(string name, boolean full)
    {
        String key = '';
        String fullKey = '';
        if (string.Isblank(name)) { return ''; }
        
        string upperName = name.ToUppercase();
        
        //Let's strip non A-Z characters
        upperName = upperName.replaceAll('[^A-Z]','');
        
        //step 1
        uppername = TranslateFirstCharacters(upperName);
        //step 2
        uppername = TranslateLastCharacters(upperName);
        
        //step 3
        string firstCharacter = upperName.Substring(0, 1);
        string remainingName = upperName.Length() > 1 ? upperName.Substring(1) : '';
        if (!string.Isblank(remainingName.Trim()))
        {
            //step 4
            remainingname = TranslateRemaining(remainingName);
            
            //step 6 - 8
            remainingname = ReplaceLastCharacter(remainingName);
        }
        //collapse repeating characters and append first character back on
        fullKey = firstCharacter + SioHelpers.CollapseAdjacentRepeating(remainingName);
        
        //a true NYSIIS key is only 6 characters long
        key = fullKey.Substring(0, (fullKey.Length() >= 6 ? 6 : fullKey.Length()));
        if(full)return fullkey;
        return key;
    }
    
    
    
    private static string TranslateRemaining(string remainingName)
    {
        if (remainingName.Length() == 0) { return ''; }
        //- 4 Translate remaining characters by following rules, incrementing by one character each time:
        //- EV → AF else A, E, I, O, U → A
        //- Q → G, Z → S, M → N
        //- KN → N else K → C
        //- SCH → SSS, PH → FF
        //H → If previous or next is nonvowel, previous.
        //W → If previous is vowel, previous.
        //Add current to key if current is not same as the last key character.
        
        remainingName = remainingName.Replace('EV', 'AF');
        //remainingName = SioHelpers.Vowels.Replace(remainingName, 'A');
        remainingname = remainingname.replaceAll('[AEIOU]','A');
        
        remainingName = remainingName.Replace('Q', 'G');
        remainingName = remainingName.Replace('Z', 'S');
        remainingName = remainingName.Replace('M', 'N');
        
        remainingName = remainingName.Replace('KN', 'N');
        remainingName = remainingName.Replace('K', 'C');
        
        remainingName = remainingName.Replace('SCH', 'SSS');
        remainingName = remainingName.Replace('PH', 'FF');
        /*
        remainingName = HPreNon.Replace(remainingName, delegate(Match match)
        {
        string v = match.ToString();
        return v.Substring(0, 1);
        });
        
        remainingName = HSufNon.Replace(remainingName, delegate(Match match)
        {
        string v = match.ToString();
        return v.Substring(0, 1);
        });
        
        */
        remainingName = remainingName.replaceAll('(([^AEIOU])H)', '$2');
        remainingName = remainingName.replaceAll('((.)H[^AEIOU])', '$2');
        remainingName = remainingName.replaceAll('(([AEIOU])W)', '$2');
        
        //            remainingName = WPreNon.Replace(remainingName, 'A');
        return remainingname;
    }
    
    private static Pattern  HPreNon = Pattern.compile('[^AEIOU]H');
    private static Pattern  HSufNon = Pattern.compile('.H[^AEIOU]');
    private static Pattern  WPreNon = Pattern.compile('(([AEIOU])W)');
    
    private static string ReplaceLastCharacter(string remainingName)
    {
        //6 If last character is S, remove it.
        //7 If last characters are AY, replace with Y.
        //8 If last character is A, remove it.
        if (remainingName.Length() == 0) { return ''; }
        
        if (remainingName.EndsWith('S'))
        {
            remainingName = remainingName.Length() > 0 ? remainingName.Substring(0, remainingName.Length() - 1) : '';
        }
        else if (remainingName.EndsWith('AY'))
        {
            remainingName = remainingName.Length() > 0 ? remainingName.Substring(0, remainingName.Length() - 2) : '';
            remainingName += 'Y';
        }
        else if (remainingName.EndsWith('A'))
        {
            remainingName = remainingName.Length() > 0 ? remainingName.Substring(0, remainingName.Length() - 1) : '';
        }
        return remainingname;
    }
    
    private static string TranslateFirstCharacters(string name)
    {
        //Translate first characters of name: MAC → MCC, KN → N, K → C, PH → FF, PF → FF, SCH → SSS
        integer nameLength = name.Length();
        
        if (name.StartsWith('MAC'))
        {
            name = 'MCC' + name.Substring(3 < nameLength ? 3 : nameLength);
        }
        else if (name.StartsWith('KN'))
        {
            name = 'N' + name.Substring(2 < nameLength ? 2 : nameLength);
        }
        else if (name.StartsWith('K'))
        {
            name = 'C' + name.Substring(1 < nameLength ? 1 : nameLength);
        }
        else if (name.StartsWith('PH'))
        {
            name = 'FF' + name.Substring(2 < nameLength ? 2 : nameLength);
        }
        else if (name.StartsWith('PF'))
        {
            name = 'FF' + name.Substring(2 < nameLength ? 2 : nameLength);
        }
        else if (name.StartsWith('SCH'))
        {
            name = 'SSS' + name.Substring(3 < nameLength ? 3 : nameLength);
        }
        return name;
    }
    
    private static string TranslateLastCharacters(string name)
    {
        //Translate last characters of name: EE → Y, IE → Y, DT, RT, RD, NT, ND → D
        if (name.EndsWith('EE') || name.EndsWith('IE'))
        {
            name = name.Substring(0, name.Length() - 2) + 'Y';
        }
        else if (name.EndsWith('DT') || name.EndsWith('RT') 
                 || name.EndsWith('RD') || name.EndsWith('NT')
                 || name.EndsWith('ND'))
        {
            name = name.Substring(0, name.Length() - 2) + 'D';
        }
        return name;
    }
    
    public override string[] BuildKeys(string word)
    {
        throw new NotImplementedException();
    }
    
    public override string BuildKey(string word)
    {
        if (string.Isblank(word)) { return ''; }
        
        string upperName = word.ToUppercase();
        
        //Let's strip non A-Z characters
        upperName = upperName.replaceAll('[^A-Z]','');
        
        //step 1
        uppername = TranslateFirstCharacters(upperName);
        //step 2
        uppername = TranslateLastCharacters(upperName);
        
        //step 3
        string firstCharacter = upperName.Substring(0, 1);
        string remainingName = upperName.Length() > 1 ? upperName.Substring(1) : '';
        if (!string.isblank(remainingName.Trim()))
        {
            //step 4
            remainingname = TranslateRemaining(remainingName);
            
            //step 6 - 8
            remainingname = ReplaceLastCharacter(remainingName);
        }
        //collapse repeating characters and append first character back on
        return firstCharacter + SioHelpers.CollapseAdjacentRepeating(remainingName);
    }
    
    public boolean IsSimilar(string[] words)
    {
        throw new NotImplementedException();
    }
}
