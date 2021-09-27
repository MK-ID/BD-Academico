--PA para TNotas
-- author: Luis mikhail Palomino Paucar
use BDAcademico
go
--Listar Notas
if OBJECT_ID('spListarNotas') is not null
	drop proc spListarNotas
go

create proc spListarNotas
as
begin
	select CodAlumno, CodAsignatura, Semestre, Parcial1, Parcial2, NotaFinal from TNotas
end
go

--Probar el PA
execute spListarNotas
go

--PA para Agregar Notas
if OBJECT_ID('spAgregarNotas') is not null
	drop proc spAgregarNotas
go

create proc spAgregarNotas
@CodAlumno	char(5), @CodAsignatura	char(3), @Semestre varchar(20),	@Parcial1 decimal(4,2), @Parcial2 decimal(4,2), @NotaFinal decimal(4,2)
as
begin
	--Validacion de parametros
	--Validar la clave primaria
	if not exists(select @CodAlumno, @CodAsignatura from TNotas where CodAlumno= @CodAlumno AND CodAsignatura = @CodAsignatura)
	--Validar que la asignatura exista
		if exists(select CodAsignatura from TAsignatura where CodAsignatura = @CodAsignatura)
		begin
			insert into TNotas values (@CodAlumno, @CodAsignatura, @Semestre, @Parcial1, @Parcial2, @NotaFinal)
			select CodError = 0, Mensaje= 'Notas insertadas en TNotas'
		end
		else select CodError = 1, Mensaje = 'Error: La asignatura ingresada no existe'
	else select CodError=1, Mensaje = 'Error: Este alumno ya cuenta con notas ingresadas en ese curso'
end
go

exec spListarNotas
go
--Probar el PA
execute spAgregarNotas 'A0001', 'S11', '2010-II', 19, 14, 17
go
execute spAgregarNotas 'A0001', 'S22', '2010-II', 19, 14, 17
go


--Eliminar Notas
if OBJECT_ID('spEliminarNotas') is not null
	drop proc spEliminarNotas
go

create proc spEliminarNotas
@CodAlumno char(5), @CodAsignatura char(3)
as 
begin
	--Notas existen
	if exists(select @CodAlumno, @CodAsignatura from TNotas where CodAlumno= @CodAlumno AND CodAsignatura = @CodAsignatura)
		--Usuario no este en la TAlumno
		begin
			delete from TNotas where CodAlumno= @CodAlumno AND CodAsignatura = @CodAsignatura
			select CodError = 0, Mensaje = 'Notas eliminadas de TNotas'
		end
	else select CodError = 1, Mensaje = 'Error: Notas no existen en TNotas'
end
go

exec spEliminarNotas 'A0001', 'S11'
go
exec spListarNotas
go

--Actualizar Notas
if OBJECT_ID('spActualizarNotas') is not null
	drop proc spActualizarNotas
go

create proc spActualizarNotas
@CodAlumno	char(5), @CodAsignatura	char(3), @Semestre varchar(20),	@Parcial1 decimal(4,2), @Parcial2 decimal(4,2), @NotaFinal decimal(4,2)
as
begin
	--Validar que las Notas existan
	if exists(select @CodAlumno, @CodAsignatura from TNotas where CodAlumno= @CodAlumno AND CodAsignatura = @CodAsignatura)
		begin
			update TNotas set Semestre = @Semestre, Parcial1 = @Parcial1, Parcial2 = @Parcial2, NotaFinal = @NotaFinal where 
			CodAlumno= @CodAlumno AND CodAsignatura = @CodAsignatura
			select CodError = 0, Mensaje = 'Notas actualizadas en TNotas'
		end
	else select CodError = 1, Mensaje = 'Error: Los datos ingresados no pueden actualizar las notas solicitadas'
end
go

execute spListarNotas
go

execute spActualizarNotas 'A0001', 'S01', '2013-II', 19, 14, 17
go

--Busqueda
if OBJECT_ID('spBuscarNotas') is not null
	drop proc spBuscarNotas
go

create proc spBuscarNotas
@Texto varchar(50), @Criterio varchar(20)
as
begin
	if (@Criterio = 'CodAlumno')
		select CodAlumno, CodAsignatura, Semestre, Parcial1, Parcial2, NotaFinal from TNotas where CodAlumno = @Texto
	else if (@Criterio = 'CodAsignatura')
		select CodAlumno, CodAsignatura, Semestre, Parcial1, Parcial2, NotaFinal from TNotas where CodAsignatura = @Texto
	else if (@Criterio = 'Semestre')
		select CodAlumno, CodAsignatura, Semestre, Parcial1, Parcial2, NotaFinal from TNotas where Semestre = @Texto
end
go

--Probar Busquedas
exec spBuscarNotas 'A0001', 'CodAlumno'
go
exec spBuscarNotas 'S01', 'CodAsignatura'
go