! 0) Constant and variable declaration
! Frame size:
        integer Maxwidth,Maxheight,irec,iwidth,iheight,i,j,ipad
        integer histo(0:255)
        parameter(Maxwidth=3220,Maxheight=2415)
        character header(54),ch
        character*24 dummy
        real sumaR,sumaG,sumaB,suma3,chAvg
        integer image(Maxheight,Maxwidth,3)

! 1) Open data files.
        open(11,file="ficheros.dat")
        open(12,file="calculo_resultados.dat")

! 2) Read image files with data file info:

        ! What does this 2 do?
2       read(11,*,end=1) dummy

        open(1,file=dummy,form='unformatted',
     &access='direct',recl=1)
        
        do irec=1,54
          read(1,rec=irec) header(irec)
        end do

! What are we checking here?
        if(ichar(header(11)).ne.54.or.ichar(header(29)).ne.24.or.
     &ichar(header(31)).ne.0) then
          print*,'Sorry, cannot handle this file.'
        end if

! 2.1) Get image height and width
        iheight=ichar(header(23))+256*(ichar(header(24))+256*
     &(ichar(header(25))+256*ichar(header(26))))
     
        iwidth=ichar(header(19))+256*(ichar(header(20))+256*
     &(ichar(header(21))+256*ichar(header(22))))
!        print*,'iheight,iwidth=',iheight,iwidth

        ipad=(Maxwidth-iwidth)*3-((Maxwidth-iwidth)*3/4)*4
        irec=54
        do i=1,iheight
          do j=1,iwidth
            irec=irec+1
!     Canal 3 - bitmap guarda primero Blue
            read(1,rec=irec) ch
            image(i,j,3)=ichar(ch)
            irec=irec+1
!     Canal 2 - despues Green
            read(1,rec=irec) ch
            image(i,j,2)=ichar(ch)
            irec=irec+1
!     Canal 1 - y por ultimo Red
            read(1,rec=irec) ch
            image(i,j,1)=ichar(ch)
          end do
          irec=irec+ipad
        end do

! 3) Science starts here.
! Reinitialise variables:
        sumaent=0.
        sigma=0.
        SumaR=0.
        SumaG=0.
        SumaB=0.
        Suma3=0.
        do i=0,255
          histo(i)=0
        end do

! Color values:
        do i=1,iheight
          do j=1,iwidth
            sumaR = sumaR + image(i,j,1)
            sumaG = sumaG + image(i,j,2)
            sumaB = sumaB + image(i,j,3)
          end do
        end do
        sumaR = sumaR/(iheight*iwidth)
        sumaG = sumaG/(iheight*iwidth)
        sumaB = sumaB/(iheight*iwidth)
        suma3 = (sumaR+sumaG+sumaB)/3.

! Sigma calculation (Standard deviation):
        do i=1,iheight
          do j=1,iwidth
            chSum = 0
            do ichan=1,3
              chAvg = chAvg + image(i,j,ichan)/3;
            end do
            sigma = sigma + (chAvg-suma3)**2
          end do
        end do
        sigma = sqrt(sigma/(1.*iheight*iwidth))
                           ! no deberia dividir entre 3*h*w ?

! Enthropy calculation [sumaent(i)]:

        ! hacer para cada canal (?)

        ! Calculamos histograma
        do i=1,iheight
          do j=1,iwidth
            ! histoR
            ! histoG
            ! histoB
            do ichan=1,3
              histo(image(i,j,ichan))=histo(image(i,j,ichan))+1
            end do
          end do
        end do

        ! Calculamos la entropia de Shannon
        do i=0,255
          prob=(1.*histo(i))/(3.*iheight*iwidth)
          if(prob.gt.0) sumaent=sumaent+(-prob*log(prob))
        end do
        ! se descartan valores de probabilidad 0

! Writing the output data:
        write(12,*) dummy,";",suma3,";",sumaR,";",sumaG,";",sumaB,
     &";",sigma,";",sumaent
        write(*,*) dummy
        !write(*,*) dummy,'Suma3=',suma3
        !write(*,*) 'SumaR=',sumaR,', SumaG=',sumaG,', SumaB=',sumaB
        !write(*,*) 'Sigma=',sigma,' SumaEnt=',sumaent

! Close the open line in the output document.
        close(1)
! Repeat for each frame
        goto 2

! Finally close the open data files. Why is there a 1 here?
1       close(12)
        close(11)

        end