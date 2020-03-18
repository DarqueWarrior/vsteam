Set-StrictMode -Version Latest
$env:Testing=$true
# The InModuleScope command allows you to perform white-box unit testing on the
# internal \(non-exported\) code of a Script Module, ensuring the module is loaded.
InModuleScope VSTeam {
   Describe 'Invoke-VSTeamRequest' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod {
         return @()
      } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      Mock Write-Host

      Context 'Invoke-VSTeamRequest Options' {
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
         Mock Invoke-RestMethod {
            # Write-Host $args
         }

         Invoke-VSTeamRequest -Method Options

         It 'Should call API' {
            Assert-VerifiableMock
         }
      }

      Context 'Invoke-VSTeamRequest Release' {
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
         Mock Invoke-RestMethod {
            # Write-Host $args
         } -Verifiable

         Invoke-VSTeamRequest -Area release -Resource releases -Id 1 -SubDomain vsrm -Version '4.1-preview' -ProjectName testproject -JSON

         It 'Should call API' {
            Assert-VerifiableMock
         }
      }

      Context 'Invoke-VSTeamRequest AdditionalHeaders' {
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
         Mock Invoke-RestMethod { return @() } -Verifiable -ParameterFilter {
            $Headers["Test"] -eq 'Test'
         }

         Invoke-VSTeamRequest -Area release -Resource releases -Id 1 -SubDomain vsrm -Version '4.1-preview' -ProjectName testproject -JSON -AdditionalHeaders @{Test = "Test" }

         It 'Should call API' {
            Assert-VerifiableMock
         }
      }

      Context 'Invoke-VSTeamRequest By Product ID' {
         # Called to convert from ProjectName to ProjectID
         Mock Get-VSTeamProject {
            return [PSCustomObject]@{
               id = '00000000-0000-0000-0000-000000000000'
            } } -Verifiable
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
         Mock Invoke-RestMethod { return @() } -Verifiable -ParameterFilter {
            $Uri -like "*https://vsrm.dev.azure.com/test/00000000-0000-0000-0000-000000000000*"
         }

         Invoke-VSTeamRequest -ProjectName testproject -UseProjectId -Area release -Resource releases -Id 1 -SubDomain vsrm -Version '4.1-preview'

         It 'Should call API' {
            Assert-VerifiableMock
         }
      }
   }
}