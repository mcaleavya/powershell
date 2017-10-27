# Allan McAleavy iostat type function Powershell.
"{0,-30}{1,-15}{2,-15}{3,-15}{4,-15}{5,-15}{6,-15}{7,-10}{8,-3}" -f "Date","Reads", "Writes","ReadMb", "WriteMb" , "Read ms", "Write ms","Queue" ,"Split IOs"
$qlen=0
$spio=0
while($true)
{

$t2=Measure-Command{$query2 = "Select * 
                               from Win32_PerfRawData_PerfDisk_PhysicalDisk Where Name = '0 C:'"}
$p=Get-WmiObject -Query $query2

$duration = 1000 - $t2.Milliseconds
#sleep -Milliseconds $duration
sleep -Seconds 1

# get next data
$c=Get-WmiObject -Query $query2

$nettime = ($c.Timestamp_PerfTime - $p.Timestamp_PerfTime)/($c.Frequency_PerfTime)
$tm =   ($c.Timestamp_Sys100NS  - $p.Timestamp_Sys100NS) * 1e-7
$avrm = $c.AvgDisksecPerRead   - $p.AvgDisksecPerRead 
$avwm = $c.AvgDisksecPerWrite  - $p.AvgDisksecPerWrite


$avrm =  (($c.AvgDisksecPerRead    - $p.AvgDisksecPerRead )  / $nettime) /10000  #/  ( $c.Timestamp_Sys100NS   - $p.Timestamp_Sys100NS )
$avwm =  (($c.AvgDisksecPerWrite   - $p.AvgDisksecPerWrite ) / $nettime) /10000  #/  ( $c.Timestamp_Sys100NS   - $p.Timestamp_Sys100NS)

$dwr  = $c.DiskWritesPerSec     - $p.DiskWritesPerSec
$drr  = $c.DiskReadsPerSec      - $p.DiskReadsPerSec

$dwb  = $c.DiskWriteBytesPerSec - $p.DiskWriteBytesPerSec
$drb  = $c.DiskReadBytesPerSec  - $p.DiskReadBytesPerSec
$dwb  = $dwb /1048576
$drb  = $drb /1048576

if ($c.CurrentDiskQueueLength - $p.CurrentDiskQueueLength -gt 0 ) 
{ 
    $qlen = $c.CurrentDiskQueueLength - $p.CurrentDiskQueueLength
}

if ($c.SplitIOPerSec - $p.SplitIOPerSec -gt 0 ) 
{ 
    $spio = $c.SplitIOPerSec - $p.SplitIOPerSec
}


"{0,-30}{1,-15}{2,-15}{3,-15:f2}{4,-15:f2}{5,-15:f6}{6,-15:f6}{7,-10}{8,-3}" -f` (Get-Date),$drr,$dwr,$drb,
                                                                                               $dwb,($avrm/1000),
                                                                                                 ($avwm/1000),$qlen,$spio

$dwr=0
$drr=0 
$dwb=0
$drb=0
$avrm=0
$avwm=0
$qlen=0
$spio=0
} 
