use BDAcademico

--Agregar Docente
if OBJECT_ID('spAgregarDocente') is not null
	drop proc spAgregarDocente
go
create proc spAgregarDocente
@CodDocente char (5) ,
@APaterno varchar (50),
@AMaterno varchar (50),
@Nombres varchar (50) ,
@Usuario varchar (50) ,
@Contrasena	varchar(50)
as
begin
	--VAlidar CodDocente
	if not exists (select CodDocente from TDocente where CodDocente=@CodDocente)
		--Validar Usuario
		if not exists (select Usuario from TUsuario where Usuario=@Usuario)
			--Validar CodCarrera
			begin
				begin tran TransacAgregar --Iniciar la transaccion explicita
				begin try
					insert into TUsuario values(@Usuario,@Contrasena)
					insert into TDocente values(@CodDocente,@APaterno,@AMaterno,@Nombres,@Usuario)
					commit tran TransacAgregar
					select CodError = 0, Mensaje= 'Se agregó Usuario y Docente en TUsuario y TDocente'
				end try
				begin catch
					Rollback tran TransacAgregar
					select CodError = 1, Mensaje= 'Error: No se ejecutó la transaccion' 
				end catch
			end
			
		else select CodError = 1, Mensaje ='Error: Usuario existe en TUsuario'
	else select CodError = 1, Mensaje = 'Error: CodDocente existe en TDocente'

end
go

--Probar el PA
execute spAgregarDocente 'D09','DIAZ','CHAVEZ','MARICARMEN','maril@gmail.com','ma123'
go

--Eliminar Docente
if OBJECT_ID ('spEliminarDocente') is not null
	drop proc spEliminarDocente
go
create proc spEliminarDocente
@CodDocente char(5),@Usuario varchar(50)
as
begin
	--Validar CodDocente existe, debe de obtener el Usuario
	if exists(select CodDocente from TDocente where CodDocente=@CodDocente)
		if not exists(select CodDocente from TCarga where CodDocente=@CodDocente)
		begin
			begin tran tranEliminar
			begin try
				delete from TDocente where CodDocente = @CodDocente
				delete from TUsuario where Usuario = @Usuario
				commit tran tranEliminar
				select  CodError=0, Mensaje = 'Docente eliminado en TDocente y TUsuario' 
			end try
			begin catch
				rollback tran tranEliminar
				select CodError = 1, Mensaje = 'Error: en la transaccion'
			end catch
		end
		else select CodError=1, Mensaje='Error:Docente esta a cargo de un curso TCarga'
	else select CodError=1, Mensaje='Error:CodDocente no existe en TDocente'
end
go
execute spEliminarDocente 'D09','maril@gmail.com'
go

--Actualizar Docente
if OBJECT_ID('spActualizarDocente') is not null
	drop proc spActualizarDocente
go
create proc spActualizarDocente
@CodDocente char (5) ,
@APaterno varchar (50),
@AMaterno varchar (50),
@Nombres varchar (50) 
as
begin
	--VAlidar CodDocente
	if exists (select CodDocente from TDocente where CodDocente=@CodDocente)
		--Validar Usuario
			begin
					update TDocente set APaterno=@APaterno,AMaterno=@AMaterno,Nombres=@Nombres where CodDocente=@CodDocente
					select CodError = 0, Mensaje= 'Se actualizó Usuario y Docente en TDocente'
			end
	else select CodError = 1, Mensaje = 'Error: CodDocente no existe en TDocente'
end
go

execute spActualizarDocente 'D09','Diaz','Chavez','Mari'
go
--busqueda

if OBJECT_ID('spBuscarDocente') is not null
drop proc spBuscarDocente
go

create proc spBuscarDocente
@Texto varchar(50), @Criterio varchar(50)
as
begin
	If(@Criterio='CodDocente')
		select CodDocente, APaterno,AMaterno,nombres, Usuario from TDocente where CodDocente=@Texto
	else if (@Criterio='APaterno')
		select CodDocente, APaterno,AMaterno,nombres, Usuario from TDocente where APaterno=@Texto
	else if (@Criterio='AMaterno')
		select CodDocente, APaterno,AMaterno,nombres, Usuario from TDocente where AMaterno=@Texto
	else if (@Criterio='Nombres')
		select CodDocente, APaterno,AMaterno,nombres, Usuario from TDocente where Nombres=@Texto
end
go


execute spBuscarDocente 'D09','CodDocente'
go