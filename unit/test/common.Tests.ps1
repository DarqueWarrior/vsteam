#Set-StrictMode -Version Latest

InModuleScope VSTeam {
   Describe 'Common' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      Context '_convertSecureStringTo_PlainText' {
         $emptySecureString = ConvertTo-SecureString 'Test String' -AsPlainText -Force

         $actual = _convertSecureStringTo_PlainText -SecureString $emptySecureString

         It 'Should return plain text' {
            $actual | Should Be 'Test String'
         }
      }

      Context '_buildProjectNameDynamicParam set Alias' {
         Mock _getProjects

         $actual = _buildProjectNameDynamicParam -AliasName TestAlias

         It 'Should set the alias of dynamic parameter' {
            $actual["ProjectName"].Attributes[1].AliasNames | Should Be 'TestAlias'
         }
      }

      Context '_getUserAgent on Mac' {
         Mock Get-OperatingSystem { return 'macOS' }
         [VSTeamVersions]::ModuleVersion = '0.0.0'

         $actual = _getUserAgent

         It 'Should return User Agent for macOS' {
            $actual | Should BeLike '*macOS*'
         }

         It 'Should return User Agent for Module Version' {
            $actual | Should BeLike '*0.0.0*'
         }

         It 'Should return User Agent for PowerShell Version' {
            $actual | Should BeLike "*$($PSVersionTable.PSVersion.ToString())*"
         }
      }

      Context '_getUserAgent on Linux' {
         Mock Get-OperatingSystem { return 'Linux' }
         [VSTeamVersions]::ModuleVersion = '0.0.0'

         $actual = _getUserAgent

         It 'Should return User Agent for Linux' {
            $actual | Should BeLike '*Linux*'
         }

         It 'Should return User Agent for Module Version' {
            $actual | Should BeLike '*0.0.0*'
         }

         It 'Should return User Agent for PowerShell Version' {
            $actual | Should BeLike "*$($PSVersionTable.PSVersion.ToString())*"
         }
      }

      Context '_buildProjectNameDynamicParam' {
         Mock _getProjects { return  ConvertFrom-Json '["Demo", "Universal"]' }

         It 'should return dynamic parameter' {
            _buildProjectNameDynamicParam | Should Not BeNullOrEmpty
         }
      }

      Context '_getWorkItemTypes' {
         [VSTeamVersions]::Account = $null

         It 'should return empty array' {
            _getWorkItemTypes -ProjectName test | Should be @()
         }
      }

      Context '_handleException' {
         # Build a proper error 
         $obj = "{Value: {Message: 'Top Message'}, Exception: {Message: 'Test Exception', Response: { StatusCode: '401'}}}"
         
         if ($PSVersionTable.PSEdition -ne 'Core') {
            $r = [System.Net.HttpWebResponse]::new()
            $e = [System.Net.WebException]::new("Test Exception", $null, [System.Net.WebExceptionStatus]::ProtocolError, $r)
         }
         else {
            $r = [System.Net.Http.HttpResponseMessage]::new([System.Net.HttpStatusCode]::Unauthorized)
            $e = [Microsoft.PowerShell.Commands.HttpResponseException]::new("Test Exception", $r)
         }
         $ex = Write-Error -Exception $e 2>&1 -ErrorAction Continue
         $ex.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($obj)

         It 'Should Write two warnings' {
            Mock Write-Warning -ParameterFilter { $Message -eq 'An error occurred: Test Exception'} -Verifiable
            Mock Write-Warning -ParameterFilter { $Message -eq 'Top Message' } -Verifiable

            _handleException $ex

            Assert-VerifiableMock
         }
      }

      Context '_handleException should re-throw' {
         $e = [System.Management.Automation.RuntimeException]::new('You must call Set-VSTeamAccount before calling any other functions in this module.')
         $ex = Write-Error -Exception $e 2>&1 -ErrorAction Continue

         It 'Should throw' {

            { _handleException $ex } | Should Throw
         }
      }

      Context '_handleException message only' {
         # Build a proper error 
         $obj = "{Value: {Message: 'Test Exception'}, Exception: {Message: 'Test Exception', Response: { StatusCode: '400'}}}"
         
         if ($PSVersionTable.PSEdition -ne 'Core') {
            $e = [System.Net.WebException]::new("Test Exception", $null)
         }
         else {
            $r = [System.Net.Http.HttpResponseMessage]::new([System.Net.HttpStatusCode]::BadRequest)
            $e = [Microsoft.PowerShell.Commands.HttpResponseException]::new("Test Exception", $r)
         }
         
         $ex = Write-Error -Exception $e 2>&1 -ErrorAction Continue
         $ex.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($obj)

         It 'Should Write one warnings' {
            Mock Write-Warning -ParameterFilter { $Message -eq 'Test Exception' } -Verifiable

            _handleException $ex

            Assert-VerifiableMock
         }
      }

      Context '_isVSTS' {
         It '.visualstudio.com should return true' {
            _isVSTS 'https://dev.azure.com/test' | Should Be $true
         }

         It '.visualstudio.com with / should return true' {
            _isVSTS 'https://dev.azure.com/test/' | Should Be $true
         }

         It 'https://dev.azure.com should return true' {
            _isVSTS 'https://dev.azure.com/test' | Should Be $true
         }

         It 'https://dev.azure.com with / should return true' {
            _isVSTS 'https://dev.azure.com/test/' | Should Be $true
         }

         It 'should return false' {
            _isVSTS 'http://localhost:8080/tfs/defaultcollection' | Should Be $false
         }
      }
   }
}