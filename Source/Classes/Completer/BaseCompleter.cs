﻿using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using System.Management.Automation.Language;
using System.Runtime.CompilerServices;

[assembly: InternalsVisibleTo("vsteam-lib.Test")]

namespace vsteam_lib
{
    public abstract class BaseCompleter : IArgumentCompleter
    {
        protected readonly IPowerShell _powerShell;

        /// <summary>
        /// This constructor is used during unit testings
        /// </summary>
        /// <param name="powerShell">fake instance of IPowerShell used for testing</param>
        protected BaseCompleter(IPowerShell powerShell) { this._powerShell = powerShell; }

        /// <summary>
        /// This constructor is used when running in a PowerShell session. It cannot be
        /// loaded in a unit test.
        /// </summary>
        [ExcludeFromCodeCoverage]
        protected BaseCompleter() : this(new PowerShellWrapper(RunspaceMode.CurrentRunspace)) { }

        public abstract IEnumerable<CompletionResult> CompleteArgument(string commandName,
                                                                       string parameterName,
                                                                       string wordToComplete,
                                                                       CommandAst commandAst,
                                                                       IDictionary fakeBoundParameters);

        protected static void SelectValues(string wordToComplete, IEnumerable<string> words, List<CompletionResult> values)
        {
            foreach (var word in words)
            {
                if (string.IsNullOrEmpty(wordToComplete) || word.StartsWith(wordToComplete, true, CultureInfo.InvariantCulture))
                {
                    values.Add(GetCompletionResult(word));
                }
            }
        }


        private static CompletionResult GetCompletionResult(string word)
        {
            return GetCompletionResult(word,word,CompletionResultType.Text);
        }

        private static CompletionResult GetCompletionResult(string word, string wordLabel, CompletionResultType resultType)
        {
            // Only wrap in single quotes if they have a space. This makes it easier
            // to use on macOs
            return (new CompletionResult(word.Contains(" ") ? $"'{word}'" : word, wordLabel, resultType, wordLabel + ": " + word));

        }

        protected static void SelectValues(string wordToComplete,
                                            Dictionary<string, string> words,
                                            List<CompletionResult> values)
        {
            foreach (var word in words)
            {
                var keyToSearch = word.Key.ToLower();
                var valueToSearch = word.Value.ToLower();

                if (string.IsNullOrEmpty(wordToComplete) ||
                    keyToSearch.Contains(wordToComplete) ||
                    valueToSearch.Contains(wordToComplete)
                    )
                {
                    values.Add(GetCompletionResult(word.Key, word.Value, CompletionResultType.Text));
                }
            }
        }
    }
}
