C PROGRAM calculation H(sigma,a) Tabare Gallardo
      IMPLICIT REAL*8 (A-H,J-Z)
      CHARACTER*50 APESO
C CRITICAL ANGLE AND HAMILTONIAN
      DIMENSION SMA(400),HA(400)
      COMMON KK,KP,A1,E1,J1,L1,P1,A2nom,E2,J2,L2,P2
      TWOPI = 8.0D0*DATAN(1.0D0)
      CERO  = 0.0D0
      UNO   = 1.0D0
      PI=TWOPI/2.D0
      G2R=PI/180.D0
      KGAUS=0.01720209895D0
      KG2=KGAUS**2

      WRITE(*,*)'------------------------------------------------------'
      WRITE(*,*)'level curves for H(sigma,a)   '
      WRITE(*,*)'Gallardo 2020, CMDA 132 9'
      WRITE(*,*)'Tabare Gallardo                gallardo@fisica.edu.uy '
      WRITE(*,*)'bug STARM corrected in April 2025'
      WRITE(*,*)'bug sigma definition correction in August 2025'
      WRITE(*,*)'------------------------------------------------------'
      WRITE(*,*)'eccentric planet with i=lonod=loper=0'

      open(1,file="planet.inp",status="old")
      READ(1,*) APESO
      READ(1,*) STARM
      READ(1,*) APESO
      READ(1,*) A1,E1,SM1
      CLOSE(1)

      WRITE(*,*)'RESONANCE ?'
      WRITE(*,*)'(ex. 2,3 for plutinos; 3,2 for hildas)'
      READ(*,*) KP,KK
C MAXIMUM FOR CALCULATION OF THE INTEGRAL WITH ENOUGH PRECISION
      MAXFAC=KP
      IF(KK.GT.KP) THEN
        MAXFAC=KK
      ENDIF
C sigma = k*lambda - kp*lambda_p + (kp-k)*varpi
      WRITE(*,*)'ASTEROID''S ORBITAL ELEMENTS:  e,i,lonod,loper'
      READ(*,*)EXC,YNC,lonod,loper
      WRITE(*,*)'width in au for plotting?'
      READ(*,*) CHOAN

C THE PLANET IS 1
      J1=0.D0
      L1=0.D0
      P1=0.D0
c planet mean motion
      mmp=dsqrt(kg2*(STARM+sm1)/a1**3)
C PARTICLE IS 2
c resonant particle mean motion
      mmr=dabs(KP/KK)*mmp
C A2 NOMINAL
C ERROR CORRECTED APRIL 2025  --------------------------------------
C      A2NOM=(kg2/mmr**2)**(1.D0/3.D0)

      A2NOM=(kg2*starm/mmr**2)**(1.D0/3.D0)

      DELA=CHOAN/50.D0
      A2=A2NOM-DELA*25.D0
C varying semimajor axis
      DO 456 I1=1,50
        A2=A2+DELA
      E2=EXC
      J2GRA=YNC
      J2=J2GRA*G2R
      L2G=LONOD
      P2G=LOPER
      L2=L2G*G2R
      P2=P2G*G2R
C NUMBER OF EVALUATIONS OF R(sigma) BETWEEN O AND 360
      ISIMAX=360

C varying critical angle from 0 to 360
      DO ISI=1,ISIMAX
C ACRIT IS SIGMA
        ACRIT=DFLOAT(ISI-1)/DFLOAT(ISIMAX)*360.D0
C TETA IS THE COMBINATION OF LAMBDAS
C        TETA=ACRIT+ORQ*LOPER
        TETA=ACRIT - (KP-KK)*LOPER
C TO RADIANS
        TETAR=TETA*G2R
        TETAR=DMOD(TETAR,TWOPI)

C INTEGRAL LAMBDA_PLA
        RTOT=CERO
        TINTEGRAL=0.D0
C INITIAL STEP 1 DEGREE
        PASO=1.D0
        LA1G=-PASO
C LAMBDA PLANET FROM 0 TO 360*KK
        LIMIT=360.D0*DABS(KK)
   88   LA1G= LA1G + PASO
C CALCULATE DISTURBING FUNCTION A DISTANCE
        CALL RCALC(LA1G,TETAR,RPER,DELTA)
C WE GOT 360*NP, WE DO NOT COMPUTE THE INTEGRAL (IS THE SAME THAN 0)
        IF(LA1G.GE.LIMIT) THEN
          GOTO 99
        ENDIF
        TINTEGRAL=TINTEGRAL+RPER*PASO
        GOTO 88
C CRUDE INTEGRAL
  99    RTOT=TINTEGRAL/(360.D0*DABS(KK))
C NOW CALCULATE HAMILTONIAN  BUG CORRECTED, MISSED STARM
        HA(ISI)=-KG2*STARM/2.D0/A2 -mmp*DSQRT(kg2*STARM*A2)*dabs(KP/KK)
     *- RTOT*SM1*KG2
        SMA(ISI)=ACRIT
      ENDDO
C OUTPUT
      OPEN(1,FILE="hamilto.dat",STATUS="UNKNOWN",ACCESS="APPEND")
      WRITE(1,*)'   '
      DO I=1,ISIMAX
        WRITE(1,1000) A2,SMA(I),HA(I)
      ENDDO
C AT THE END REPEAT RESULT FOR SIGMA=0
      WRITE(1,1000) A2,360.0,HA(1)
      CLOSE(1)
  456 CONTINUE
 1000 FORMAT(F10.6,F7.2,E20.12)
      END
C********************************************************************
C********************************************************************
      SUBROUTINE RCALC(LA1G,TETAR,RPER,DELTA)
      IMPLICIT REAL*8 (A-H,J-Z)
      COMMON KK,KP,A1,E1,J1,L1,P1,A2nom,E2,J2,L2,P2
      TWOPI = 8.0D0*DATAN(1.0D0)
      CERO  = 0.0D0
      UNO   = 1.0D0
      PI=TWOPI/2.D0
      G2R=PI/180.D0

C RESONANT DISTURBING FUNCTION IS CALCULATED AT a2 nominal
      a2=a2nom
C PLANET++++++++++++++++++++++++++++++++++++++++++++++++
      LA1=LA1G*g2r
C MEAN ANOMALY PLANET assuming loper=0
      AM1=LA1
 200  IF (AM1.GT.TWOPI) THEN
        AM1=AM1-TWOPI
        GOTO 200
      END IF
 201  IF (AM1.LT.CERO) THEN
        AM1=AM1+TWOPI
        GOTO 201
      END IF
C PLANET IN excentric orbit
C SOLVING KEPLER FOR PLANET (ECCENTRIC)
      call SOLKEP(E1,AM1,AEX1)
C TRUE ANOMALY
      AVE1=DACOS((DCOS(AEX1)-E1)/(UNO-E1*DCOS(AEX1)))
      IF(AM1.GT.PI) AVE1=TWOPI-AVE1
C HELIOCENTRIC DISTANCE
      R1=A1*(UNO-E1*DCOS(AEX1))
C RADIUS VECTOR FOR planet
      X1=R1*(DCOS(L1)*DCOS(P1-L1+AVE1)-DSIN(L1)*DSIN(P1-L1+AVE1)
     **DCOS(J1))
      Y1=R1*(DSIN(L1)*DCOS(P1-L1+AVE1)+DCOS(L1)*DSIN(P1-L1+AVE1)
     **DCOS(J1))
      Z1=R1*DSIN(P1-L1+AVE1)*DSIN(J1)

C PARTICLE+++++++++++++++++++++++++++++++++++++++++++++++++++++
C GIVEN LAMBDA PLANET CALCULATE LAMBDA PARTICLE
C      LA2=(NPQ*LA1-TETAR)/NP
      LA2=(KP*LA1 + TETAR)/KK
C MEAN ANOMALY PARTICLE
      AM2=LA2-P2
 202  IF (AM2.GT.TWOPI) THEN
        AM2=AM2-TWOPI
        GOTO 202
      END IF
 203  IF (AM2.LT.CERO) THEN
        AM2=AM2+TWOPI
        GOTO 203
      END IF
C SOLVING KEPLER FOR PARTICLE (ECCENTRIC)
      call SOLKEP(E2,AM2,AEX2)
C TRUE ANOMALY
      AVE2=DACOS((DCOS(AEX2)-E2)/(UNO-E2*DCOS(AEX2)))
      IF(AM2.GT.PI) AVE2=TWOPI-AVE2
C HELIOCENTRIC DISTANCE
      R2=A2*(UNO-E2*DCOS(AEX2))
C RADIUS VECTOR FOR PARTICLE
      X2=R2*(DCOS(L2)*DCOS(P2-L2+AVE2)-DSIN(L2)*DSIN(P2-L2+AVE2)
     **DCOS(J2))
      Y2=R2*(DSIN(L2)*DCOS(P2-L2+AVE2)+DCOS(L2)*DSIN(P2-L2+AVE2)
     **DCOS(J2))
      Z2=R2*DSIN(P2-L2+AVE2)*DSIN(J2)
C MUTUAL DISTANCE
      DELTA=DSQRT((X1-X2)**2+(Y1-Y2)**2+(z1-Z2)**2)
C SCALAR PRODUCT R1*R2
      R1R2=X1*X2+Y1*Y2+z1*z2
C DIRECT PART
      RDIR=UNO/DELTA
C INDIRECT PART
      RIND=-R1R2/R1**3
C DISTURBING FUNCTION
      RPER=RDIR+RIND
      RETURN
      END
C********************************************************************
C ========================================================================
C SOLVING KEPLER
      SUBROUTINE SOLKEP(EX,M,E)
      IMPLICIT REAL*8 (A-H,O-Z)
      REAL*8 M,MK
      TOLE=1.D-12
C      TWOPI=8.D0*DATAN(1.D0)
C      M=DMOD(M,TWOPI)
      E=M
      NITER=0
 100  E0=E
      SE=DSIN(E0)
      CE=DCOS(E0)
      ES=EX*SE
      EC=1.D0-EX*CE
      MK=E0-ES
      U=(MK-M)/EC
      XPRI=E0-U
      XSEG=E0-U/(1.D0-U*ES)
      E=(XPRI+XSEG)/2.D0
      DEX=DABS(E-E0)
      NITER=NITER+1
C	 IF(NITER.GT.20)GOTO 200
      IF(DEX.GT.TOLE)GOTO 100
      RETURN
      END
C********************************************************************
C ========================================================================


