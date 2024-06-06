import sys
import re
from datetime import datetime


def print_current_version():
    file_path = 'Projects/App/Project.swift'
    try:
        # Read the content of the Swift file
        with open(file_path, 'r') as file:
            content = file.read()
        # Extract version information using regular expressions
        short_version_match = re.search(r'"CFBundleShortVersionString": "(\d+\.\d+\.\d+)"', content)
        build_version_match = re.search(r'"CFBundleVersion": "(\d*)"', content)
        
        if short_version_match and build_version_match:
            current_short_version = short_version_match.group(1)
            current_build_version = build_version_match.group(1)
            print(f"현재 버전은 \n shortVersion {current_short_version} \n buildVersion {current_build_version}")
        else:
            print("버전 정보를 찾을 수 없습니다.")
    except Exception as e:
        print(f"Error modifying the file: {e}")

def set_version():
    file_path = 'Projects/App/Project.swift'
    try:
        # Read the content of the Swift file
        with open(file_path, 'r') as file:
            content = file.read()
        
        split_content = content.split('\n')
        build_start_index = "a"
        for ind, lineText in enumerate(split_content) :
            if re.search(r'"CFBundleShortVersionString": "(\d+\.\d+\.\d+)",', lineText) :
                build_start_index = ind
                break
        marketing_target_name_match = re.search(r'"CFBundleShortVersionString": "(\d)+\.(\d)+\.(\d)+"', content)
        new_target_marketing_version = f'{marketing_target_name_match.group(1)}.{int(marketing_target_name_match.group(2)) + 1}.{marketing_target_name_match.group(3)}'
        new_marketing_version = f'      "CFBundleShortVersionString": "{new_target_marketing_version}",'
        
        build_target_name_match = re.search(r'"CFBundleVersion": "(\d*)",', content)
        today = generate_date_number()
        build_target_index = len(str(today))
        new_build_version = f'      "CFBundleVersion": "{today}{int(build_target_name_match.group(1)[build_target_index:]) + 1}",'
        
        next_inpolist_index = "a"
        for ind, lineText in enumerate(split_content) :
            if re.search(r'"CFBundleVersion": "(\d*)"', lineText): 
                next_inpolist_index = ind
                break

        modified_content = split_content[:build_start_index] + [new_marketing_version] + [new_build_version] + split_content[next_inpolist_index + 1: ]
        save_file = '\n'.join(modified_content)
        
        file_path = 'Projects/App/Project.swift'
        # Write the modified content back to the file
        with open(file_path, 'w') as file:
            
            file.write(save_file)
            
    except Exception as e:
        print(f"Error modifying the file: {e}")

def generate_date_number():
    today = datetime.now()
    date_number = today.strftime("%Y%m%d")
    return int(date_number)

def check_version_regular_expression(version):
    target_regular_expression = r'^\d+\.\d+\.\d+$'
    if re.match(target_regular_expression, version):
        return True
    else:
        print("주어진 버전 문자열이 지정된 형식에 일치하지 않습니다.")
        return False

if __name__ == "__main__":
    is_new_version = input("버전을 올리시겠습니까? (y/n): ")
    
    print_current_version()
    if is_new_version == "y":
        set_version()