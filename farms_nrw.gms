********************************************************************************
$ontext

   Dairy ABM project

   GAMS file : Farms_nrw.GMS

   @purpose  : Build a farm population for NRW from agricultural statistics
               on farm structur at commune level
   @author   : W. Britz & David Schaefer
   @date     : 30.10.2020
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy :

$offtext
********************************************************************************
$offlisting


*
*  mnemonics follow the labelling in "
*
  set s_types / 'Ackerbau','Gartenbau','Dauerkultur','FutterBau','Veredlungs','Viehaltungs',
                'Pflanzenbauverbund','Viehhaltungsverbund','Verbund' /;

  set s_SizeClass / 'unter 5','5 - 10','10 - 20','20 - 50','50 - 100','100 - 200','100 und mehr','200 und mehr' /;

  set s_landuse  /
             "Ackerland,Betriebe",
             "Dauergruenland,Betriebe"
             "Dauerkulturen,Betriebe"
  /;
  set s_landuseLF  /
             "Ackerland,LF",
             "Dauergruenland,LF"
             "Dauerkulturen,LF"
  /;


  set items / set.s_types,set.s_SizeClass,set.s_landUse,'Betriebe',n,insgesamt,set.s_landUseLF,ha,"insgesamt davon" /;
  set TypesLandUseT(items) / set.s_types,set.s_landUse,"Betriebe",set.s_landUseLF,"insgesamt","insgesamt davon"/;
  set TypesLandUse(TypesLandUseT)  / set.s_types,set.s_landUse/;



  set typesT(typesLandUseT)  / set.s_types,'Betriebe'/;
  set types(TypesLandUse)    / set.s_types /;
  set sizeClassT(items)      / set.s_sizeClass,'Betriebe','insgesamt','insgesamt davon'/;
  set sizeClass(sizeClassT)  / set.s_sizeClass /;
  alias(sizeClass,sizeClass1);

  alias(types,types1);

  set landUse(typesLandUse)  / set.s_landUse /;
  set landUseLF(typesLandUseT)  / set.s_landUseLF /;

  set l_l(landUse,landUseLF) "Link between Betriebe and LF";
  l_l(landUse,landUseLF) $ (landuse.pos eq landUseLF.pos) = YES;

  set sizeClassG(sizeClass);
*
* --- the NUTS II / I tables comprise only a class "100 und mehr"
*
  sizeClassG(sizeClass) = YES;
  sizeClassG("100 und mehr") = NO;

  alias(sizeClassG,sizeClassG1);

  set sizeClassC(sizeClass);
  sizeClassC(sizeClass) = YES;
  sizeClassC("100 - 200") = NO;
  sizeClassC("200 und mehr") = NO;

*
* --- load sets for units by adminstrative level and cross sets
*     from GDX file
*

  set s_regBez,s_kreise,s_gemeinden,s_kreis_gemeinden,regBez_Kreise,ids,r_ids;
$GDXIN "2_Commune_NRW_ASE2016.gdx"
$load s_regBez=regBez,s_kreise=kreise,s_gemeinden=gemeinden,s_kreis_gemeinden = kreis_gemeinden,regBez_Kreise
$GDXIN


$GDXIN "GemeindeDaten.gdx"
$load ids,r_ids
$GDXIN



  set r "all regional units" / set.s_regBez,set.s_Kreise,set.s_gemeinden /;
  alias(r,r1);

  set regBez(r)    "NUTS I"   / set.s_regBez /;
  set kreise(r)    "NUTS II"  / set.s_kreise, "Hochsauerlandkreis", "Staedteregion Aachen"/;
  set gemeinden(r) "Communes" / set.s_gemeinden/;


  set kreis_gemeinden(r,r) "Gemeinden in Kreisen" /set.s_kreis_gemeinden,
                                                   "Staedteregion Aachen"."Alsdorf, Stadt"
                                                   "Staedteregion Aachen"."Baesweiler, Stadt"
                                                   "Staedteregion Aachen"."Eschweiler, Stadt"
                                                   "Staedteregion Aachen"."Herzogenrath, Stadt"
                                                   "Staedteregion Aachen"."Monschau, Stadt"
                                                   "Staedteregion Aachen"."Roetgen"
                                                   "Staedteregion Aachen"."Simmerath"
                                                   "Staedteregion Aachen"."Stolberg (Rhld.), Stadt"
                                                   "Staedteregion Aachen"."Wuerselen, Stadt"
                                                   "Staedteregion Aachen"."Aachen, kreisfreie Stadt"
                                                   "Hochsauerlandkreis"."Arnsberg, Stadt"
                                                   "Hochsauerlandkreis"."Bestwig"
                                                   "Hochsauerlandkreis"."Brilon, Stadt"
                                                   "Hochsauerlandkreis"."Eslohe (Sauerland)"
                                                   "Hochsauerlandkreis"."Hallenberg, Stadt"
                                                   "Hochsauerlandkreis"."Marsberg, Stadt"
                                                   "Hochsauerlandkreis"."Medebach, Stadt"
                                                   "Hochsauerlandkreis"."Meschede, Stadt"
                                                   "Hochsauerlandkreis"."Olsberg, Stadt"
                                                   "Hochsauerlandkreis"."Schmallenberg, Stadt"
                                                   "Hochsauerlandkreis"."Sundern (Sauerland), Stadt"
                                                   "Hochsauerlandkreis"."Winterberg, Stadt"
/;


  alias(regBez,regBez1);


 regBez_Kreise("Regierungsbezirk Koeln","Alsdorf, Stadt") = NO;
 regBez_Kreise("Regierungsbezirk Koeln","Baesweiler, Stadt") = NO;
 regBez_Kreise("Regierungsbezirk Koeln","Eschweiler, Stadt") = NO;
 regBez_Kreise("Regierungsbezirk Koeln","Herzogenrath, Stadt") = NO;
 regBez_Kreise("Regierungsbezirk Koeln","Monschau, Stadt") = NO;
 regBez_Kreise("Regierungsbezirk Koeln","Roetgen") = NO;
 regBez_Kreise("Regierungsbezirk Koeln","Simmerath") = NO;
 regBez_Kreise("Regierungsbezirk Koeln","Stolberg (Rhld.), Stadt") = NO;
 regBez_Kreise("Regierungsbezirk Koeln","Wuerselen, Stadt") = NO;
 regBez_Kreise("Regierungsbezirk Koeln","Aachen, kreisfreie Stadt") = NO;


 regBez_Kreise("Regierungsbezirk Arnsberg","Arnsberg, Stadt") = NO;
 regBez_Kreise("Regierungsbezirk Arnsberg","Bestwig") = NO;
 regBez_Kreise("Regierungsbezirk Arnsberg","Brilon, Stadt") = NO;
 regBez_Kreise("Regierungsbezirk Arnsberg","Eslohe (Sauerland)") = NO;
 regBez_Kreise("Regierungsbezirk Arnsberg","Hallenberg, Stadt") = NO;
 regBez_Kreise("Regierungsbezirk Arnsberg","Marsberg, Stadt") = NO;
 regBez_Kreise("Regierungsbezirk Arnsberg","Medebach, Stadt") = NO;
 regBez_Kreise("Regierungsbezirk Arnsberg","Meschede, Stadt") = NO;
 regBez_Kreise("Regierungsbezirk Arnsberg","Olsberg, Stadt") = NO;
 regBez_Kreise("Regierungsbezirk Arnsberg","Schmallenberg, Stadt") = NO;
 regBez_Kreise("Regierungsbezirk Arnsberg","Sundern (Sauerland), Stadt") = NO;
 regBez_Kreise("Regierungsbezirk Arnsberg","Winterberg, Stadt") = NO;


*
* --- data for individual communes and cross-tabulations (farm and size, land use and size etc.)
*     for NUTS II and I
*
parameter p_GemeindeData(r,*,items);
$GDXIN "2_Commune_NRW_ASE2016.gdx"
$onUNDF
$load p_GemeindeData
$GDXIN

display p_gemeindeData;
table p_gemeindeDataMissingValues(r,*,items)

                                                          Betriebe           "unter 5"           "5 - 10"        "10 - 20"        "20 - 50"       "50 - 100"       "100 - 200"     "200 und mehr"    "Ackerbau"    "Gartenbau"  "Dauerkultur"    "Futterbau"     "Veredlungs"   "Viehaltungs"      "Pflanzenbauverbund"    "Viehhaltungsverbund"   "Verbund"    "Ackerland,LF"   "Dauergruenland,LF"    "Dauerkulturen,LF"
    "Vettweiss".Betriebe                                     74                  3                   5              6                 17              17                18              8                58                                           8                                                                                1                 7              6661               419
    "Elsdorf".Betriebe                                       43                                                     6                 14              14                 7              2                34                                           3                1                                     1                                           4              2805               137
    "Leichlingen (Rheinland), Stadt".Betriebe                37                  7                   5              6                 10               7                 1              1                 7            6              1               17               1                                     2                                           3               650               783                     29
    "Schloss Holte-Stukenbrock, Stadt".Betriebe              52                  7                  11             10                 14               7                 3                                8            4                              25               5                                     1                         2                 7              1205               390                     17
    "Velen".Betriebe                                        125                 21                  11             22                 42              25                 3              1                21            6                              38              37                                                                                 9              3668               465                     52
    "Preussisch Oldendorf, Stadt".Betriebe                   83                  7                  10             22                 14              22                 7              1                40            2                              4               13                                     1                         5                18              3267               239                     13

     ;

p_gemeindeData(r,"Betriebe",items) = p_gemeindeData(r,"Betriebe",items) + p_gemeindeDataMissingValues(r,"Betriebe",items);



  p_gemeindeData(r,"betriebe","100 und mehr") $ (not p_gemeindeData(r,"betriebe","100 und mehr"))
     = p_gemeindeData(r,"betriebe","100 - 200") + p_gemeindeData(r,"betriebe","200 und mehr");



parameter    p_crossData(r,typesLandUseT,sizeClassT)
execute_load "2_County_NRW_ASE2016.gdx" p_crossData;


  parameter p_meanSize(r,landUse,sizeClassT);
*
* --- calculate mean size for land use types in each size class
*
  p_meanSize(r,"ackerLand,Betriebe",sizeClassT) $ (p_crossData(r,"ackerland,Betriebe",sizeClassT))
    = p_crossData(r,"ackerLand,LF",sizeClassT)/p_crossData(r,"ackerland,Betriebe",sizeClassT);

  p_meanSize(r,"DauerGruenLand,Betriebe",sizeClassT) $ (p_crossData(r,"DauerGruenLand,Betriebe",sizeClassT))
    = p_crossData(r,"DauerGruenLand,LF",sizeClassT)/p_crossData(r,"DauerGruenLand,Betriebe",sizeClassT);

  p_meanSize(r,"DauerKulturen,Betriebe",sizeClassT) $ (p_crossData(r,"DauerKulturen,Betriebe",sizeClassT))
    = p_crossData(r,"DauerKulturen,LF",sizeClassT)/p_crossData(r,"DauerKulturen,Betriebe",sizeClassT);

  p_meanSize(r,landUse,sizeClassT) $ (p_meanSize(r,landUse,sizeClassT) le 1.E-10) = 0;


*
* --- calculate shares in cross-cells
*
  set dummmy /"insgesamt davon"/;
  parameter p_share(r,typesLandUse,sizeClassT);

  p_share(r,typesLandUse,sizeClassT) $ p_crossData(r,"Betriebe","insgesamt")
     = p_crossData(r,typesLandUse,sizeClassT)/p_crossData(r,"Betriebe","insgesamt");

  p_share(r,typesLandUse,sizeClassT) $ p_crossData(r,"Betriebe","insgesamt davon")
     = p_crossData(r,typesLandUse,sizeClassT)/p_crossData(r,"Betriebe","insgesamt davon");

  p_meanSize(kreise,landUSe,SizeClassT) $ (not p_meanSize(kreise,landUSe,SizeClassT))
   = sum(regBez_kreise(regBez,kreise), p_meanSize(regBez,landUSe,SizeClassT));

  p_meanSize(Gemeinden,landUSe,SizeClassT) $ (not p_meanSize(Gemeinden,landUSe,SizeClassT))
   = sum(kreis_Gemeinden(kreise,Gemeinden), p_meanSize(kreise,landUSe,SizeClassT));

  p_meanSize(Gemeinden,landUSe,SizeClassT) $ (not p_meanSize(Gemeinden,landUSe,SizeClassT))
   = sum(regbez_kreise(regBez,Gemeinden), p_meanSize(regBez,landUSe,SizeClassT));

  p_meanSize(Gemeinden,landUSe,'100 - 200')    = p_meanSize(Gemeinden,landUSe,'100 und mehr');
  p_meanSize(Gemeinden,landUSe,'200 und mehr') = p_meanSize(Gemeinden,landUSe,'100 und mehr')*1.5;



  p_share(r,typesLandUse,'100 - 200')    = p_share(r,typesLandUse,'100 und mehr') * 0.75;
  p_share(r,typesLandUse,'200 und mehr') = p_share(r,typesLandUse,'100 und mehr') * 0.25;

parameter  p_type_land(types,landUseLF) /

                           "Ackerbau"."Ackerland,LF"                 1.0,
                           "Ackerbau"."Dauergruenland,LF"           -0.1,

                           'GartenBau'."Ackerland,LF"                0.5,
                           'GartenBau'."Dauergruenland,LF"           0.5,

                           "Veredlungs"."Ackerland,LF"               1.0,

                           'Verbund'."Ackerland,LF"                  0.5,
                           'Verbund'."Dauergruenland,LF"             0.5,

                           'PflanzenBauVerbund'."Ackerland,LF"       0.8,
                           'PflanzenBauVerbund'."Dauerkulturen,LF"   0.2,

                           'FutterBau'."Dauergruenland,LF"           0.75,
                           'FutterBau'."Ackerland,LF"                0.25,


                           "Viehhaltungsverbund"."Dauergruenland,LF" 0.5,
                           "Viehhaltungsverbund"."Ackerland,LF"      0.5,

                           "Viehaltungs"."Dauergruenland,LF"    0.5,
                           "Viehaltungs"."Ackerland,LF"         0.5,

                           'Dauerkultur'."Ackerland,LF"                  0.1,
                           'Dauerkultur'."Dauerkulturen,LF"              0.9
                           /;



  parameter p_farmSize(sizeClass);

  p_farmSize("unter 5")  =    2.5;
  p_farmSize("5 - 10")   =   7.5;
  p_farmSize("10 - 20")   =  15;
  p_farmSize("20 - 50")   =  35;
  p_farmSize("50 - 100")  =  75;
  p_farmSize("100 - 200") = 150;
  p_farmSize("100 und mehr") = 200;
  p_farmSize("200 und mehr") = 300;

  parameter p_res(r,*,*,*);

  p_crossData(r,typesLandUseT,sizeClassT)$(p_crossData(r,typesLandUseT,sizeClassT) eq undf) = EPS;

  scalar considerSize / 1 /;

* -------------------------------------------------------------------------------------------
*
*   Set-up NLP problem to estimate the number of farms by size and type resp. land use
*   at commune level
*
* -------------------------------------------------------------------------------------------

  positive variables

    v_nFarm(r,types,sizeClass)
    v_farmHa(r,typesLandUseT,types,sizeClass)
    v_landUse(r,typesLandUseT,types,sizeClass)
    v_crossData(r,landUseLF,sizeClass)
 ;

  variable v_HPD "Posterior density"
           v_dummy;
*

  equations

   e_farmRegBez(regBez,types,sizeClass)
   e_haLandUseRegBez(regBez,landUseLF,sizeClass)
   e_farmKeise(kreise,types,sizeClass)
   e_haLandUseKreise(kreise,landUseLF,sizeClass)
   e_crossData(r,landUseLF,sizeClass)
   e_farmTypes1(r,types)
   e_farmTypes2(r,types)
   e_farmSizes1(r,sizeClass)
   e_farmSizes2(r,sizeClass)
   e_addUpGT100(r,types)
   e_addUpGT100LF(r,LandUseLF,types)
   e_landUseLF1(r,landUseLF)
   e_landUseLF2(r,landUseLF)
   e_meanSize(r,types,sizeClass)
   e_sumFarms1(r)
   e_sumFarms2(r)
   e_landUse(r,landUseLF,types,sizeClass)
   e_HPD
   e_dummy
  ;

  parameter p_target(r,typesLanduse,sizeClass) "A priori information on distribution";
  option kill=p_target;
  option nlp=conopt4;


  set rCur(r) "Gemeinden";
  set curRegBez(regBez);
  set curKreis(Kreise);

  set rAllCur(r);

  parameter p_slack / 1 /;


display r,s_gemeinden;

*
* --- recover given number of farms types / land Use and size at NUTS I level,
*     from NUTS II
*
  e_farmRegBez(curRegBez(regBez),types,sizeClassC) $ ( (p_crossData(regBez,types,sizeClassC) ne 1.E-10) ) ..

    sum( regBez_kreise(regBez,r), v_nFarm(r,types,sizeClassC)) =E= v_nFarm(regBez,types,sizeClassC);
*
* --- recover given number of farms types / land Use and size at NUTS I level,
*     from NUTS II
*
  e_haLandUseRegBez(curRegBez(regBez),landUseLF,sizeClassC) $ ( (p_crossData(regBez,landUseLF,sizeClassC) ne 1.E-10))..

    sum( regBez_kreise(regBez,r), v_crossData(r,landUseLF,sizeClassC)) =E= v_crossData(regBez,landUseLF,sizeClassC);
*
* --- recover given number of farms types / land Use and size at NUTS II level,
*     from communes
*
  e_farmKeise(curKreis(kreise),types,sizeClassC) $ sum( kreis_gemeinden(kreise,gemeinden),1) ..

    sum( kreis_gemeinden(kreise,gemeinden) $ (  p_GemeindeData(gemeinden,'Betriebe',types)
                                              $ p_GemeindeData(gemeinden,'Betriebe',sizeClassC)),
      v_nFarm(gemeinden,types,sizeClassC)) =E= v_nFarm(kreise,types,sizeClassC);

*
* --- recover given number land use by size class at NUTS II level
*
  e_haLandUseKreise(curKreis(kreise),landUseLF,sizeClassC) $ (sum( kreis_gemeinden(kreise,gemeinden),1)) ..

    sum( kreis_gemeinden(kreise,gemeinden) $ (  p_GemeindeData(gemeinden,'Betriebe',sizeClassC)
                                                      $ p_GemeindeData(gemeinden,'Betriebe',LanduseLF)),
      v_crossData(gemeinden,landUseLF,sizeClassC)) =E= v_crossData(kreise,landUseLF,sizeClassC);
*
* --- define land use by size class in each commune
*
  e_crossData(rCur,landUseLF,sizeClassC) $ (  p_GemeindeData(rCur,'Betriebe',sizeClassC)
                                            $ p_GemeindeData(rCur,'Betriebe',LanduseLF) ) ..

     sum(types $ p_GemeindeData(rCur,'Betriebe',types),
           v_landUse(rCur,landUseLF,types,sizeClassC)) =E= v_crossData(rCur,landUseLF,sizeClassC);

*
* --- define land use by type and size class in each commune
*
  e_landUse(rCur,landUseLF,Types,SizeClass) $ (  p_GemeindeData(rCur,'Betriebe',types)
                                               $ p_GemeindeData(rCur,'Betriebe',sizeClass)
                                               $ p_GemeindeData(rCur,'Betriebe',LanduseLF)) ..

     v_landUse(rCur,LandUseLF,types,SizeClass) =E=
            v_nFarm(rCur,types,sizeClass) * v_FarmHa(rCur,landUseLF,types,sizeClass);
*
* --- adds up "100-200" and "200 and mehr" to "100 and mehr"
*
  e_addUpGT100(rCur,types) $ (p_GemeindeData(rCur,'Betriebe',types)
                                    and (   p_GemeindeData(rCur,'Betriebe',"100 - 200")
                                         or p_GemeindeData(rCur,'Betriebe',"200 und mehr"))) ..

     v_nFarm(rCur,types,"100 und mehr") =E=

         v_nFarm(rCur,types,"100 - 200")    $ p_GemeindeData(rCur,'Betriebe',"100 - 200")
       + v_nFarm(rCur,types,"200 und mehr") $ p_GemeindeData(rCur,'Betriebe',"200 und mehr");

  e_addUpGT100LF(rCur,landUseLF,types) $ (p_GemeindeData(rCur,'Betriebe',types)
                                    and (   p_GemeindeData(rCur,'Betriebe',"100 - 200")
                                         or p_GemeindeData(rCur,'Betriebe',"200 und mehr"))
                                    and p_GemeindeData(rCur,'Betriebe',landUseLF) )  ..

      v_landUse(rCur,landUseLF,types,"100 und mehr")

           =E=

               v_landUse(rCur,landUseLF,types,"100 - 200")    $ p_GemeindeData(rCur,'Betriebe',"100 - 200")
             + v_landUse(rCur,landUseLF,types,"200 und mehr") $ p_GemeindeData(rCur,'Betriebe',"200 und mehr");
*
* --- adds up cross-tabular (types and size) estimates to given number of farms by type
*
  e_farmTypes1(rCur,types) $ ( p_GemeindeData(rCur,'Betriebe',types)
                               $ (p_GemeindeData(rCur,'Betriebe',types) ne 1.e-10)) ..

    sum(sizeClassG $ p_GemeindeData(rCur,'Betriebe',sizeClassG),
                v_nFarm(rCur,types,sizeClassG)) =G= p_GemeindeData(rCur,'Betriebe',types)-p_slack;

  e_farmTypes2(rCur,types) $ ( p_GemeindeData(rCur,'Betriebe',types)
                               $ (p_GemeindeData(rCur,'Betriebe',types) ne 1.e-10)) ..

    sum(sizeClassG $ p_GemeindeData(rCur,'Betriebe',sizeClassG),
                v_nFarm(rCur,types,sizeClassG)) =L= p_GemeindeData(rCur,'Betriebe',types)+p_slack;
*
* --- adds up cross-tabular (types and size) estimates to given number of farms by size-class
*
  e_farmSizes1(rCur,sizeClassG) $ (p_GemeindeData(rCur,'Betriebe',sizeClassG)
                                    $ (p_GemeindeData(rCur,'Betriebe',sizeClassG) ne 1.e-10)) ..

    sum(types $ p_GemeindeData(rCur,'Betriebe',types),
                v_nFarm(rCur,types,sizeClassG)) =G= p_GemeindeData(rCur,'Betriebe',sizeClassG)-p_slack;

  e_farmSizes2(rCur,sizeClassG) $ (p_GemeindeData(rCur,'Betriebe',sizeClassG)
                                    $ (p_GemeindeData(rCur,'Betriebe',sizeClassG) ne 1.e-10)) ..

    sum(types $ p_GemeindeData(rCur,'Betriebe',types),
                v_nFarm(rCur,types,sizeClassG)) =L= p_GemeindeData(rCur,'Betriebe',sizeClassG)+p_slack;
*
* --- adds up cross-tabular (types and size) estimates to given total number of farms
*
  e_sumFarms1(rCur) $ (p_GemeindeData(rCur,'Betriebe','Betriebe')
                        $ (p_GemeindeData(rCur,'Betriebe','Betriebe') ne 1.E-10)) ..

    sum( (types,sizeClassG) $ (  p_GemeindeData(rCur,'Betriebe',types)
                               $ p_GemeindeData(rCur,'Betriebe',sizeClassG)),
       v_nFarm(rCur,types,sizeClassG)) =G= p_GemeindeData(rCur,'Betriebe','Betriebe')-p_slack;

  e_sumFarms2(rCur) $ (p_GemeindeData(rCur,'Betriebe','Betriebe')
                        $ (p_GemeindeData(rCur,'Betriebe','Betriebe') ne 1.E-10)) ..

    sum( (types,sizeClassG) $ (  p_GemeindeData(rCur,'Betriebe',types)
                               $ p_GemeindeData(rCur,'Betriebe',sizeClassG)),
       v_nFarm(rCur,types,sizeClassG)) =L= p_GemeindeData(rCur,'Betriebe','Betriebe')+p_slack;
*
*  --- exhaust land use in commune in ha by land use aggregated over size classes
*
  e_landUseLF1(rCur,landUseLF) $ (p_GemeindeData(rCur,'Betriebe',landUseLF)
                                     $ (p_GemeindeData(rCur,'Betriebe',landuseLF) ne 1.e-10)) ..

    sum( (types,sizeClassG) $ (  p_GemeindeData(rCur,'Betriebe',types)
                               $ p_GemeindeData(rCur,'Betriebe',sizeClassG)),
        v_landUse(rCur,landUseLF,types,sizeClassG))
            =L= p_GemeindeData(rCur,'Betriebe',landUseLF)+p_slack*100;

  e_landUseLF2(rCur,landUseLF) $ (p_GemeindeData(rCur,'Betriebe',landUseLF)
                                    $ (p_GemeindeData(rCur,'Betriebe',landuseLF) ne 1.e-10)) ..

    sum( (types,sizeClassG) $ (  p_GemeindeData(rCur,'Betriebe',types)
                               $ p_GemeindeData(rCur,'Betriebe',sizeClassG)),
        v_landUse(rCur,landUseLF,types,sizeClassG))
            =G= p_GemeindeData(rCur,'Betriebe',landUseLF)-p_slack*100;
*
*  --- average size of farms in size class
*
  e_meanSize(rCur,types,sizeClassG) $ (  p_GemeindeData(rCur,'Betriebe',types)
                                      $ p_GemeindeData(rCur,'Betriebe',sizeClassG)) ..

        sum(landuseLF $ p_GemeindeData(rCur,'Betriebe',landUseLF),
             v_farmHa(rCur,landUseLF,types,sizeClassG))
                   =E= v_farmHa(rCur,"insgesamt",types,sizeClassG);


   e_dummy .. v_dummy =E= 10;
*
* --- HPD estimator, squared diff against a prori
*
  e_HPD ..
*
*     --- mean squared relative deviation, weighted with # of obs
*
      v_HPD * [ sum( (rCur,types,sizeClass) $ (p_target(rCur,types,sizeClass)
                                               and (v_nFarm.range(rCur,types,sizeClass) ne 0)),
                                                     abs(p_target(rCur,types,sizeClass)))

                     + sum( (rCur,types,sizeClass) $ p_target(rCur,types,sizeClass),
                                                         p_farmSize(sizeClass))


                     + sum( (rCur,landUseLF,types,sizeClass) $ p_target(rCur,types,sizeClass),
                                                (abs(p_type_land(types,landUseLF))+0.1))
              +1]




                       =E=
*
*
*
                            sum( (rCur,types,sizeClass) $ (p_target(rCur,types,sizeClass)
                                                                  and (v_nFarm.range(rCur,types,sizeClass) ne 0)),
*
*                               --- normalized deviation between estimated number of farms and a priori-number
*
                                    sqr( (v_nFarm(rCur,types,sizeClass)-p_target(rCur,types,sizeClass)
                                                      $ (p_target(rCur,types,sizeClass) gt 0)
                                               - 10   $ (p_target(rCur,types,sizeClass) le 0)
                                                      )
                                             /abs(p_target(rCur,types,sizeClass))))

*
*            --- minimize deviation from average size in sizeClass
*
            + sum( (rCur,types,sizeClass) $ p_target(rCur,types,sizeClass),

                    sqr( (v_farmHa(rCur,"insgesamt",types,sizeClass)
                          - p_farmSize(sizeClass))
                         / p_farmSize(sizeClass)
                       )
                  )
*
*            --- penalty for not desired combination
*
            + sum( (rCur,landUseLF,types,sizeClass) $ p_target(rCur,types,sizeClass),

                    sqr( (v_farmHa(rCur,landUseLF,types,sizeClass)
                             / (v_farmHa(rCur,"insgesamt",types,sizeClass)+0.001)
                            - (p_type_land(types,landUseLF)
                               - 1 $ (not p_type_land(types,landUseLF)))
                          )
                         / (abs(p_type_land(types,landUseLF))+0.1)
                        )
                  )  * considerSize

;
*
* --- model definition
*
  option limcol=0;
  option limrow=0;
  model m_farmStruct / all /;
  m_farmStruct.solvelink = 5;
  m_farmStruct.optfile   = 1;
*  m_farmStruct.solprint  = 2;
  m_farmStruct.limrow    = 10000;
  m_farmStruct.limcol    = 1000;
  m_farmStruct.holdfixed = 1;
* m_farmStruct.iterlim   = 0;
  m_farmStruct.reslim    = 30*60;

  set tries / try1*try20/;

  set type / noObje,HPD /;


  parameter test;

  set rCurKreisGem(r);

* test(gemeinden) = sum(kreis_gemeinden(kreise,gemeinden),1) -1;
*

  scalar roundAcc,diffWeight / 10/;
*$ontext
  loop( (regBez1),
*
*    --- delete dynamic regional set used in model equations
*
     option kill=rCur;
     option kill=curKreis;
     option kill=curRegBez;
*
*    -- set currnet NUTSII, NUTSIII in that NUTSII and related communes
*
     curRegBez(regBez1) = YES;
     curKreis(kreise) $ sum(regBez_kreise(curRegBez,kreise),1) = YES;

*     curKreis("Kreis Mettmann") = YES;

     rCur(Gemeinden)  $ sum(kreis_gemeinden(curKreis,gemeinden),1) = YES;
     rCur(Gemeinden)  $ sum(regBez_kreise(curRegBez,gemeinden),1) = YES;

     option kill=rAllCur;
     rallCur(curRegBez) = YES; rAllCur(curKreis) = YES; rallCur(rCur) = YES;

     option kill=rCurKReisGem;
     rCurKreisGem(curKreis) = YES; rCurKreisGem(rCur) = YES;

     option kill=v_farmHa;
     option kill=v_nFarm;
     option kill=v_hpd;

     loop(type,

        m_farmStruct.solprint  = 1;

        if ( sameas(type,"noObje"),
*
*          --- starting value for total land
*
           v_farmHa.l(rAllCur,"insgesamt",types,sizeClass)  = p_FarmSize(SizeClass);
*
*          --- starting value for each land type (arable, gras, permanent)
*
           v_farmHa.l(rAllCur,landUseLF,types,sizeClass)
              = p_FarmSize(SizeClass) * p_type_land(types,landUseLF) $ ( p_type_land(types,landUseLF) gt 0) + 0.1;


           v_farmHa.lo(rAllCur,"insgesamt",types,sizeClass)  = 0.1;
*
* --       upper and lower limits for size classes
*
           v_farmHa.up(rAllCur,"insgesamt",types,"unter 5")   = 5;

           v_farmHa.lo(rAllCur,"insgesamt",types,"5 - 10")    = 5;
           v_farmHa.up(rAllCur,"insgesamt",types,"5 - 10")    = 10;

           v_farmHa.lo(rAllCur,"insgesamt",types,"10 - 20")   = 10;
           v_farmHa.up(rAllCur,"insgesamt",types,"10 - 20")   = 20;

           v_farmHa.lo(rAllCur,"insgesamt",types,"20 - 50")   = 20;
           v_farmHa.up(rAllCur,"insgesamt",types,"20 - 50")   = 50;

           v_farmHa.lo(rAllCur,"insgesamt",types,"50 - 100")  = 50;
           v_farmHa.up(rAllCur,"insgesamt",types,"50 - 100")  = 100;

           v_farmHa.lo(rAllCur,"insgesamt",types,"100 - 200")  = 100;
           v_farmHa.up(rAllCur,"insgesamt",types,"100 - 200")  = 200;

           v_farmHa.lo(rAllCur,"insgesamt",types,"100 und mehr")  = 100;
           v_farmHa.up(rAllCur,"insgesamt",types,"100 und mehr")  = 10000;

           v_farmHa.lo(rAllCur,"insgesamt",types,"200 und mehr")  = 200;
           v_farmHa.up(rAllCur,"insgesamt",types,"200 und mehr")  = 10000;

           v_farmHa.lo(rAllCur,"insgesamt",types,sizeClass) = max(0.1,v_farmHa.lo(rAllCur,"insgesamt",types,sizeClass)-1);
           v_farmHa.up(rAllCur,"insgesamt",types,sizeClass) = v_farmHa.up(rAllCur,"insgesamt",types,sizeClass)+1;

           v_farmHa.lo(rAllCur,landUseLF,types,sizeClass) = 0.00;
           v_farmHa.up(rAllCur,landUseLF,types,sizeClass) = v_farmHa.up(rAllCur,"insgesamt",types,sizeClass);
*
*          --- fix cross-tabular given data
*
           v_nFarm.lo(rAllCur,types,sizeClassC)
              $ ( (p_crossData(rAllCur,types,sizeClassC) ne 1.E-10) and (not rCur(rAllCur)))
                  = max(0,p_crossData(rAllCur,types,sizeClassC)-1);

           v_nFarm.up(rAllCur,types,sizeClassC)
              $ ( (p_crossData(rAllCur,types,sizeClassC) ne 1.E-10) and (not rCur(rAllCur)))
                  = p_crossData(rAllCur,types,sizeClassC)+1;

           v_crossData.lo(rAllCur,landUseLF,sizeClassC)
              $ ( (p_crossData(rAllCur,landUseLF,sizeClassC) ne 1.E-10) and (not rCur(rAllCur)))
                 = max(0,p_crossData(rAllCur,landUseLF,sizeClassC)-50);

           v_crossData.up(rAllCur,landUseLF,sizeClassC)
              $ ( (p_crossData(rAllCur,landUseLF,sizeClassC) ne 1.E-10) and (not rCur(rAllCur)))
                 = p_crossData(rAllCur,landUseLF,sizeClassC)+50;

*
*         --- fix cross-tabular cells to zero in communes if either no farms of that type/land use
*             or no farms of that size class found in statistics for that commune
*
           v_nFarm.fx(rCur,types,sizeClass) $ (    (not p_GemeindeData(rCur,'Betriebe',types))
                                                or (not p_GemeindeData(rCur,'Betriebe',sizeClass))) = 0;

           v_FarmHa.fx(rCur,landUSeLF,types,sizeClass) $ (    (not p_GemeindeData(rCur,'Betriebe',types))
                                                           or (not p_GemeindeData(rCur,'Betriebe',sizeClass))
                                                           or (not p_GemeindeData(rCur,'Betriebe',landUseLF))
                                                           ) = 0;

           v_crossData.fx(rCur,landUseLf,SizeClass) $ (   (not p_GemeindeData(rCur,'Betriebe',landUseLF))
                                                       or (not p_GemeindeData(rCur,'Betriebe',sizeClass))) = 0;

*
*         --- same for mean size
*
           p_meanSize(rCur,landuse,sizeClass) $   (    (not p_GemeindeData(rCur,'Betriebe',landUse))
                                                     or (not p_GemeindeData(rCur,'Betriebe',sizeClass))) = 0;
*
*         --- a priori assumption: same relative distribution as at higher level,
*                             round to pull against integers, add eps
*                             to make a difference between am empty cell and
*                             numbers < 0.5 rounded to zero
*
          p_target(rCur,types,sizeClass) $ (    p_GemeindeData(rCur,'Betriebe',types)
                                            and p_GemeindeData(rCur,'Betriebe',sizeClass))
           = p_GemeindeData(rCur,'Betriebe','Betriebe')
                * sum( kreis_gemeinden(kreise,rCur), p_share(kreise,types,sizeClass));

          p_target(rCur,types,sizeClass) $ ( (not p_target(rCur,types,sizeClass))
                                              and  p_GemeindeData(rCur,'Betriebe',types)
                                              and p_GemeindeData(rCur,'Betriebe',sizeClass))

           = p_GemeindeData(rCur,'Betriebe','Betriebe')
                * sum( regBez_kreise(regBez,rCur), p_share(regBez,types,sizeClass));

          p_target(rCur,typesLandUse,sizeClass) $ p_target(rCur,typesLandUse,sizeClass)
           = round(p_target(rCur,typesLandUse,sizeClass)) + eps;
*
*         --- zero numbers are pulled to zero (see HDP definition)
*
           p_target(rCur,typesLandUse,sizeClass) $ (p_target(rCur,typesLandUse,sizeClass)
                                                   $ (p_target(rCur,typesLandUse,sizeClass) eq eps))
            = -max(0.0001,(p_GemeindeData(rCur,'Betriebe','Betriebe')
                              * sum( kreis_gemeinden(kreise,rCur), p_share(kreise,typesLandUse,sizeClass)))*0.1);

*          display p_target;
*
*        --- Load all result for estimation using fractional variables
*
           $$ifthen exist "farmStructEst1.gdx1"

                execute_load "farmStructEst1.gdx" p_res;
                v_nFarm.l(rAllCur,types,sizeClass)                 = p_res(rAllCur,types,sizeClass,"n");
                v_farmHa.l(rAllCur,landUseLF,types,sizeClass)      = p_res(rAllCur,types,sizeClass,landUseLF);

           $$else

                v_nFarm.l(rCur,types,sizeClass) $ (p_target(rCur,types,sizeClass) gt 0) = p_target(rCur,types,sizeClass);


           $$endif

           $$include 'ini.gms'
*
*          ---- default case that number of farms with land use in a size class
*               should exceed total number of farms in that size class
*
           solve m_farmStruct using NLP minimizing v_dummy;
           if ( m_farmStruct.iterlim eq 0, abort "test with zero iterations");

           loop(tries $ (m_farmStruct.sumInfes > 0),
*
              v_crossData.lo(rAllCur,landUseLF,sizeClassC)
                    $ ( (v_crossData.l(rAllCur,landUseLF,sizeClassC) eq v_crossData.lo(rAllCur,landUseLF,sizeClassC))
                            $  (abs(v_crossData.m(rAllCur,landUseLF,sizeClassC)) gt eps))
                   = max(0,v_crossData.lo(rAllCur,landUseLF,sizeClassC)-50);
*
              v_crossData.up(rAllCur,landUseLF,sizeClassC)
                    $ ( (v_crossData.l(rAllCur,landUseLF,sizeClassC) eq v_crossData.up(rAllCur,landUseLF,sizeClassC))
                            $  (abs(v_crossData.m(rAllCur,landUseLF,sizeClassC)) gt eps))
                   = v_crossData.up(rAllCur,landUseLF,sizeClassC)+50;

              v_nFarm.lo(rCurKreisGem,types,sizeClassC)
                $ ( (v_nFarm.lo(rCurKreisGem,types,sizeClassC) eq v_nFarm.l(rCurKreisGem,types,sizeClassC))
                     $ (abs(v_nFarm.m(rCurKreisGem,types,sizeClassC)) gt eps))
                   = max(0,v_nFarm.lo(rCurKreisGem,types,sizeClassC)-1);

              v_nFarm.up(rCurKreisGem,types,sizeClassC)
                $ ( (v_nFarm.up(rCurKreisGem,types,sizeClassC) eq v_nFarm.l(rCurKreisGem,types,sizeClassC))
                     $ (abs(v_nFarm.m(rCurKreisGem,types,sizeClassC)) gt eps))
                   = v_nFarm.up(rCurKreisGem,types,sizeClassC)+1;

              p_slack = p_slack+1;

               $$ifthen exist "farmStructEst1.gdx1"

                 execute_load "farmStructEst1.gdx" p_res;
                 v_nFarm.l(rAllCur,types,sizeClass)          = p_res(rAllCur,types,sizeClass,"n");
                 v_farmHa.l(rAllCur,landUseLF,types,sizeClass)      = p_res(rAllCur,types,sizeClass,landUseLF);

               $$else

*                   v_nFarm.l(rCur,types,sizeClass) $ (p_target(rCur,types,sizeClass) gt 0) = p_target(rCur,types,sizeClass);


               $$endif
*              $$include 'ini.gms'

                if ( tries.pos eq card(tries), m_farmStruct.solprint = 1);
                solve m_farmStruct using NLP minimizing v_dummy;
            );

            p_res(rAllCur,types,sizeClass,"n")          = v_nFarm.l(rAllCur,types,sizeClass);
            p_res(rAllCur,types,sizeClass,landuseLF)    = v_farmHa.l(rAllCur,landUseLF,types,sizeClass);
            execute_unload "farmStructEst1.gdx" p_res,v_nFarm;
            solve m_farmStruct using NLP minimizing v_dummy;
*
*          --- stop program execution with error message if still infeasible
*           after introduction of slacks
*
            display m_farmStruct.sumInfes;
            if ( m_farmStruct.sumInfes > 0, abort "No solution for RMIP",curRegBez);


        else
           m_farmStruct.solprint = 1;
           $$ifthen exist "farmStructEst2.gdx1"

              execute_load "farmStructEst2.gdx" p_res;
              v_nFarm.l(rAllCur,types,sizeClass)             = p_res(rAllCur,types,sizeClass,"n");
              v_farmHa.l(rAllCur,landUseLF,types,sizeClass)  = p_res(rAllCur,types,sizeClass,landUseLF);
           $$endif
           solve m_farmStruct using NLP minimizing v_hpd;
*
*          --- Store results for later restart
*
           p_res(rAllCur,types,sizeClass,"n")          = v_nFarm.l(rAllCur,types,sizeClass);
           p_res(rAllCur,types,sizeClass,landuseLF)    = v_farmHa.l(rAllCur,landUseLF,types,sizeClass);
           execute_unload "farmStructEst2.gdx" p_res;

*          -------------------------------------------------------------------------------------------
*
*            Re-use estimation framework to move from fractionals to integer estimates
*
*          -------------------------------------------------------------------------------------------

*
*            --- load previous results from integer step
*
           $$ifthen exist "farmStructEst2.gdx1"
              execute_load "farmStructEst2.gdx" p_res;
              v_nFarm.l(rAllCur,types,sizeClass)                 = p_res(rAllCur,types,sizeClass,"n");
              v_farmHa.l(rAllCur,landUseLF,types,sizeClass)      = p_res(rAllCur,types,sizeClass,landUseLF);
              v_farmHa.l(rAllCur,"insgesamt",types,sizeClassC)   =  sum(landuseLF, v_farmHa.l(rAllCur,landUseLF,types,sizeClassC));
           $$endif

           option kill=p_target;

*
*          --- lower bounds are floor
*
           v_nFarm.lo(rAllCur,types,sizeClass) $ (v_nFarm.range(rAllCur,types,sizeClass) ne 0)
              = max(0,floor(v_nFarm.l(rAllCur,types,sizeClass)));

           v_nFarm.up(rAllCur,types,sizeClass) $ (v_nFarm.range(rAllCur,types,sizeClass) ne 0)
              = ceil(v_nFarm.l(rAllCur,types,sizeClass));

           loop(tries $ (m_farmStruct.sumInfes eq 0),

               roundAcc   = 10**(-min(5,max(1,(card(tries)-tries.pos))));

               v_nFarm.fx(rCur,types,sizeClassG) $
                    ( (     (v_nFarm.l(rCur,types,sizeClassG) gt (round(v_nFarm.l(rCur,types,sizeClassG))-roundAcc) )
                        and (v_nFarm.l(rCur,types,sizeClassG) lt (round(v_nFarm.l(rCur,types,sizeClassG))+roundAcc) )
                       )
                        $ (v_nFarm.range(rCur,types,sizeClassG) ne 0)
                     ) = round(v_nFarm.l(rCur,types,sizeClassG));

*              m_farmStruct.solprint = 0;
*
*              --- a priori is the lower bounds minus 10 (plus some "noise" to treat equal estimate such as 0.5 0.5 slighly different)
*
               p_target(rCur,types,sizeClassG) $ ( (v_nFarm.range(rCur,types,sizeClassG) ne 0)
                                                       $ ((v_nFarm.l(rCur,types,sizeClassG)-0.5) le v_nFarm.lo(rCur,types,sizeClassG)))
                  = max(-20+ (types.pos*0.01) + (sizeClassG.pos*0.02),
                             v_nFarm.lo(rCur,types,sizeClassG)
                                - 1/(v_nFarm.l(rCur,types,sizeClassG)-v_nFarm.lo(rCur,types,sizeClassG))
                                     *diffWeight  + (types.pos*0.01) + (sizeClassG.pos*0.02));
*
*              --- a priori for closer to lower bound with lower bound = 0
*
               p_target(rCur,types,sizeClassG) $ ( (v_nFarm.range(rCur,types,sizeClassG) ne 0)
                                                    $ ((v_nFarm.l(rCur,types,sizeClassG)-0.5) le v_nFarm.lo(rCur,types,sizeClassG))
                                                    $ (v_nFarm.up(rCur,types,sizeClassG) eq 1))
                  = -max(1,1/(v_nFarm.l(rCur,types,sizeClassG)*diffWeight*uniform(0.9,1.1) + (types.pos*0.01) + (sizeClassG.pos*0.02)));

*
*              --- a priori for closer to upper bound
*
               p_target(rCur,types,sizeClassG) $ ( (v_nFarm.range(rCur,types,sizeClassG) ne 0)
                                                       $ ((v_nFarm.l(rCur,types,sizeClassG)-0.5) gt v_nFarm.lo(rCur,types,sizeClassG)))
                  = max(0.2+ (types.pos*0.01) + (sizeClassG.pos*0.02),
                              v_nFarm.up(rCur,types,sizeClassG)
                                +  1/(v_nFarm.up(rCur,types,sizeClassG)-v_nFarm.l(rCur,types,sizeClassG))
                                     *diffWeight  + (types.pos*0.01) + (sizeClassG.pos*0.02));

               m_farmStruct.reslim = 30*60;
               m_farmStruct.solprint = 1;
               solve m_farmStruct using NLP minimizing v_HPD;
               p_res(rAllCur,types,sizeClass,tries)   = v_nFarm.l(rAllCur,types,sizeClass);
               p_res(rAllCur,types,sizeClassG,tries)  = v_nFarm.l(rAllCur,types,sizeClassG);
               p_res(rAllCur,"unfixed","",tries)      = sum ( (types,sizeClassG) $ (v_nFarm.range(rAllCur,types,sizeClassG) ne 0),1);
               p_res(curRegBez,"unfixed","",tries)    = sum(rcur, p_res(rCur,"unfixed","",tries));
               execute_unload "farmStructEst3.gdx" p_res;
           );

*
*          --- store results
*
           p_res(rAllCur,types,sizeClass,"n")          = v_nFarm.l(rAllCur,types,sizeClass);
           p_res(rAllCur,types,sizeClass,landuseLF)    = v_farmHa.l(rAllCur,landUseLF,types,sizeClass);

           p_res(rAllCur,'Betriebe','Betriebe',"n")  = sum( (types,sizeClassG),  v_nFarm.l(rAllCur,types,sizeClassG));
           p_res(rAllCur,'Betriebe',sizeClassG,"n")  = sum( (types),             v_nFarm.l(rAllCur,types,sizeClassG));
           p_res(rAllCur,types,'Betriebe',"n")       = sum( (sizeClassG),        v_nFarm.l(rAllCur,types,sizeClassG));
           execute_unload "farmStructEst.gdx" p_res;
        );
    );
 );

*$offtext
*
* --- Assign results
*
SET GN /
"Aachen"
"Ahaus"
"Ahlen"
"Aldenhoven"
"Alfter"
"Alpen"
"Alsdorf"
"Altena"
"Altenbeken"
"Altenberge"
"Anroechte"
"Arnsberg"
"Ascheberg"
"Attendorn"
"Augustdorf"
"Bad Berleburg"
"Bad Driburg"
"Bad Honnef"
"Bad Laasphe"
"Bad Lippspringe"
"Bad Muenstereifel"
"Bad Oeynhausen"
"Bad Salzuflen"
"Bad Sassendorf"
"Bad Wuennenberg"
"Baesweiler"
"Balve"
"Barntrup"
"Beckum"
"Bedburg"
"Bedburg-Hau"
"Beelen"
"Bergheim"
"Bergisch Gladbach"
"Bergkamen"
"Bergneustadt"
"Bestwig"
"Beverungen"
"Bielefeld"
"Billerbeck"
"Blankenheim"
"Blomberg"
"Bocholt"
"Bochum"
"Boenen"
"Bonn"
"Borchen"
"Borgentreich"
"Borgholzhausen"
"Borken"
"Bornheim"
"Bottrop"
"Brakel"
"Breckerfeld"
"Brilon"
"Brueggen"
"Bruehl"
"Buende"
"Bueren"
"Burbach"
"Burscheid"
"Castrop-Rauxel"
"Coesfeld"
"Dahlem"
"Datteln"
"Delbrueck"
"Detmold"
"Dinslaken"
"Doerentrup"
"Dormagen"
"Dorsten"
"Dortmund"
"Drensteinfurt"
"Drolshagen"
"Duelmen"
"Dueren"
"Duesseldorf"
"Duisburg"
"Eitorf"
"Elsdorf"
"Emmerich am Rhein"
"Emsdetten"
"Engelskirchen"
"Enger"
"Ennepetal"
"Ennigerloh"
"Ense"
"Erftstadt"
"Erkelenz"
"Erkrath"
"Erndtebrueck"
"Erwitte"
"Eschweiler"
"Eslohe (Sauerland)"
"Espelkamp"
"Essen"
"Euskirchen"
"Everswinkel"
"Extertal"
"Finnentrop"
"Frechen"
"Freudenberg"
"Froendenberg/Ruhr"
"Gangelt"
"Geilenkirchen"
"Geldern"
"Gelsenkirchen"
"Gescher"
"Geseke"
"Gevelsberg"
"Gladbeck"
"Goch"
"Grefrath"
"Greven"
"Grevenbroich"
"Gronau (Westf.)"
"Guetersloh"
"Gummersbach"
"Haan"
"Hagen"
"Halle (Westf.)"
"Hallenberg"
"Haltern am See"
"Halver"
"Hamm"
"Hamminkeln"
"Harsewinkel"
"Hattingen"
"Havixbeck"
"Heek"
"Heiden"
"Heiligenhaus"
"Heimbach"
"Heinsberg"
"Hellenthal"
"Hemer"
"Hennef (Sieg)"
"Herdecke"
"Herford"
"Herne"
"Herscheid"
"Herten"
"Herzebrock-Clarholz"
"Herzogenrath"
"Hiddenhausen"
"Hilchenbach"
"Hilden"
"Hille"
"Hoerstel"
"Hoevelhof"
"Hoexter"
"Holzwickede"
"Hopsten"
"Horn-Bad Meinberg"
"Horstmar"
"Hueckelhoven"
"Hueckeswagen"
"Huellhorst"
"Huenxe"
"Huertgenwald"
"Huerth"
"Ibbenbueren"
"Inden"
"Iserlohn"
"Isselburg"
"Issum"
"Juechen"
"Juelich"
"Kaarst"
"Kalkar"
"Kall"
"Kalletal"
"Kamen"
"Kamp-Lintfort"
"Kempen"
"Kerken"
"Kerpen"
"Kevelaer"
"Kierspe"
"Kirchhundem"
"Kirchlengern"
"Kleve"
"Koeln"
"Koenigswinter"
"Korschenbroich"
"Kranenburg"
"Krefeld"
"Kreuzau"
"Kreuztal"
"Kuerten"
"Ladbergen"
"Laer"
"Lage"
"Langenberg"
"Langenfeld (Rhld.)"
"Langerwehe"
"Legden"
"Leichlingen (Rhld.)"
"Lemgo"
"Lengerich"
"Lennestadt"
"Leopoldshoehe"
"Leverkusen"
"Lichtenau"
"Lienen"
"Lindlar"
"Linnich"
"Lippetal"
"Lippstadt"
"Loehne"
"Lohmar"
"Lotte"
"Luebbecke"
"Luedenscheid"
"Luedinghausen"
"Luegde"
"Luenen"
"Marienheide"
"Marienmuenster"
"Marl"
"Marsberg"
"Mechernich"
"Meckenheim"
"Medebach"
"Meerbusch"
"Meinerzhagen"
"Menden (Sauerland)"
"Merzenich"
"Meschede"
"Metelen"
"Mettingen"
"Mettmann"
"Minden"
"Moehnesee"
"Moenchengladbach"
"Moers"
"Monheim am Rhein"
"Monschau"
"Morsbach"
"Much"
"Muelheim an der Ruhr"
"Muenster"
"Nachrodt-Wiblingwerde"
"Netphen"
"Nettersheim"
"Nettetal"
"Neuenkirchen"
"Neuenrade"
"Neukirchen-Vluyn"
"Neunkirchen"
"Neunkirchen-Seelscheid"
"Neuss"
"Nideggen"
"Niederkassel"
"Niederkruechten"
"Niederzier"
"Nieheim"
"Noervenich"
"Nordkirchen"
"Nordwalde"
"Nottuln"
"Nuembrecht"
"Oberhausen"
"Ochtrup"
"Odenthal"
"Oelde"
"Oer-Erkenschwick"
"Oerlinghausen"
"Olfen"
"Olpe"
"Olsberg"
"Ostbevern"
"Overath"
"Paderborn"
"Petershagen"
"Plettenberg"
"Porta Westfalica"
"Preussisch Oldendorf"
"Pulheim"
"Radevormwald"
"Raesfeld"
"Rahden"
"Ratingen"
"Recke"
"Recklinghausen"
"Rees"
"Reichshof"
"Reken"
"Remscheid"
"Rheda-Wiedenbrueck"
"Rhede"
"Rheinbach"
"Rheinberg"
"Rheine"
"Rheurdt"
"Rietberg"
"Roedinghausen"
"Roesrath"
"Roetgen"
"Rommerskirchen"
"Rosendahl"
"Ruethen"
"Ruppichteroth"
"Saerbeck"
"Salzkotten"
"Sankt Augustin"
"Sassenberg"
"Schalksmuehle"
"Schermbeck"
"Schieder-Schwalenberg"
"Schlangen"
"Schleiden"
"Schloss Holte-Stukenbrock"
"Schmallenberg"
"Schoeppingen"
"Schwalmtal"
"Schwelm"
"Schwerte"
"Selfkant"
"Selm"
"Senden"
"Sendenhorst"
"Siegburg"
"Siegen"
"Simmerath"
"Soest"
"Solingen"
"Sonsbeck"
"Spenge"
"Sprockhoevel"
"Stadtlohn"
"Steinfurt"
"Steinhagen"
"Steinheim"
"Stemwede"
"Stolberg (Rhld.)"
"Straelen"
"Suedlohn"
"Sundern (Sauerland)"
"Swisttal"
"Tecklenburg"
"Telgte"
"Titz"
"Toenisvorst"
"Troisdorf"
"Uebach-Palenberg"
"Uedem"
"Unna"
"Velbert"
"Velen"
"Verl"
"Versmold"
"Vettweiss"
"Viersen"
"Vlotho"
"Voerde (Niederrhein)"
"Vreden"
"Wachtberg"
"Wachtendonk"
"Wadersloh"
"Waldbroel"
"Waldfeucht"
"Waltrop"
"Warburg"
"Warendorf"
"Warstein"
"Wassenberg"
"Weeze"
"Wegberg"
"Weilerswist"
"Welver"
"Wenden"
"Werdohl"
"Werl"
"Wermelskirchen"
"Werne"
"Werther (Westf.)"
"Wesel"
"Wesseling"
"Westerkappeln"
"Wetter (Ruhr)"
"Wettringen"
"Wickede (Ruhr)"
"Wiehl"
"Willebadessen"
"Willich"
"Wilnsdorf"
"Windeck"
"Winterberg"
"Wipperfuerth"
"Witten"
"Wuelfrath"
"Wuerselen"
"Wuppertal"
"Xanten"
"Zuelpich"
/;

set GN_Gemeinden(*,Gemeinden)  /
 "Aachen"                          .    "Aachen, kreisfreie Stadt                                  "
 "Ahaus"                           .    "Ahaus, Stadt                                              "
 "Ahlen"                           .    "Ahlen, Stadt                                              "
 "Aldenhoven"                      .    "Aldenhoven                                                "
 "Alfter"                          .    "Alfter                                                    "
 "Alpen"                           .    "Alpen                                                     "
 "Alsdorf"                         .    "Alsdorf, Stadt                                            "
 "Altena"                          .    "Altena, Stadt                                             "
 "Altenbeken"                      .    "Altenbeken                                                "
 "Altenberge"                      .    "Altenberge                                                "
 "Anroechte"                       .    "Anroechte                                                 "
 "Arnsberg"                        .    "Arnsberg, Stadt                                           "
 "Ascheberg"                       .    "Ascheberg                                                 "
 "Attendorn"                       .    "Attendorn, Stadt                                          "
 "Augustdorf"                      .    "Augustdorf                                                "
 "Bad Berleburg"                   .    "Bad Berleburg, Stadt                                      "
 "Bad Driburg"                     .    "Bad Driburg, Stadt                                        "
 "Bad Honnef"                      .    "Bad Honnef, Stadt                                         "
 "Bad Laasphe"                     .    "Bad Laasphe, Stadt                                        "
 "Bad Lippspringe"                 .    "Bad Lippspringe, Stadt                                    "
 "Bad Muenstereifel"               .    "Bad Muenstereifel, Stadt                                  "
 "Bad Oeynhausen"                  .    "Bad Oeynhausen, Stadt                                     "
 "Bad Salzuflen"                   .    "Bad Salzuflen, Stadt                                      "
 "Bad Sassendorf"                  .    "Bad Sassendorf                                            "
 "Bad Wuennenberg"                 .    "Bad Wuennenberg, Stadt                                    "
 "Baesweiler"                      .    "Baesweiler, Stadt                                         "
 "Balve"                           .    "Balve, Stadt                                              "
 "Barntrup"                        .    "Barntrup, Stadt                                           "
 "Beckum"                          .    "Beckum, Stadt                                             "
 "Bedburg"                         .    "Bedburg, Stadt                                            "
 "Bedburg-Hau"                     .    "Bedburg-Hau                                               "
 "Beelen"                          .    "Beelen                                                    "
 "Bergheim"                        .    "Bergheim, Stadt                                           "
 "Bergisch Gladbach"               .    "Bergisch Gladbach, Stadt                                  "
 "Bergkamen"                       .    "Bergkamen, Stadt                                          "
 "Bergneustadt"                    .    "Bergneustadt, Stadt                                       "
 "Bestwig"                         .    "Bestwig                                                   "
 "Beverungen"                      .    "Beverungen, Stadt                                         "
 "Bielefeld"                       .    "Bielefeld                                                 "
 "Billerbeck"                      .    "Billerbeck, Stadt                                         "
 "Blankenheim"                     .    "Blankenheim                                               "
 "Blomberg"                        .    "Blomberg, Stadt                                           "
 "Bocholt"                         .    "Bocholt, Stadt                                            "
 "Bochum"                          .    "Bochum                                                    "
 "Boenen"                          .    "Boenen                                                    "
 "Bonn"                            .    "Bonn                                                      "
 "Borchen"                         .    "Borchen                                                   "
 "Borgentreich"                    .    "Borgentreich, Stadt                                       "
 "Borgholzhausen"                  .    "Borgholzhausen, Stadt                                     "
 "Borken"                          .    "Borken, Stadt                                             "
 "Bornheim"                        .    "Bornheim, Stadt                                           "
 "Bottrop"                         .    "Bottrop                                                   "
 "Brakel"                          .    "Brakel, Stadt                                             "
 "Breckerfeld"                     .    "Breckerfeld, Stadt                                        "
 "Brilon"                          .    "Brilon, Stadt                                             "
 "Brueggen"                        .    "Brueggen                                                  "
 "Bruehl"                          .    "Bruehl, Stadt                                             "
 "Buende"                          .    "Buende, Stadt                                             "
 "Bueren"                          .    "Bueren, Stadt                                             "
 "Burbach"                         .    "Burbach                                                   "
 "Burscheid"                       .    "Burscheid, Stadt                                          "
 "Castrop-Rauxel"                  .    "Castrop-Rauxel, Stadt                                     "
 "Coesfeld"                        .    "Coesfeld, Stadt                                           "
 "Dahlem"                          .    "Dahlem                                                    "
 "Datteln"                         .    "Datteln, Stadt                                            "
 "Delbrueck"                       .    "Delbrueck, Stadt                                          "
 "Detmold"                         .    "Detmold, Stadt                                            "
 "Dinslaken"                       .    "Dinslaken, Stadt                                          "
 "Doerentrup"                      .    "Doerentrup                                                "
 "Dormagen"                        .    "Dormagen, Stadt                                           "
 "Dorsten"                         .    "Dorsten, Stadt                                            "
 "Dortmund"                        .    "Dortmund                                                  "
 "Drensteinfurt"                   .    "Drensteinfurt, Stadt                                      "
 "Drolshagen"                      .    "Drolshagen, Stadt                                         "
 "Duelmen"                         .    "Duelmen, Stadt                                            "
 "Dueren"                          .    "Dueren, Stadt                                             "
 "Duesseldorf"                     .    "Duesseldorf                                               "
 "Duisburg"                        .    "Duisburg                                                  "
 "Eitorf"                          .    "Eitorf                                                    "
 "Elsdorf"                         .    "Elsdorf                                                   "
 "Emmerich am Rhein"               .    "Emmerich am Rhein, Stadt                                  "
 "Emsdetten"                       .    "Emsdetten, Stadt                                          "
 "Engelskirchen"                   .    "Engelskirchen                                             "
 "Enger"                           .    "Enger, Stadt                                              "
 "Ennepetal"                       .    "Ennepetal, Stadt                                          "
 "Ennigerloh"                      .    "Ennigerloh, Stadt                                         "
 "Ense"                            .    "Ense                                                      "
 "Erftstadt"                       .    "Erftstadt, Stadt                                          "
 "Erkelenz"                        .    "Erkelenz, Stadt                                           "
 "Erkrath"                         .    "Erkrath, Stadt                                            "
 "Erndtebrueck"                    .    "Erndtebrueck                                              "
 "Erwitte"                         .    "Erwitte, Stadt                                            "
 "Eschweiler"                      .    "Eschweiler, Stadt                                         "
 "Eslohe (Sauerland)"              .    "Eslohe (Sauerland)                                        "
 "Espelkamp"                       .    "Espelkamp, Stadt                                          "
 "Essen"                           .    "Essen                                                     "
 "Euskirchen"                      .    "Euskirchen, Stadt                                         "
 "Everswinkel"                     .    "Everswinkel                                               "
 "Extertal"                        .    "Extertal                                                  "
 "Finnentrop"                      .    "Finnentrop                                                "
 "Frechen"                         .    "Frechen, Stadt                                            "
 "Freudenberg"                     .    "Freudenberg, Stadt                                        "
 "Froendenberg/Ruhr"               .    "Froendenberg/Ruhr, Stadt                                  "
 "Gangelt"                         .    "Gangelt                                                   "
 "Geilenkirchen"                   .    "Geilenkirchen, Stadt                                      "
 "Geldern"                         .    "Geldern, Stadt                                            "
 "Gelsenkirchen"                   .    "Gelsenkirchen                                             "
 "Gescher"                         .    "Gescher, Stadt                                            "
 "Geseke"                          .    "Geseke, Stadt                                             "
 "Gevelsberg"                      .    "Gevelsberg, Stadt                                         "
 "Gladbeck"                        .    "Gladbeck, Stadt                                           "
 "Goch"                            .    "Goch, Stadt                                               "
 "Grefrath"                        .    "Grefrath                                                  "
 "Greven"                          .    "Greven, Stadt                                             "
 "Grevenbroich"                    .    "Grevenbroich, Stadt                                       "
 "Gronau (Westf.)"                 .    "Gronau (Westf.), Stadt                                    "
 "Guetersloh"                      .    "Guetersloh, Stadt                                         "
 "Gummersbach"                     .    "Gummersbach, Stadt                                        "
 "Haan"                            .    "Haan, Stadt                                               "
 "Hagen"                           .    "Hagen                                                     "
 "Halle (Westf.)"                  .    "Halle (Westf.), Stadt                                     "
 "Hallenberg"                      .    "Hallenberg, Stadt                                         "
 "Haltern am See"                  .    "Haltern am See, Stadt                                     "
 "Halver"                          .    "Halver, Stadt                                             "
 "Hamm"                            .    "Hamm                                                      "
 "Hamminkeln"                      .    "Hamminkeln, Stadt                                         "
 "Harsewinkel"                     .    "Harsewinkel, Stadt                                        "
 "Hattingen"                       .    "Hattingen, Stadt                                          "
 "Havixbeck"                       .    "Havixbeck                                                 "
 "Heek"                            .    "Heek                                                      "
 "Heiden"                          .    "Heiden                                                    "
 "Heiligenhaus"                    .    "Heiligenhaus, Stadt                                       "
 "Heimbach"                        .    "Heimbach, Stadt                                           "
 "Heinsberg"                       .    "Heinsberg, Stadt                                          "
 "Hellenthal"                      .    "Hellenthal                                                "
 "Hemer"                           .    "Hemer, Stadt                                              "
 "Hennef (Sieg)"                   .    "Hennef (Sieg), Stadt                                      "
 "Herdecke"                        .    "Herdecke, Stadt                                           "
 "Herford"                         .    "Herford, Stadt                                            "
 "Herne"                           .    "Herne                                                     "
 "Herscheid"                       .    "Herscheid                                                 "
 "Herten"                          .    "Herten, Stadt                                             "
 "Herzebrock-Clarholz"             .    "Herzebrock-Clarholz                                       "
 "Herzogenrath"                    .    "Herzogenrath, Stadt                                       "
 "Hiddenhausen"                    .    "Hiddenhausen                                              "
 "Hilchenbach"                     .    "Hilchenbach, Stadt                                        "
 "Hilden"                          .    "Hilden, Stadt                                             "
 "Hille"                           .    "Hille                                                     "
 "Hoerstel"                        .    "Hoerstel, Stadt                                           "
 "Hoevelhof"                       .    "Hoevelhof                                                 "
 "Hoexter"                         .    "Hoexter, Stadt                                            "
 "Holzwickede"                     .    "Holzwickede                                               "
 "Hopsten"                         .    "Hopsten                                                   "
 "Horn-Bad Meinberg"               .    "Horn-Bad Meinberg, Stadt                                  "
 "Horstmar"                        .    "Horstmar, Stadt                                           "
 "Hueckelhoven"                    .    "Hueckelhoven, Stadt                                       "
 "Hueckeswagen"                    .    "Hueckeswagen, Stadt                                       "
 "Huellhorst"                      .    "Huellhorst                                                "
 "Huenxe"                          .    "Huenxe                                                    "
 "Huertgenwald"                    .    "Huertgenwald                                              "
 "Huerth"                          .    "Huerth, Stadt                                             "
 "Ibbenbueren"                     .    "Ibbenbueren, Stadt                                        "
 "Inden"                           .    "Inden                                                     "
 "Iserlohn"                        .    "Iserlohn, Stadt                                           "
 "Isselburg"                       .    "Isselburg, Stadt                                          "
 "Issum"                           .    "Issum                                                     "
 "Juechen"                         .    "Juechen                                                   "
 "Juelich"                         .    "Juelich, Stadt                                            "
 "Kaarst"                          .    "Kaarst, Stadt                                             "
 "Kalkar"                          .    "Kalkar, Stadt                                             "
 "Kall"                            .    "Kall                                                      "
 "Kalletal"                        .    "Kalletal                                                  "
 "Kamen"                           .    "Kamen, Stadt                                              "
 "Kamp-Lintfort"                   .    "Kamp-Lintfort, Stadt                                      "
 "Kempen"                          .    "Kempen, Stadt                                             "
 "Kerken"                          .    "Kerken                                                    "
 "Kerpen"                          .    "Kerpen, Stadt                                             "
 "Kevelaer"                        .    "Kevelaer, Stadt                                           "
 "Kierspe"                         .    "Kierspe, Stadt                                            "
 "Kirchhundem"                     .    "Kirchhundem                                               "
 "Kirchlengern"                    .    "Kirchlengern                                              "
 "Kleve"                           .    "Kleve, Stadt                                              "
 "Koeln"                           .    "Koeln                                                     "
 "Koenigswinter"                   .    "Koenigswinter, Stadt                                      "
 "Korschenbroich"                  .    "Korschenbroich, Stadt                                     "
 "Kranenburg"                      .    "Kranenburg                                                "
 "Krefeld"                         .    "Krefeld                                                   "
 "Kreuzau"                         .    "Kreuzau                                                   "
 "Kreuztal"                        .    "Kreuztal, Stadt                                           "
 "Kuerten"                         .    "Kuerten                                                   "
 "Ladbergen"                       .    "Ladbergen                                                 "
 "Laer"                            .    "Laer                                                      "
 "Lage"                            .    "Lage, Stadt                                               "
 "Langenberg"                      .    "Langenberg                                                "
 "Langenfeld (Rhld.)"              .    "Langenfeld (Rheinland), Stadt                             "
 "Langerwehe"                      .    "Langerwehe                                                "
 "Legden"                          .    "Legden                                                    "
 "Leichlingen (Rhld.)"             .    "Leichlingen (Rheinland), Stadt                            "
 "Lemgo"                           .    "Lemgo, Stadt                                              "
 "Lengerich"                       .    "Lengerich, Stadt                                          "
 "Lennestadt"                      .    "Lennestadt, Stadt                                         "
 "Leopoldshoehe"                   .    "Leopoldshoehe                                             "
 "Leverkusen"                      .    "Leverkusen                                                "
 "Lichtenau"                       .    "Lichtenau, Stadt                                          "
 "Lienen"                          .    "Lienen                                                    "
 "Lindlar"                         .    "Lindlar                                                   "
 "Linnich"                         .    "Linnich, Stadt                                            "
 "Lippetal"                        .    "Lippetal                                                  "
 "Lippstadt"                       .    "Lippstadt, Stadt                                          "
 "Loehne"                          .    "Loehne, Stadt                                             "
 "Lohmar"                          .    "Lohmar, Stadt                                             "
 "Lotte"                           .    "Lotte                                                     "
 "Luebbecke"                       .    "Luebbecke, Stadt                                          "
 "Luedenscheid"                    .    "Luedenscheid, Stadt                                       "
 "Luedinghausen"                   .    "Luedinghausen, Stadt                                      "
 "Luegde"                          .    "Luegde, Stadt                                             "
 "Luenen"                          .    "Luenen, Stadt                                             "
 "Marienheide"                     .    "Marienheide                                               "
 "Marienmuenster"                  .    "Marienmuenster, Stadt                                     "
 "Marl"                            .    "Marl, Stadt                                               "
 "Marsberg"                        .    "Marsberg, Stadt                                           "
 "Mechernich"                      .    "Mechernich, Stadt                                         "
 "Meckenheim"                      .    "Meckenheim, Stadt                                         "
 "Medebach"                        .    "Medebach, Stadt                                           "
 "Meerbusch"                       .    "Meerbusch, Stadt                                          "
 "Meinerzhagen"                    .    "Meinerzhagen, Stadt                                       "
 "Menden (Sauerland)"              .    "Menden (Sauerland), Stadt                                 "
 "Merzenich"                       .    "Merzenich                                                 "
 "Meschede"                        .    "Meschede, Stadt                                           "
 "Metelen"                         .    "Metelen                                                   "
 "Mettingen"                       .    "Mettingen                                                 "
 "Mettmann"                        .    "Mettmann, Stadt                                           "
 "Minden"                          .    "Minden, Stadt                                             "
 "Moehnesee"                       .    "Moehnesee                                                 "
 "Moenchengladbach"                .    "Moenchengladbach                                          "
 "Moers"                           .    "Moers, Stadt                                              "
 "Monheim am Rhein"                .    "Monheim am Rhein, Stadt                                   "
 "Monschau"                        .    "Monschau, Stadt                                           "
 "Morsbach"                        .    "Morsbach                                                  "
 "Much"                            .    "Much                                                      "
 "Muelheim an der Ruhr"            .    "Muelheim an der Ruhr                                      "
 "Muenster"                        .    "Muenster                                                  "
 "Nachrodt-Wiblingwerde"           .    "Nachrodt-Wiblingwerde                                     "
 "Netphen"                         .    "Netphen, Stadt                                            "
 "Nettersheim"                     .    "Nettersheim                                               "
 "Nettetal"                        .    "Nettetal, Stadt                                           "
 "Neuenkirchen"                    .    "Neuenkirchen                                              "
 "Neuenrade"                       .    "Neuenrade, Stadt                                          "
 "Neukirchen-Vluyn"                .    "Neukirchen-Vluyn, Stadt                                   "
 "Neunkirchen"                     .    "Neunkirchen                                               "
 "Neunkirchen-Seelscheid"          .    "Neunkirchen-Seelscheid                                    "
 "Neuss"                           .    "Neuss, Stadt                                              "
 "Nideggen"                        .    "Nideggen, Stadt                                           "
 "Niederkassel"                    .    "Niederkassel, Stadt                                       "
 "Niederkruechten"                 .    "Niederkruechten                                           "
 "Niederzier"                      .    "Niederzier                                                "
 "Nieheim"                         .    "Nieheim, Stadt                                            "
 "Noervenich"                      .    "Noervenich                                                "
 "Nordkirchen"                     .    "Nordkirchen                                               "
 "Nordwalde"                       .    "Nordwalde                                                 "
 "Nottuln"                         .    "Nottuln                                                   "
 "Nuembrecht"                      .    "Nuembrecht                                                "
 "Oberhausen"                      .    "Oberhausen                                                "
 "Ochtrup"                         .    "Ochtrup, Stadt                                            "
 "Odenthal"                        .    "Odenthal                                                  "
 "Oelde"                           .    "Oelde, Stadt                                              "
 "Oer-Erkenschwick"                .    "Oer-Erkenschwick, Stadt                                   "
 "Oerlinghausen"                   .    "Oerlinghausen, Stadt                                      "
 "Olfen"                           .    "Olfen, Stadt                                              "
 "Olpe"                            .    "Olpe, Stadt                                               "
 "Olsberg"                         .    "Olsberg, Stadt                                            "
 "Ostbevern"                       .    "Ostbevern                                                 "
 "Overath"                         .    "Overath, Stadt                                            "
 "Paderborn"                       .    "Paderborn, Stadt                                          "
 "Petershagen"                     .    "Petershagen, Stadt                                        "
 "Plettenberg"                     .    "Plettenberg, Stadt                                        "
 "Porta Westfalica"                .    "Porta Westfalica, Stadt                                   "
 "Preussisch Oldendorf"            .    "Preussisch Oldendorf, Stadt                               "
 "Pulheim"                         .    "Pulheim, Stadt                                            "
 "Radevormwald"                    .    "Radevormwald, Stadt                                       "
 "Raesfeld"                        .    "Raesfeld                                                  "
 "Rahden"                          .    "Rahden, Stadt                                             "
 "Ratingen"                        .    "Ratingen, Stadt                                           "
 "Recke"                           .    "Recke                                                     "
 "Recklinghausen"                  .    "Recklinghausen, Stadt                                     "
 "Rees"                            .    "Rees, Stadt                                               "
 "Reichshof"                       .    "Reichshof                                                 "
 "Reken"                           .    "Reken                                                     "
 "Remscheid"                       .    "Remscheid                                                 "
 "Rheda-Wiedenbrueck"              .    "Rheda-Wiedenbrueck, Stadt                                 "
 "Rhede"                           .    "Rhede, Stadt                                              "
 "Rheinbach"                       .    "Rheinbach, Stadt                                          "
 "Rheinberg"                       .    "Rheinberg, Stadt                                          "
 "Rheine"                          .    "Rheine, Stadt                                             "
 "Rheurdt"                         .    "Rheurdt                                                   "
 "Rietberg"                        .    "Rietberg, Stadt                                           "
 "Roedinghausen"                   .    "Roedinghausen                                             "
 "Roesrath"                        .    "Roesrath, Stadt                                           "
 "Roetgen"                         .    "Roetgen                                                   "
 "Rommerskirchen"                  .    "Rommerskirchen                                            "
 "Rosendahl"                       .    "Rosendahl                                                 "
 "Ruethen"                         .    "Ruethen, Stadt                                            "
 "Ruppichteroth"                   .    "Ruppichteroth                                             "
 "Saerbeck"                        .    "Saerbeck                                                  "
 "Salzkotten"                      .    "Salzkotten, Stadt                                         "
 "Sankt Augustin"                  .    "Sankt Augustin, Stadt                                     "
 "Sassenberg"                      .    "Sassenberg, Stadt                                         "
 "Schalksmuehle"                   .    "Schalksmuehle                                             "
 "Schermbeck"                      .    "Schermbeck                                                "
 "Schieder-Schwalenberg"           .    "Schieder-Schwalenberg, Stadt                              "
 "Schlangen"                       .    "Schlangen                                                 "
 "Schleiden"                       .    "Schleiden, Stadt                                          "
 "Schloss Holte-Stukenbrock"       .    "Schloss Holte-Stukenbrock, Stadt                          "
 "Schmallenberg"                   .    "Schmallenberg, Stadt                                      "
 "Schoeppingen"                    .    "Schoeppingen                                              "
 "Schwalmtal"                      .    "Schwalmtal                                                "
 "Schwelm"                         .    "Schwelm, Stadt                                            "
 "Schwerte"                        .    "Schwerte, Stadt                                           "
 "Selfkant"                        .    "Selfkant                                                  "
 "Selm"                            .    "Selm, Stadt                                               "
 "Senden"                          .    "Senden                                                    "
 "Sendenhorst"                     .    "Sendenhorst, Stadt                                        "
 "Siegburg"                        .    "Siegburg, Stadt                                           "
 "Siegen"                          .    "Siegen, Stadt                                             "
 "Simmerath"                       .    "Simmerath                                                 "
 "Soest"                           .    "Soest, Stadt                                              "
 "Solingen"                        .    "Solingen                                                  "
 "Sonsbeck"                        .    "Sonsbeck                                                  "
 "Spenge"                          .    "Spenge, Stadt                                             "
 "Sprockhoevel"                    .    "Sprockhoevel, Stadt                                       "
 "Stadtlohn"                       .    "Stadtlohn, Stadt                                          "
 "Steinfurt"                       .    "Steinfurt, Stadt                                          "
 "Steinhagen"                      .    "Steinhagen                                                "
 "Steinheim"                       .    "Steinheim, Stadt                                          "
 "Stemwede"                        .    "Stemwede                                                  "
 "Stolberg (Rhld.)"                .    "Stolberg (Rhld.), Stadt                                   "
 "Straelen"                        .    "Straelen, Stadt                                           "
 "Suedlohn"                        .    "Suedlohn                                                  "
 "Sundern (Sauerland)"             .    "Sundern (Sauerland), Stadt                                "
 "Swisttal"                        .    "Swisttal                                                  "
 "Tecklenburg"                     .    "Tecklenburg, Stadt                                        "
 "Telgte"                          .    "Telgte, Stadt                                             "
 "Titz"                            .    "Titz                                                      "
 "Toenisvorst"                     .    "Toenisvorst, Stadt                                        "
 "Troisdorf"                       .    "Troisdorf, Stadt                                          "
 "Uebach-Palenberg"                .    "uebach-Palenberg, Stadt                                   "
 "Uedem"                           .    "Uedem                                                     "
 "Unna"                            .    "Unna, Stadt                                               "
 "Velbert"                         .    "Velbert, Stadt                                            "
 "Velen"                           .    "Velen                                                     "
 "Verl"                            .    "Verl, Stadt                                               "
 "Versmold"                        .    "Versmold, Stadt                                           "
 "Vettweiss"                       .    "Vettweiss                                                 "
 "Viersen"                         .    "Viersen, Stadt                                            "
 "Vlotho"                          .    "Vlotho, Stadt                                             "
 "Voerde (Niederrhein)"            .    "Voerde (Niederrhein), Stadt                               "
 "Vreden"                          .    "Vreden, Stadt                                             "
 "Wachtberg"                       .    "Wachtberg                                                 "
 "Wachtendonk"                     .    "Wachtendonk                                               "
 "Wadersloh"                       .    "Wadersloh                                                 "
 "Waldbroel"                       .    "Waldbroel, Stadt                                          "
 "Waldfeucht"                      .    "Waldfeucht                                                "
 "Waltrop"                         .    "Waltrop, Stadt                                            "
 "Warburg"                         .    "Warburg, Stadt                                            "
 "Warendorf"                       .    "Warendorf, Stadt                                          "
 "Warstein"                        .    "Warstein, Stadt                                           "
 "Wassenberg"                      .    "Wassenberg, Stadt                                         "
 "Weeze"                           .    "Weeze                                                     "
 "Wegberg"                         .    "Wegberg, Stadt                                            "
 "Weilerswist"                     .    "Weilerswist                                               "
 "Welver"                          .    "Welver                                                    "
 "Wenden"                          .    "Wenden                                                    "
 "Werdohl"                         .    "Werdohl, Stadt                                            "
 "Werl"                            .    "Werl, Stadt                                               "
 "Wermelskirchen"                  .    "Wermelskirchen, Stadt                                     "
 "Werne"                           .    "Werne, Stadt                                              "
 "Werther (Westf.)"                .    "Werther (Westf.), Stadt                                   "
 "Wesel"                           .    "Wesel, Stadt                                              "
 "Wesseling"                       .    "Wesseling, Stadt                                          "
 "Westerkappeln"                   .    "Westerkappeln                                             "
 "Wetter (Ruhr)"                   .    "Wetter (Ruhr), Stadt                                      "
 "Wettringen"                      .    "Wettringen                                                "
 "Wickede (Ruhr)"                  .    "Wickede (Ruhr)                                            "
 "Wiehl"                           .    "Wiehl, Stadt                                              "
 "Willebadessen"                   .    "Willebadessen, Stadt                                      "
 "Willich"                         .    "Willich, Stadt                                            "
 "Wilnsdorf"                       .    "Wilnsdorf                                                 "
 "Windeck"                         .    "Windeck                                                   "
 "Winterberg"                      .    "Winterberg, Stadt                                         "
 "Wipperfuerth"                    .    "Wipperfuerth, Stadt                                       "
 "Witten"                          .    "Witten, Stadt                                             "
 "Wuelfrath"                       .    "Wuelfrath, Stadt                                          "
 "Wuerselen"                       .    "Wuerselen, Stadt                                          "
 "Wuppertal"                       .    "Wuppertal                                                 "
 "Xanten"                          .    "Xanten, Stadt                                             "
 "Zuelpich"                        .    "Zuelpich, Stadt                                           "

/;

scalar nGN; nGN = card(GN);display NGN;

*
* --------------------------------------------------------------------------------------------------
*
*
*   Generate data in format in ABM
*
*
* --------------------------------------------------------------------------------------------------


execute_load "farmStructEst.gdx" p_res;


   set SizeClasses / below5,from5to10,from10to20,from20to50,from50to100,from100to200,above200 /;

   set s_s(sizeClasses,sizeClass)
       / below5.'unter 5',
         from5to10.'5 - 10',
         from10to20.'10 - 20',
         from20to50.'20 - 50',
         from50to100.'50 - 100',
         from100to200.'100 - 200',
         above200.'200 und mehr' /;


  set farmTypes / Arable,Dairy,Pig,MixedLivestock,Mixed,Fixed /;

  set t_t(farmTypes,types) /
      Arable.('Ackerbau','Pflanzenbauverbund')
      Fixed.('Gartenbau','Dauerkultur'),
      Dairy.'FutterBau',
      Pig.'Veredlungs',
      MixedLivestock.('Viehaltungs','Viehhaltungsverbund'),
      Mixed.'Verbund' /;

   set landType / arab,gras,perm /;

   set landType_LF(landType,landUseLf) /

       arab. "Ackerland,LF",
       gras. "Dauergruenland,LF"
       perm. "Dauerkulturen,LF"
   /;


   parameter p_farmStruct(GN,farmTypes,SizeClasses)
             p_farmHa(GN,farmTypes,SizeClasses,landType);

   p_farmStruct(GN,farmTypes,SizeClasses)
     = sum( (GN_Gemeinden(GN,gemeinden),
             t_t(farmTypes,types),
             s_s(sizeClasses,sizeClass)),
                   p_res(gemeinden,types,sizeClass,"n"));

   p_farmHa(GN,farmTypes,SizeClasses,landType)
     = sum( (GN_Gemeinden(GN,gemeinden),
               t_t(farmTypes,types),
               s_s(sizeClasses,sizeClass),
               landType_LF(landType,landUseLf)),
                   p_res(gemeinden,types,sizeClass,landUseLF));

  execute_unload "..\admin_NRW_RR.gdx" p_farmStruct;



display p_farmStruct;
