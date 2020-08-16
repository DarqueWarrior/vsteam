Set-StrictMode -Version Latest

Describe 'VSTeamReleaseStatus' {
   BeforeAll {
      Import-Module SHiPS
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamBuild.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamReleaseDefinition.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())
      
      ## Arrange
      Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { $Service -eq 'Release' }

      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Set-VSTeamEnvironmentStatus by ID' {
      BeforeAll {
         Mock _useWindowsAuthenticationOnPremise { return $false }
         Mock Invoke-RestMethod
         Mock Invoke-RestMethod { throw 'error' } -ParameterFilter { $Uri -like "*101*" }

         $expectedBody = ConvertTo-Json ([PSCustomObject]@{status = 'inProgress'; comment = ''; scheduledDeploymentTime = $null })
      }

      It 'should set environments' {
         ## Act
         Set-VSTeamEnvironmentStatus -ProjectName project -ReleaseId 1 -Id 15 -Status inProgress -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -eq $expectedBody -and
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/1/environments/15?api-version=$(_getApiVersion Release)"
         }
      }

      It 'by Id should throw' {
         ## Act / Assert
         { Set-VSTeamEnvironmentStatus -ProjectName project -ReleaseId 101 -Id 101 -Status inProgress -Force } | Should -Throw
      }
   }
}