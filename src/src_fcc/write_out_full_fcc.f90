!***************************************************************************
! write_out_full.f90
! ------------------
! Copyright (C) 2007-2011, Eco2s team, Gerardo Fratini
! Copyright (C) 2011-2015, LI-COR Biosciences
!
! This file is part of EddyPro (TM).
!
! EddyPro (TM) is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! EddyPro (TM) is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with EddyPro (TM).  If not, see <http://www.gnu.org/licenses/>.
!
!***************************************************************************
!
! \brief       Write results on output files
! \author      Gerardo Fratini
! \note
! \sa
! \bug
! \deprecated
! \test
! \todo
!***************************************************************************
subroutine WriteOutFull(lEx)
    use m_fx_global_var
    implicit none
    !> in/out variables
    Type(ExType), intent(in) :: lEx
    character(16000) :: dataline

    !> local variables
    integer :: var
    integer :: i
    integer :: gas
    integer :: igas
    character(DatumLen) :: datum
    include '../src_common/interfaces_1.inc'


    call clearstr(dataline)
    !> Preliminary file and timestamp information
    ! call AddDatum(dataline, lEx%fname(1:len_trim(lEx%fname)), separator)
    call AddDatum(dataline, trim(lEx%fname), separator)
    call AddDatum(dataline, lEx%date(1:10), separator)
    call AddDatum(dataline, lEx%time(1:5), separator)
    call WriteDatumFloat(float_doy, datum, EddyProProj%err_label)
    call stripstr(datum)  !< Added to fix a strange behaviour
    call AddDatum(dataline, datum(1:index(datum, '.') + 3), separator)
    if (lEx%daytime) then
        call AddDatum(dataline, '1', separator)
    else
        call AddDatum(dataline, '0', separator)
    endif
    call WriteDatumInt(lEx%file_records, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumInt(lEx%used_records, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)

    !> Corrected fluxes (Level 3)
    !> Tau
    call WriteDatumFloat(Flux3%tau, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumInt(QCFlag%tau, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    if (FCCMetadata%ru) then
        call WriteDatumFloat(lEx%rand_uncer(u), datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
    elseif(EddyProProj%fix_out_format) then
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if

    !> H
    call WriteDatumFloat(Flux3%H, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumInt(QCFlag%H, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    if (FCCMetadata%ru) then
        call WriteDatumFloat(lEx%rand_uncer(ts), datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
    elseif(EddyProProj%fix_out_format) then
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if

    !> LE
    if(fcc_var_present(h2o)) then
        call WriteDatumFloat(Flux3%LE, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        call WriteDatumInt(QCFlag%h2o, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        if (FCCMetadata%ru) then
            call WriteDatumFloat(lEx%rand_uncer_LE, datum, EddyProProj%err_label)
            call AddDatum(dataline, datum, separator)
        elseif(EddyProProj%fix_out_format) then
            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        end if
    elseif(EddyProProj%fix_out_format) then
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if

    !> Gases
    if(fcc_var_present(co2)) then
        call WriteDatumFloat(Flux3%co2, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        call WriteDatumInt(QCFlag%co2, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        if (FCCMetadata%ru) then
            call WriteDatumFloat(lEx%rand_uncer(co2), datum, EddyProProj%err_label)
            call AddDatum(dataline, datum, separator)
        elseif(EddyProProj%fix_out_format) then
            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        end if
    elseif(EddyProProj%fix_out_format) then
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if

    if(fcc_var_present(h2o)) then
        call WriteDatumFloat(Flux3%h2o, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        call WriteDatumInt(QCFlag%h2o, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        if (FCCMetadata%ru) then
            call WriteDatumFloat(lEx%rand_uncer(h2o), datum, EddyProProj%err_label)
            call AddDatum(dataline, datum, separator)
        elseif(EddyProProj%fix_out_format) then
            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        end if
    elseif(EddyProProj%fix_out_format) then
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if

    if(fcc_var_present(ch4)) then
        call WriteDatumFloat(Flux3%ch4, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        call WriteDatumInt(QCFlag%ch4, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        if (FCCMetadata%ru) then
            call WriteDatumFloat(lEx%rand_uncer(ch4), datum, EddyProProj%err_label)
            call AddDatum(dataline, datum, separator)
        elseif(EddyProProj%fix_out_format) then
            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        end if
    elseif(EddyProProj%fix_out_format) then
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if

    if(fcc_var_present(gas4)) then
        call WriteDatumFloat(Flux3%gas4, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        call WriteDatumInt(QCFlag%gas4, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        if (FCCMetadata%ru) then
            call WriteDatumFloat(lEx%rand_uncer(gas4), datum, EddyProProj%err_label)
            call AddDatum(dataline, datum, separator)
        elseif(EddyProProj%fix_out_format) then
            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        end if
    elseif(EddyProProj%fix_out_format) then
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if

    !> storage
    call WriteDatumFloat(lEx%Stor%H, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    if(fcc_var_present(h2o)) then
        call WriteDatumFloat(lEx%Stor%LE, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
    elseif(EddyProProj%fix_out_format) then
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if
    do gas = co2, n2o
        if(fcc_var_present(gas)) then
            call WriteDatumFloat(lEx%Stor%of(gas), datum, EddyProProj%err_label)
            call AddDatum(dataline, datum, separator)
        elseif(EddyProProj%fix_out_format) then
            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        end if
    end do

    !> vertical advection fluxes
    do gas = co2, n2o
        if(fcc_var_present(gas)) then
            if (lEx%rot_w /= error .and. lEx%d(gas) >= 0d0) then
                if (gas /= h2o) then
                    call WriteDatumFloat(lEx%rot_w * lEx%d(gas) * 1d3, datum, EddyProProj%err_label)
                    call AddDatum(dataline, datum, separator)
                else
                    call WriteDatumFloat(lEx%rot_w * lEx%d(gas), datum, EddyProProj%err_label)
                    call AddDatum(dataline, datum, separator)
                end if
            else
                call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
            end if
        elseif(EddyProProj%fix_out_format) then
            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        end if
    end do

    !> Gas concentrations, densities and timelags
    do gas = co2, n2o
        if (fcc_var_present(gas)) then
            call WriteDatumFloat(lEx%d(gas), datum, EddyProProj%err_label)
            call AddDatum(dataline, datum, separator)
            call WriteDatumFloat(lEx%chi(gas), datum, EddyProProj%err_label)
            call AddDatum(dataline, datum, separator)
            call WriteDatumFloat(lEx%r(gas), datum, EddyProProj%err_label)
            call AddDatum(dataline, datum, separator)
            call WriteDatumFloat(lEx%tlag(gas), datum, EddyProProj%err_label)
            call AddDatum(dataline, datum, separator)
            if (lEx%def_tlag(gas)) then
                call AddDatum(dataline, '1', separator)
            else
                call AddDatum(dataline, '0', separator)
            endif
        elseif(EddyProProj%fix_out_format) then
            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
            call AddDatum(dataline, '9', separator)
        end if
    end do

    !> Air properties
    call WriteDatumFloat(lEx%Ts, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%Ta, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%Pa, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%RHO%a, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    if (lEx%RHO%a /= 0d0 .and. lEx%RHO%a /= error) then
        call WriteDatumFloat(lEx%RhoCp /lEx%RHO%a, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
    else
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if
    call WriteDatumFloat(lEx%Va, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    if (Flux3%h2o /= error) then
        call WriteDatumFloat(Flux3%h2o * 0.0648d0, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
    else
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if
    call WriteDatumFloat(lEx%RHO%w, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%e, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%es, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%Q, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%RH, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%VPD, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%Tdew, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)

    !> Unrotated and rotated wind components
    call WriteDatumFloat(lEx%unrot_u, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%unrot_v, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%unrot_w, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%rot_u, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%rot_v, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%rot_w, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%WS, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%MWS, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%WD, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    !> rotation angles
    call WriteDatumFloat(lEx%yaw, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%pitch, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%roll, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)

    !> turbulence
    call WriteDatumFloat(lEx%ustar, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%TKE, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%L, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%zL, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%bowen, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(lEx%Tstar, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)

    !> footprint
    if (Meth%foot /= 'none') then
        select case(foot_model_used(1:len_trim(foot_model_used)))
            case('kljun_04')
            call AddDatum(dataline, '0', separator)
            case('kormann_meixner_01')
            call AddDatum(dataline, '1', separator)
            case('hsieh_00')
            call AddDatum(dataline, '2', separator)
        end select
        call WriteDatumFloat(Foot%peak, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        call WriteDatumFloat(Foot%offset, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        call WriteDatumFloat(Foot%x10, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        call WriteDatumFloat(Foot%x30, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        call WriteDatumFloat(Foot%x50, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        call WriteDatumFloat(Foot%x70, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        call WriteDatumFloat(Foot%x90, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
    elseif(EddyProProj%fix_out_format) then
        call AddDatum(dataline, '9', separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if

    !> Uncorrected fluxes (Level 0)
    !> Tau
    call WriteDatumFloat(lEx%Flux0%tau, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(BPCF%of(w_u), datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    !> H
    call WriteDatumFloat(lEx%Flux0%H, datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumFloat(BPCF%of(w_ts), datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    !> LE
    if(fcc_var_present(h2o)) then
        call WriteDatumFloat(lEx%Flux0%LE, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        call WriteDatumFloat(BPCF%of(w_h2o), datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
    elseif(EddyProProj%fix_out_format) then
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if
    !> Gases
    if(fcc_var_present(co2)) then
        call WriteDatumFloat(lEx%Flux0%co2, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        call WriteDatumFloat(BPCF%of(w_co2), datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
    elseif(EddyProProj%fix_out_format) then
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if
    if(fcc_var_present(h2o)) then
        call WriteDatumFloat(lEx%Flux0%h2o, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        call WriteDatumFloat(BPCF%of(w_h2o), datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
    elseif(EddyProProj%fix_out_format) then
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if
    if(fcc_var_present(ch4)) then
        call WriteDatumFloat(lEx%Flux0%ch4, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        call WriteDatumFloat(BPCF%of(w_ch4), datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
    elseif(EddyProProj%fix_out_format) then
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if
    if(fcc_var_present(gas4)) then
        call WriteDatumFloat(lEx%Flux0%gas4, datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
        call WriteDatumFloat(BPCF%of(w_gas4), datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
    elseif(EddyProProj%fix_out_format) then
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if

    !> Vickers and Mahrt 97 flags
    do i = 1, 12
        write(datum, *) lEx%vm_flags(i)
        call AddDatum(dataline, datum, separator)
    end do

    !> Spikes for EddyPro variables
    call WriteDatumInt(lEx%spikes(u), datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumInt(lEx%spikes(v), datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumInt(lEx%spikes(w), datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    call WriteDatumInt(lEx%spikes(ts), datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    do var = co2, gas4
        if(fcc_var_present(var)) then
            call WriteDatumInt(lEx%spikes(var), datum, EddyProProj%err_label)
            call AddDatum(dataline, datum, separator)
        elseif(EddyProProj%fix_out_format) then
            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        end if
    end do

    !> LI-COR's diagnostic flags
    if (Diag7200%present) then
        do i = 1, 9
            call WriteDatumInt(nint(lEx%licor_flags(i)), datum, EddyProProj%err_label)
            call AddDatum(dataline, datum, separator)
        end do
    elseif(EddyProProj%fix_out_format) then
        do i = 1, 9
            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        end do
    end if
    if (Diag7500%present) then
        do i = 10, 13
            call WriteDatumInt(nint(lEx%licor_flags(i)), datum, EddyProProj%err_label)
            call AddDatum(dataline, datum, separator)
        end do
    elseif(EddyProProj%fix_out_format) then
        do i = 1, 4
            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        end do
    end if
    if (Diag7700%present) then
        do i = 14, 29
            call WriteDatumInt(nint(lEx%licor_flags(i)), datum, EddyProProj%err_label)
            call AddDatum(dataline, datum, separator)
        end do
    elseif(EddyProProj%fix_out_format) then
        do i = 1, 16
            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        end do
    end if

    !> AGCs
    if (Diag7200%present) then
        call WriteDatumInt(nint(lEx%agc72), datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
    elseif(EddyProProj%fix_out_format) then
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if
    if (Diag7500%present) then
        call WriteDatumInt(nint(lEx%agc75), datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
    elseif(EddyProProj%fix_out_format) then
        call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
    end if
!        if (Diag7700%present) then
!            call WriteDatumInt(nint(lEx%rssi77), datum, EddyProProj%err_label)
!            call AddDatum(dataline, datum, separator)
!        elseif(EddyProProj%fix_out_format) then
!            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
!        end if

    !> Variances
    do var = u, ts
        call WriteDatumFloat(lEx%var(var), datum, EddyProProj%err_label)
        call AddDatum(dataline, datum, separator)
    end do
    do gas = co2, gas4
        if(fcc_var_present(gas)) then
            call WriteDatumFloat(lEx%var(gas), datum, EddyProProj%err_label)
            call AddDatum(dataline, datum, separator)
        elseif(EddyProProj%fix_out_format) then
            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        end if
    end do
    !> w-covariances
    call WriteDatumFloat(lEx%cov_w(ts), datum, EddyProProj%err_label)
    call AddDatum(dataline, datum, separator)
    do gas = co2, gas4
        if(fcc_var_present(gas)) then
            call WriteDatumFloat(lEx%cov_w(gas), datum, EddyProProj%err_label)
            call AddDatum(dataline, datum, separator)
        elseif(EddyProProj%fix_out_format) then
            call AddDatum(dataline, trim(adjustl(EddyProProj%err_label)), separator)
        end if
    enddo

    !> Mean values of user variables
    if (NumUserVar > 0) then
        do var = 1, NumUserVar
            call WriteDatumFloat(lEx%user_var(var), datum, EddyProProj%err_label)
            call AddDatum(dataline, datum, separator)
        end do
    end if

    write(uflx, '(a)')   dataline(1:len_trim(dataline) - 1)

end subroutine WriteOutFull
