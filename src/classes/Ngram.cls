public class NGram
{
	public class ArgumentException extends Exception {}
    public static List<string> GenerateNGram(string name, integer n, boolean removeSpaces)
    {
        if (n <= 0)
        {
            throw new ArgumentException('NGram size must be greater than 0.');
        }
        
        List<string> grams = new List<string>();
        
        //if the name is null, empty, or if we're removing spaces and it is only spaces then return an empty list
        if (string.isBlank(name) || (removeSpaces && string.isBlank(name.Trim()))) { return grams; }
        
        //removeSpaces if requested
        if (removeSpaces)
        {
            name = name.Replace(' ', '');
        }
        
        
        if (n < name.Length())
        {
            for (integer i = 0; (i + n) <= name.Length(); i++)
            {
                grams.Add(name.Substring(i, i+n));
            }
        }
        else
        {   //really not sure what to do here if the length is less than the required q gram size
            
            //grams.Add(name);
        }
        system.debug(grams);
        return grams;
    }
}
