import os
import sys

def to_lower_camel_case(snake_str):
    return snake_str[0].lower() + snake_str[1:]
    
def modify_dependency_file(feature_name):
    file_path = 'Plugins/DependencyPlugin/ProjectDescriptionHelpers/Dependency+Target.swift'
    try:
        # Read the content of the Swift file
        with open(file_path, 'r') as file:
            content = file.read()

        # Find the position to insert the new case above the public var targetName variable
        target_name_index = content.find("  public var targetName: String {")

        new_case_name = to_lower_camel_case(feature_name)
        # Add a new case to the Feature enum above the public var targetName
        new_case = f"  case {new_case_name}\n"
        modified_content = content[:target_name_index] + f"{new_case}" + content[target_name_index:]

        # Write the modified content back to the file
        with open(file_path, 'w') as file:
            file.write(modified_content)

    except Exception as e:
        print(f"Error modifying the file: {e}")

def modify_dependency_custom_shared_file(feature_name):
    file_path = 'Plugins/DependencyPlugin/ProjectDescriptionHelpers/Dependency+Target.swift'
    try:
        # Read the content of the Swift file
        with open(file_path, 'r') as file:
            content = file.read()

        # Find the position to insert the new case above the public var targetName variable
        target_name_index = content.find("  static func feature(_ feature: Feature) -> TargetDependency {")

        new_case_name = to_lower_camel_case(feature_name)
        # Add a new case to the Feature enum above the public var targetName
        new_case = f"""  static let {new_case_name}: TargetDependency = .project(target: "{feature_name}", path: .relativeToShared("{feature_name}"))\n"""
        modified_content = content[:target_name_index] + f"{new_case}" + content[target_name_index:]

        # Write the modified content back to the file
        with open(file_path, 'w') as file:
            file.write(modified_content)

    except Exception as e:
        print(f"Error modifying the file: {e}")

def modify_dependency_custom_core_file(feature_name):
    file_path = 'Plugins/DependencyPlugin/ProjectDescriptionHelpers/Dependency+Target.swift'
    try:
        # Read the content of the Swift file
        with open(file_path, 'r') as file:
            content = file.read()

        # Find the position to insert the new case above the public var targetName variable
        target_name_index = content.find("  static func feature(_ feature: Feature) -> TargetDependency {")

        new_case_name = to_lower_camel_case(feature_name)
        # Add a new case to the Feature enum above the public var targetName
        new_case = f"""  static let {new_case_name}: TargetDependency = .project(target: "{feature_name}", path: .relativeToCore("{feature_name}"))\n"""
        modified_content = content[:target_name_index] + f"{new_case}" + content[target_name_index:]

        # Write the modified content back to the file
        with open(file_path, 'w') as file:
            file.write(modified_content)

    except Exception as e:
        print(f"Error modifying the file: {e}")


def create_feature(feature_name):
    feature_path = f'Projects/Features/{feature_name}/'
    os.makedirs(feature_path)

    resources_path = os.path.join(feature_path, 'Resources')
    sources_path = os.path.join(feature_path, 'Sources')

    os.makedirs(resources_path)
    os.makedirs(sources_path)
    
    
    # Create KeepResources.swift in Resources directory
    keep_resources_path = os.path.join(resources_path, 'KeepResources.swift')
    with open(keep_resources_path, 'w') as keep_resources_file:
        keep_resources_file.write('// Content of KeepResources.swift')

    # Create KeepSources.swift in Sources directory
    keep_sources_path = os.path.join(sources_path, 'KeepSources.swift')
    with open(keep_sources_path, 'w') as keep_sources_file:
        keep_sources_file.write('// Content of KeepSources.swift')

def create_shared(feature_name):
    feature_path = f'Projects/Shared/{feature_name}/'
    os.makedirs(feature_path)

    sources_path = os.path.join(feature_path, 'Sources')

    os.makedirs(sources_path)

    # Create KeepSources.swift in Sources directory
    keep_sources_path = os.path.join(sources_path, 'KeepSources.swift')
    with open(keep_sources_path, 'w') as keep_sources_file:
        keep_sources_file.write('// Content of KeepSources.swift')
        
def create_core(feature_name):
    feature_path = f'Projects/core/{feature_name}/'
    os.makedirs(feature_path)

    sources_path = os.path.join(feature_path, 'Sources')

    os.makedirs(sources_path)

    # Create KeepSources.swift in Sources directory
    keep_sources_path = os.path.join(sources_path, 'KeepSources.swift')
    with open(keep_sources_path, 'w') as keep_sources_file:
        keep_sources_file.write('// Content of KeepSources.swift')

def create_project_core_file(feature_name):

    create_core(feature_name)
    
    file_path = f'Projects/core/{feature_name}/Project.swift'
    try:
        # Create the Project.swift file content
        project_content = f"""
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "{feature_name}",
  targets: .custom(
    name: "{feature_name}",
    product: .framework
  )
)

"""

        # Write the content to the new Project.swift file
        with open(file_path, 'w') as file:
            file.write(project_content)

    except Exception as e:
        print(f"Error creating the Project.swift file: {e}")

def create_project_shared_file(feature_name):

    create_shared(feature_name)
    
    file_path = f'Projects/shared/{feature_name}/Project.swift'
    try:
        # Create the Project.swift file content
        project_content = f"""
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "{feature_name}",
  targets: .custom(
    name: "{feature_name}",
    product: .framework
  )
)

"""

        # Write the content to the new Project.swift file
        with open(file_path, 'w') as file:
            file.write(project_content)

    except Exception as e:
        print(f"Error creating the Project.swift file: {e}")

def create_test_dir(feature_name) :
    test_content = f"""
import XCTest

final class {feature_name}Tests: XCTestCase {{
  override func setUp() {{}}
}}
"""

    feature_path = f'Projects/Features/{feature_name}/Tests'
    os.makedirs(feature_path)
    
    
    test_file_name = feature_name + "Test.swift"
    
    keep_resources_path = os.path.join(feature_path, test_file_name)
    with open(keep_resources_path, 'w') as keep_resources_file:
        keep_resources_file.write(test_content)

  

def create_project_feature_file(feature_name):

    create_feature(feature_name)
    
    file_path = f'Projects/Features/{feature_name}/Project.swift'
    try:
        # Create the Project.swift file content
        project_content = f"""
import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "{feature_name}Feature",
  targets: .feature(
    .{to_lower_camel_case(feature_name)},
    testingOptions: [.unitTest],
    dependencies: [],
    testDependencies: []
  )
)
"""

        # Write the content to the new Project.swift file
        with open(file_path, 'w') as file:
            file.write(project_content)

    except Exception as e:
        print(f"Error creating the Project.swift file: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python TuistScript.py <feature|shared|core>")
        sys.exit(1)

    
    feature_name = input("모듈의 이름을 입력하세요: ")

    if sys.argv[1] == "feature":
        # Modify the Dependency+Target.swift file
        modify_dependency_file(feature_name)

        # Create the Project.swift file
        create_project_feature_file(feature_name)
        
        create_test_dir(feature_name)

        print(f"{feature_name} 폴더와 파일이 생성되었습니다.")
    elif sys.argv[1] == "shared":
        # Modify the Dependency+Target.swift file
        modify_dependency_custom_shared_file(feature_name)

        # Create the Project.swift file
        create_project_shared_file(feature_name)

        print(f"{feature_name} 폴더와 파일이 생성되었습니다.")
        pass
    elif sys.argv[1] == "core":
        
        modify_dependency_custom_core_file(feature_name)

        create_project_core_file(feature_name)

    else:
        print("Invalid feature type. Use <feature|shared|core>")
        sys.exit(1)

