function Update-VSTeam {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
      [Alias('TeamName', 'TeamId', 'TeamToUpdate', 'Id')]
      [string]$Name,

      [string]$NewTeamName,

      [string]$Description,

      [switch] $Force,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      if (-not $NewTeamName -and -not $Description) {
         throw 'You must provide a new team name or description, or both.'
      }

      if ($Force -or $pscmdlet.ShouldProcess($Name, "Update-VSTeam")) {
         if (-not $NewTeamName) {
            $body = '{"description": "' + $Description + '" }'
         }

         if (-not $Description) {
            $body = '{ "name": "' + $NewTeamName + '" }'
         }

         if ($NewTeamName -and $Description) {
            $body = '{ "name": "' + $NewTeamName + '", "description": "' + $Description + '" }'
         }

         # Call the REST API
         $resp = _callAPI -Method PATCH `
            -Resource "projects/$ProjectName/teams" `
            -Id $Name `
            -Body $body `
            -Version $(_getApiVersion Core)

         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $team = [vsteam_lib.Team]::new($resp, $ProjectName)

         Write-Output $team
      }
   }
}
