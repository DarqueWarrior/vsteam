﻿using NSubstitute;
using NSubstitute.Extensions;
using System.Management.Automation;
using System.Management.Automation.Abstractions;

namespace vsteam_lib.Test
{
   internal class BaseTests
   {
      internal static IPowerShell PrepPowerShell()
      {
         var ps = Substitute.For<IPowerShell>();
         ps.ReturnsForAll(ps);
         ps.Commands.Returns(new PSCommand());
         return ps;
      }
   }
}
