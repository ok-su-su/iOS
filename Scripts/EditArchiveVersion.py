import sys
import re
from datetime import datetime


def print_current_version():
    file_path = 'Projects/App/MealGok/Project.swift'
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

def set_version(is_update_version):
    file_path = 'Projects/App/MealGok/Project.swift'
    try:
        # Read the content of the Swift file
        with open(file_path, 'r') as file:
            content = file.read()

        start_content = '''      "BGTaskSchedulerPermittedIdentifiers": "com.maramincho.mealgok",\n'''
        build_start_index = content.find(start_content)
        marketing_target_name_match = re.search(r'"CFBundleShortVersionString": "(\d)+\.(\d)+\.(\d)+"', content)
        mid_num = int(marketing_target_name_match.group(2)) + 1 if is_update_version == 'y' else int(marketing_target_name_match.group(2))
        new_target_marketing_version = f'{marketing_target_name_match.group(1)}.{int(marketing_target_name_match.group(2)) + 1}.{marketing_target_name_match.group(3)}'
        new_marketing_version = f'      "CFBundleShortVersionString": "{new_target_marketing_version}",\n'
        
        
        build_target_name_match = re.search(r'"CFBundleVersion": "(\d*)"', content)
        today = generate_date_number()
        build_target_index = len(str(today))
        new_build_version = f'      "CFBundleVersion": "{today}{int(build_target_name_match.group(1)[build_target_index:]) + 1}",\n'
        
        next_inpolist_index = content.find('''      "UIUserInterfaceStyle": "Light",''')
        modified_content = content[:build_start_index] + start_content + new_marketing_version + new_build_version + content[next_inpolist_index: ]

        # Write the modified content back to the file
        with open(file_path, 'w') as file:
            file.write(modified_content)

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

    set_version(is_new_version)