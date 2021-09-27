--PA para TCarrera
-- author: Luis mikhail Palomino Paucar
use BDAcademico
go

---Listar Usuario
if OBJECT_ID('spListarUsuario') is not null
drop proc spListarUsuario
go
create proc spListarUsuario
as
begin
select Usuario, Contrasena from TUsuario
end
go
--Consulta
execute spListarUsuario
go

--PA para agregar usuario
if OBJECT_ID('spAgregarUsuario') is not null
	drop proc spAgregarUsuario
go
create proc spAgregarUsuario

@Usuario varchar(50), @Contrasena varchar(50)
as
begin
	---validacion de parametro CodError=0(Correcto), CodError=1,(Error)
	---validar la clave primaria
	if not exists(select Usuario from TUsuario where Usuario=@Usuario)
	---validar que la carrera no se duplique
		if not exists(select Contrasena from TUsuario where Contrasena=@contrasena)
		begin
			insert into TUsuario values(@Usuario,@Contrasena)
			select CodError=0,Mensaje='Usuario insertado en TUsuario'
		end
		else select CodError = 1, Mensaje='Error: Clave Duplicada en TUsuario'
	else select CodError=1, Mensaje='Error: Clave duplicada en TUsuario'
end 
go

--Probar el PA
execute spAgregarUsuario 'mari@gmail.com','m123'
go


---Eliminar Usuario
if OBJECT_ID('spEliminarUsuario') is not null
drop proc spEliminarUsuario
go
create proc spEliminarUsuario
@Usuario varchar(50)
as
begin
	--Usuario exista
	if exists(select Usuario from TUsuario where Usuario=@Usuario)
	--Usuario no este en la tabla Docente
		if not exists(select Usuario from TDocente where Usuario=@Usuario)
		--Usuario no este en la tabla Alumno
			if not exists(select Usuario from TAlumno where Usuario=@Usuario) 
			begin
				delete from TUsuario where Usuario=@Usuario
				select CodError=0, Mensaje='Error:Usuario eliminado de TUsuario'
			end
			else select CodError=1, Mensaje='Error:Usuario existe en TAlumno'
		else select CodError=1, Mensaje='Error:Usuario existe en TDocente'
	else select CodError=1, Mensaje='Error:Usuario no existe en TUsuario'
end
go
--probar el PA
execute spEliminarUsuario 'maril@gmail.com'
go

--actualizar Usuario
if OBJECT_ID('spActualizarUsuario') is not null
drop proc spActualizarUsuario
go

create proc spActualizarUsuario
@Usuario varchar(50), @Contrasena varchar(50)
as
begin
	--validar que el Usuario que exista
	if exists(select Usuario from TUsuario where Usuario=@Usuario)
		if not exists(select Contrasena from TUsuario where Contrasena=@Contrasena)
		begin
			update TUsuario set Contrasena=@Contrasena where Usuario=@Usuario
			select CodError=0, Mensaje='Contrasena actualizada en TUsuario'
		end
		else select CodError=1, Mensaje='ERROR: Contrase�a duplicada en TUsuario'
	else select CodError=1, Mensaje='ERROR: Usuario no existe en TUsuario'
end
go
--probar PA
execute spActualizarUsuario 'mari@gmail.com','ma123'
go



--busqueda Usuario

if OBJECT_ID('spBuscarUsuario') is not null
drop proc spBuscarUsuario
go

create proc spBuscarUsuario
@Texto varchar(50), @Criterio varchar(50)
as
begin
	If(@Criterio='Usuario')
		select Usuario, Contrasena from TUsuario where Usuario=@Texto
end
go
--Probar PA
execute spBuscarUsuario 'mari@gmail.com','Usuario'
go

-- PA que permita hacer Login
if OBJECT_ID('spLoginUsuario') is not null
	drop proc spLoginUsuario
go
create proc spLoginUsuario
@Usuario varchar(50), @Contrasena varchar(50)
as
begin
	if exists(select Usuario from TUsuario where Usuario = @Usuario and Contrasena=@Contrasena)
		begin
			declare @TipoUsuario varchar(20)
			if exists(select Usuario from TAlumno where Usuario = @Usuario)
				set @TipoUsuario = 'Alumno'
			else if exists(select Usuario from TDocente where Usuario = @Usuario)
				set @TipoUsuario = 'Docente'
			select CodError = 0, Mensaje = @TipoUsuario
		end
	else select CodError = 1, Mensaje = 'Error: Usuario y/o Contrase�as Incorrectas'
end
go

exec spLoginUsuario 'cuellar@hotmail.com','1234'
go


