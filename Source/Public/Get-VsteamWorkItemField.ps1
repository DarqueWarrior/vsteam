function Get-VsteamWorkItemField {
   [CmdletBinding()]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true, Position=0)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      $WorkItemType
   )
   process {
      #no expand option, so have to call once to get the URL, and once to get the fields
      $wit = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType
      $url = $wit.url +"/fields?api-version=" + (_getApiVersion Processes)
      
      # Call the REST API
      $resp = _callAPI -Url $url | Select-Object -ExpandProperty value
      foreach ($r in $resp) {
         $r.psobject.TypeNames.Insert(0,'vsteam_lib.WorkitemField')
         Add-Member -InputObject $r -MemberType AliasProperty -Name WorkItemType    -Value $WorkItemType
         Add-Member -InputObject $r -MemberType NoteProperty  -Name ProcessTemplate -Value $ProcessTemplate
      }

      return $resp
   }
}
