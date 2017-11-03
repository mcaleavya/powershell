# Allan McAleavy network stats script.
# Added in TCP counts.
# set execute policy for my user - damb powerhell..

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
"{0,-30}{1,-20}{2,-20}{3,-20}{4,-12}{5,-10}{6,-10}{7,-10}{8,-10}{9,-10}{10,-10}{11,-11}{12,-10}{13,-11}" -f "Date Time","Name","Read MB/sec","Write MB/sec","Esablished ","Listen ","TimeWait ","CloseWait","Bound","Total","Out Err","Recv Err","Out Disc","In Disc"
while($true)
{


$Start = Get-NetAdapterStatistics -Name "Eth*"
sleep -Seconds 1
$Next=Get-NetAdapterStatistics -Name "Eth*"
$conns=Get-NetTCPConnection
$lsn=0;
$est=0;
$tw=0;
$cw=0;
$bnd=0;
$oerr=0;
$rerr=0;
$odisc=0;
$idisc=0;
For( $i = 0 ; $i -lt $Start.Count; $i++) 
{
$interface = $Start[$i].Name 
[int]$interface_rxb = ($Next[$i].ReceivedBytes - $Start[$i].ReceivedBytes) / 1048576
[int]$interface_txb = ($Next[$i].SentBytes - $Start[$i].SentBytes) / 1048576
$oerr += $Start[$i].OutboundPacketErrors
$rerr += $Start[$i].ReceivedPacketErrors
$odisc += $Start[$i].OutboundDiscardedPackets
$idisc += $Start[$i].ReceivedDiscardedPackets
}

For( $i = 0 ; $i -lt $conns.Count; $i++) 
{
if ( $conns[$i].State -Contains "Listen") { $lsn++;}
if ( $conns[$i].State -Contains "Established") { $est++;}
if ( $conns[$i].State -Contains "TimeWait") { $tw++;}
if ( $conns[$i].State -Contains "CloseWait") { $cw++;}
if ( $conns[$i].State -Contains "Bound") { $bnd++;}

$tot=($est+$lsn+$tw+$cw+$bnd)
}
"{0,-30}{1,-20}{2,-20}{3,-20}{4,-12}{5,-10}{6,-10}{7,-10}{8,-10}{9,-10}{10,-10}{11,-11}{12,-10}{13,-11}" -f` (Get-Date),$interface , $interface_rxb , $interface_txb,$est,$lsn,$tw,$cw,$bnd,$tot,$oerr,$rerr,$odisc,$idisc
$lsn=0;
$est=0;
$tw=0;
$cw=0;
$bnd=0;
$oerr=0;
$rerr=0;
$odisc=0;
$idisc=0;
} 
