#!/usr/bin/env python3
import re

# Read the advisor_data.py file
with open('advisor_data.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Replace **text** with text
content = re.sub(r'\*\*([^*]+?)\*\*', r'\1', content)

# Write back
with open('advisor_data.py', 'w', encoding='utf-8') as f:
    f.write(content)

print('✓ Successfully removed all markdown bold formatting from advisor_data.py')
