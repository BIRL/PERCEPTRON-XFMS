use strict;

my $jobID="$ARGV[0]";
my $jobDir=$ARGV[1];
my $mode=$ARGV[2];

my @Equivalences=qx(cat $jobDir/$jobID.pdb\_equivalences.txt);
#my @Equivalences=qx(cat $jobDir/$jobID\_equivalences.txt);
chomp @Equivalences;

my %EquivChains=();
my %EquivRes=();

for(my $i=0; $i<@Equivalences; $i++)
{
  my @splitted=split " ", $Equivalences[$i];
  $EquivChains{$splitted[1]}=$splitted[0];
  $EquivRes{$splitted[1]}=$splitted[2];
}

my @tertiary_frustration=qx(cat $jobDir/tertiary_frustration.dat);

open(FRUST, ">$jobDir/$jobID.pdb\_$mode");
open(FRUSTAUX, ">$jobDir/$jobID\_$mode.pdb\_auxiliar");
open(FRUSTRENUM, ">$jobDir/$jobID\_$mode\_renumbered");


if($mode eq "configurational" || $mode eq "mutational")
{
print FRUST "Res1 Res2 ChainRes1 ChainRes2 DensityRes1 DensityRes2 AA1 AA2 NativeEnergy DecoyEnergy SDEnergy FrstIndex Welltype FrstState\n";


	for(my $i=2; $i<@tertiary_frustration; $i++)
	{
	  my @splitted=split " ", $tertiary_frustration[$i];
	  my $Res1=$splitted[0];
	  my $Res2=$splitted[1];
	  my $Density1=$splitted[11];
	  my $Density2=$splitted[12];  
	  my $AA1=$splitted[13];
	  my $AA2=$splitted[14];
	  my $NativeEnergy=$splitted[15];
	  my $DecoyEnergy=$splitted[16];
	  my $SDEnergy=$splitted[17];
	  my $FrstIndex=$splitted[18];
          my $ResResDistance="";
	  my $FrstType="";
          my $FrstTypeAux="";
          #Assign well-type
          if($splitted[10]<6.5)
          {
            $ResResDistance="short";
          }
          elsif($splitted[10]>=6.5)
          {
            if($Density1 <2.6 && $Density2<2.6)
	    {
            $ResResDistance="water-mediated";
	    }
	    else
	    {
            $ResResDistance="long";
	    }
          }
          if($FrstIndex<=-1)
          {
           $FrstType="highly";
           $FrstTypeAux="red";
	  }
          if($FrstIndex>-1 && $FrstIndex<0.78)
          {
           $FrstType="neutral";
           $FrstTypeAux="gray";
	  }
          if($FrstIndex>=0.78)
          {
           $FrstType="minimally";
           $FrstTypeAux="green";
	  }
	  print FRUST "$EquivRes{$Res1} $EquivRes{$Res2} $EquivChains{$Res1} $EquivChains{$Res2} $Density1 $Density2 $AA1 $AA2 $NativeEnergy $DecoyEnergy $SDEnergy $FrstIndex $ResResDistance $FrstType\n";
	  print FRUSTRENUM "$Res1 $Res2 $EquivChains{$Res1} $EquivChains{$Res2} $Density1 $Density2 $AA1 $AA2 $NativeEnergy $DecoyEnergy $SDEnergy $FrstIndex $ResResDistance $FrstType\n";
	  
 	  if($FrstTypeAux eq "green" || $FrstTypeAux eq "red" )
          {
 	  print FRUSTAUX "$EquivRes{$Res1} $EquivRes{$Res2} $EquivChains{$Res1} $EquivChains{$Res2} $ResResDistance $FrstTypeAux\n";

          }
	}
}

elsif($mode eq "singleresidue")
{
print FRUST "Res ChainRes DensityRes AA NativeEnergy DecoyEnergy SDEnergy FrstIndex\n";

	for(my $i=2; $i<@tertiary_frustration; $i++)
	{
	  my @splitted=split " ", $tertiary_frustration[$i];
	  my $Res=$splitted[0];
	  my $Density=$splitted[5];
	  my $AA=$splitted[6];
	  my $NativeEnergy=$splitted[7];
	  my $DecoyEnergy=$splitted[8];
	  my $SDEnergy=$splitted[9];
	  my $FrstIndex=$splitted[10];

	  print FRUST "$EquivRes{$Res} $EquivChains{$Res} $Density $AA $NativeEnergy $DecoyEnergy $SDEnergy $FrstIndex\n";
	}
}

close FRUST;
close FRUSTAUX;
close FRUSTRENUM;

system("rm $jobDir/$jobID\_$mode\_renumbered");
