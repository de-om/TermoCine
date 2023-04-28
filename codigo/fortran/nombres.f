        write(*,*) 'Cual es el fotograma inicial?'
        read(*,*) j

        write(*,*) 'Cual es el fotograma final?'
        read(*,*) k

        open(11,file="ficheros.dat")
          do i=j,k
            write(11,'(A3,I7.7,A4)') 'out',i,".bmp"
          end do
        close(11)

        end