
import sys
import os

def to_lower_camel_case(snake_str):
    return snake_str[0].lower() + snake_str[1:]
    
def modify_dependency_file(feature_name):
    file_path = 'Tuist/ProjectDescriptionHelpers/Dependency+FeatureTarget.swift'
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
        
def create_feature(feature_name):
    feature_path = f'Projects/Feature/{feature_name}/'
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

def create_project_feature_file(feature_name):
    
    create_feature(feature_name)
    
    file_path = f'Projects/Feature/{feature_name}/Project.swift'
    try:
        # Create the Project.swift file content
        project_content = f"""
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "{feature_name}",
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

def create_test_dir(feature_name) :
    test_content = f"""
import XCTest

final class {feature_name}Tests: XCTestCase {{
  override func setUp() {{}}
}}
"""

    feature_path = f'Projects/Feature/{feature_name}/Tests'
    os.makedirs(feature_path)
    
    
    test_file_name = feature_name + "Test.swift"
    
    keep_resources_path = os.path.join(feature_path, test_file_name)
    with open(keep_resources_path, 'w') as keep_resources_file:
        keep_resources_file.write(test_content)


def modify_XcodeWorkspace(feature_name):
    file_path = 'Workspace.swift'
    try:
        # Read the content of the Swift file
        with open(file_path, 'r') as file:
            content = file.readlines()

        newPath = f'    "Projects/Feature/{feature_name}",\n'

        modified_content = content[:-2] + [newPath] + content[-2:]

        # Write the modified content back to the file
        with open(file_path, 'w') as file:
            file.write("".join(modified_content))

    except Exception as e:
        print(f"Error modifying the file: {e}")
        

def create_preview_project_feature_file(feature_name, preivew_feature_name):
    file_path = f'Projects/Feature/{preivew_feature_name}/Project.swift'
    try:
        # Create the Project.swift file content
        project_content = f"""
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "{preivew_feature_name}",
  targets: .app(
    name: "{preivew_feature_name}",
    testingOptions: [
    ],
    dependencies: [
      .feature(.{ to_lower_camel_case(feature_name) }),
    ]
  )
)
"""

        # Write the content to the new Project.swift file
        with open(file_path, 'w') as file:
            file.write(project_content)

    except Exception as e:
        print(f"Error creating the Project.swift file: {e}")

def create_preview_module(feature_name) :
    preview_name = feature_name + "Preview"
    modify_XcodeWorkspace(preview_name)
    create_preview_project_feature_file(feature_name, preview_name)

def createFeatureDirectoryAndFile(feature_name: str):
    # Modify the Dependency+Target.swift file
    modify_dependency_file(feature_name)

    # Create the Project.swift file
    create_project_feature_file(feature_name)
    
    create_test_dir(feature_name)
    
    create_preview_module(feature_name)

    print(f"{feature_name} 폴더와 파일이 생성되었습니다.")

createFeatureDirectoryAndFile("hiTest")