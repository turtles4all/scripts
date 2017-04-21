
Compare-Object -ReferenceObject (Get-Content $file1) -DifferenceObject (Get-Content $file2) -IncludeEqual