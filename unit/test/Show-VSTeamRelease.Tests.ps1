Set-StrictMode -Version Latest

Describe 'VSTeamRelease' {
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
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { $Service -eq 'Release' }

      Mock Show-Browser
   }

   Context 'Show-VSTeamRelease' {
      it 'by Id should show release' {
         ## Act
         Show-VSTeamRelease -projectName project -Id 15

         ## Assert
         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_release?releaseId=15'
         }
      }

      ## Act / Assert
      it 'with invalid Id should throw' {
         { Show-VSTeamRelease -projectName project -Id 0 } | Should -Throw
      }
   }
}