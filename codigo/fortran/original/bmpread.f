
        integer Maxwidth,Maxheight,irec,iwidth,iheight,i,j,ipad
        integer histo(0:255)
        parameter(Maxwidth=3220,Maxheight=2415)
        character header(54),ch
        character*24 dummy
        real suma
        integer image(Maxheight,Maxwidth,3)

        open(11,file="ficheros.dat")
        open(12,file="salida.dat")

2       read(11,*,end=1) dummy

        open(1,file=dummy,form='unformatted',
     &access='direct',recl=1)

        do irec=1,54
          read(1,rec=irec) header(irec)
        end do

        if(ichar(header(11)).ne.54.or.ichar(header(29)).ne.24.or.
     &ichar(header(31)).ne.0) then
          print*,'sorry, can not handle this file'
        end if

! get image height and width
        iheight=ichar(header(23))+256*(ichar(header(24))+256*
     &(ichar(header(25))+256*ichar(header(26))))
        iwidth=ichar(header(19))+256*(ichar(header(20))+256*
     &(ichar(header(21))+256*ichar(header(22))))
c        print*,'iheight,iwidth=',iheight,iwidth

        ipad=(Maxwidth-iwidth)*3-((Maxwidth-iwidth)*3/4)*4
        irec=54
        do i=1,iheight
        do j=1,iwidth
          irec=irec+1
          read(1,rec=irec) ch
          image(i,j,3)=ichar(ch)
          irec=irec+1
          read(1,rec=irec) ch
          image(i,j,2)=ichar(ch)
          irec=irec+1
          read(1,rec=irec) ch
          image(i,j,1)=ichar(ch)
        end do
        irec=irec+ipad
        end do

C-- COMIENZA LA CIENCIA:

        sumaent=0.
        sigma=0.
        suma=0.
        do i=0,255
           histo(i)=0
        end do


          do i=1,iheight   !calculamos la media
          do j=1,iwidth
            suma=suma+image(i,j,1)+image(i,j,2)+image(i,j,3)
          end do
          end do
          suma=suma/(3.*iheight*iwidth)

          do i=1,iheight   !calculamos la sigma
          do j=1,iwidth
          do ichan=1,3
            sigma=sigma+((image(i,j,ichan)-suma)**2)
          end do
          end do
          end do
          sigma=sqrt(sigma/(1.*iheight*iwidth))

          do i=1,iheight   !calculamos la entropia
          do j=1,iwidth
          do ichan=1,3
           histo(image(i,j,ichan))=histo(image(i,j,ichan))+1
          end do
          end do
          end do

          do i=0,255
            prob=(1.*histo(i))/(3.*iheight*iwidth)
            if(prob.gt.0) sumaent=sumaent+(-prob*log(prob))
          end do


        write(12,*) suma, sigma, sumaent

        close(1)
        goto 2

1       close(12)
        close(11)

        end
