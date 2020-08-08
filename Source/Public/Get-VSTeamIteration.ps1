function Get-VSTeamIteration {
   [CmdletBinding(DefaultParameterSetName = 'ByIds')]
   param(
      [Parameter(Mandatory = $false, ParameterSetName = "ByPath")]
      [string] $Path,

      [Parameter(Mandatory = $false, ParameterSetName = "ByIds")]
      [int[]] $Ids,

      [Parameter(Mandatory = $false, ParameterSetName = "ByPath")]
      [Parameter(Mandatory = $false, ParameterSetName = "ByIds")]
      [int] $Depth,
      
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      if ($PSCmdlet.ParameterSetName -eq "ByPath") {
         $resp = Get-VSTeamClassificationNode -StructureGroup "iterations" -ProjectName $ProjectName -Path $Path -Depth $Depth
      }else {
         $resp = Get-VSTeamClassificationNode -ProjectName $ProjectName -Depth $Depth -Ids $Ids
      }
      Write-Output $resp
   }
}