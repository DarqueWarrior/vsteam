Set-StrictMode -Version Latest

Describe 'Remove-VSTeamBuildDefinition' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      $resultsVSTS = Get-Content "$sampleFiles\buildDefvsts.json" -Raw | ConvertFrom-Json

      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
   }

   Context 'Succeeds' {
      BeforeAll {
         Mock Invoke-RestMethod { return $resultsVSTS }
      }

      It 'should delete build definition' {
         Remove-VSTeamBuildDefinition -projectName project -id 2 -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Delete' -and
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/2?api-version=$(_getApiVersion Build)"
         }
      }
   }

   Context 'Succeeds on TFS local Auth' {
      BeforeAll {
         Mock Invoke-RestMethod { return $resultsVSTS }
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

         Remove-VSTeamBuildDefinition -projectName project -id 2 -Force
      }

      It 'should delete build definition' {
         Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
            $Method -eq 'Delete' -and
            $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions/2?api-version=$(_getApiVersion Build)"
         }
      }
   }
}