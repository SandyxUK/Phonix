public class Soundex extends PhoneticEncoder implements ISimilarity
{
    private boolean full;
    private integer length;
    
    /// <summary> Constructs a Soundex encoder which generates keys of given length.</summary>
    /// <param name="full">a flag which specifies, whether the first character has to
    /// to be encoded, or not. If <code>false</code>, then this encoder works
    /// like the original soundex described by Knuth, i.e. 'Knuth'
    /// will become 'K530'. If <code>true</code>, then this encoder will encode
    /// the first character too, i.e. 'Knuth' will become '2530'.
    /// </param>
    /// <param name="length">the length of the keys to generate.
    /// </param>
    public Soundex(boolean full, integer length)
    {
        this.full = full;
        this.length = length;
    }
    
    /// <summary> Constructs a Soundex encoder which generates keys of length 4.</summary>
    /// <param name="full">a flag which specifies, whether the first character has to
    /// to be encoded, or not. If <code>false</code>, this encoder works
    /// like the original soundex described by Knuth, i.e. 'Knuth'
    /// will become 'K530'. If <code>true</code>, this encoder will encode
    /// the first character too, i.e. 'Knuth' will become '2530'.
    /// </param>
    public Soundex(boolean full)
    {
        this(full, 4);
    }
    
    /// <summary> Constructs an original Soundex encoder which generates keys of given length.</summary>
    /// <param name="length">the length of the keys to generate.
    /// </param>
    public Soundex(integer length) 
    {
        this(false, length);
    }
    
    /// <summary> Constructs an original Soundex encoder which generates keys of length 4.</summary>
    public Soundex() 
    {
        this(false, 4);
    }
    
    /// <summary> Returns a <tt>String</tt> identifying the algorithm.</summary>
    public override string ToString()
    {
        return 'Soundex_' + full + '_' + length;
    }
    
    public boolean IsSimilar(List<String> words)
    {
        List<String> encoders = new List<String>();
        
        for (Integer i = 0; i < words.size(); i++)
        {
            encoders.add(BuildKey(words[i]));
            system.debug(encoders);
            if (i != 0)
            {
                if (encoders[i] != encoders[i - 1])
                {
                    return false;
                }
            }
        }
        return true;
    }
    
    private static string GETCode(string c)
    {
        String char1 = c.toLowerCase().substring(0,1);

        switch on char1
        {
            when 'b','p','f','v'{ return '1';}
            when 'c','s','k','g','j','q','x','z'{ return '2';}
            when 'd','t'{ return '3';}
            when 'l'{ return '4';}
            when 'm','n'{ return '5';}
            when 'r'{ return '6';}
        }
        return '*';
    }
    
    /// <summary> Returns the encoding of the given word.</summary>
    /// <param name="word">the word to encode.
    /// </param>
    /// <returns> an array with the encoding of the word.
    /// This is never <code>null</code>.
    /// </returns>
    public override string[] BuildKeys(string word)
    {
        system.debug(word);
        if (word == null) return emptykeys;
        return (!(word.length()==0)) ? new List<String> { BuildKey(word) } : EmptyKeys;
        
    }
    
    /// <summary> Returns the encoding of the given word.</summary>
    /// <param name="word">the word to encode.
    /// </param>
    /// <returns> the encoding of the word. This is never <code>null</code>.
    /// </returns>
    public override string BuildKey(string word)
    {
        if (length <= 0)
            return '';
        
        if (word.length()==0)
            return '';
        
		String[] chars = word.split('');
		// the 1st element in an Apex '' split is garbage; remove it:
		//chars.remove(0);
        String result = '';
        
        integer inIdx, outIdx;
        String prevDigit;

        if (full)
        {
            inIdx = outIdx = 0;
            prevDigit = '*';
        }
        else
        {
            inIdx = outIdx = 1;
            result+=chars[0].ToUppercase();
            prevDigit = GETCode(chars[0]);
        }
        
        while (inIdx < chars.size() && outIdx < length)
        {
            String c = GETCode(chars[inIdx]);
            
            if (c != '*' && c != prevDigit)
            {
                result+=c;
                outIdx++;
            }
            
            prevDigit = c;
            inIdx++;
        }
        
        for (; outIdx < length; outIdx++)
            result+='0';
        
        return result;
    }
}
