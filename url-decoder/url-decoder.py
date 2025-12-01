import urllib.parse

# Read the file line by line
with open('encoded.txt', 'r') as f:
    lines = f.readlines()

# URL decode each line
decoded_lines = [urllib.parse.unquote(line) for line in lines]

# Write to new file
with open('url_decoded.txt', 'w') as f:
    f.writelines(decoded_lines)

print('URL decoded strings saved to url_decoded.txt')
