namespace WebApi;

// Rick Strahl: https://weblog.west-wind.com/posts/2024/Jun/13/C-Version-Formatting
public static class VersionExtensions
{
    public static string FormatVersion(this Version version, int minTokens = 2, int maxTokens = 2)
    {
        if (minTokens < 1)
            minTokens = 1;
        if (minTokens > 4)
            minTokens = 4;
        if (maxTokens < minTokens)
            maxTokens = minTokens;
        if (maxTokens > 4)
            maxTokens = 4;

        int[] items = [version.Major, version.Minor, version.Build, version.Revision];

        // items = items[0..maxTokens];   // netstandard/net472 can't use
        items = items.Take(maxTokens).ToArray();

        string baseVersion = string.Empty;

        for (int i = 0; i < minTokens; i++)
        {
            baseVersion += "." + items[i];
        }

        string extendedVersion = string.Empty;

        for (int i = minTokens; i < maxTokens; i++)
        {
            extendedVersion += "." + items[i];
        }

        return baseVersion.TrimStart('.') + extendedVersion.TrimEnd('.', '0');
    }
}
