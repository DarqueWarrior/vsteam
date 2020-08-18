﻿using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class TeamTests
   {
      [TestMethod]
      public void Constructor()
      {
         // Arrange
         var obj = BaseTests.LoadJson("./SampleFiles/Get-VSTeam.json");

         // Act
         var actual = new Team(obj[0], "ProjectName");

         // Assert
         Assert.AreEqual("The default project team.", actual.Description, "Description");
      }
   }
}
