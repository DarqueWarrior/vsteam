#
# Module manifest for module 'vsteam'
#
# Generated by: @DonovanBrown
#
# Generated on: 11/25/2016
#
# .ExternalHelp vsTeam-Help.xml

@{

   # Script module or binary module file associated with this manifest.
   RootModule        = ''

   # Version number of this module.
   ModuleVersion     = '4.0.7'

   # Supported PSEditions
   # CompatiblePSEditions = @()

   # ID used to uniquely identify this module
   GUID              = '210e95b1-50bb-44da-a993-f567f4574214'

   # Author of this module
   Author            = '@DonovanBrown'

   # Company or vendor of this module
   CompanyName       = ''

   # Copyright statement for this module
   Copyright         = '(c) 2016 Donovan Brown. All rights reserved.'

   # Description of the functionality provided by this module
   Description       = 'Adds functionality for working with Visual Studio Team Services and Team Foundation Server.'

   # Minimum version of the Windows PowerShell engine required by this module
   # PowerShellVersion = ''

   # Name of the Windows PowerShell host required by this module
   # PowerShellHostName = ''

   # Minimum version of the Windows PowerShell host required by this module
   # PowerShellHostVersion = ''

   # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
   # DotNetFrameworkVersion = ''

   # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
   # CLRVersion = ''

   # Processor architecture (None, X86, Amd64) required by this module
   # ProcessorArchitecture = ''

   # Modules that must be imported into the global environment prior to importing this module
   RequiredModules   = @('SHiPS', 'Trackyon.Utils')

   # Assemblies that must be loaded prior to importing this module
   # RequiredAssemblies = @()

   # Script files (.ps1) that are run in the caller's environment prior to importing this module.
   ScriptsToProcess = @('src\teamspsdrive.ps1')

   # Type files (.ps1xml) to be loaded when importing this module
   TypesToProcess    = @('types\Approvals.ps1xml',
      'types\builds.ps1xml',
      'types\cloudSubscriptions.ps1xml',
      'types\repositories.ps1xml',
      'types\policies.ps1xml',
      'types\releaseDefinitions.ps1xml',
      'types\releases.ps1xml',
      'types\serviceendpoints.ps1xml',
      'types\team.ps1xml',
      'types\teammembers.ps1xml',
      'types\teams.ps1xml',
      'types\tfvc.ps1xml',
      'types\users.ps1xml',
      'types\workitems.ps1xml')

   # Format files (.ps1xml) to be loaded when importing this module
   FormatsToProcess  = @('formats\Approvals.format.ps1xml',
      'formats\builds.format.ps1xml',
      'formats\policyTypes.format.ps1xml',
      'formats\profile.format.ps1xml',
      'formats\serviceendpoints.format.ps1xml',
      'formats\serviceendpointTypes.format.ps1xml',
      'formats\team.format.ps1xml',
      'formats\users.format.ps1xml',
      'formats\workitemTypes.format.ps1xml',
      'formats\workitems.format.ps1xml',
      'formats\vsteamPSDrive.format.ps1xml')

   # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
   NestedModules     = @('src\team.psm1',
      'src\refs.psm1',
      'src\repositories.psm1',
      'src\agents.psm1',
      'src\Approvals.psm1',
      'src\buildDefinitions.psm1',
      'src\builds.psm1',
      'src\cloudSubscriptions.psm1',
      'src\policies.psm1',
      'src\policyTypes.psm1'
      'src\pools.psm1',
      'src\projects.psm1',
      'src\queues.psm1',
      'src\releaseDefinitions.psm1',
      'src\releases.psm1',
      'src\serviceendpoints.psm1',
      'src\serviceendpointTypes.psm1',
      'src\teams.psm1',
      'src\profile.psm1',
      'src\teammembers.psm1',
      'src\tfvc.psm1',
      'src\users.psm1',
      'src\workitemTypes.psm1',
      'src\workitems.psm1',
      '.\src\feeds.psm1')

   # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
   FunctionsToExport = @('Add-VSTeamAzureRMServiceEndpoint',
      'Add-VSTeamSonarQubeEndpoint',
      'Add-VSTeamKubernetesEndpoint',
      'Add-VSTeamServiceFabricEndpoint',
      'Add-VSTeamServiceEndpoint',
      'Update-VSTeamServiceEndpoint',
      'Add-VSTeamBuild',
      'Add-VSTeamBuildDefinition',
      'Add-VSTeamProject',
      'Add-VSTeamRelease',
      'Add-VSTeamReleaseDefinition',
      'Add-VSTeamAccount',
      'Add-VSTeam',
      'Add-VSTeamPolicy',
      'Clear-VSTeamDefaultProject',
      'Get-VSTeamApproval',
      'Get-VSTeamBuild',
      'Get-VSTeamBuildDefinition',
      'Get-VSTeamCloudSubscription',
      'Get-VSTeamPolicy',
      'Get-VSTeamPolicyType',
      'Get-VSTeamPool',
      'Get-VSTeamProject',
      'Get-VSTeamQueue',
      'Get-VSTeamRelease',
      'Get-VSTeamReleaseDefinition',
      'Get-VSTeamServiceEndpoint',
      'Get-VSTeamInfo',
      'Get-VSTeam',
      'Get-VSTeamMember',
      'Update-VSTeamPolicy',
      'Remove-VSTeamBuild',
      'Remove-VSTeamBuildDefinition',
      'Remove-VSTeamProject',
      'Remove-VSTeamRelease',
      'Remove-VSTeamReleaseDefinition',
      'Remove-VSTeamServiceEndpoint',
      'Remove-VSTeamAccount',
      'Remove-VSTeam',
      'Remove-VSTeamPolicy',
      'Set-VSTeamApproval',
      'Set-VSTeamDefaultProject',
      'Set-VSTeamReleaseStatus',
      'Update-VSTeamProject',
      'Update-VSTeam',
      'Get-VSTeamGitRepository',
      'Add-VSTeamGitRepository',
      'Remove-VSTeamGitRepository',
      'Get-VSTeamBuildLog',
      'Add-VSTeamBuildTag',
      'Get-VSTeamBuildTag',
      'Remove-VSTeamBuildTag',
      'Get-VSTeamBuildArtifact',
      'Update-VSTeamBuild',
      'Get-VSTeamOption',
      'Get-VSTeamResourceArea',
      'Show-VSTeamProject',
      'Show-VSTeamBuildDefinition',
      'Show-VSTeamApproval',
      'Show-VSTeamBuild',
      'Show-VSTeamGitRepository',
      'Show-VSTeamReleaseDefinition',
      'Show-VSTeamRelease',
      'Show-VSTeam',
      'Add-VSTeamProfile',
      'Remove-VSTeamProfile',
      'Get-VSTeamProfile',
      'Set-VSTeamAPIVersion',
      'Invoke-VSTeamRequest',
      'Get-VSTeamUser',
      'Remove-VSTeamUser',
      'Add-VSTeamUser',
      'Update-VSTeamUser',
      'Set-VSTeamEnvironmentStatus',
      'Get-VSTeamServiceEndpointType',
      'Update-VSTeamBuildDefinition',
      'Get-VSTeamTfvcRootBranch',
      'Get-VSTeamTfvcBranch',
      'Get-VSTeamWorkItemType',
      'Add-VSTeamWorkItem',
      'Get-VSTeamWorkItem',
      'Show-VSTeamWorkItem',
      'Get-VSTeamGitRef',
      'Get-VSTeamAgent',
      'Remove-VSTeamAgent',
      'Enable-VSTeamAgent',
      'Disable-VSTeamAgent',
      'Update-VSTeamProfile',
      'Get-VSTeamAPIVersion',
      'Add-VSTeamNuGetEndpoint',
      'Get-VSTeamFeed',
      'Add-VSTeamFeed',
      'Show-VSTeamFeed',
      'Remove-VSTeamFeed')

   # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
   # CmdletsToExport = @()

   # Variables to export from this module
   # VariablesToExport = ''

   # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
   AliasesToExport   = @('Get-ServiceEndpoint',
      'Add-AzureRMServiceEndpoint',
      'Remove-ServiceEndpoint',
      'Add-SonarQubeEndpoint',
      'Add-KubernetesEndpoint',
      'Add-ServiceEndpoint',
      'Update-ServiceEndpoint',
      'Add-ServiceFabricEndpoint',
      'Remove-ServiceFabricEndpoint',
      'Remove-VSTeamServiceFabricEndpoint',
      'Remove-VSTeamAzureRMServiceEndpoint',
      'Remove-VSTeamSonarQubeEndpoint',
      'Remove-AzureRMServiceEndpoint',
      'Remove-SonarQubeEndpoint',
      'Get-Build',
      'Show-Build',
      'Get-BuildLog',
      'Get-BuildTag',
      'Get-BuildArtifact',
      'Add-Build',
      'Add-BuildTag',
      'Remove-Build',
      'Remove-BuildTag',
      'Update-Build',
      'Get-BuildDefinition',
      'Add-BuildDefinition',
      'Show-BuildDefinition',
      'Remove-BuildDefinition',
      'Show-Approval',
      'Get-Approval',
      'Set-Approval',
      'Get-CloudSubscription',
      'Get-GitRepository',
      'Show-GitRepository',
      'Add-GitRepository',
      'Remove-GitRepository',
      'Get-Pool',
      'Get-Project',
      'Show-Project',
      'Update-Project',
      'Add-Project',
      'Remove-Project',
      'Get-Queue',
      'Get-ReleaseDefinition',
      'Show-ReleaseDefinition',
      'Add-ReleaseDefinition',
      'Remove-ReleaseDefinition',
      'Get-Release',
      'Show-Release',
      'Add-Release',
      'Remove-Release',
      'Set-ReleaseStatus',
      'Add-ReleaseEnvironment',
      'Get-TeamInfo',
      'Add-TeamAccount',
      'Remove-TeamAccount',
      'Get-TeamOption',
      'Get-TeamResourceArea',
      'Clear-DefaultProject',
      'Set-DefaultProject',
      'Get-TeamMember',
      'Get-Team',
      'Add-Team',
      'Update-Team',
      'Remove-Team',
      'Add-Profile',
      'Remove-Profile',
      'Get-Profile',
      'Set-APIVersion',
      'gti',
      'ivr',
      'Add-User',
      'Remove-User',
      'Get-User',
      'Update-User',
      'ata',
      'Set-EnvironmentStatus',
      'Add-VSTeamReleaseEnvironment',
      'Get-ServiceEndpointType',
      'Update-BuildDefinition',
      'Get-TfvcRootBranch',
      'Get-TfvcBranch',
      'Get-WorkItemType',
      'Add-WorkItem',
      'Get-WorkItem',
      'Show-WorkItem',
      'Get-Policy', 
      'Get-PolicyType', 
      'Add-Policy', 
      'Update-Policy', 
      'Remove-Policy',
      'Get-GitRef',
      'Get-Agent',
      'Remove-Agent',
      'Enable-Agent',
      'Disable-Agent',
      'Update-Profile',
      'Get-APIVersion',
      'Add-NuGetEndpoint',
      'Get-Feed',
      'Add-Feed',
      'Show-Feed',
      'Remove-Feed')

   # DSC resources to export from this module
   # DscResourcesToExport = @()

   # List of all modules packaged with this module
   # ModuleList = @()

   # List of all files packaged with this module
   # FileList = @()

   # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
   PrivateData       = @{

      PSData = @{

         # Tags applied to this module. These help with module discovery in online galleries.
         Tags                       = @('VSTS', 'TFS', 'DevOps', 'VisualStudio', 'TeamServices', 'Team')

         # If you use this you don't need SHiPS in your private repository but the user
         # has to install SHiPS manually.  If you don't add this SHiPS will be installed
         # automatically when VSTeam is installed. 
         # ExternalModuleDependencies = @('SHiPS')

         # A URL to the license for this module.
         # LicenseUri = ''

         # A URL to the main website for this project.
         ProjectUri                 = 'https://github.com/DarqueWarrior/vsteam'

         # A URL to an icon representing this module.
         # IconUri = ''

         # ReleaseNotes of this module
         # ReleaseNotes = ''

      } # End of PSData hashtable

   } # End of PrivateData hashtable

   # HelpInfo URI of this module
   # HelpInfoURI = ''

   # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
   # DefaultCommandPrefix = ''
}
