--PA para TCarrera
-- author: Luis mikhail Palomino Paucar

use BDAcademico
-- Listar Carrera
if OBJECT_ID ('spListarAlumno') is not null
   drop proc spListarAlumno
go
create proc spListarAlumno
as
begin
    select CodAlumno, APaterno, AMaterno, Nombres, Usuario, CodCarrera from TAlumno
end
go

execute spListarAlumno
go
--PA para agregar alumno (transaccional)
if OBJECT_ID('spAgregarAlumno') is not null
	drop proc spAgregarAlumno
go
create proc spAgregarAlumno
@CodAlumno char (5) ,
@APaterno varchar (50),
@AMaterno varchar (50),
@Nombres varchar (50) ,
@Usuario varchar (50) ,
@CodCarrera char (3),
@Contrasena	varchar(50)
as
begin
	--VAlidar CodAlumno
	if not exists (select CodAlumno from TAlumno where CodAlumno=@CodAlumno)
		--Validar Usuario
		if not exists (select Usuario from TUsuario where Usuario=@Usuario)
			--Validar CodCarrera
			if exists (select CodCarrera from TCarrera where CodCarrera=@CodCarrera)
			begin
				begin tran TransacAgregar --Iniciar la transaccion explicita
				begin try
					insert into TUsuario values(@Usuario,@Contrasena)
					insert into TAlumno values(@CodAlumno,@APaterno,@AMaterno,@Nombres,@Usuario,@CodCarrera)
					commit tran TransacAgregar
					select CodError = 0, Mensaje= 'Se agreg� Usuario y Alumno en TUsuario y TAlumno'
				end try
				begin catch
					Rollback tran TransacAgregar
					select CodError = 1, Mensaje= 'Error: No se ejecut� la transaccion' 
				end catch
			end
			else select CodError=1, Mensaje= 'Error: CodCarrera no existe en TCarrera'
		else select CodError = 1, Mensaje ='Error: Usuario existe en TUsuario'
	else select CodError = 1, Mensaje = 'Error: CodAlumno existe en TAlumno'

end

execute spAgregarAlumno 'A0031','Alvarez','Astete','Anthony','tony','C03','123'
go

--Eliminar Alumno
if OBJECT_ID ('spEliminarAlumno') is not null
	drop proc spEliminarAlumno
go
create proc spEliminarAlumno
@CodAlumno char(5)
as
begin
	--Validar CodAlumno existe, debe de obtener el Usuario
	declare @Usuario varchar(50)
	set @Usuario=(select Usuario from TAlumno where CodAlumno=@CodAlumno)
	if exists (select CodAlumno from TAlumno where CodAlumno=@CodAlumno)
		if exists (select Usuario from TUsuario where Usuario=@Usuario)
		begin
			begin tran tranEliminar
			begin try
				delete from TAlumno where CodAlumno = @CodAlumno
				delete from TUsuario where Usuario = @Usuario
				commit tran tranEliminar
				select  CodError=0, Mensaje = 'Alumno eliminado en TAlumno y TUsuario' 
			end try
			begin catch
				rollback tran tranEliminar
				select CodError = 1, Mensaje = 'Error: en la transaccion'
			end catch
		end
		else select CodError = 1, Mensaje= 'Error: Usuario no existe en TUsuario'
	else select CodError = 1, Mensaje = 'Error: No existe CodAlumno en TAlumno' 
end
go

execute spEliminarAlumno 'A0030'
go

-- Actualizar Alumno
if OBJECT_ID ('spListarAlumno') is not null
   drop proc spListarAlumno
go
create proc spListarAlumno
as
begin
    select CodAlumno, APaterno, AMaterno, Nombres, Usuario, CodCarrera from TAlumno
end
go

execute spListarAlumno
go
--PA para actualizar alumno (transaccional)
if OBJECT_ID('spActualizarAlumno') is not null
	drop proc spActualizarAlumno
go
create proc spActualizarAlumno
@CodAlumno char (5) ,
@APaterno varchar (50),
@AMaterno varchar (50),
@Nombres varchar (50) ,
@Usuario varchar (50) ,
@CodCarrera char (3),
@Contrasena	varchar(50)
as
begin
	--VAlidar CodAlumno
	if  exists (select CodAlumno from TAlumno where CodAlumno=@CodAlumno)
		--Validar Usuario
		if  exists (select Usuario from TUsuario where Usuario=@Usuario)
			--Validar CodCarrera
			if exists (select CodCarrera from TCarrera where CodCarrera=@CodCarrera)
			begin
				begin tran TransacAgregar --Iniciar la transaccion explicita
				begin try
					update TUsuario set Contrasena=@Contrasena where Usuario=@Usuario
					update TAlumno set CodCarrera=@CodCarrera where CodAlumno=@CodAlumno
					commit tran TransacAgregar
					select CodError = 0, Mensaje= 'Se actualiz� Usuario y Alumno en TUsuario y TAlumno'
				end try
				begin catch
					Rollback tran TransacAgregar
					select CodError = 1, Mensaje= 'Error: No se ejecut� la transaccion' 
				end catch
			end
			else select CodError=1, Mensaje= 'Error: CodCarrera no existe en TCarrera'
		else select CodError = 1, Mensaje ='Error: Usuario no existe en TUsuario'
	else select CodError = 1, Mensaje = 'Error: CodAlumno existe en TAlumno'

end
go
exec spActualizarAlumno 'A0031','Alvarez','Astete','Anthony','tony','C03','1235'
go

--Busqueda
if OBJECT_ID('spBuscarAlumno') is not null
	drop proc spBuscarAlumno
go
create proc spBuscarAlumno
@Texto varchar(50), @Criterio varchar(20)
as 
begin
	if (@Criterio = 'CodAlumno')
		select CodAlumno, Usuario from TAlumno where CodAlumno = @Texto

end
go

exec spBuscarAlumno 'A0005','CodAlumno'
go

select * from TAlumno
select * from TUsuario
select * from TNotas