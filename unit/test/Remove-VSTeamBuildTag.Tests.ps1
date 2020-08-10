Set-StrictMode -Version Latest

Describe 'VSTeamBuildTag' {
   BeforeAll {
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
   
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())

      $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
   }

   Context 'Remove-VSTeamBuildTag' {
      BeforeAll {
         [string[]] $inputTags = "Test1", "Test2", "Test3"
         Mock Invoke-RestMethod { return @{ value = $null } }
      }

      Context 'Services' {
         BeforeAll {
            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'https://dev.azure.com/test' }
         }

         It 'should add tags to Build' {
            Remove-VSTeamBuildTag -ProjectName VSTeamBuildTag -id 2 -Tags $inputTags

            foreach ($inputTag in $inputTags) {
               Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                  $Method -eq 'Delete' -and
                  $Uri -eq "https://dev.azure.com/test/VSTeamBuildTag/_apis/build/builds/2/tags?api-version=$(_getApiVersion Build)" + "&tag=$inputTag"
               }
            }
         }
      }

      Context 'Server' {
         BeforeAll {
            Mock _useWindowsAuthenticationOnPremise { return $true }

            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         }

         It 'should add tags to Build' {
            Remove-VSTeamBuildTag -ProjectName VSTeamBuildTag -id 2 -Tags $inputTags

            foreach ($inputTag in $inputTags) {
               Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                  $Method -eq 'Delete' -and
                  $Uri -eq "http://localhost:8080/tfs/defaultcollection/VSTeamBuildTag/_apis/build/builds/2/tags?api-version=$(_getApiVersion Build)" + "&tag=$inputTag"
               }
            }
         }
      }
   }
}