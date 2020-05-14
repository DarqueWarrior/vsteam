using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation

class UncachedProjectCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName,
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst,
      [IDictionary] $FakeBoundParameters) {

      $results = [List[CompletionResult]]::new()

      [VSTeamProjectCache]::update()

      foreach ($p in [VSTeamProjectCache]::GetCurrent() ) {
         if ($p -like "*$WordToComplete*" -and $p -notmatch "\W") {
            $results.Add([CompletionResult]::new($p))
         }
         elseif ($p -like "*$WordToComplete*") {
            $results.Add([CompletionResult]::new("'$($p.replace("'","''"))'", $p, 0, $p))
         }
      }
      return $results
   }
}