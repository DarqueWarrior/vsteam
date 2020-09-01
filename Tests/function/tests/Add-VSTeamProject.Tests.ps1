Set-StrictMode -Version Latest

Describe 'VSTeamProject' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      . "$baseFolder/Source/Classes/VSTeamLeaf.ps1"
      . "$baseFolder/Source/Classes/VSTeamDirectory.ps1"      
      . "$baseFolder/Source/Classes/VSTeamProcess.ps1"
      . "$baseFolder/Source/Classes/VSTeamTask.ps1"
      . "$baseFolder/Source/Classes/VSTeamAttempt.ps1"
      . "$baseFolder/Source/Classes/VSTeamEnvironment.ps1"
      . "$baseFolder/Source/Private/applyTypes.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamQueue.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"
      . "$baseFolder/Source/Public/Remove-VSTeamAccount.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamProcess.ps1"

      $singleResult = [PSCustomObject]@{
         name        = 'Test'
         description = ''
         url         = ''
         id          = '123-5464-dee43'
         state       = ''
         visibility  = ''
         revision    = [long]0
         defaultTeam = [PSCustomObject]@{ }
         _links      = [PSCustomObject]@{ }
      }

      Mock Start-Sleep

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' }
      Mock _callApi -ParameterFilter { $area -eq 'work' -and $resource -eq 'processes' } -MockWith {
         return [PSCustomObject]@{value = @(
               [PSCustomObject]@{
                  name   = 'Agile'
                  Typeid = '00000000-0000-0000-0000-000000000001'
               },
               [PSCustomObject]@{
                  name   = 'CMMI'
                  Typeid = '00000000-0000-0000-0000-000000000002'
               },
               [PSCustomObject]@{
                  name   = 'Scrum'
                  Typeid = '00000000-0000-0000-0000-000000000003'
               }
            )
         }
      }

      # Get-VSTeamProject for cache 
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*`$top=100*" -and
         $Uri -like "*stateFilter=WellFormed*"
      }
   }

   Context 'Add-VSTeamProject' {
      BeforeAll {
         Mock Write-Progress

         # Add Project
         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = '123-5464-dee43'; url = 'https://someplace.com' } } -ParameterFilter {
            $Method -eq 'POST' -and
            $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)"
         }

         # Track Progress
         Mock Invoke-RestMethod {            
            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($i -gt 9) {
               return @{status = 'succeeded' }
            }

            return @{status = 'inProgress' }
         } -ParameterFilter {
            $Uri -eq 'https://someplace.com'
         }

         # Get-VSTeamProject to return project after creation
         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)"
         }
      }

      It 'with tfvc should create project with tfvc' {
         Add-VSTeamProject -Name Test -tfvc

         Should -Invoke Invoke-RestMethod -Times 1 -Scope It  -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)"
         }

         Should -Invoke Invoke-RestMethod -Times 1 -Scope It  -ParameterFilter {
            $Method -eq 'Post' -and
            $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" -and
            $Body -like '*"name":*"Test"*' -and
            $Body -like '*"templateTypeId":*6b724908-ef14-45cf-84f8-768b5384da45*' -and
            $Body -like '*"sourceControlType":*"Tfvc"*'
         }
      }
   }

   Context 'Add-VSTeamProject with Agile' {
      BeforeAll {
         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com' } } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
         Mock _trackProjectProgress
         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
      }

      It 'Should create project with Agile' {
         Add-VSTeamProject -ProjectName Test -processTemplate Agile

         Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
      }
   }

   Context 'Add-VSTeamProject with CMMI' {
      BeforeAll {
         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com' } } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
         Mock _trackProjectProgress
         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         Mock Get-VSTeamProcess { return [PSCustomObject]@{
               name   = 'CMMI'
               id     = 1
               Typeid = '00000000-0000-0000-0000-000000000002'
            }
         }
      }

      It 'Should create project with CMMI' {
         Add-VSTeamProject -ProjectName Test -processTemplate CMMI

         Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
      }
   }

   Context 'Add-VSTeamProject throws error' {
      BeforeAll {
         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com' } } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
         Mock Write-Error
         Mock _trackProjectProgress { throw 'Test error' }
         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
      }

      It '_trackProjectProgress errors should throw' {
         { Add-VSTeamProject -projectName Test -processTemplate CMMI } | Should -Throw
      }
   }
}