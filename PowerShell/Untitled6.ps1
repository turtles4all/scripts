Clear-Host
$file = "c:\users\Adkins\Desktop\file.txt"
echo "" > $file
Get-Random -InputObject $(Get-Service) –Count 10 | ForEach-Object {
    echo "---------Description---------"$_.DisplayName"---------------------------" >> $file
    echo "What does this service do? What does it provide to the system? IPsec $" >> $file
    echo "When does this service get launched?" >> $file
    echo "What applications or other services may need this service? Why?" >> $file
    echo "What are the security implications of this service? How can it be used for malicious purposes or indicate security issues with the system?" >> $file
    sc.exe qc $_.Name >> $file
                                                                         }
#Get-Random -InputObject $(Get-Service) –Count 10 | ForEach-Object { sc.exe query $_.Name }

Function boottype($i){
    switch($i){
       1 { Return "Automatic" }
       2 { Return "Manual" }
       3 { Return "Disabled" }
       4 { Return "Automatic (Delayed Start)"}
       }
}