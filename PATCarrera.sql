--PA para TCarrera
-- author: Luis mikhail Palomino Paucar
use BDAcademico
go

---Listar carrera
if OBJECT_ID('spListarCarrera') is not null
drop proc spListarCarrera
go
create proc spListarCarrera
as
begin
select CodCarrera, Carrera from TCarrera
end
go
--Consulta
execute spListarCarrera
go

--PA para agregar carrera
if OBJECT_ID('spAgregarCarrera') is not null
	drop proc spAgregarCarrera
go
create proc spAgregarCarrera

@CodCarrera char(3), @Carrera varchar(50)
as
begin
	---validacion de parametro CodError=0(Correcto), CodError=1,(Error)
	---validar la clave primaria
	if not exists(select CodCarrera from TCarrera where CodCarrera=@CodCarrera)
	---validar que la carrera no se duplique
		if not exists(select Carrera from TCarrera where Carrera=@Carrera)
		begin
			insert into TCarrera values(@CodCarrera,@Carrera)
			select CodError=0,Mensaje='Carrera insertada en Tcarrera'
		end
		else select CodError = 1, Mensaje='Error: Clave Duplicada en TCarrera'
	else select CodError=1, Mensaje='Error: Clave duplicada en TCarrera'

	
end 
go
--Probar el PA
execute spAgregarCarrera 'C04','Ingenieria Ambiental'
go

---Eliminar Carrera
if OBJECT_ID('spEliminarCarrera') is not null
drop proc spEliminarCarrera
go
create proc spEliminarCarrera
@CodCarrera char(3)
as
begin
	--CodCarrera exista
	if exists(select CodCarrera from TCarrera where CodCarrera=@CodCarrera)
	--CodCarrera mo este en la tabla Alumno
		if not exists(select CodCarrera from TAlumno where CodCarrera=@CodCarrera)
		begin
			delete from TCarrera where CodCarrera=@CodCarrera
			select CodError=0, Mensaje='Error:Carrera eliminada de TCarrera'
		end
		else select CodError=1, Mensaje='Error:CodCarrera no existe en TCarrera'
	else select CodError=1, Mensaje='Error:CodCarrera no existe en TCarrera'
end
go

execute spEliminarCarrera 'CO4'
go

--delete from TCarrera where Carrera ='Ingenieria INDUSTRIAL'

--actualizar carrera
if OBJECT_ID('spActualizarCarrera') is not null
drop proc spActualizarCarrera
go

create proc spActualizarCarrera
@CodCarrera char(3), @Carrera varchar(50)
as
begin
	--validar que el Codigo de carrera exista
	if exists(select CodCarrera from TCarrera where CodCarrera=@CodCarrera)
		if not exists(select Carrera from TCarrera where Carrera=@Carrera)
		begin
			update TCarrera set Carrera=@Carrera where CodCarrera=@Codcarrera
			select CodError=0, Mensaje='Carrera actualizada en TCarrera'
		end
		else select CodError=1, Mensaje='ERROR: Carrera duplicada en TCarrera'
	else select CodError=1, Mensaje='ERROR: Carrera no existe en TCarrera'
end
go
execute spActualizarCarrera 'C04','Ingenieria Ambiental'
go

--busqueda

if OBJECT_ID('spBuscarrCarrera') is not null
drop proc spBuscarCarrera
go

create proc spBuscarCarrera
@Texto varchar(50), @Criterio varchar(50)
as
begin
	If(@Criterio='CodCarrera')
		select CodCarrera, Carrera from TCarrera where CodCarrera=@Texto
	else if (@Criterio='Carrera')
		select CodCarrera,Carrera from TCarrera where Carrera LIKE @Texto + '%'
end
go

execute spBuscarCarrera 'C04','CodCarrera'
go



