(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



BeginPackage["RBSFA`"];


RBSFAversion::usage="RBSFAversion[] prints the current version of the RB-SFA package in use and its timestamp.";
Begin["`Private`"];
RBSFAversion[]="RB-SFA v2.0.5, Thu 24 Mar 2016 17:18:51";
End[];


hydrogenicDTME::usage="hydrogenicDTME[p,\[Kappa]] returns the dipole transition matrix element for a 1s hydrogenic state of ionization potential \!\(\*SubscriptBox[\(I\), \(p\)]\)=\!\(\*FractionBox[\(1\), \(2\)]\)\!\(\*SuperscriptBox[\(\[Kappa]\), \(2\)]\).";
hydrogenicDTMERegularized::usage="hydrogenicDTMERegularized[p,\[Kappa]] returns the dipole transition matrix element for a 1s hydrogenic state of ionization potential \!\(\*SubscriptBox[\(I\), \(p\)]\)=\!\(\*FractionBox[\(1\), \(2\)]\)\!\(\*SuperscriptBox[\(\[Kappa]\), \(2\)]\), regularized to remove the denominator of 1/(\!\(\*SuperscriptBox[\(p\), \(2\)]\)+\!\(\*SuperscriptBox[\(\[Kappa]\), \(2\)]\)\!\(\*SuperscriptBox[\()\), \(3\)]\), where the saddle-point solutions are singular."
Begin["`Private`"];
hydrogenicDTME[p_List,\[Kappa]_]:=(8I)/\[Pi] (Sqrt[2\[Kappa]^5]p)/(Total[p^2]+\[Kappa]^2)^3
hydrogenicDTME[p_?NumberQ,\[Kappa]_]:=(8I)/\[Pi] (Sqrt[2\[Kappa]^5]p)/(p^2+\[Kappa]^2)^3
hydrogenicDTMERegularized[p_List,\[Kappa]_]:=(8I)/\[Pi] (Sqrt[2\[Kappa]^5]p)/1
hydrogenicDTMERegularized[p_?NumberQ,\[Kappa]_]:=(8I)/\[Pi] (Sqrt[2\[Kappa]^5]p)/1
End[];


gaussianDTME::usage="gaussianDTME[p,\[Kappa]] returns the dipole transition matrix element for a gaussian state of characteristic size 1/\[Kappa].";
Begin["`Private`"];
gaussianDTME[p_List,\[Kappa]_]:=-I (4\[Pi])^(3/4) \[Kappa]^(-7/2) p Exp[-(Total[p^2]/(2\[Kappa]^2))]
gaussianDTME[p_?NumberQ,\[Kappa]_]:=-I (4\[Pi])^(3/4) \[Kappa]^(-7/2) p Exp[-(p^2/(2\[Kappa]^2))]
End[];


flatTopEnvelope::usage="flatTopEnvelope[\[Omega],num,nRamp] returns a Function object representing a flat-top envelope at carrier frequency \[Omega] lasting a total of num cycles and with linear ramps nRamp cycles long.";
Begin["`Private`"];
flatTopEnvelope[\[Omega]_,num_,nRamp_]:=Function[t,Piecewise[{{0,t<0},{Sin[(\[Omega] t)/(4nRamp)]^2,0<=t<(2 \[Pi])/\[Omega] nRamp},{1,(2 \[Pi])/\[Omega] nRamp<=t<(2 \[Pi])/\[Omega] (num-nRamp)},{Sin[(\[Omega] ((2 \[Pi])/\[Omega] num-t))/(4nRamp)]^2,(2 \[Pi])/\[Omega] (num-nRamp)<=t<(2 \[Pi])/\[Omega] num},{0,(2 \[Pi])/\[Omega] num<=t}}]]
End[];


cosPowerFlatTop::usage="cosPowerFlatTop[\[Omega],num,power] returns a Function object representing a smooth flat-top envelope of the form 1-Cos(\[Omega] t/2 num\!\(\*SuperscriptBox[\()\), \(power\)]\)";
Begin["`Private`"];
cosPowerFlatTop[\[Omega]_,num_,power_]:=Function[t,1-Cos[(\[Omega] t)/(2num)]^power]
End[];


PointsPerCycle::usage="PointsPerCycle is a sampling option which specifies the number of sampling points per cycle to be used in integrations.";
TotalCycles::usage="TotalCycles is a sampling option which specifies the total number of periods to be integrated over.";
CarrierFrequency::usage="CarrierFrequency is a sampling option which specifies the carrier frequency to be used.";
Protect[PointsPerCycle,TotalCycles,CarrierFrequency];


standardOptions={PointsPerCycle->90,TotalCycles->1,CarrierFrequency->0.057};


harmonicOrderAxis::usage="harmonicOrderAxis[opt\[Rule]value] returns a list of frequencies which can be used as a frequency axis for Fourier transforms, scaled in units of harmonic order, for the provided field duration and sampling options.";
TargetLength::usage="TargetLength is an option for harmonicOrderAxis which specifies the total length required of the resulting list.";
LengthCorrection::usage="LengthCorrection is an option for harmonicOrderAxis which allows for manual correction of the length of the resulting list.";
Protect[LengthCorrection,TargetLength];
Begin["`Private`"];
Options[harmonicOrderAxis]=standardOptions~Join~{TargetLength->Automatic,LengthCorrection->1};
harmonicOrderAxis::target="Invalid TargetLength option `1`. This must be a positive integer or Automatic.";
harmonicOrderAxis[OptionsPattern[]]:=Module[{num=OptionValue[TotalCycles],npp=OptionValue[PointsPerCycle]},
Piecewise[{
{1/num Range[0.,Round[(npp num+1)/2.]-1+OptionValue[LengthCorrection]],OptionValue[TargetLength]===Automatic},
{Round[(npp num+1)/2.]/num Range[0,OptionValue[TargetLength]-1]/OptionValue[TargetLength],IntegerQ[OptionValue[TargetLength]]&&OptionValue[TargetLength]>=0}
},
Message[harmonicOrderAxis::target,OptionValue["TargetLength"]];Abort[]
]
]
End[];


frequencyAxis::usage="frequencyAxis[opt\[Rule]value] returns a list of frequencies which can be used as a frequency axis for Fourier transforms, in atomic units of frequency, for the provided field duration and sampling options.";
Begin["`Private`"];
Options[frequencyAxis]=Options[harmonicOrderAxis];
frequencyAxis[options:OptionsPattern[]]:=OptionValue[CarrierFrequency]harmonicOrderAxis[options]
End[];


timeAxis::usage="timeAxis[opt\[Rule]value] returns a list of times which can be used as a time axis ";
TimeScale::usage="TimeScale is an option for timeAxis which specifies the units the list should use: AtomicUnits by default, or LaserPeriods if required.";
AtomicUnits::usage="AtomicUnits is a value for the option TimeScale of timeAxis which specifies that the times should be in atomic units of time.";
LaserPeriods::usage="LaserPeriods is a value for the option TimeScale of timeAxis which specifies that the times should be in multiples of the carrier laser period.";
Protect[TimeScale,AtomicUnits,LaserPeriods];
Begin["`Private`"];
Options[timeAxis]=standardOptions~Join~{TimeScale->AtomicUnits,PointNumberCorrection->0};
timeAxis::scale="Invalid TimeScale option `1`. Available values are AtomicUnits and LaserPeriods";
timeAxis[OptionsPattern[]]:=Block[{T=2\[Pi]/\[Omega],\[Omega]=OptionValue[CarrierFrequency],num=OptionValue[TotalCycles],npp=OptionValue[PointsPerCycle]},
Piecewise[{
{1,OptionValue[TimeScale]===AtomicUnits},
{1/T,OptionValue[TimeScale]===LaserPeriods}
},
Message[timeAxis::scale,OptionValue[TimeScale]];Abort[]
]*Table[t
,{t,0,num (2\[Pi])/\[Omega],num/(num*npp+OptionValue[PointNumberCorrection]) (2\[Pi])/\[Omega]}
]
]
End[];


getSpectrum::usage="getSpectrum[DipoleList] returns the power spectrum of DipoleList.";
Polarization::usage="Polarization is an option for getSpectrum which specifies a polarization vector along which to polarize the dipole list. The default, Polarization\[Rule]False, specifies an unpolarized spectrum.";
ComplexPart::usage="part is an option for getSpectrum which specifies a function (like Re, Im, or by default #&) which should be applied to the dipole list before the spectrum is taken.";
\[Omega]Power::usage="\[Omega]Power is an option for getSpectrum which specifies a power of frequency which should multiply the spectrum.";
DifferentiationOrder::usage="DifferentiationOrder is an option for getSpectrum which specifies the order to which the dipole list should be differentiated before the spectrum is taken.";
Protect[Polarization,part,\[Omega]Power,DifferentiationOrder];

Begin["`Private`"];
Options[getSpectrum]={Polarization->False,ComplexPart->(#&),\[Omega]Power->0,DifferentiationOrder->0}~Join~standardOptions;

getSpectrum::diffOrd="Invalid differentiation order `1`.";
getSpectrum::\[Omega]Pow="Invalid \[Omega] power `1`.";

getSpectrum[dipoleList_,OptionsPattern[]]:=Block[
{polarizationVector,differentiatedList,depth,dimensions,
num=OptionValue[TotalCycles],npp=OptionValue[PointsPerCycle],\[Omega]=OptionValue[CarrierFrequency],\[Delta]t=(2\[Pi]/\[Omega])/npp
},
polarizationVector=OptionValue[Polarization]/Norm[OptionValue[Polarization]];

differentiatedList=OptionValue[ComplexPart][Piecewise[{
{dipoleList,OptionValue[DifferentiationOrder]==0},
{1/(2\[Delta]t) (Most[Most[dipoleList]]-Rest[Rest[dipoleList]]),OptionValue[DifferentiationOrder]==1},
{1/\[Delta]t^2 (Most[Most[dipoleList]]-2Most[Rest[dipoleList]]+Rest[Rest[dipoleList]]),OptionValue[DifferentiationOrder]==2}},
Message[getSpectrum::diffOrd,OptionValue[DifferentiationOrder]];Abort[]
]];

If[NumberQ[OptionValue[\[Omega]Power]],Null;,Message[getSpectrum::\[Omega]Pow,OptionValue[\[Omega]Power]];Abort[]  ];

num Table[
(\[Omega]/num k)^(2OptionValue[\[Omega]Power]),{k,1,Round[Length[differentiatedList]/2]}
]*If[
OptionValue[Polarization]===False,(*unpolarized spectrum*)
(*funky depth thing so this can take lists of numbers and lists of vectors, of arbitrary length. Makes for easier benchmarking.*)
depth=Length[Dimensions[dipoleList]];
dimensions=If[Length[#]>1,#[[2]],1(*#\[LeftDoubleBracket]1\[RightDoubleBracket]*)]&[Dimensions[dipoleList]];
Sum[Abs[
Fourier[
If[depth>1,Re[differentiatedList[[All,i]]],Re[differentiatedList[[All]]]]
,FourierParameters->{-1, 1}
][[1;;Round[Length[differentiatedList]/2]]]
]^2,{i,1,dimensions}]
,(*polarized spectrum*)
Abs[
Transpose[Table[
Fourier[
Re[differentiatedList[[All,i]]]
,FourierParameters->{-1, 1}
]
,{i,1,2}]][[1;;Round[Length[differentiatedList]/2]]].polarizationVector
]^2
]
]
End[];


spectrumPlotter::usage="spectrumPlotter[spectrum] plots the given spectrum with an appropriate axis in a \!\(\*SubscriptBox[\(log\), \(10\)]\) scale.";
FrequencyAxis::usage="FrequencyAxis is an option for spectrumPlotter which specifies the axis to use.";
Protect[FrequencyAxis];
Begin["`Private`"];
Options[spectrumPlotter]=Join[{FrequencyAxis->"HarmonicOrder"},Options[harmonicOrderAxis],Options[ListLinePlot]];
spectrumPlotter[spectrum_,options:OptionsPattern[]]:=ListPlot[
{Which[
OptionValue[FrequencyAxis]==="HarmonicOrder",
harmonicOrderAxis["TargetLength"->Length[spectrum],Sequence@@FilterRules[{options}~Join~Options[spectrumPlotter],Options[harmonicOrderAxis]]],
OptionValue[FrequencyAxis]==="Frequency",
frequencyAxis["TargetLength"->Length[spectrum],Sequence@@FilterRules[{options}~Join~Options[spectrumPlotter],Options[harmonicOrderAxis]]],
True,Range[Length[spectrum]]
],
Log[10,spectrum]
}\[Transpose]
,Sequence@@FilterRules[{options},Options[ListLinePlot]]
,Joined->True
,PlotRange->Full
,PlotStyle->Thick
,Frame->True
,Axes->False
,ImageSize->800
]
End[];


biColorSpectrum::usage="biColorSpectrum[DipoleList] produces a two-colour spectrum of DipoleList, separating the two circular polarizations.";
Begin["`Private`"];
Options[biColorSpectrum]=Join[{PlotRange->All},Options[Show],Options[spectrumPlotter],DeleteCases[Options[getSpectrum],Polarization->False]];
biColorSpectrum[dipoleList_,options:OptionsPattern[]]:=Show[{
spectrumPlotter[
getSpectrum[dipoleList,Polarization->{1,+I},Sequence@@FilterRules[{options},Options[getSpectrum]]],
PlotStyle->Red,Sequence@@FilterRules[{options},Options[spectrumPlotter]]],
spectrumPlotter[
getSpectrum[dipoleList,Polarization->{1,-I},Sequence@@FilterRules[{options},Options[getSpectrum]]],
PlotStyle->Blue,Sequence@@FilterRules[{options},Options[spectrumPlotter]]]
}
,PlotRange->OptionValue[PlotRange]
,Sequence@@FilterRules[{options},Options[Show]]
]
End[];


SineSquaredGate::usage="SineSquaredGate[nGateRamp] specifies an integration gate with a sine-squared ramp, such that SineSquaredGate[nGateRamp][\[Omega]t,nGate] has nGate flat periods and nGateRamp ramp periods.";
LinearRampGate::usage="LinearRampGate[nGateRamp] specifies an integration gate with a linear ramp, such that SineSquaredGate[nGateRamp][\[Omega]t,nGate] has nGate flat periods and nGateRamp ramp periods.";
Begin["`Private`"];
SineSquaredGate[nGateRamp_][\[Omega]\[Tau]_,nGate_]:=Piecewise[{{1,\[Omega]\[Tau]<=2\[Pi] (nGate-nGateRamp)},{Sin[(2\[Pi] nGate-\[Omega]\[Tau])/(4nGateRamp)]^2,2\[Pi] (nGate-nGateRamp)<\[Omega]\[Tau]<=2\[Pi] nGate},{0,nGate<\[Omega]\[Tau]}}]
LinearRampGate[nGateRamp_][\[Omega]\[Tau]_,nGate_]:=Piecewise[{{1,\[Omega]\[Tau]<=2\[Pi] (nGate-nGateRamp)},{-((\[Omega]\[Tau]-2\[Pi] (nGate+nGateRamp))/(2\[Pi] nGateRamp)),2\[Pi] (nGate-nGateRamp)<\[Omega]\[Tau]<=2\[Pi] nGate},{0,nGate<\[Omega]\[Tau]}}]
End[];


getIonizationPotential::usage="getIonizationPotential[Target] returns the ionization potential of an atomic target, e.g. \"Hydrogen\", in atomic units.\[IndentingNewLine]
getIonizationPotential[Target,q] returns the ionization potential of the q-th ion of the specified Target, in atomic units.";
Begin["`Private`"];
getIonizationPotential[Target_,Charge_:0]:=UnitConvert[ElementData[Target,"IonizationEnergies"][[Charge+1]]/(Quantity[1,"AvogadroConstant"]Quantity[1,"Hartrees"])]
End[];


makeDipoleList::usage="makeDipoleList[VectorPotential\[Rule]A] calculates the dipole response to the vector potential A.";

VectorPotential::usage="VectorPotential is an option for makeDipole list which specifies the field's vector potential. Usage should be VectorPotential\[Rule]A, where A[t]//.pars must yield a list of numbers for numeric t and parameters indicated by FieldParameters\[Rule]pars.";
VectorPotentialGradient::usage="VectorPotentialGradient is an option for makeDipole list which specifies the gradient of the field's vector potential. Usage should be VectorPotentialGradient\[Rule]GA, where GA[t]//.pars must yield a square matrix of the same dimension as the vector potential for numeric t and parameters indicated by FieldParameters\[Rule]pars. The indices must be such that GA[t]\[LeftDoubleBracket]i,j\[RightDoubleBracket] returns \!\(\*SubscriptBox[\(\[PartialD]\), \(i\)]\)\!\(\*SubscriptBox[\(A\), \(j\)]\)[t].";
FieldParameters::usage="FieldParameters is an option for makeDipole list which ";
Preintegrals::usage="Preintegrals is an option for makeDipole list which specifies whether the preintegrals of the vector potential should be \"Analytic\" or \"Numeric\".";
ReportingFunction::usage="ReportingFunction is an option for makeDipole list which specifies a function used to report the results, either internally (by the default, Identity) or to an external file.";
Gate::usage="Gate is an option for makeDipole list which specifies the integration gate to use. Usage as Gate\[Rule]g, nGate\[Rule]n will gate the integral at time \[Omega]t/\[Omega] by g[\[Omega]t,n]. The default is Gate\[Rule]SineSquaredGate[1/2].";
nGate::usage="nGate is an option for makeDipole list which specifies the total number of cycles in the integration gate.";
IonizationPotential::usage="IonizationPotential is an option for makeDipoleList which specifies the ionization potential \!\(\*SubscriptBox[\(I\), \(p\)]\) of the target.";
Target::usage="Target is an option for makeDipoleList which specifies chemical species producing the HHG emission, pulling the ionization potential from the Wolfram ElementData curated data set.";
DipoleTransitionMatrixElement::usage="DipoleTransitionMatrixElement is an option for makeDipoleList which secifies a function f to use as the dipole transition matrix element, or a pair of functions {\!\(\*SubscriptBox[\(f\), \(ion\)]\),\!\(\*SubscriptBox[\(f\), \(rec\)]\)} to be used separately for the ionization and recombination dipoels, to be used in the form f[p,\[Kappa]]=f[p,\!\(\*SqrtBox[\(2 \*SubscriptBox[\(I\), \(p\)]\)]\)].";
\[Epsilon]Correction::usage="\[Epsilon]Correction is an option for makeDipoleList which specifies the regularization correction \[Epsilon], i.e. as used in the factor \!\(\*FractionBox[\(1\), SuperscriptBox[\((t - tt + \[ImaginaryI]\\\ \[Epsilon])\), \(3/2\)]]\).";
PointNumberCorrection::usage="PointNumberCorrection is an option for makeDipoleList and timeAxis which specifies an extra number of points to be integrated over, which is useful to prevent Indeterminate errors when a Piecewise envelope is being differentiated at the boundaries.";
IntegrationPointsPerCycle::usage="IntegrationPointsPerCycle is an option for makeDipoleList which controls the number of points per cycle to use for the integration. Set to Automatic, to follow PointsPerCycle, or to an integer.";
RunInParallel::usage="RunInParallel is an option for makeDipoleList which, if set to True, parallelizes the loop over harmonic emission time.";


Protect[VectorPotential,VectorPotentialGradient,FieldParameters,Preintegrals,ReportingFunction,Gate,nGate,IonizationPotential,Target,\[Epsilon]Correction,PointNumberCorrection,DipoleTransitionMatrixElement,IntegrationPointsPerCycle,RunInParallel];



Begin["`Private`"];
Options[makeDipoleList]=standardOptions~Join~{
VectorPotential->Automatic,FieldParameters->{},VectorPotentialGradient->None,
Preintegrals->"Analytic",ReportingFunction->Identity,
Gate->SineSquaredGate[1/2],nGate->3/2,\[Epsilon]Correction->0.1,
IonizationPotential->0.5,Target->Automatic,DipoleTransitionMatrixElement->hydrogenicDTME,
PointNumberCorrection->0,Verbose->0,
RunInParallel->Automatic,
IntegrationPointsPerCycle->Automatic
};
makeDipoleList::gate="The integration gate g provided as Gate\[Rule]`1` is incorrect. Its usage as g[`2`,`3`] returns `4` and should return a number.";
makeDipoleList::pot="The vector potential A provided as VectorPotential\[Rule]`1` is incorrect or is missing FieldParameters. Its usage as A[`2`] returns `3` and should return a list of numbers.";
makeDipoleList::gradpot="The vector potential GA provided as VectorPotentialGradient\[Rule]`1` is incorrect or is missing FieldParameters. Its usage as GA[`2`] returns `3` and should return a square matrix of numbers. Alternatively, use VectorPotentialGradient\[Rule]None.";
makeDipoleList::preint="Wrong Preintegrals option `1`. Valid options are \"Analytic\" and \"Numeric\".";
makeDipoleList::runpar="Wrong RunInParallel option `1`.";




makeDipoleList[OptionsPattern[]]:=Block[
{
num=OptionValue[TotalCycles],npp=OptionValue[PointsPerCycle],\[Omega]=OptionValue[CarrierFrequency],
dipoleRec,dipoleIon,\[Kappa],
A,F,GA,pi,ps,S,
gate,tGate,setPreintegral,
tInit,tFinal,\[Delta]t,\[Delta]tint,\[Epsilon]=OptionValue[\[Epsilon]Correction],
AInt,A2Int,GAInt,GAdotAInt,AdotGAInt,GAIntInt,bigPScorrectionInt,AdotGAdotAInt,
integrand,dipoleList,
TableCommand,SumCommand
},

A[t_]=OptionValue[VectorPotential][t]//.OptionValue[FieldParameters];
F[t_]=-D[A[t],t];
GA[t_]=If[
TrueQ[OptionValue[VectorPotentialGradient]==None],        Table[0,{Length[A[tInit]]},{Length[A[tInit]]}],
OptionValue[VectorPotentialGradient][t]//.OptionValue[FieldParameters]
];

tInit=0;
tFinal=(2\[Pi])/\[Omega] num;
(*looping timestep*)
\[Delta]t=(tFinal-tInit)/(num*npp+OptionValue[PointNumberCorrection]);
(*integration timestep*)
\[Delta]tint=If[OptionValue[IntegrationPointsPerCycle]===Automatic,\[Delta]t,(tFinal-tInit)/(num*OptionValue[IntegrationPointsPerCycle]+OptionValue[PointNumberCorrection])];

tGate=OptionValue[nGate] (2\[Pi])/\[Omega];
(*Check potential and potential gradient for correctness.*)
With[{\[Omega]tRandom=RandomReal[{\[Omega] tInit,\[Omega] tFinal}]},
If[!And@@(NumberQ/@A[\[Omega]tRandom/\[Omega]]),Message[makeDipoleList::pot,OptionValue[VectorPotential],\[Omega]tRandom,A[\[Omega]tRandom]];Abort[]];
If[!And@@(NumberQ/@Flatten[GA[\[Omega]tRandom/\[Omega]]]),Message[makeDipoleList::gradpot,OptionValue[VectorPotentialGradient],\[Omega]tRandom,GA[\[Omega]tRandom]];Abort[]];
];

gate[\[Omega]\[Tau]_]:=OptionValue[Gate][\[Omega]\[Tau],OptionValue[nGate]];
With[{\[Omega]tRandom=RandomReal[{\[Omega] tInit,\[Omega] tFinal}]},
If[!TrueQ[NumberQ[gate[\[Omega]tRandom]]],
Message[makeDipoleList::gate,OptionValue[Gate],\[Omega]tRandom,OptionValue[nGate],gate[\[Omega]tRandom]];Abort[]]
];

(*Target setup*)
Which[
OptionValue[Target]===Automatic,\[Kappa]=Sqrt[2OptionValue[IonizationPotential]],
True,\[Kappa]=Sqrt[2getIonizationPotential[OptionValue[Target]]]
];
With[{dim=Length[A[RandomReal[{\[Omega] tInit,\[Omega] tFinal}]]]},
(*Explicit conjugation of the recombination matrix element to keep the integrand analytic.*)
Which[
Head[OptionValue[DipoleTransitionMatrixElement]]===List,
dipoleIon[{p1_,p2_,p3_}[[1;;dim]],\[Kappa]\[Kappa]_]=First[OptionValue[DipoleTransitionMatrixElement]][{p1,p2,p3},\[Kappa]\[Kappa]];
dipoleRec[{p1_,p2_,p3_}[[1;;dim]],\[Kappa]\[Kappa]_]=Assuming[{{p1,p2,p3,\[Kappa]\[Kappa]}\[Element]Reals},Simplify[
Conjugate[Last[OptionValue[DipoleTransitionMatrixElement]][{p1,p2,p3},\[Kappa]\[Kappa]]]
]];
,True,
dipoleIon[{p1_,p2_,p3_}[[1;;dim]],\[Kappa]\[Kappa]_]=OptionValue[DipoleTransitionMatrixElement][{p1,p2,p3},\[Kappa]\[Kappa]];
dipoleRec[{p1_,p2_,p3_}[[1;;dim]],\[Kappa]\[Kappa]_]=Assuming[{{p1,p2,p3,\[Kappa]\[Kappa]}\[Element]Reals},Simplify[
Conjugate[OptionValue[DipoleTransitionMatrixElement][{p1,p2,p3},\[Kappa]\[Kappa]]]
]];
];
];


setPreintegral[integralVariable_,preintegrand_,dimensions_,integrateWithoutGradient_,parametric_]:=Which[
OptionValue[VectorPotentialGradient]=!=None||TrueQ[integrateWithoutGradient],(*Vector potential gradient specified, or integral variable does not depend on it, so integrate*)
Which[
OptionValue[Preintegrals]=="Analytic",
integralVariable[t_,tt_]=((#/.{\[Tau]->t})-(#/.{\[Tau]->tt}))&[Integrate[preintegrand[\[Tau],tt],\[Tau]]];

,OptionValue[Preintegrals]=="Numeric",
Which[
TrueQ[Not[parametric]],
Block[{innerVariable},
integralVariable[t_,tt_]=(innerVariable[t]-innerVariable[tt]/.First[
NDSolve[{innerVariable'[\[Tau]]==preintegrand[\[Tau]],innerVariable[tInit]==ConstantArray[0,dimensions]},innerVariable,{\[Tau],tInit,tFinal},MaxStepSize->0.25/\[Omega]]
])
];
,True,
Block[{matrixpreintegrand,innerVariable,\[Tau]pre},
matrixpreintegrand[indices_,t_?NumericQ,tt_?NumericQ]:=preintegrand[t,tt][[##&@@indices]];
integralVariable[t_,tt_]=Array[(
innerVariable[##][t-tt,tt]/.First@NDSolve[{
D[innerVariable[##][\[Tau]pre,tt],\[Tau]pre]==Piecewise[{{matrixpreintegrand[{##},tt+\[Tau]pre,tt],tt+\[Tau]pre<=tFinal}},0],
innerVariable[##][0,tt]==0
},innerVariable[##]
,{\[Tau]pre,0,tFinal-tInit},{tt,tInit,tFinal}
,MaxStepSize->0.25/\[Omega]
]
)&,dimensions];
]
];
];
,OptionValue[VectorPotentialGradient]===None,(*Vector potential gradient has not been specified, and integral variable depends on it, so return appropriate zero matrix*)
integralVariable[t_]=ConstantArray[0,dimensions];
integralVariable[t_,tt_]=ConstantArray[0,dimensions];
];
Apply[setPreintegral,({
 {AInt, A[#1]&, {Length[A[tInit]]}, True, False},
 {A2Int, A[#1].A[#1]&, {}, True, False},
 {GAInt, GA[#1]&, {Length[A[tInit]],Length[A[tInit]]}, False, False},
 {GAdotAInt, GA[#1].A[#1]&, {Length[A[tInit]]}, False, False},
 {AdotGAInt, A[#1].GA[#1]&, {Length[A[tInit]]}, False, False},
 {GAIntInt, GAInt[#1,#2]&, {Length[A[tInit]],Length[A[tInit]]}, False, True},
 {AdotGAdotAInt, A[#1].GAdotAInt[#1,#2]&, {}, False, True},
 {bigPScorrectionInt, GAdotAInt[#1,#2]+A[#1].GAInt[#1,#2]&, {Length[A[tInit]]}, False, True}
}),{1}];
(*{\!\(
\*SubsuperscriptBox[\(\[Integral]\), 
SubscriptBox[\(t\), \(0\)], \(t\)]\(A\((\[Tau])\)\[DifferentialD]\[Tau]\)\),\!\(
\*SubsuperscriptBox[\(\[Integral]\), 
SubscriptBox[\(t\), \(0\)], \(t\)]\(A
\*SuperscriptBox[\((\[Tau])\), \(2\)]\[DifferentialD]\[Tau]\)\),\!\(
\*SubsuperscriptBox[\(\[Integral]\), 
SubscriptBox[\(t\), \(0\)], \(t\)]\(\[Del]A\((\[Tau])\)\[DifferentialD]\[Tau]\)\),\!\(
\*SubsuperscriptBox[\(\[Integral]\), 
SubscriptBox[\(t\), \(0\)], \(t\)]\(\[Del]A\((\[Tau])\)\[CenterDot]A\((\[Tau])\)\[DifferentialD]\[Tau]\)\),\!\(
\*SubsuperscriptBox[\(\[Integral]\), 
SubscriptBox[\(t\), \(0\)], \(t\)]\(A\((\[Tau])\)\[CenterDot]\[Del]A\((\[Tau])\)\[DifferentialD]\[Tau]\)\),\!\(
\*SubsuperscriptBox[\(\[Integral]\), \(t'\), \(t\)]\(
\*SubsuperscriptBox[\(\[Integral]\), \(t'\), \(\[Tau]\)]\[Del]A\((\[Tau]')\)\[DifferentialD]\[Tau]'\[DifferentialD]\[Tau]\)\),\!\(
\*SubsuperscriptBox[\(\[Integral]\), \(t'\), \(t\)]\(
\*SubscriptBox[\(A\), \(k\)]\((\[Tau])\)\[CenterDot]\(
\*SubsuperscriptBox[\(\[Integral]\), \(t'\), \(\[Tau]\)]
\*SubscriptBox[\(\[PartialD]\), \(k\)]
\*SubscriptBox[\(A\), \(j\)]\((\[Tau]')\)
\*SubscriptBox[\(A\), \(j\)]\((\[Tau]')\)\[DifferentialD]\[Tau]'\[DifferentialD]\[Tau]\)\)\),\!\(
\*SubsuperscriptBox[\(\[Integral]\), \(t'\), \(t\)]\(
\*SubsuperscriptBox[\(\[Integral]\), \(t'\), \(\[Tau]\)]\((
\*SubscriptBox[\(A\), \(k\)]\((\[Tau]')\)
\*SubscriptBox[\(\[PartialD]\), \(j\)]
\*SubscriptBox[\(A\), \(k\)]\((\[Tau]')\) + 
\*SubscriptBox[\(A\), \(k\)]\((\[Tau])\)
\*SubscriptBox[\(\[PartialD]\), \(k\)]
\*SubscriptBox[\(A\), \(j\)]\((\[Tau]')\))\)\[DifferentialD]\[Tau]'\[DifferentialD]\[Tau]\)\)};*)


(*Displaced momentum*)
pi[p_,t_,tt_]:=p+A[t]-GAInt[t,tt].p-GAdotAInt[t,tt];

(*Stationary momentum and action*)
ps[t_,tt_]:=ps[t,tt]=-(1/(t-tt-I \[Epsilon]))Inverse[IdentityMatrix[Length[A[tInit]]]-1/(t-tt-I \[Epsilon]) (GAIntInt[t,tt]+GAIntInt[t,tt]\[Transpose])].(AInt[t,tt]-bigPScorrectionInt[t,tt]);


S[t_,tt_]:=1/2 (Total[ps[t,tt]^2]+\[Kappa]^2)(t-tt)+ps[t,tt].AInt[t,tt]+1/2 A2Int[t,tt]-(
ps[t,tt].GAIntInt[t,tt].ps[t,tt]+ps[t,tt].bigPScorrectionInt[t,tt]+AdotGAdotAInt[t,tt]
);

integrand[t_,\[Tau]_]:=I ((2\[Pi])/(\[Epsilon]+I \[Tau]))^(3/2) dipoleRec[pi[ps[t,t-\[Tau]],t,t-\[Tau]],\[Kappa]]*dipoleIon[pi[ps[t,t-\[Tau]],t-\[Tau],t-\[Tau]],\[Kappa]].F[t-\[Tau]]Exp[-I S[t,t-\[Tau]]]gate[\[Omega] \[Tau]];

(*Debugging constructs. Verbose\[Rule]1 prints information about the internal functions. Verbose\[Rule]2 returns all the relevant internal functions and stops.*)
Which[
OptionValue[Verbose]==1,Information/@{A,GA,ps,pi,S,AInt,A2Int,GAInt,GAdotAInt,AdotGAInt,GAIntInt,bigPScorrectionInt,AdotGAdotAInt},
OptionValue[Verbose]==2,Return[With[{t=Global`t,tt=Global`tt,p=Global`t,\[Tau]=Global`\[Tau]},
{A[t],GA[t],ps[t,tt],pi[p,t,tt],S[t,tt],AInt[t],AInt[t,tt],A2Int[t],A2Int[t,tt],GAInt[t],GAInt[t,tt],GAdotAInt[t],GAdotAInt[t,tt],AdotGAInt[t],AdotGAInt[t,tt],GAIntInt[t],GAIntInt[t,tt],bigPScorrectionInt[t],bigPScorrectionInt[t,tt],AdotGAdotAInt[t],AdotGAdotAInt[t,tt],integrand[t,\[Tau]]}]]
];

(*Single-run parallelization*)
Which[
OptionValue[RunInParallel]===Automatic||OptionValue[RunInParallel]===False,
TableCommand=Table,SumCommand=Sum,
OptionValue[RunInParallel]===True,
TableCommand=ParallelTable,SumCommand=Sum,
OptionValue[RunInParallel]==="InactiveDirect",
TableCommand=Inactive[Table],SumCommand=Inactive[Sum],
OptionValue[RunInParallel]==="InactiveParallel",
TableCommand=Inactive[ParallelTable],SumCommand=Inactive[Sum],
OptionValue[RunInParallel]==="Scramble",
TableCommand=table,SumCommand=sum,
True,Message[makeDipoleList::runpar,OptionValue[RunInParallel]];Abort[]
];

(*Numerical integration loop*)
dipoleList=TableCommand[
OptionValue[ReportingFunction][
\[Delta]tint SumCommand[(
integrand[t,\[Tau]]
),{\[Tau],0,If[OptionValue[Preintegrals]=="Analytic",tGate,Min[t-tInit,tGate]],\[Delta]tint}]
]
,{t,tInit,tFinal,\[Delta]t}
];
dipoleList

]
End[];


EndPackage[]


$DistributedContexts::overwrite="Warning: overwriting previous value of $DistributedContexts. Reinstate your old definition, and include the RBSFA context to ensure proper parallelization of RB-SFA calculations.";
If[
ValueQ[$DistributedContexts],
Message[$DistributedContexts::overwrite]
]
$DistributedContexts:={$Context,"RBSFA`"}
