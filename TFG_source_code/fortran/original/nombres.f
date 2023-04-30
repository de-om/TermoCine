        write(*,*) 'cuantos fotogramas?'
        read(*,*) j
        open(11,file="ficheros.dat")
        do i=1,j
            write(11,'(A3,I7.7,A4)') "out",i,".bmp"
        end do
        close(11)

        end
