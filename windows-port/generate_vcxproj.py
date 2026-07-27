import os

vcxproj_content = """<?xml version="1.0" encoding="utf-8"?>
<Project ToolsVersion="15.0" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <Import Project="packages\\Microsoft.Windows.CppWinRT.2.0.230706.1\\build\\native\\Microsoft.Windows.CppWinRT.props" Condition="Exists('packages\\Microsoft.Windows.CppWinRT.2.0.230706.1\\build\\native\\Microsoft.Windows.CppWinRT.props')" />
  <PropertyGroup Label="Globals">
    <CppWinRTOptimized>true</CppWinRTOptimized>
    <CppWinRTRootNamespaceAutoMerge>true</CppWinRTRootNamespaceAutoMerge>
    <MinimalCoreWin>true</MinimalCoreWin>
    <ProjectGuid>{A3D73499-1389-42E1-AC0F-7F0CC5FCAFE1}</ProjectGuid>
    <ProjectName>PKGMachete</ProjectName>
    <RootNamespace>PKGMachete</RootNamespace>
    <DefaultLanguage>en-US</DefaultLanguage>
    <MinimumVisualStudioVersion>16.0</MinimumVisualStudioVersion>
    <AppxPackageSigningEnabled>false</AppxPackageSigningEnabled>
    <WindowsPackageType>None</WindowsPackageType>
    <AppxPackage>false</AppxPackage>
    <WindowsAppSDKSelfContained>true</WindowsAppSDKSelfContained>
  </PropertyGroup>
  <Import Project="$(VCTargetsPath)\\Microsoft.Cpp.Default.props" />
  <ItemGroup Label="ProjectConfigurations">
    <ProjectConfiguration Include="Release|x64">
      <Configuration>Release</Configuration>
      <Platform>x64</Platform>
    </ProjectConfiguration>
  </ItemGroup>
  <PropertyGroup Label="Configuration">
    <ConfigurationType>Application</ConfigurationType>
    <PlatformToolset>v143</PlatformToolset>
    <CharacterSet>Unicode</CharacterSet>
    <DesktopCompatible>true</DesktopCompatible>
  </PropertyGroup>
  <Import Project="$(VCTargetsPath)\\Microsoft.Cpp.props" />
  <ImportGroup Label="ExtensionSettings">
  </ImportGroup>
  <ImportGroup Label="PropertySheets">
    <Import Project="$(UserRootDir)\\Microsoft.Cpp.$(Platform).user.props" Condition="exists('$(UserRootDir)\\Microsoft.Cpp.$(Platform).user.props')" Label="LocalAppDataPlatform" />
  </ImportGroup>
  <PropertyGroup Label="UserMacros" />
  <ItemDefinitionGroup>
    <ClCompile>
      <PrecompiledHeader>Use</PrecompiledHeader>
      <PrecompiledHeaderFile>pch.h</PrecompiledHeaderFile>
      <PrecompiledHeaderOutputFile>$(IntDir)pch.pch</PrecompiledHeaderOutputFile>
      <WarningLevel>Level4</WarningLevel>
      <AdditionalOptions>%(AdditionalOptions) /bigobj</AdditionalOptions>
      <DisableSpecificWarnings>4453;28204</DisableSpecificWarnings>
      <PreprocessorDefinitions>WIN32;_WINDOWS;NDEBUG;%(PreprocessorDefinitions)</PreprocessorDefinitions>
      <LanguageStandard>stdcpp20</LanguageStandard>
    </ClCompile>
    <Link>
      <GenerateDebugInformation>true</GenerateDebugInformation>
      <SubSystem>Windows</SubSystem>
    </Link>
  </ItemDefinitionGroup>
  <ItemGroup>
    <ClInclude Include="pch.h" />
    <ClInclude Include="App.xaml.h">
      <DependentUpon>App.xaml</DependentUpon>
    </ClInclude>
    <ClInclude Include="MainWindow.xaml.h">
      <DependentUpon>MainWindow.xaml</DependentUpon>
    </ClInclude>
  </ItemGroup>
  <ItemGroup>
    <ClCompile Include="pch.cpp">
      <PrecompiledHeader>Create</PrecompiledHeader>
    </ClCompile>
    <ClCompile Include="App.xaml.cpp">
      <DependentUpon>App.xaml</DependentUpon>
    </ClCompile>
    <ClCompile Include="MainWindow.xaml.cpp">
      <DependentUpon>MainWindow.xaml</DependentUpon>
    </ClCompile>
    <ClCompile Include="$(GeneratedFilesDir)module.g.cpp" />
  </ItemGroup>
  <ItemGroup>
    <ApplicationDefinition Include="App.xaml">
      <SubType>Designer</SubType>
    </ApplicationDefinition>
  </ItemGroup>
  <ItemGroup>
    <Page Include="MainWindow.xaml">
      <SubType>Designer</SubType>
    </Page>
  </ItemGroup>
  <ItemGroup>
    <Manifest Include="app.manifest" />
  </ItemGroup>
  <ItemGroup>
    <None Include="packages.config" />
  </ItemGroup>
  <Import Project="$(VCTargetsPath)\\Microsoft.Cpp.targets" />
  <ImportGroup Label="ExtensionTargets">
    <Import Project="packages\\Microsoft.Windows.CppWinRT.2.0.230706.1\\build\\native\\Microsoft.Windows.CppWinRT.targets" Condition="Exists('packages\\Microsoft.Windows.CppWinRT.2.0.230706.1\\build\\native\\Microsoft.Windows.CppWinRT.targets')" />
    <Import Project="packages\\Microsoft.WindowsAppSDK.1.4.231008000\\build\\native\\Microsoft.WindowsAppSDK.targets" Condition="Exists('packages\\Microsoft.WindowsAppSDK.1.4.231008000\\build\\native\\Microsoft.WindowsAppSDK.targets')" />
  </ImportGroup>
</Project>
"""

packages_content = """<?xml version="1.0" encoding="utf-8"?>
<packages>
  <package id="Microsoft.Windows.CppWinRT" version="2.0.230706.1" targetFramework="native" />
  <package id="Microsoft.WindowsAppSDK" version="1.4.231008000" targetFramework="native" />
</packages>
"""

manifest_content = """<?xml version="1.0" encoding="utf-8"?>
<assembly manifestVersion="1.0" xmlns="urn:schemas-microsoft-com:asm.v1">
  <assemblyIdentity version="5.0.0.0" name="PKGMachete"/>
  <compatibility xmlns="urn:schemas-microsoft-com:compatibility.v1">
    <application>
      <supportedOS Id="{8e0f7a12-bfb3-4fe8-b9a5-48fd50a15a9a}" />
    </application>
  </compatibility>
</assembly>
"""

pch_cpp_content = """#include "pch.h"
"""

with open("windows-port/PKGMachete.vcxproj", "w") as f:
    f.write(vcxproj_content)
with open("windows-port/packages.config", "w") as f:
    f.write(packages_content)
with open("windows-port/app.manifest", "w") as f:
    f.write(manifest_content)
with open("windows-port/pch.cpp", "w") as f:
    f.write(pch_cpp_content)

print("Generated Windows MSBuild files.")
