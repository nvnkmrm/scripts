import urllib.parse
import base64

# Read the file line by line
with open('encoded.txt', 'r') as f:
    lines = f.readlines()

# Decode each line (URL decode first, then Base64 decode)
decoded_lines = []
for line in lines:
    line = line.strip()
    if line:
        # First URL decode (converts %2b to +, %2f to /, etc.)
        url_decoded = urllib.parse.unquote(line)
        # Then Base64 decode
        decoded = base64.b64decode(url_decoded)
        decoded_lines.append(decoded.decode('utf-8', errors='ignore') + '\n')

# Write to new file
with open('url_decoded.txt', 'w') as f:
    f.writelines(decoded_lines)

print('Decoded strings saved to url_decoded.txt')
