import urllib.parse

# Read the file line by line
with open('encoded.txt', 'r') as f:
    encoded_lines = f.readlines()

# URL unquote each line
unquoted_lines = []
for encoded_line in encoded_lines:
    encoded_line = encoded_line.strip()
    if encoded_line:
        unquoted_line = urllib.parse.unquote(encoded_line)
        unquoted_lines.append(unquoted_line + '\n')

# Write to new file
with open('unquoted.txt', 'w', encoding='utf-8') as f:
    f.writelines(unquoted_lines)

print('URL unquoted strings saved to unquoted.txt')
