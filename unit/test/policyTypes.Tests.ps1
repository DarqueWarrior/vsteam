Set-StrictMode -Version Latest
$env:Testing=$true
# The InModuleScope command allows you to perform white-box unit testing on the
# internal \(non-exported\) code of a Script Module, ensuring the module is loaded.
InModuleScope VSTeam {
   Describe "Policies VSTS" {
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

      $results = [PSCustomObject]@{
         value = [PSCustomObject]@{ }
      }

      $singleResult = [PSCustomObject]@{ }

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      Context 'Get-VSTeamPolicyType by project' {
         Mock Invoke-RestMethod { return $results } -Verifiable

         Get-VSTeamPolicyType -ProjectName Demo

         It 'Should return policies' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/Demo/_apis/policy/types?api-version=$([VSTeamVersions]::Core)"
            }
         }
      }

      Context 'Get-VSTeamPolicyType by project throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Get-VSTeamPolicyType -ProjectName Demo } | Should Throw
         }
      }

      Context 'Get-VSTeamPolicyType by id' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamPolicyType -ProjectName Demo -id 90a51335-0c53-4a5f-b6ce-d9aff3ea60e0

         It 'Should return policies' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/Demo/_apis/policy/types/90a51335-0c53-4a5f-b6ce-d9aff3ea60e0?api-version=$([VSTeamVersions]::Core)"
            }
         }
      }

      Context 'Get-VSTeamPolicyType by id throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should return policies' {
            { Get-VSTeamPolicyType -ProjectName Demo -id 90a51335-0c53-4a5f-b6ce-d9aff3ea60e0 } | Should Throw
         }
      }
   }
}