# Allan McAleavy network stats script.
# October 27th 2017
#
"{0,-30}{1,-30}{2,-30}{3,-30}" -f "Date Time","Name","Read MB/sec","Write MB/sec"
while($true)
{


$Start = Get-NetAdapterStatistics -Name "Eth*"
sleep -Seconds 1
$Next=Get-NetAdapterStatistics -Name "Eth*"
For( $i = 0 ; $i -lt $Start.Count; $i++)
{
$interface = $Start[$i].Name
[int]$interface_rxb = ($Next[$i].ReceivedBytes - $Start[$i].ReceivedBytes) / 1048576
[int]$interface_txb = ($Next[$i].SentBytes - $Start[$i].SentBytes) / 1048576
"{0,-30}{1,-30}{2,-30}{3,-30}" -f` (Get-Date),$interface , $interface_rxb , $interface_txb
}
}
