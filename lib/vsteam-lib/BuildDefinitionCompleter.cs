﻿using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation.Abstractions;

namespace vsteam_lib
{
   public class BuildDefinitionCompleter : BaseProjectCompleter
   {
      /// <summary>
      /// This constructor is used when running in a PowerShell session. It cannot be
      /// loaded in a unit test.
      /// </summary>
      [ExcludeFromCodeCoverage]
      public BuildDefinitionCompleter() : base() { }

      /// <summary>
      /// This constructor is used during unit testings
      /// </summary>
      /// <param name="powerShell">fake instance of IPowerShell used for testing</param>
      internal BuildDefinitionCompleter(IPowerShell powerShell) : base(powerShell) { }

      internal override IEnumerable<string> GetValues(string projectName)
      {
         this._powerShell.Commands.Clear();

         var results = this._powerShell.AddCommand("Get-VSTeamBuildDefinition")
                                       .AddParameter("ProjectName", projectName)
                                       .AddCommand("Select-Object")
                                       .AddParameter("ExpandProperty", "Name")
                                       .AddParameter("Unique")
                                       .AddCommand("Sort-Object")
                                       .Invoke<string>();

         PowerShellWrapper.LogPowerShellError(this._powerShell, results);

         return results;
      }
   }
}