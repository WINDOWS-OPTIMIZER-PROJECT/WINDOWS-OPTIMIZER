#author:gorillagriller
#md5 generation of file content
@"
using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace FileHash
{
    public class HashChecker
    {
        public static bool CheckHash(string filePath, string storedHash, string algorithm)
        {
            using (var hashAlgorithm = HashAlgorithm.Create(algorithm))
            {
                using (var stream = File.OpenRead(filePath))
                {
                    byte[] hash = hashAlgorithm.ComputeHash(stream);
                    string computedHash = BitConverter.ToString(hash).Replace("-", "").ToLowerInvariant();
                    return computedHash == storedHash;
                }
            }
        }
    }
}
"@
