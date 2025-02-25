import xml.etree.ElementTree as ET

def xml_to_dict(node):
    result = {'Label': node.text.strip() if node.text and node.text.strip() else '', 'Branches': []}
    for child in node:
        result['Branches'].append(xml_to_dict(child))
    return result

def to_lua(node, indent=0):
    indent_str = '  ' * indent
    branches_indent = '  ' * (indent + 1)
    result = indent_str + '{'
    label = node['Label'].replace('"', '\\"')
    result += f'\n{branches_indent}Label = "{label}",'
    if node['Branches']:
        result += f'\n{branches_indent}Branches = {{'
        for i, branch in enumerate(node['Branches']):
            branch_str = to_lua(branch, indent + 2)
            result += f'\n{branch_str}'
            if i < len(node['Branches']) - 1:
                result += ','
        result += f'\n{branches_indent}}}'
    else:
        result += f'\n{branches_indent}Branches = {{}}'
    result += f'\n{indent_str}}}'
    return result

tree = ET.parse('safechat.xml')
root = tree.getroot()

lua_root = {'Label': 'ROOT', 'Branches': []}
for utterance in root.findall('utterance'):
    lua_root['Branches'].append(xml_to_dict(utterance))

lua_code = 'local safeChatData = {\n    Label = "ROOT",\n    Branches = {'
for i, branch in enumerate(lua_root['Branches']):
    lua_code += f'\n{to_lua(branch, 4)}'
    if i < len(lua_root['Branches']) - 1:
        lua_code += ','
lua_code += '\n    }\n}\n'

with open('safechat.lua', 'w') as f:
    f.write(lua_code)
